# Katalon test execution via OpenSTF

This repository is for verification to execute tests with Android devices in different network via OpenSTF.

## Usage

### Get 2 PCs and 1 Android

- *PC(A): OpenSTF server. Android connected*
  - installed Git, Docker, Android SDK
    - if the OS is Linux, you shouldn't need Android SDK because you can share USB ports with Docker containers(and Appium container includes ADB) in practice
    - note: it has not tested for Linux
  - connected to the Internet and opened 50022 port
    - if PC(B) is in same LAN, opening port is not necessary
- *PC(B): Katalon tests executor*
  - installed Git, Docker
  - connected to the Internet
- *Android*
  - you can select an emulator or a real device
    - when real device, you have to connect it to PC(A) via USB
    - when emulator, you have to launch it in PC(A)
  - enabled USB debug mode
    - make sure whether OpenSTF recognize the device before executing tests ( `/#!/devices` )

### Setup (Only first time execution)

#### in PC(A)

```bash
$ git clone https://github.com/spinylobster/openstf-katalon.git
$ cd openstf-katalon/openstf
$ adb devices # make sure one Android device is listed
$ ./start.sh
```

#### in PC(B)

```bash
$ git clone https://github.com/spinylobster/openstf-katalon.git
$ cd openstf-katalon/katalon
$ ./setup.sh
```

#### set the generated public key for SSH portforward

put `openstf-katalon/katalon/stf-portforwarder/.ssh/id.key.pub` in PC(B)
to PC(A)'s `openstf-katalon/openstf/sshd/ssh/authorized_keys/`

#### register ADB key / Access token

1. copy the content of `openstf-katalon/katalon/appium/adbkey.pub` in PC(B) to PC(A)'s clipboard
2. open `http://127.0.0.1:7100` on PC(A)
3. go to `Settings` -> `Keys` 
4. click ADB key add button and paste the content of `adbkey.pub`
5. click AccessToken add button and generate and copy the content

#### input environment info

in PC(B)

```bash
$ ./start.sh
```

on the first time Katalon execution, you need to input these info:
- OpenSTF's hostname
  - specify PC(A)'s hostname or global IP
    - if PC(A) and PC(B) are in same network, input PC(A)'s local IP
    - if PC(A) and PC(B) are same PC, specify `host.docker.internal`
- OpenSTF's AccessToken
  - paste the copied access token
- SSH port
  - 50022 by default

### Run tests

in PC(A)

```bash
$ cd openstf-katalon/openstf
$ ./start.sh
```

in PC(B)

```bash
$ cd openstf-katalon/katalon
$ ./start.sh
$ docker-compose exec katalon /root/run_tests.example.sh
```

## TODOs

- multiple Android device and parallel tests
- adress the bug that OpenSTF shutdowns after some time
- execute tests on CircleCI

