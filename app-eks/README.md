# app-eks

This section walks through the deployment of webapp on AWS EKS cluster.

## Prerequisite
Install docker and start the docker daemon service
```
sudo yum install docker -y
sudo chmod 777 /var/run/docker.sock
sudo systemctl restart docker
```



To list the available charts of ALB controller in helm
```
helm repo add eks-charts https://aws.github.io/eks-charts
helm repo list
helm search  repo eks-charts/aws-load-balancer-controller
helm search  repo eks-charts/aws-load-balancer-controller  --versions
```