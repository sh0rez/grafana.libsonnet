local d = (import './doc-util/main.libsonnet');

local k = (import 'ksonnet-util/kausal.libsonnet'),
      container = k.core.v1.container,
      containerPort = k.core.v1.containerPort,
      deploy = k.apps.v1.deployment;

local lib = {
  _images:: {
    grafana: 'grafana/grafana',
  },

  // grafana configuration
  config: (import './config.libsonnet'),

  // dashboards
  dashboards: (import './dashboards.libsonnet'),
  datasources: (import './datasources.libsonnet'),

  // grafana container + deployment
  _container:: container.new('grafana', $._images.grafana)
               + container.withPorts(containerPort.new('grafana', 80))
               + container.withEnvMap({
                 GF_PATHS_CONFIG: '/etc/grafana-config/grafana.ini',
                 GF_INSTALL_PLUGINS: std.join(',', $.config._plugins),
               })
               + k.util.resourcesRequests('10m', '40Mi'),

  deployment: deploy.new('grafana', 1, [$._container])
              + deploy.mixin.spec.template.spec.securityContext.withRunAsUser(0)
              + $.dashboards.mount()
              + $.datasources.mount()
              + k.util.podPriority('critical'),

  // grafana service
  service: k.util.serviceFor($.deployment),
};

{
  // usage: error "grafana.libsonnet must not used directly, call new() instead",

  '#new': d.fn('new creates a new Grafana instance that can be configured using the `with...` functions this package provides'),
  new():: lib,

  '#addConfig': d.fn('addConfig adds the passed properties to `grafana.ini`, configuring the instance.', [d.arg('config', d.T.object)]),
  addConfig(config):: {
    config+: { _ini+:: { sections+: config } },
  },
  '#addPlugins': d.fn('addPlugins installs the passed plugins on the Grafana instance', [d.arg('plugins', d.T.array)]),
  addPlugins(plugins):: {
    config+: { _plugins+:: plugins },
  },

  '#addDashboards': d.fn('addDashboards provisions the passed dashboards on the instance', [d.arg('dashboards', d.T.object)]),
  addDashboards(dashboards):: {
    dashboards+: { _dashboards+:: dashboards },
  },

  '#addDatasources': d.fn('addDatasources provisions the passed datasources on the instance', [d.arg('datasources', d.T.object)]),
  addDatasources(datasources):: {
    datasources+: { _datasources+:: datasources },
  },
  '#datasource': d.obj('`datasource` provides `ds-util`, a utility for quickly creating datasources'),
  datasource: (import './ds-util.libsonnet'),
}
