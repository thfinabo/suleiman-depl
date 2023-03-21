# suleiman-depl

This deployment consists of a microservice app, a simple profile web page, Prometheus and Grafana all running in a Kubernetes cluster.

### Current Structure

1. eks-cluster-tf-scripts contains the terraform scripts that would be used by jenkins to deploy the kubernetes cluster on AWS.
2. Jenkinsfiles contains the three jenkinsfile, three because I made my deployment run in three build, which are very dependent on one another.
3. jenkins-server-tf-scripts contains the terraform scripts to deploy an ec2 instance that would run the Jenkins server. 
4. k8s-manifests contains the scripts/manifest of the monitoring app, alerting app (I never fully configured though), sock shop microservice app and my personal webpage.
5. delete-resources-jenkinsfile is my way of deleting everything created on AWS by jenkinsfile. 


### Pre-requisite for the build

1. A S3 bucket must be created which matches the bucketname in the eks-cluster-tf-scripts/backend.tf and jenkins-server-tf-scripts/backend.tf files
2. A key must be created which matches with keyname in the jenkins-server-tf-scripts/jenkins-server.tf file.
3. AWSCli must be installed, Terraform too.
4. AWS Access key ID and Secret Access key must be generated in other to configure awscli to have access to the aws account


### How to build
1. Run the jenkins-server-tf sccript on any laptop that has the above pre-requites all installed and set up.
	a. cd into the jenkins-server-tf dir and run the following commands
		"terraform init"
		"terraform apply --auto-approve"

	b. Wait until the deployment is complete and copy the IP address of the instance created on AWS. Jenkins will be running would be running on that instance already. But to access it, you will have to append the port ":8080" to the IP address you copied from the output. (Jenkins run on port 8080) e.g "10.100.256.56:8080
	
	c. When Jenkins load up, you will be asked for a default password which can be found in a path shown on the welcome page of jenkins. You will need to ssh into the server from the terminal, which is the reason for the key.pem generated from aws.
	
	d. Upon successful login, you will need to set up jenkins.
	
2. After setup, you will need to create three 3 credentials;
	a. Github credentials -> using the username with password type
	b. AWS access key -> using the secret text type of credentials. The ID here must match this "AWS_ACCESS_KEY_ID" and the secret is your access key
	c. AWS secret access key -> using the same secret type of credentials. The ID must match this too "AWS_SECRET_ACCESS_KEY" and the secret is your aws secret access key
	
 PS: Navigate to Manage jenkins on your dashboard, scroll down and select manage credentials. You will click on the little blue text clearly written as "global" to find the page to create credentials. Then click on a button with the inscription add credentials
 
3. After creating credentials, you will need to create pipelines. I have three jenkinsfile which means you will need to create three pipeline. This is because there are some dependencies when deploying the monitoring app "some importation of dashboard".
	
	a. Click on new item on the dashboard, enter a pipeline name, choose the "pipeline" type of pipeline and click ok
	
	b. Leave all defaults, scroll down to where 
	

