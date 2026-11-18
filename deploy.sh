
#!/usr/bin/env bash
set -euo pipefail

# Required deployment variables
: "${AWS_REGION:?AWS_REGION is required}"
: "${INSTANCE_ID:?INSTANCE_ID is required}"
: "${REGISTRY:?REGISTRY is required}"
: "${IMAGE_TAG:?IMAGE_TAG is required}"

echo "Starting Sneakers deployment..."
echo "Target EC2 instance: $INSTANCE_ID"
echo "Image tag: $IMAGE_TAG"

# Build the commands that will execute on EC2
REMOTE_COMMAND=$(
  printf 'export AWS_REGION=%q REGISTRY=%q IMAGE_TAG=%q\n' \
    "$AWS_REGION" "$REGISTRY" "$IMAGE_TAG"

  cat <<'REMOTE_SCRIPT'
set -eu

cd /home/ubuntu/sneakers-app

echo "Logging into Amazon ECR..."

aws ecr get-login-password --region "$AWS_REGION" | \
  docker login --username AWS --password-stdin "$REGISTRY"

echo "Pulling the new Sneakers image..."

docker compose pull app

echo "Updating Sneakers container..."

docker compose up -d --no-deps app

docker image prune -f

echo "Sneakers deployment completed!"
REMOTE_SCRIPT
)

# Send deployment commands to EC2 through SSM
COMMAND_ID=$(aws ssm send-command \
  --region "$AWS_REGION" \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --parameters "$(jq -cn --arg script "$REMOTE_COMMAND" '{commands: [$script]}')" \
  --query "Command.CommandId" \
  --output text)

echo "SSM command ID: $COMMAND_ID"

# Wait for deployment to finish
if ! aws ssm wait command-executed \
  --region "$AWS_REGION" \
  --command-id "$COMMAND_ID" \
  --instance-id "$INSTANCE_ID"; then

  echo "Deployment failed!"

  aws ssm get-command-invocation \
    --region "$AWS_REGION" \
    --command-id "$COMMAND_ID" \
    --instance-id "$INSTANCE_ID" \
    --output json

  exit 1
fi

echo "Sneakers deployment completed successfully!"
