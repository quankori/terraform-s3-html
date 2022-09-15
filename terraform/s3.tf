resource "aws_s3_bucket" "static" {
  bucket = "kori-landing-page"
  acl    = "public-read"
  policy = file("./policies/s3_static_policy.json")

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_object" "object" {
  for_each     = fileset(path.module, "../sources/**/*")
  bucket       = aws_s3_bucket.static.id
  key          = replace(each.value, "../sources", "")
  source       = each.value
  etag         = filemd5("${each.value}")
  content_type = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
}
