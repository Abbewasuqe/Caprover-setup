## Installation
Set up the infrastucture for caprover-server and caprover-worker
```sh
Terraform init && Terraform apply
ansible-playbook -i inventory.yml docker-playbook.yml
ansible-playbook -i inventory.yml caprover-playbook.yml  
```
CapRover is initialized, you can visit ```http://[IP_OF_YOUR_CAPROVER_SERVER]:3000``` in your browser and login to CapRover using the default password ```captain42```

the server we just deployed is running in the cloud and this CLI tool we are about to install can be setup in your local machine. So open up your local machine and let us go ahead to install CapRover CLI.

## Set up Caprover CLI
Now you are able to install the CapRover CLI with the following command.
```
 npm install -g caprover
```
Then run 
```
 caprover serversetup
```
This will guide you through a multi step process including putting in your domain that will allow you to configure the server.
Go to https://captain.example.example.example and login with the password that you used during CLI server setup. This should now bring you to a dashboard page
## Cluster
To get started, you are going to need to have another server that you are going to add to the cluster. You will need SSH access for this server.

The first thing you are going to need to do is to enable a Docker Registry through the CapRover dashboard. You can navigate here by logging into your CapRover server and clicking the “Cluster” tab on the left side.

Then, you are going to want to click “Add Self-Hosted Registry” and follow the popup to create your own registry

If you scroll down, you should see a section labeled “Nodes” and this is where we are going to add our new server.

We are going to need to generate a private/public key on our server that has CapRover on it. First, you are going to want to ssh into your server that is running CapRover using the following command.
```sh
$ ssh user@remoteip (for example, $ ssh root@172.34.312.43)
```
Once inside, we are able to generate a pair of private and public keys on the remote machine. You can do this with the following command.
```sh
ssh-keygen
```
This will create two files.

```
/username/.ssh/id_rsa
```
and 
```
/username/.ssh/is_rsa.pub
```
We are going to need the contents of both of these files, so save them somewhere so that we can use them at a later time.

Now, we are going to need to SSH into our new server. This is so we are able to add the public key that we just generated into our new servers “known hosts”. Once you are inside the new server, navigate to the following file.
```
/username/.ssh/known_hosts
```

Then, add the public key that we generated in previous step on a new line in this file with whatever editor you prefer.

Once you have that step completed we can finally add our new server to the cluster. First, go back to the “Cluster” page on the dashboard and scroll down to “Nodes”. We now have all of the data that we need to attach a new node.

You should only need to fill in two fields here as your CapRover IP Address should already be installed on the machine.

New node IP Address: This should be the IP address of the new server that you want to add as a node. You can generally find the IP address on the admin panel of whatever service you have the server registered with.

SSH Private Key for username: This is the private key that we generated a few steps before, that comes from the id_rsa file on your CapRover machine.

If you followed all the previous steps correctly, you should be able to click “Join Cluster” and you should now see your new server added below as a worker node.
er.

If it is not working you can run the commands manually your self from an SSH session. First, from your main leader node, run the following command:
```
docker swarm join-token worker
```
It will output something like this:
```To add a worker to this swarm, run the following command:```
```
docker swarm join --token SWMTKN-secret-token-here 127.0.0.1:2377
```

Then, copy the command from the output of above, and simply from the worker node, run that command.


