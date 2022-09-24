#!/bin/bash
set -e

RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;36m'
NC='\033[0m'

# Pretty print helper
function pprint() {
  printf "${1}${2}${NC}"
}


pprint $BLUE "Logging into ECR..."
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 405540451878.dkr.ecr.us-west-2.amazonaws.com
pprint $GREEN " OK\n"

pprint $BLUE "Building docker image...\n"
make docker-jupyter-build

pprint $BLUE "Tagging images..."
docker tag orion-jupyter:latest 405540451878.dkr.ecr.us-west-2.amazonaws.com/orion-jupyter
pprint $GREEN " OK\n"

pprint $BLUE "Pushing images to ECR...\n"
docker push 405540451878.dkr.ecr.us-west-2.amazonaws.com/orion-jupyter

pprint $BLUE "Deploying new images to ECS..."
aws ecs update-service --service orion --cluster orion --force-new-deployment > /dev/null
pprint $GREEN " OK\n"
