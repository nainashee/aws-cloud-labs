# boto3 EC2 Automation Lab

## What I Built
A Python automation script using boto3 that lists EC2 instances, stops them, waits for full shutdown, and restarts them — with clean readable output at each step.

## Architecture
```
Python Script (boto3)
    |
~/.aws/credentials (Access Key ID + Secret Access Key)
    |
AWS EC2 API
    |
EC2 Instance (i-0d45306d367ca349c)
```

## What I Did
- Installed boto3 via pip
- Configured AWS credentials using `aws configure`
- Wrote a script to connect to EC2 using `boto3.client('ec2', region_name='us-west-1')`
- Listed all EC2 instances by looping through `response['Reservations']` → `['Instances']`
- Printed each instance's ID and current state
- Stopped an instance using `ec2.stop_instances()`
- Used a boto3 waiter (`instance_stopped`) to wait for full shutdown before proceeding
- Started the instance using `ec2.start_instances()`
- Added clean print statements at each step for readable output

## Final Script
```python
import boto3

# Connect to EC2
ec2 = boto3.client('ec2', region_name='us-west-1')

# 1. List all EC2 instances and print their ID and state
response = ec2.describe_instances()
for item in response['Reservations']:
    for instance in item['Instances']:
        print(instance['InstanceId'], instance['State']['Name'])

# 2. Stop the instance
print("Stopping Instance")
ec2.stop_instances(InstanceIds=['i-021bae146e098aea3'])

# Wait until fully stopped
print("Waiting for instance to fully stop")
waiter = ec2.get_waiter('instance_stopped')
waiter.wait(InstanceIds=['i-021bae146e098aea3'])

# 3. Start the instance
ec2.start_instances(InstanceIds=['i-021bae146e098aea3'])
print("Instance Started Successfully")
```

## Sample Output
```
i-021bae146e098aea3 running
Stopping Instance
Waiting for instance to fully stop
Instance Started Successfully
```

## Key Concepts Learned
- boto3 authenticates automatically by reading `~/.aws/credentials` — no hardcoded keys needed
- boto3 method names mirror IAM actions: `ec2:DescribeInstances` → `ec2.describe_instances()`
- EC2 describe_instances response is nested: `Reservations` → `Instances` → instance data
- Waiters poll AWS every few seconds until a resource reaches a target state — more reliable than using `time.sleep()`
- Calling `start_instances()` immediately after `stop_instances()` fails with `IncorrectInstanceState` — the instance must finish stopping first
- Hardcoding instance IDs is fine for practice but should be replaced with dynamic lookups in production scripts

## Mistakes Made and Fixed
- Used `run` instead of `python` to execute the script in PowerShell — corrected to `python '.\script.py'`
- Windows file path backslashes caused `unicodeescape` error — fixed with raw string prefix `r'C:\path\...'`
- Called `start_instances()` before instance finished stopping → `IncorrectInstanceState` error — fixed by adding a waiter between stop and start
- `print(response)` left in script caused messy raw output — removed and replaced with targeted print statements
