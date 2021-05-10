[Unit]
Requires=docker.service ${requires_cloudsql ? "cloudsql.service": ""}
After=docker.service ${requires_cloudsql ? "cloudsql.service": ""}

[Service]
Type=simple
Environment=HOME=/home/chronos
%{ for key, value in args }Environment=${key}=${value}
%{ endfor ~}
Restart=on-failure
RestartSec=3
ExecStartPre=/usr/bin/docker-credential-gcr configure-docker
ExecStart=/usr/bin/docker run \
  --rm \
  --name=${systemd_name}-%i \
  --env-file /home/chronos/.env \
  ${cloudsql ? "-v cloudsql:${cloudsql_path}:ro" : ""} \
  ${image} \
  ${join(" ", formatlist("$${%s}", keys(args)))}
ExecStop=/usr/bin/docker stop ${systemd_name}-%i
