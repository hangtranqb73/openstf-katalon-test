const wd = require('wd');

const driver = wd.promiseChainRemote({ host: 'localhost', port: 4723 });
driver
  .init({
    deviceName: 'Android',
    platformName: 'Android',
    app: '/katalon/katalon/source/androidapp/APIDemos.apk',
    adbPort: 7401
  })
  .setImplicitWaitTimeout(3000)
  .quit();
