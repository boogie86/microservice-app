## General description:

This is a simple app with 2 microservices:

The frontend is written in Python and makes use of the Flask framework.
The backend is a MySql database.

## Functionality: 


Once the app is up and running, it can be accessed via 
browser at http://localhost:5000 (or a custom http endpoint, if it;s deployed to an
online server). It has 3 "routes":

route("/"): Displays a simple welcome message.  It is accessible via http://localhost:5000.
route('/how are you'): Displays an answer to the question in the route name.  It is accessible via http://localhost:5000/how are you.
route('/read from database'): Reads and displays the records in the bac-end database.  It is accessible via http://localhost:5000/read from database.

## Steps to test the app functionality:

1. Go to the Github repo where the app code resides
2. Clone the repo to a local folder on your computer
3. Open a command window and navigate to the folder where you cloned the app 
4. Run the following command: docker-compose up. If everything works as expected, you should see something like this:
5. Open your browser and navigate to one of the 3 route URLs described above (http://localhost:5000, http://localhost:5000/how are you and http://localhost:5000/read from database):

https://imgur.com/7PxsrZJ

## Code setup explained:

The app is deployed via 2 Docker containers (MySql and Flask), based on 2 Dockerfiles (Dockerfile.mysql and Dockerfile.flask).
This setup is put together via a compose file (docker-compose.yml), where the 2 docker files are invoked, along
with some extra configurations. 

The flask container setup is fairly simple. It's based on the app.py file, which holds the front-end code (the 3 routes, the last of which contains a connection to the MySql back-end.  

The MySql container setup is based on 2 files:

dbinit.sql - SQL script that creates the database setup (creating and populating the database, table, user, etc.)
setup.sh - Unix script that orchestrates the database setup effort.

These 2 files are copied into the container at build time and serve as a container entrypoint. When the container is spawn, the sh script will be executed, calling the dbinit.sql, which will configure the database and make the back-end ready for receiving requests from the Flask front-end.

The password for the MySql database can be passed in one of two ways, both of which are set up inside the application:

Through secrets:
When we spin up the container setup via the docker-compose file, the credentials can be passed via docker secrets.
You will notice that in the compose file a docker secret is declared at the top(db_mysql_user_password). The secret is created based on the 
information found in the env file (an MD5 hash of the database password). This approach allows for a fully automated deployment of the setup - no manual intervention needed, including for the creation of the secret. 

Through MD5 hash:
In this app, the secret-based approach is used when the setup is spawned via docker-compose. Because - as part of the CI/CD pipeline - we are going to automate the building and deployment of the 2 containers to Docker Hub (through automated builds), we will have to build our containers via the Docker files instead. This is because currently Docker Hub does not support Automated Builds based on docker compose (only directly via dockerfiles). 

In this case we will pass the db credentials via the MD5 hash directly (as opposed to creating secrets based on the hash and then passing the secrets 
to the container). It's still secure, as the credentials are encrypted, but it's generally considered less safe that the first approach (for example, if someone gets a hold of the hash, they might run a brute force algorithm against a predefined list of passwords - if they get a match, they can use it to get access to the db). 

We can check the database to make sure everything is set up properly, by opening a shell session inside the container with this command:
docker exec -it  <container name/id> bash. The result should be something similar to this:

Further we can log into the db using the following command: mysql -udb_user -pPassw0rd. The result should be something like this:


The Docker Hub repository is integrated with Github, meaning that whenever we commit something to the Github repo, Docker Hub detects it and automatically starts building the 2 containers. If everything goes well and the build succeeds, the resulting artifacts are stored in the Docker Hub repo. This tutorial assumes an existing Docker Hub repo with the Automated Build functionality configured. If you don't have one, you can create an account at hub.docker.com, create a repo, integrate it with your Github repo and configure the automated builds functionality (one time configuration activity - done from the Docker Hub UI). 

## Steps for configuring automated builds in Docker Hub:

1. Assuming you are inside your Docker Hub, go to Builds ->Configure Automated Builds:

2. Set your Github repo as the origin for the builds:

3. Set the build rules like so:

4. Save your configuration by clicking the Save button.

## Voila! A fully automated CI/CD pipeline for our app, from local all the way to Docker Hub!




