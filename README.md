# DALLE Backend

A backend Kotlin app that integrates with openAI's image services.

## Dependencies
    Java 17
    Gradle 7.6.1
    Springboot 2.6.1

## To Build the app locally
    ./gradlew clean build
## To Run the app locally
    ./gradlew bootRun

## Deploying the app to an AWS EC2 Instance locally
    ### AWS prerequisites
    - An IAM account user account in a group that has AdministratorAccess permissions
    
    - IAM user account access key (This will be required to be passed in as a local variable to Terraform.tf)
    - IAM user account secret key  (This will be required to be passed in as a local variable to Terraform.tf)
    - An EC2 instance with a public IP address
        Go to the AWS EC2 Dashboard and launch an instance
        Select Software Image (AMI)
            Canonical, Ubuntu, 20.04 LTS, amd64 
            ami-0aa2b7722dc1b5612
        Create a new key pair and save it some where safe, this will be used later by terraform to ssh into the instance
        The Instance name is an optional field to launch but make sure to fill it out. This will be important later
        Once the new instance is launched, jog down the following
            {Instance_id}
            {instance_name}
            {instance_ami}
            {instance_user} (Most likely ec2-user as that seems to the be the default)
            {instance_type} (In our case, we created a t2.micro, but this is just a test instance)
            {instance_ip_address} (Found when navigating EC2 > Instances > {click on Instance ID} > "Connect to Instance" Button > "EC2 Instance Connect" tab)

    ### Install Terraform if it's not already installed
    ### In the project root directory, run the following commands
    - terraform init or terraform init -upgrade
    ### Create a file called vars.tf at the root of the project directory
        should be at the same level as the terraform.tf file
        ```
            locals {
            access_key = {your_iam_user_access_key}
            secret_key = {your_iam_user_secret_key}
            region = {your_iam_user_aws_region}
            ami = {your_ami_of_the_instance_you_just_created}
            instance_name = {instance_name}
            instance_user = {instance_user}
            instance_type = {instance_type}
            git_repo_url = {this_git_repo_url}
            project_name = {this_git_repo_name} 
            private_key_path = {path_to_the_pem_file_for_the_key_pair_you_created_when_you_created_the_instance}
            instance_ip_address = {instance_ip_address}
            }
        ```
        Substitute the values in the curly braces with the values you got from the previous steps
        This will pass in the values as local variables to the terraform.tf file during deployment
    ### 
        Makes sure your terraform state is empty by running the following command and observing the output
            terraform state list

        If there are any residule states, remove them first
            terraform state rm {state_name}

        Then Run terraform init --upgrade again

      Run the following command

            terraform import aws_instance.{instance_name} {instance_id}

      This tells terraform to import and use the existing EC2 instance that was previously created in AWS
      Instead of creating a new instance, terraform will use the existing one

    ### Run Terraform Plan to review all the changes that will be made to the AWS infrastructure
            terraform plan
        If there are any errors, fix them and run the command again

    ### Run Terraform Apply to deploy the app to AWS EC2 Instance
            Note :  In Terrafrom.tf, there is a provisioner that will 
                    run a shell script to install Java 17 and Gradle 7.6.1 in the remote mahcine
                    and then run the app

## Setting up github actions to deploy the app with CI/CD support
    