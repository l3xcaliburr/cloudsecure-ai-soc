[server]
protocol = http
http_port = 3000
domain = ${domain}
root_url = http://${domain}

[security]
admin_user = admin
admin_password = ${admin_password}
allow_embedding = true

[auth.anonymous]
enabled = false

[dashboards]
default_home_dashboard_path = /etc/grafana/provisioning/dashboards/security-overview.json

[provisioning]
; path to folder that contains datasources YAML files
datasources = /etc/grafana/provisioning/datasources
; path to folder that contains dashboards JSON files
dashboards = /etc/grafana/provisioning/dashboards

[plugins]
allow_loading_unsigned_plugins = grafana-worldmap-panel,grafana-clock-panel

[log]
mode = console
level = info

[metrics]
enabled = true

[tracing.jaeger]
address =

[feature_toggles]
enable = publicDashboards