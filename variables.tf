variable name {
  type = string
  description = "Name of the pool."
}

variable image {
  type = string
  description = "Docker image on which the workers are based."
}

variable location {
  type = string
  description = "Zone or region in which to create the pool."
}

variable workers_per_instance {
  type = number
  description = "Number of workers to start up per instance."
}

variable command {
  type = list(string)
  default = []
  description = "Command to run in workers. See README for line break support."
}

variable cloudsql_connections {
  type = set(string)
  default = []
  description = "List of CloudSQL connections to establish before starting workers."
}

variable cloudsql_path {
  type = string
  default = "/cloudsql"
  description = "The path at which CloudSQL connection sockets will be available in workers and timers."
}

variable cloudsql_restart_interval {
  type = number
  default = 5
  description = "Number of seconds to wait before restarting the CloudSQL service if it stops."
}

variable cloudsql_restart_policy {
  type = string
  default = "always"
  description = "The restart policy to apply to the CloudSQL service."

  validation {
    condition = contains(["no", "on-success", "on-failure", "on-abnormal", "on-watchdog", "on-abort", "always"], var.cloudsql_restart_policy)
    error_message = "CloudSQL restart policy must be one of [always, no, on-success, on-failure, on-abnormal, on-watchdog, on-abort]."
  }
}

variable cloudsql_wait_duration {
  type = number
  default = 30
  description = "How long to wait (in seconds) for CloudSQL connections to be established before starting workers."
}

variable disk_size {
  type = number
  default = 25
  description = "Disk size (in GB) to create instances with."
}

variable disk_type {
  type = string
  default = "pd-balanced"
  description = "Disk type to create instances with."

  validation {
    condition = contains(["pd-ssd", "local-ssd", "pd-balanced", "pd-standard"], var.disk_type)
    error_message = "Disk type must be one of [pd-ssd, local-ssd, pd-balanced, pd-standard]."
  }
}

variable env {
  type = map(string)
  default = {}
  description = "Environment variables to inject into workers and timers."
}

variable expose_ports {
  type = list(object({
    port = number
    protocol = optional(string)
    container_port = optional(number)
    host = optional(string)
  }))
  default = []
  description = "Container ports to be exposed on the host."

  validation {
    error_message = "Protocol must be one of [udp, tcp]."
    condition = alltrue([
      for p in var.expose_ports:
        contains(["tcp", "udp"], lower(p.protocol))
      if p.protocol != null
    ])
  }
}

variable health_check_enabled {
  type = bool
  default = false
  description = "Flag indicating whether to create a health check to force unhealthy instances to be recreated."
}

variable health_check_port {
  type = number
  default = 4144
  description = "The host port that is exposed for the health check."
}

variable health_check_name {
  type = string
  default = null
  description = "The name of the created health check."
}

variable health_check_interval {
  type = number
  default = 10
  description = "Interval between health checks."
}

variable health_check_healthy_threshold {
  type = number
  default = 3
  description = "Number of consecutive health checks that must succeed for an instance to be marked as healthy."
}

variable health_check_initial_delay {
  type = number
  default = 60
  description = "Number of seconds to allow instances to boot before starting health checks."
}

variable health_check_unhealthy_threshold {
  type = number
  default = 3
  description = "Number of consecutive health checks that must fail for an instance to be marked as unhealthy."
}

variable instance_count {
  type = number
  default = 1
  description = "Number of instances to create in the pool."
}

variable labels {
  type = map(string)
  default = {}
  description = "Labels to apply to all instances in the pool."
}

variable log_driver {
  type = string
  default = "local"
  description = "Default log driver to be used in the Docker daemon."
}

variable log_opts {
  type = map(string)
  default = null
  description = "Options for configured log driver."
}

variable machine_type {
  type = string
  default = "f1-micro"
  description = "Machine type to create instances in the pool with."
}

variable metadata {
  type = map(string)
  default = {}
  description = "Additional metadata to add to instances. Keys used by this module will be overwritten."
}

variable mounts {
  type = list(object({
    type = optional(string)
    src = string
    target = string
    readonly = optional(bool)
  }))
  default = []
  description = "Volumes to mount into the worker containers."
}

variable network {
  type = string
  default = "default"
  description = "Network name or link in which to create the pool."
}

variable preemptible {
  type = bool
  default = false
  description = "Whether or not to create preemptible instances."
}

variable restart_interval {
  type = number
  default = 5
  description = "Number of seconds to wait before restarting a failed worker."
}

variable restart_policy {
  type = string
  default = "always"
  description = "Restart policy to apply to failed workers."

  validation {
    condition = contains(["no", "on-success", "on-failure", "on-abnormal", "on-watchdog", "on-abort", "always"], var.restart_policy)
    error_message = "Restart policy must be one of [always, no, on-success, on-failure, on-abnormal, on-watchdog, on-abort]."
  }
}

variable runcmd {
  type = list(string)
  default = []
  description = "Additional commands to run on instance startup. These commands are run after Docker is configured & restarted, and immediately before any workers & CloudSQL connections are started."
}

variable service_account_email {
  type = string
  default = null
  description = "Service account to assign to the pool."
}

variable systemd_name {
  type = string
  default = "worker"
  description = "Name of the systemd service for workers. This is configurable to ensure it doesn't clash with names of timers."
}

variable tags {
  type = list(string)
  default = []
  description = "Network tags to apply to instances in the pool."
}

variable timers {
  type = list(
  object({
    name = string,
    schedule = string,
    command = optional(list(string))
  })
  )
  default = []
  description = "Scheduled timers to execute on instances."
}

variable timezone {
  type = string
  default = "Etc/UTC"
  description = "Timezone to use on instances. See the \"TZ database name\" column on https://en.wikipedia.org/wiki/List_of_tz_database_time_zones for an indication as to available timezone names."
}

variable wait_for_instances {
  type = bool
  default = false
  description = "Wait for instances to stabilise starting after updating the pool's instance group."
}