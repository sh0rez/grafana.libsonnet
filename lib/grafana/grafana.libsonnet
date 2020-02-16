local k = (import "ksonnet-util/kausal.libsonnet"),
      container = k.core.v1.container,
      containerPort = k.core.v1.containerPort,
      deploy = k.apps.v1.deployment;

local lib = {
  // parameters for library behavior
  _config:: {
  },
  _images:: {
    grafana: "grafana/grafana",
  },

  // grafana configuration
  config: (import "./config.libsonnet"),

  // dashboards
  dashboards: (import "./dashboards.libsonnet"),
  datasources: (import "./datasources.libsonnet"),

  // grafana container + deployment
  _container:: container.new("grafana", $._images.grafana)
    + container.withPorts(containerPort.new("grafana", 80))
    + container.withEnvMap({
        GF_PATHS_CONFIG: "/etc/grafana-config/grafana.ini",
        GF_INSTALL_PLUGINS: std.join(',', $.config._plugins),
      })
    + k.util.resourcesRequests("10m", "40Mi"),

  deployment: deploy.new("grafana", 1, [$._container])
    + deploy.mixin.spec.template.spec.securityContext.withRunAsUser(0)
    + $.dashboards.mount()
    + $.datasources.mount()
    + k.util.podPriority('critical'),

  // grafana service
  service: k.util.serviceFor($.deployment)
};

{
  usage: error "grafana.libsonnet must not used directly, call new() instead",

  // new returns Grafana resources with sane defaults
  new():: lib,

  // addConfig adds config entries to grafana.ini
  addConfig(config):: {
    config+: { _ini+:: { sections+: config }},
  },
  addPlugins(plugins):: {
    config+: { _plugins+:: plugins }
  },

  // dashboards
  addDashboards(dashboards):: {
    dashboards+: { _dashboards+:: dashboards}
  },

  // datasources
  addDatasources(datasources):: {
    datasources+: { _datasources+:: datasources }
  },
  datasource: (import "./ds-util.libsonnet")
}
