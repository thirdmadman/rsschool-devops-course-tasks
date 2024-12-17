# Task 9

## Overview

This is Terraform configuration to deploy a one Bastion Host/Nat Gateway (combined) and kubernetes cluster (represented as one master node).

Overall infrastructure has been inherited from task_2 with slight changes. It's supposed you already setup all the prerequisites from task_2 and task_1.

### Prerequisites

Before running this code locally you need to make sure to create ```backend.tfvars``` file with all needed variables. Example may be found in ```backend.tfvars.example```

Install kubectl for your local machine.

## Deploy

### Copy config to local machine

In result of ```terraform apply``` command you will get output of ips: public IP of the NAT instance, private IP of the k3s main instance.

You need to connect to the main node of the cluster using ssh via basion/nat instance. To do this use following command:
```ssh -A -J ec2-user@<PUBLIC-IP-NATGW> ec2-user@<PRIVATE-IP-K3S-MAIN>```

After this you need to copy file ```/etc/rancher/k3s/k3s.yaml``` to your local computer into desired directory.

Then you need to setup port forwarding for k3s main node API

### Port forwarding Linux

To do this on Linux you can use following command:
```ssh -f -N -A -L 6443:<PRIVATE-IP-K3S-MAIN>:6443 ec2-user@<PUBLIC-IP-NATGW>```
This will start to forward traffic from port 6443 to port 6443 on the private IP address of the k3s main node in foreground.

### Port forwarding Windows

To make port forwarding work on Windows you need to use XShell ssh client.

1. Open Xshell.
2. If the Sessions dialog box does not automatically opens up, click Open on the Flie menu.
3. In the Sessions dialog box, right click on the session that connects to your remote host, and then click Properties.
4. In the Category menu, Click Tunneling. 
5. In the TCP/IP Forwarding section, click Add. (RESULT: Forwarding Rule dialog box opens.)
6. In the Type list, select Local (Outgoing).
7. For Source Host, enter the "localhost".
8. In the Listen Port field, enter "6443"
9. In the Destination Host field, enter private IP of the k3s main instance.
10. In the Destination Port field, enter "6443".
11. Click OK to save the changes.
12. Click Connect. New session tab will be opened. You need to keep this session up until you dont need to work more with remote kubectl.

### Using kubectl with remote cluster

To run kubectl without remote cluster locally with downloaded config k3s.yaml you cane use environment variable: KUBECONFIG, and set it to path to k3s.yaml. For example: 
```export KUBECONFIG=/home/user/Downloads/k3s.yaml```

As second variant you can use parameter "--kubeconfig" with kubectl, and set it to path to k3s.yaml. For example:

```kubectl get nodes --kubeconfig /home/user/Downloads/k3s.yaml```

### Testing cluster

To test the cluster, you can use

```kubectl get nodes```

To apply test workload:
````kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml```

To see all pods:
```kubectl get pods -o wide --all-namespaces```
