resource "aws_s3_bucket" "mybucket" {
  bucket = var.SimplStoragebucket
}

# ✅ Ownership controls (needed to avoid ACL issues)
resource "aws_s3_bucket_ownership_controls" "BucketOwnerShip" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# ✅ Allow public policies (bucket level)
resource "aws_s3_bucket_public_access_block" "Bucketaccessblock" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# ✅ Bucket policy for public read (no ACLs needed)
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

# ✅ Upload index.html
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}

# ✅ Upload error.html
resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "error.html"
  source       = "error.html"
  content_type = "text/html"
}

# ✅ Upload profile.jpeg
resource "aws_s3_object" "profilepic" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "profile.jpeg"
  source       = "profile.jpeg"
  content_type = "image/jpeg"
}

# ✅ Website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_policy.publicread ]
}
