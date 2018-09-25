const serverIpAndPort = getServerConfig();
if (!serverIpAndPort) { throw new Error('Invalid argument: set the server IP and Port'); }

const Swagger = require('swagger-client');

const SWAGGER_URL = `http://${serverIpAndPort}/api/v1/swagger.json`;
const AUTH_TOKEN = process.env.STF_ACCESS_TOKEN;

let client;
let deviceSerial;

Swagger({
  url: SWAGGER_URL,
  usePromise: true,
  authorizations: {
    accessTokenAuth: 'Bearer ' + AUTH_TOKEN
  }
})
  .then(_client => { client = _client; })
  .then(() => client.apis.user.getUserDevices({ fields: 'serial,using,ready' }))
  .then(res => res.obj.devices.filter(x => x.using))
  .then(devices => {
    if (devices.length === 0) { throw new Error('No usable devices'); }
    return devices[0];
  })
  .then(device => client.apis.user.deleteUserDeviceBySerial({
    serial: (deviceSerial = device.serial)
  }))
  .then(res => {
    if (!res.obj.success) { throw new Error('Could not disconnect to device'); }
  })
  .then(() => { console.log('Device disconnect successfully!'); })
  .catch(e => { console.error(e); });

// get OpenSTF server config from args
function getServerConfig() {
  return process.argv[2];
}

