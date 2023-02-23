# Planning codebuild creation
resource "aws_codebuild_project" "tf-plan" {
  name          = "tf-cicd-plan2"
  description   = "Plan stage for terraform"
  service_role  = aws_iam_role.tf-codebuild-role.arn
  artifacts {
    type = "CODEPIPELINE"
  }

# Environment creation - using docker image of terraform of linux
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    # image                       = "hashicorp/terraform:0.14.3"
    image                       = "hashicorp/terraform:1.3.8"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    # providing the image_pull_credentials_type
    registry_credential{
        credential = var.dockerhub_credentials
        credential_provider = "SECRETS_MANAGER"
    }
 }
# buildspec file location inside the folder for plan
 source {
     type   = "CODEPIPELINE"
     buildspec = file("buildspec/plan-buildspec.yml")
 }
}

# Similar to plan only few changes needed ----
# CodeBuild spec file location inside the folder for apply
resource "aws_codebuild_project" "tf-apply" {
  name          = "tf-cicd-apply"
  description   = "Apply stage for terraform"
  service_role  = aws_iam_role.tf-codebuild-role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:0.14.3"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential{
        credential = var.dockerhub_credentials
        credential_provider = "SECRETS_MANAGER"
    }
 }
 source {
     type   = "CODEPIPELINE"
     buildspec = file("buildspec/apply-buildspec.yml")
 }
}

# Creating CodePipeline 
resource "aws_codepipeline" "cicd_pipeline" {
    name = "tf-cicd"
    role_arn = aws_iam_role.tf-codepipeline-role.arn
    artifact_store {
        type="S3"
        location = aws_s3_bucket.codepipeline_artifacts.id
    }
    stage {
        name = "Source"
        action{
            name = "Source"
            category = "Source"
            owner = "AWS"
            provider = "CodeStarSourceConnection"
            version = "1"
            output_artifacts = ["tf-code"]
            configuration = {
                FullRepositoryId = "aws-cicd-pipeline-using-terraform"
                # Getting error here, even if defined Branch = main
                BranchName   = "main"
                ConnectionArn = var.codestar_connector_credentials
                OutputArtifactFormat = "CODE_ZIP"
            }
        }
    }
    stage {
        name ="Plan"
        action{
            name = "Build"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["tf-code"]
            configuration = {
                ProjectName = "tf-cicd-plan"
            }
        }
    }
    stage {
        name ="Deploy"
        action{
            name = "Deploy"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["tf-code"]
            configuration = {
                ProjectName = "tf-cicd-apply"
            }
        }
    }
}
