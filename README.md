# What I did step by step

This tutorial provides a step-by-step guide to creating a CI/CD pipeline, 
building a Docker image, pushing it to GitHub Container Registry (GHCR), 
provisioning an AWS EC2 instance with Terraform, and running your container on EC2.

---

## Docker Setup on Windows

1. Install Docker Desktop and start it.
2. Verify Docker installation by checking its version.
3. Prepare your application Docker image by writing a Dockerfile 
   that sets up the working directory, copies your source files, compiles Java files, 
   exposes the required port, and sets the default command to launch your app.
4. Build the Docker image locally and verify that it works.
   * docker build -t <name> . _example devops-demo_
   * docker run -p <host-port>:<container-port> <name> _example: 8080:80_

---

## GitHub Actions Workflow
1. Check code works locally
   * javac src/handlers/*.java src/*.java
   * java -cp src Launcher
2. Create a GitHub Actions workflow file in your repository.
3. Configure the workflow to trigger on push or pull request events for all branches.
4. Add steps to checkout the repository code.
5. Commit and push the workflow, then verify it runs in the GitHub Actions tab.
6. You can pull the image and run locally with command or with docker desktop
    * docker pull ghcr.io/<your-username>/<repo-name>/devops-demo:latest
   
---

## Terraform Setup for EC2

1. Create a Terraform configuration to define the AWS provider and region.
2. Generate an RSA key pair for SSH access to the EC2 instance.
3. Save the private key file locally with restricted permissions.
   * on ssh-ing I was getting Bad Permissions error and GPT told me to do this and it worked
   * icacls id_rsa_tofu.pem /inheritance:r
   * icacls id_rsa_tofu.pem /remove "NT AUTHORITY\Authenticated Users"
   * icacls id_rsa_tofu.pem /remove "BUILTIN\Users"
   * icacls id_rsa_tofu.pem /grant "${env:USERNAME}:F"
   * icacls id_rsa_tofu.pem
4. Define a security group to allow inbound HTTP and SSH traffic.
5. Define an EC2 instance resource that references the key pair and security group, associates a public IP, and sets appropriate tags.
6. Add outputs to retrieve the public IP and DNS of the EC2 instance.
7. Initialize Terraform, run a plan to verify changes, and then apply the configuration to create the EC2 instance.
   * terraform init
   * terraform plan
   * terraform apply

---

## SSH Access to EC2

1. Ensure your private key file has restricted permissions suitable for SSH.
2. Use the `ssh` command with the key to log in to the EC2 instance as the default user (`ec2-user`).
3. Confirm you can access the instance without permission errors.
    * ssh -i devops-demo-key.pem ubuntu@<public-ip> _depends what the instance is running on, could be ec2-user@<public-ip>
---

## Running Docker Container on EC2

1. Install Docker on the EC2 instance if it is not already installed.
2. Start the Docker service and enable it to start on boot.
3. Pull the Docker image from GHCR.
4. Run the container detached, mapping the container port to the instance port (e.g., port 80).
    * sudo apt update
    * sudo apt upgrade -y
    * sudo apt install docker.io -y
    * sudo systemctl start docker
    * sudo systemctl enable docker
    * docker pull ghcr.io/<your-username>/<repo-name>:latest
    * docker run -d -p 80:80 ghcr.io/<your-username>/<repo-name>:latest
      _In my case the latter two were:_
    * sudo docker pull ghcr.io/teodordichev/devopsrest/devops-demo:latest
    * sudo docker run -d -p 80:80 ghcr.io/teodordichev/devopsrest/devops-demo:latest
5. Verify the container is running and accessible locally.
    * http:\<public-ip>
6. Open the EC2 public IP in a browser to verify the app is serving traffic.
    
---

## Running Ansible playbook (step-by-step)

1. After all other steps are completed, and we have working EC2 instance we can run the playbook
2. Run this command in the ansible directory
   * ansible-playbook -i inventory.ini deploy.yml _It will connect to the instance, install docker and run the container_

---

This guide covers all steps from local development to deploying your containerized app on AWS EC2 with a CI/CD workflow in GitHub Actions.
Check instances in the browser here: https://us-east-1.console.aws.amazon.com/