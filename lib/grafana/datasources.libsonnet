local k = (import 'ksonnet-util/kausal.libsonnet'),
      configMap = k.core.v1.configMap;

local fieldValues(object) = function(key) object[key],
      objToArr(obj) = std.map(fieldValues(obj), std.objectFields(obj));

{
  _datasources:: {},
  configMap: configMap.new('grafana-datasources')
             + configMap.withData({
               'datasources.yml': k.util.manifestYaml({
                 apiVersion: 1,
                 datasources: objToArr($._datasources),
               }),
             }),

  mount(dir='/etc/grafana/datasources'):: k.util.configMapVolumeMount($.configMap, dir),
}
