# suleiman-depl

This deployment consists of a microservice app, a simple profile web page, Prometheus and Grafana all running in a Kubernetes cluster.

### Kindly Find the proof of my work in the "proof-of-work" directory

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

##### Pre-requisite: Duplicate the jenkins-server-tf elsewhere because, when you run terraform init, a .terraform dir would be created which would make it impossible to push to GitHub and also to make your GitHub code clean from unwanted files.

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
	
	b. Leave all defaults, scroll down to where to select the pipeline script from, select pipeline from Source Control Manager (SCM). Fill in the details that appears next. 
	PS: You will need a GitHub URL here, that is where Jenkins would pull the scripts/instructions/build from. You can fork this repo or make a clone.
	c. Follow same steps when creating deployment 2 and deployment 3, but this time around, make sure you select a "build trigger", deployment 2 should be triggered by successful deployment of deployment of 1 and also select "Quiet period" and add time to me it, about 300secs. Do same with deployment 3 but it should triggered by deployment 2 and Quiet period should be about 120secs.
	d. When the deployment are completed, you can check your AWS GUI and navigate to load balancer, there you would find 6 LB, 2 of which are internal and 4 Internet-facing. It is from those 4 LB you would be able to access the; sock shop app, my app, prometheus and grafana. 
	e. You can now navigate to Route53 amd set up a hosted zone, then create some record set with the load balancer's DNS setting it to CNAME type. Also not forget to make the changes in your domain name provider (e.g Namecheap...)
	f. Doing this, you should now be able to view the applications from your set sub-domain/domain names.
	
## Deleting Resources

	a. Copy the content of the "delete-resources-jenkinsfile" file and replace it with the jenkinsfile1 content. 
	b. Push the changes to GitHub
	c. Then disable deployment 2 and 3. 
	d. Then click on build on deployment 1 and everything shall be destroyed. 
	e. To destroy the jenkins-server, you will need to go back to the directory where you had a copy of the jenkins-server-tf dir. Open a terminal in the jenkins-server-tf directory and run the command "terraform destroy --auto-approve" and the jenkins server shall to be deleted.
	
