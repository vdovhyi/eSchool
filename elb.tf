resource "google_compute_forwarding_rule" "default" {
  project               = "${var.project}"
  name                  = "lbb"
  target                = "${google_compute_target_pool.default.self_link}"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "8080"
}

resource "google_compute_target_pool" "default" {
  project          = "${var.project}"
  name             = "lbbackend"
  instances        = ["${google_compute_instance.instance_app.*.self_link}"]
  region           = "${var.region}"
  session_affinity = "NONE"

  health_checks = [
    "${google_compute_http_health_check.http_health_check.self_link}"
  ]
}

resource "google_compute_http_health_check" "http_health_check" {
  name               = "http-health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
  port = "8080"

}