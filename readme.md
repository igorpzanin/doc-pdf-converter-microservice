<h1>doc-pdf-converter-microservice</h1>
The main goal is to run the Python application every 5 minutes in a Docker container to convert all DOC/DOCX files in a host tmp directory and add them to an S3 bucket on AWS.
<h2>1) Run Terraform Ec2</h2>
1) Join modules dir:

>     cd terraform/modules

2) Init terraform
>     terraform init

3) Apply terraform
>     terraform apply -y

<h2>2) SSH aws ec2</h2>

Before join SSH you must copy the microservice directory into de ec2 instance:

>     scp -i /your/path/to/aws-ec2-server.pem -r /home/user/my_project ec2-user@192.0.2.0:/home/ubuntu

Must change your aws-ec2-server.pem path, microservicem path and the correct ec2 dns 

To SSH the ec2 instance run the command:

>     ssh -i /your/path/to/aws-ec2-server.pem ubuntu@ec2.compute-1.amazonaws.com

Must change your aws-ec2-server.pem path and the correct ec2 dns 

<h2>3) Install Docker</h2>
1) Set up Docker's apt repository.

>     # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

2) Install the Docker packages.
>     sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

To add a cron to run the application every 5 minutes:
>     (crontab -l ; echo "*/5 * * * * cd /home/ubuntu/wordpdfconverter/app && sudo docker compose up") | crontab -

<h2>Changes</h2>


In the script.py, you must change your AWS credentials and Bucket name.

Must change in modules.tf the private key path, ami and the vpc

I'm leaving the Dockerfile in this repository just to show what is in the image I'm using, but it's not necessary for the container's functioning