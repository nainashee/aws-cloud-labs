# S3 Storage Lab

## What I Built
An S3 bucket with hands-on exploration of object storage, access control, and programmatic access via boto3.

## Architecture
```
Local Machine
    |
boto3 (Python SDK)
    |
AWS S3
    |
practice-bucket-nainashee
    |
Objects (IMG_3627.jpg, farm.jpg)
```

## What I Did
- Created an S3 bucket: practice-bucket-nainashee (us-west-1)
- Uploaded IMG_3627.jpg (6.8 MB) via the AWS console
- Attempted to access the object via its public URL
- Received AccessDenied — confirmed buckets are private by default
- Explored the difference between public access and presigned URLs
- Installed boto3 and configured AWS credentials via `aws configure`
- Wrote a Python script to list all S3 buckets and upload a file programmatically
- Confirmed farm.jpg appeared in the bucket after running the script

## Key Concepts Learned
- S3 buckets are private by default — least privilege applied at the storage level
- Object URL = public URL, accessible to anyone if bucket is public
- Presigned URL = temporary, expiring URL — secure way to share objects without making the bucket public
- boto3 authenticates using Access Key ID + Secret Access Key stored in `~/.aws/credentials`
- `aws configure` creates the credentials file that boto3 reads automatically
- boto3 naming pattern mirrors IAM actions: `s3:ListBuckets` → `s3.list_buckets()`

## boto3 Methods Used
| Method | What it does |
|--------|-------------|
| `boto3.client('s3')` | Creates an S3 client connected to your AWS account |
| `s3.list_buckets()` | Returns all buckets in the account |
| `s3.upload_file(local_path, bucket, key)` | Uploads a local file to S3 |
| `s3.download_file(bucket, key, local_path)` | Downloads an object from S3 |

## Mistakes Made and Fixed
- Windows file path backslashes caused a `unicodeescape` error in Python — fixed by adding `r` prefix to make it a raw string: `r'C:\Users\...'`
- Tried to access a private object via public URL — received AccessDenied, which is the correct default behavior
