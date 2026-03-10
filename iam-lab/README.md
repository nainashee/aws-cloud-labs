# IAM (Identity and Access Management) Lab

## What I Built
Hands-on exploration of AWS IAM — creating users, writing custom policies from scratch, testing least privilege, and comparing custom vs managed policies.

## Architecture
```
AWS Account
    |
IAM User (practice-user)
    |
Custom Policy OR Managed Policy
    |
EC2 Service (DescribeInstances)
```

## What I Did
- Created an IAM user: practice-user with no permissions
- Attempted EC2 actions → confirmed Access Denied with zero permissions
- Wrote a custom JSON policy granting only `ec2:DescribeInstances` on `*`
- Attached the policy → confirmed read access worked
- Removed the policy → confirmed access was immediately revoked
- Attached AWS managed policy `AmazonEC2ReadOnlyAccess` → compared scope to custom policy
- Wrote a custom JSON policy from scratch for a Lambda function with two statements:
  - Statement 1: `s3:GetObject` on `arn:aws:s3:::my-data-bucket/*`
  - Statement 2: `logs:CreateLogGroup`, `logs:CreateLogStream`, `logs:PutLogEvents` on `*`
- Cleaned up: deleted practice-user and all custom policies

## IAM Policy JSON Structure
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DescribeEC2Instances",
      "Effect": "Allow",
      "Action": ["ec2:DescribeInstances"],
      "Resource": "*"
    }
  ]
}
```

| Component | Purpose |
|-----------|---------|
| Sid | Statement ID — a label for the statement |
| Effect | Allow or Deny |
| Action | The AWS API action(s) being permitted or denied |
| Resource | The specific AWS resource(s) the action applies to |

## Key Concepts Learned
- IAM follows least privilege — grant only what is needed, nothing more
- Custom policies = precise, scoped to exact actions needed
- Managed policies = broader scope, maintained by AWS, easier but less precise
- Removing a policy immediately revokes access — no delay
- CloudWatch Logs actions use the prefix `logs:` not `cloudwatch:`
- Action arrays require square brackets: `["action1", "action2"]`
- Resource ARNs can be scoped: `arn:aws:s3:::bucket-name/*` limits to objects inside a specific bucket

## Mistakes Made and Fixed
- Initially used `"cloudwatch:CreateLogGroup"` — incorrect prefix, correct is `"logs:CreateLogGroup"`
- Forgot square brackets around multiple actions in the Action field — JSON syntax error
