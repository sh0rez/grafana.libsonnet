# package grafana

```jsonnet
local grafana = import github.com/jsonnet-libs/grafana
```

The `grafana` jsonnet package is the offical way of installing Grafana to Kubernetes using [Tanka](https://tanka.dev).

## Index

- `fn new()`
- `fn addConfig(config)`
- `fn addDashboards(dashboards)`
- `fn addDatasources(datasources)`
- `fn addPlugins(plugins)`
- `obj datasource`
  - `fn new(name, type)`

### fn new

```
new()
```

new creates a new Grafana instance that can be configured using the `with...` functions this package provides

### fn addConfig

```
addConfig(config)
```

addConfig adds the passed properties to `grafana.ini`, configuring the instance.

### fn addDashboards

```
addDashboards(dashboards)
```

addDashboards provisions the passed dashboards on the instance

### fn addDatasources

```
addDatasources(datasources)
```

addDatasources provisions the passed datasources on the instance

### fn addPlugins

```
addPlugins(plugins)
```

addPlugins installs the passed plugins on the Grafana instance

## datasource

`datasource` provides `ds-util`, a utility for quickly creating datasources

### fn datasource.new

```
datasource.new(name, type)
```

new creates a new datasource of given type and name
