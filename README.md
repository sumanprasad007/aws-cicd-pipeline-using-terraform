# aws-cicd-pipeline-using-terraform

Creating the whole AWS-CodePipeline using Terraform:

# Imp commands of Terraform

1. terraform init
2. terraform plan
3. terraform apply -auto-approve
4. terraform destroy -auto-approve
5. terraform workspace list
6. terraform workspace new dev
7. terraform workspace select dev

# Pre-requisites are:

	-Repository - GitHub
	-S3 Bucket (TF state)
	-Dockerhub Credentials
	-Codestar Connector: Helps to connect AWS Pipeline with GitHub seamless 
	-Dev. Environment: Clone the GitHub repo locally to make the required changes as needed
	
# Architectural Diagram:

![image](https://user-images.githubusercontent.com/55047333/218096815-cd76db12-28d4-4688-adb4-32950e14bd6b.png)



# aws-cicd-pipeline-using-terraform
# demo-sample-pipeline
