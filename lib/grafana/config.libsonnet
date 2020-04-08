local k = (import 'k.libsonnet'),
      configMap = k.core.v1.configMap;

{
  // ini contents
  _ini:: { sections: {
    server: {
      http_port: 80,
    },
    users: {
      default_theme: 'light',
    },
    explore: {
      enabled: true,
    },
  } },

  // grafana.ini
  grafana: configMap.new('grafana-config')
           + configMap.withData({
             'grafana.ini': std.manifestIni($._ini),
           }),

  // grafana plugins
  _plugins:: [],
}
