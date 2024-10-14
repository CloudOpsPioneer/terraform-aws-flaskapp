# app-eks

This section walks through the deployment of webapp on AWS EKS cluster.

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

## Troubleshooting 
To check connectivity of any app running on pod.

#### ClusterIP
Run either one of the commands to test.
```sh
kubectl run busybox --image=busybox -- sleep 4800
kubectl exec -it busybox -- telnet <pod_ip>:<default port of container>  [ Ex: kubectl exec -it bus -- telnet 10.74.51.19:80 ]
kubectl exec -it busybox -- telnet <svc ip>:<target port in service> [ Ex: kubectl exec -it bus -- telnet 10.74.51.216 8080 ]
```
