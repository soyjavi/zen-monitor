# ZEN-monitor

You can use this module of ZEN to visualize data from [ZENserver](https://github.com/soyjavi/zen-server) audit.

ZENserver provides information about:

  - **Memory** usage
  - **Requests** to the instance
  - **Methods**: : GET, POST, PUT, DELETE, OPTIONS,...
  - Response **codes**: 200, 403, 404
  - **mime-types** serverd
  - **Devices**, **OS**, and **browsers** used

![image](https://raw.githubusercontent.com/cat2608/contacts/master/assets/img/screen-18.png)

## 1. Introduction

Remember that to use ZENmonitor first we need configure at zen.yml the **monitor** rule:

*zen.yml*:
```yaml
...
# -- Monitor -------------------------------------------------------------------
monitor:
  password: mypassword
  process : 300000 #ms
  request : 1000 #ms
...
```

ZENserver will store two types of files into monitor's folder: *request* y *server*. This files have information about request to application and status machine. With *process* and *request* attributes you are configuring when ZENserver will store this information.

### 1.1 Installation

To use ZENmonitor first you need clone the project:

```bash
$ git clone https://github.com/soyjavi/zen-monitor.git
```

Now, install all dependencies:

```bash
$ npm install
$ bower install
```

Finally, you just need compile and run de server:

```bash
$ gulp init
$ gulp
```

### 1.2 Running ZENmonitor

The `gulp` command starts a server at `http://localhost:8000`:

![image](https://raw.githubusercontent.com/cat2608/contacts/master/assets/img/screen-20.png)

Now, you can type information about your instance: *URL*, *PORT* and *PASSWORD*. This password must be the same as you configured at zen.yml file.

![image](https://raw.githubusercontent.com/cat2608/contacts/master/assets/img/screen-21.png)

You can export all graph to png, jpeg, pdf, svg formats.
