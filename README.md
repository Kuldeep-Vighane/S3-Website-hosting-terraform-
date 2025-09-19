# Terraform S3 Static Website Hosting 🚀

This project demonstrates how to **host a static website on Amazon S3 using Terraform**.  
It automates the creation of the S3 bucket, applies permissions, uploads files, and enables website hosting.

---

## 📌 Objectives
1. Create an S3 bucket for static website hosting.  
2. Configure ownership and public access settings.  
3. Apply a bucket policy for **public read access**.  
4. Upload website files (`index.html`, `error.html`, `profile.jpeg`).  
5. Enable website hosting.  
6. Troubleshoot IAM permission issues.  

---

## 🛠️ Steps Implemented

### 1. Created S3 Bucket

resource "aws_s3_bucket" "mybucket" {
  bucket = var.SimplStoragebucket
}


2. Set Ownership Controls

resource "aws_s3_bucket_ownership_controls" "BucketOwnerShip" {
  bucket = aws_s3_bucket.mybucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


3. Configured Public Access Settings

resource "aws_s3_bucket_public_access_block" "Bucketaccessblock" {
  bucket = aws_s3_bucket.mybucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


4. Applied Bucket Policy (Public Read)

resource "aws_s3_bucket_policy" "publicread" {
  bucket = aws_s3_bucket.mybucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.mybucket.arn}/*"
      }
    ]
  })
}


5. Uploaded Website Files

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}


6. Enabled Website Hosting

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id
  index_document { suffix = "index.html" }
  error_document { key = "error.html" }
  depends_on = [ aws_s3_bucket_policy.publicread ]
}


7. IAM Troubleshooting
Faced AccessDenied for s3:PutBucketPolicy.

Fixed by attaching AdministratorAccess policy to Admin-user:



aws iam attach-user-policy \
  --user-name Admin-user \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
🔑 Key Learnings
Terraform simplifies AWS provisioning with reusable infrastructure as code.

Public access requires disabling Block Public Access first.

IAM users need AdministratorAccess for bucket policy changes.

Hosting a website on S3 requires:

Bucket creation

File upload

Public read policy

Website configuration

✅ Outcome
S3 bucket created successfully.

Website files uploaded.

Public access configured (after fixing IAM issue).

Website hosting enabled.

📂 Project Structure

TerraformS3WebHosting/
│── main.tf
│── variables.tf
│── outputs.tf
│── index.html
│── error.html
│── profile.jpeg
│── .gitignore
│── README.md



⚡ How to Use
Clone this repository:

git clone https://github.com/Kuldeep-Vighane/TerraformS3WebHosting.git
cd TerraformS3WebHosting
Initialize Terraform:

terraform init
Apply configuration:

terraform apply -auto-approve
Access your website via the S3 website endpoint provided in AWS.
