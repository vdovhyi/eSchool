data "null_data_source" "auth_mysql_allowed_1" {
  count  = "${var.countnat}"
  inputs = {
    name   = "nat-${count.index + 1}"
    value  = "${element(google_compute_address.address.*.address, count.index)}"
  }
}

resource "google_sql_database_instance" "instance" {
    name               = "${var.project}-db-instance313"
    region             = "${var.region}"
    database_version   = "${var.database_version}"

    settings {
        tier             = "db-f1-micro"
        disk_autoresize  = "${var.disk_autoresize}"
        disk_size        = "${var.disk_size}"
        disk_type        = "${var.disk_type}"
        ip_configuration {
            ipv4_enabled = "true"
            authorized_networks = [
               "${data.null_data_source.auth_mysql_allowed_1.*.outputs}"
            ]
        }
    }
}
resource "google_sql_database" "default" {
  name      = "${var.db_name}"
  project   = "${var.project}"
  instance  = "${google_sql_database_instance.instance.name}"
  charset   = "${var.db_charset}"
  collation = "${var.db_collation}"
}

resource "google_sql_user" "default" {
  name     = "${var.user_name}"
  project  = "${var.project}"
  instance = "${google_sql_database_instance.instance.name}"
  host     = "${var.user_host}"
  password = "${var.user_password}"
}