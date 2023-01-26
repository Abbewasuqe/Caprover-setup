## Continuous Deployment with GitLab CI.
- Go to Gitlab.com and login to your account
- Click on "New Project" to create a new repository
- Click on "Create blank project"
- Name your project and finish your project creation

## Add Sample Source Code

- For this tutorial we'll work with a very easy sample source code containing one file
``` index.php```
```
<?php echo 'PHP output: Hello World!'; ?> 
```
- In order to build on a 3rd party build system, you need to have a Dockerfile.
- In this tutorial, we'll use the PHP Dockerfile:
``` dockerfile```
``` 
FROM php:7.3-apache
COPY ./ /var/www/html/
``` 
# Create an Access Token for CapRover

CapRover needs to pull the built images from GitLab, so we need to create an access token. Navigate to https://gitlab.com/-/profile/personal_access_tokens and create a token.

Make sure to assign read_registry and write_registry permissions for this token.

One you created the token move to the next step:
# Add Token to CapRover

Login to your CapRover web dashboard, under Cluster click on Add Remote Registry. Then enter these fields:

    Username: your gitlab username
    Password: your gitlab Token [From the previous step]
    Domain: registry.gitlab.com
    Image Prefix: again, your gitlab username
# Create a CapRover App
On CapRover dashboard and create an app, we call it my-test-gitlab-deploy

# Create CI/CD Variables

Next, go to your project page on GitLab, navigate to Settings > CI/CD. Then, under Variables add the following variables:

    Key : CAPROVER_URL , Value : https://captain.root.domain.com [replace it with your domain]
    Key : CAPROVER_PASSWORD , Value : mYpAsSwOrD [replace it with your password]
    Key : CAPROVER_APP , Value : my-test-gitlab-deploy [replace it with your app name]

Add all these 3 variables. For best security make sure they are they are protected. It's okay if they are not masked, they won't appear in logs.
# GitLab CI File

So far, we have two files in our directory index.php and Dockerfile. Now let's add GitLab's specific build instructions:

IMPORTANT Make sure your ``` .gitlab-ci.yml```  is spelled exactly as this. It starts with a dot.

``` .gitlab-ci.yml``` 
``` 
build-docker-master:
  image: docker:19.03.1
  stage: build
  services:
    - docker:19.03.1-dind
  before_script:
    - export DOCKER_REGISTRY_USER=$CI_REGISTRY_USER # built-in GitLab Registry User
    - export DOCKER_REGISTRY_PASSWORD=$CI_REGISTRY_PASSWORD # built-in GitLab Registry Password
    - export DOCKER_REGISTRY_URL=$CI_REGISTRY # built-in GitLab Registry URL
    - export COMMIT_HASH=$CI_COMMIT_SHA # Your current commit sha
    - export IMAGE_NAME_WITH_REGISTRY_PREFIX=$CI_REGISTRY_IMAGE # Your repository prefixed with GitLab Registry URL
    - docker login -u "$DOCKER_REGISTRY_USER" -p "$DOCKER_REGISTRY_PASSWORD" $DOCKER_REGISTRY_URL # Instructs GitLab to login to its registry

  script:
    - echo "Building..." # MAKE SURE NO SPACE ON EITHER SIDE OF = IN THE FOLLOWING LINE
    - export CONTAINER_FULL_IMAGE_NAME_WITH_TAG=$IMAGE_NAME_WITH_REGISTRY_PREFIX/my-build-image:$COMMIT_HASH
    - docker build -f ./Dockerfile --pull -t built-image-name .
    - docker tag built-image-name "$CONTAINER_FULL_IMAGE_NAME_WITH_TAG"
    - docker push "$CONTAINER_FULL_IMAGE_NAME_WITH_TAG"
    - echo $CONTAINER_FULL_IMAGE_NAME_WITH_TAG
    - echo "Deploying on CapRover..."
    - docker run caprover/cli-caprover:v2.1.1 caprover deploy --caproverUrl $CAPROVER_URL --caproverPassword $CAPROVER_PASSWORD --caproverApp $CAPROVER_APP --imageName $CONTAINER_FULL_IMAGE_NAME_WITH_TAG
  only:
    - main
``` 
Commit and push this file to your GitLab repository. 
Wait a little bit until your build is finished and deployed automatically! After a few minutes you can see your deployed app on CapRover.
