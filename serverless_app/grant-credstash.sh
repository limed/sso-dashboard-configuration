#!/bin/bash

region="us-east-1"
credstash_key_id="`aws --region $region kms list-aliases --query "Aliases[?AliasName=='alias/credstash'].TargetKeyId | [0]" --output text`"
role_arn="`aws iam get-role --role-name sso-dashboard-dynamo-loader-prod-us-west-2-lambdaRole --query Role.Arn --output text`"
constraints="EncryptionContextEquals={app=sso-dashboard}"

# Grant the sso-dashboard IAM role permissions to decrypt
aws kms create-grant --key-id $credstash_key_id --grantee-principal $role_arn --operations "Decrypt" --constraints $constraints --name sso-dashboard-dynamo-publishing
