# ZEN-monitor

Este módulo de ZEN te sirve para visualizar los datos de la auditoría que recoge [ZENserver](https://github.com/soyjavi/zen-server/tree/master/documentation/ES) cuando habilitamos en su configuración la opción **Monitor**.

En esta auditoría, ZENserver nos provee de información sobre:

  - El estado de la **memoria**
  - Las **peticiones** recibidas por nuestras instancias
  - Los **métodos** solicitados: GET, POST, PUT, DELETE, OPTIONS,...
  - Los **código** de respuesta tanto si son de éxito como si son de errores contemplados por el firewall y no.
  - Los **mime-types** servidos
  - Los tipos de **dispositivos**, **sistemas operativos** y **navegadores** que acceden a la aplicación.


![image](https://raw.githubusercontent.com/cat2608/contacts/master/assets/img/screen-18.png)


## 1. Inicio

Recordemos que para habilitar el monitor sobre nuestras instancias, en *ZENserver* debemos añadir la regla de monitoreo de la siguiente manera:

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

ZENserver irá almacenando dos tipos de ficheros en la carpeta monitor: *request* y *server* que son los ficheros `json` que contienen la información referente a las peticiones a la instancia y al estado de la máquina.

### 1.1 Instalación

Para visualizar los datos de tus instancias, primeramente, clónate el proyecto:

```bash
$ git clone https://github.com/soyjavi/zen-monitor.git
```

E instala sus dependencias:

```bash
$ npm install
$ bower install
```

Por último solamente queda compilar y arrancar el server que trae la ZENmonitor:

```bash
$ gulp init
$ gulp
```

El comando `gulp` te arranca un server en el puerto 8000, lo puedes comprobar en el log del comando. Ahora solo te queda ir al navegador y accedet a `http://localhost:8000`:
