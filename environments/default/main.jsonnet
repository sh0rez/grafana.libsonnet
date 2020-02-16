local grafana = (import "grafana/grafana.libsonnet");

{
  local _ds = grafana.datasource.prometheus.new("prom", "https://localhost")
    + grafana.datasource.withBasicAuth("tom", "secret"),

  grafana: grafana.new()
    + grafana.addConfig({
        server+: {
          http_port: 99,
        }
      })
    + grafana.addPlugins(["piechart"])
    + grafana.addDashboards({
        loki: {name: "loki"},
        consul: {name: "consul"}
      })
    + grafana.addDatasources({prom: _ds})
}
