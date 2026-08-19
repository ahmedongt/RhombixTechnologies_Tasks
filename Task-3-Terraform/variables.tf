variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 Instance Type (Free Tier eligible)"
  type        = string
  default     = "t2.micro"
}

variable "s3_bucket_name" {
  description = "Globally unique S3 Bucket Name"
  type        = string
  default     = "rhombix-devops-task-storage-2026-sadeem" 
}