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


1. Inicio
---------

Recordemos que para habilitar el monitor sobre nuestras instancias, en *ZENserver* debemos añadir la regla de monitoreo de la siguiente manera:

*zen.yml*:

```yaml
...
# -- Monitor -------------------------------------------------------------------
monitor:
  password: mypassword
  process : 10000
  request : 1000
...
```
