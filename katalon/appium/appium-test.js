const wd = require('wd');

const driver = wd.promiseChainRemote({ host: 'localhost', port: 4723 });
driver
  .init({
    deviceName: 'Android',
    platformName: 'Android',
    app: '/Users/satoshiisemura/dev/katalon/openstf-katalon/katalon/KatalonAndroidSample/androidapp/APIDemos.apk'
  })
  .setImplicitWaitTimeout(3000)
  .quit();
