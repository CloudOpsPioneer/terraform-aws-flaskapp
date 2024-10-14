# app-eks

This section will guide you through the deployment of a Web Application on the AWS Elastic Kubernetes Service (EKS) cluster. While multiple documentations and blogs might suggest using eksctl to simplify the process of creating necessary resources, we will not be using eksctl in this tutorial.

The primary reason for this choice is that eksctl automates the creation of resources via AWS CloudFormation stacks. Although convenient, this automation can sometimes obscure the details of the infrastructure, making it challenging to understand or audit the exact resources created. Without using eksctl, we will have more visibility and control over each component deployed, allowing for a more granular management and customization of the Kubernetes environment tailored specifically for our WebApp.

## Prerequisite
Install docker and start the docker daemon service
```sh
sudo yum install docker -y
sudo chmod 777 /var/run/docker.sock
sudo systemctl restart docker
```

To list the available charts of ALB controller in helm
```sh
helm repo add eks-charts https://aws.github.io/eks-charts
helm repo list
helm search  repo eks-charts/aws-load-balancer-controller
helm search  repo eks-charts/aws-load-balancer-controller  --versions
```

To install kubectl, refer the AWS documentation [install-kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html#kubectl-install-update)
```sh
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.30.4/2024-09-11/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
```
To create kubeconfig, refer the AWS documentation [create-kubeconfig](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html)
```sh
aws eks update-kubeconfig --region us-east-1 --name <EKS_CLUSTER_NAME>
```

## Troubleshooting 
To check connectivity of any app running on pod.

#### ClusterIP
Run either one of the commands to test.
```sh
kubectl run busybox --image=busybox -- sleep 4800
kubectl exec -it busybox -- telnet <pod_ip>:<default port of container>  [ Ex: kubectl exec -it bus -- telnet 10.74.51.19:80 ]
kubectl exec -it busybox -- telnet <svc ip>:<target port in service> [ Ex: kubectl exec -it bus -- telnet 10.74.51.216 8080 ]
```
