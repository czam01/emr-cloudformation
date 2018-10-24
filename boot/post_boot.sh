#!/bin/bash
instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
arn_target=$(aws elbv2 describe-target-groups --region us-east-1 |grep mach-big-data-target-emr-spot | grep arn |cut -c32-141)
aws elbv2 register-targets --target-group-arn $arn_target --region us-east-1 --targets Id=$instance_id,Port=8890

