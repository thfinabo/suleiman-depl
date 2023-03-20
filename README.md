# suleiman-depl

This deployment consists of a microservice app, a simple profile web page, Prometheus and Grafana all running in a Kubernetes cluster.

### Current Structure

1. eks-cluster-tf-scripts contains the terraform scripts that would be used by jenkins to deploy the kubernetes cluster on AWS.
2. Jenkinsfiles contains the three jenkinsfile, three because I made my deployment run in three build, which are very dependent on one another.
3. jenkins-server-tf-scripts contains the terraform scripts to deploy an ec2 instance that would run the Jenkins server. 
4. k8s-manifests contains the scripts/manifest of the monitoring app, alerting app (I never fully configured though), sock shop microservice app and my personal webpage.
5. delete-resources-jenkinsfile is my way of deleting everything created on AWS by jenkinsfile. 


### Prequisite for the build

1. A S3 bucket must be created which matches the bucketname in the eks-cluster-tf-scripts/backend.tf and jenkins-server-tf-scripts/backend.tf files
2. A key must be created which matches with keyname in the jenkins-server-tf-scripts/jenkins-server.tf file.
3. AWSCli must be installed, Terraform too.

