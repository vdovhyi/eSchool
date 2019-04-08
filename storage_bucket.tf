resource "google_storage_bucket" "mystorage_bucket" {
  count         = 1
  name          = "${var.bucketName}"
  location      = "${var.bucketLocation}"
  storage_class = "${var.storage_class}"
  force_destroy = "true"
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_storage_default_object_access_control" "public_rule" {
  bucket = "${google_storage_bucket.mystorage_bucket.name}"
  role   = "READER"
  entity = "allUsers"
}