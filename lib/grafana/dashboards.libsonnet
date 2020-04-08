local k = (import 'ksonnet-util/kausal.libsonnet'),
      configMap = k.core.v1.configMap;

{
  // modified by addDashboards()
  _dashboards:: {},
  // configMap for each dashboard
  configMaps: {
    [name]: configMap.new('dashboard-' + name)
            + configMap.withData({
              [name + '.json']: std.toString($._dashboards[name]),
            })
    for name in std.objectFields($._dashboards)
  },

  // mount returns the mount-adders for each dashboard configMap
  mount(dir='/etc/grafana/dashboards', i=0)::
    local fields = std.objectFields($.configMaps),
          cm = $.configMaps[fields[i]];
    if i == std.length(fields)
    then {}
    else k.util.configMapVolumeMount(cm, dir) + $.mount(dir, i + 1),
}
