local d = (import './doc-util/main.libsonnet');

{
  '#new': d.fn('new creates a new datasource of given type and name', [d.arg('name', d.T.string), d.arg('type', d.T.string)]),
  new(name, type):: {
    name: name,
    type: type,
    access: 'proxy',
    version: 1,
  },

  withDefault(default):: {
    default: default,
  },
  withEditable(editable):: {
    editable: editable,
  },
  addJsonData(data):: {
    jsonData+: data,
  },
  withBasicAuth(username, password):: {
    basicAuth: true,
    basicAuthUser: username,
    basicAuthPassword: password,
  },

  // prometheus datasource
  prometheus:: {
    new(name, url):: $.new(name, 'prometheus') {
      url: url,
    } + self.withMethod('GET'),

    withMethod(method):: $.addJsonData({
      httpMethod: method,
    }),
  },
}
