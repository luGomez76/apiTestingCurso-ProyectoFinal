function fn() {
  var env = karate.env;

  var config = {
    env: env,
    urlBase: 'https://api-ventas.synnexaconsulting.com',
    urlQaTeam: 'https://api.qateamperu.com'
  }

  return config;
}