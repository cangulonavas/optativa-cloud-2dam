# Actividad 07. Creación de una VPC de forma manual

## Objetivo de la práctica

En esta práctica vamos a realizar la creación independiente de los elementos de red desde la consola de AWS, el resultado será el mismo que en la práctica anterior pero se trata de que entiendas qué papel juegan cada uno de los siguientes conceptos en la VPC:

* Red
* Subred
* Zona de disponibilidad
* Dirección IP Pública
* Nombre de host DNS
* Gateway de internet IGW
* Tabla de enrutamiento

## Práctica a Realizar

Vamos a crear una VPC y todos sus elementos necesarios paso a paso. La VPC tendrá las siguientes direcciones:

* Red: **192.168.0.0/16**
* Subred: **192.168.0.0/24**

!!! success "Captura las pantallas"
    Esta tarea la **documentarás paso a paso**. Para comprobar que ha funcionado correctamente, al final entregarás también una captura del resultado de **acceder por ssh a las instancia y comprobar su dirección privada**.

## Creación independiente de los elementos de red desde la consola de AWS

En la práctica anterior hemos creado una VPC completa (utilizando la ayuda para la configuración que nos ofrece AWS) porque ya conocíamos de antemano todos los elementos que necesitábamos. Pero puede darse el caso de que tengamos que crear los  elementos por separado. De eso trata esta alternativa, por tanto, seleccionaremos la opción **Solo la VPC** al crearla.

### Creación de la VPC

Lo primero es crear una VPC con su direccionamiento (por ejemplo, `192.168.0.0/16`) seleccionando la opción **Solo la VPC**:

![](../images/ud03/practica1/001b.png)

![img](../images/ud03/practica1/002b.png)

### Creación de las subredes

A continuación, una vez creada la VPC, desde la opción de Subredes, crearemos la subred asociándola a la VPC que acabamos de crear y dándole un nombre y un rango de direcciones IPv4, que debe estar dentro del rango de la VPC. Por ejemplo, podemos asignar el rango **192.168.0.0/24**:

![](../images/ud03/practica1/003b.png)

---

---

![](../images/ud03/practica1/004b.png)

En este caso no hemos asignado una zona de disponibilidad en concreto, con lo que la subred se puede crear en cualquiera de las seis zonas de disponibilidad que hay en la región del Norte de Virginia (us-east-1).

![](../images/ud03/practica1/005b.png)

### Comprobación de funcionamiento con una EC2

Vamos a lanzar una instancia EC2 y comprobar si funciona la arquitectura que acabamos de hacer. Para ello, al crear la instancia, seleccionaremos la VPC y subred que hemos creado. 

![](../images/ud03/practica1/006b.png)

<br>

Es importante **habilitar la asignación de una IP pública**.

!!! note "Nota"
    AWS solo asigna automáticamente direcciones IP públicas en la VPC por defecto, pero no en las creadas por nosotros.



![](../images/ud03/practica1/006c.png)

<br>

Una vez creado, nos daremos cuenta de que SÍ que se asigna una IP pública pero **NO un nombre de host DNS**. El problema reside en que en la VPC no hemos habilitado esta resolución.

![](../images/ud03/practica1/006d.png)

### Nombre de host DNS

Para habilitar el nombre de host DNS, accedemos al menú de VPC y seleccionaremos la VPC creada:

![](../images/ud03/practica1/007b.png)

<br>

Y editaremos la configuración para habilitar la opción **nombres de host DNS**.

<img src="../images/ud03/practica1/008b.png" width="600">

<br>

Ahora cuando volvamos a comprobar las propiedades de la EC2 creada, podremos ver que ya le ha asignado un nombre de host DNS a través del cual podremos acceder por ssh (también lo podríamos hacer utilizando la ip pública).

Cuando intentemos acceder por ssh, nos daremos cuenta de que NO es posible hacerlo, ya que a nuestra VPC le falta un elemento/servicio que permita a todo lo que haya dentro poder configurarse para poder conectarse con el exterior y viceversa. 

### Internet Gateway

El elemento que nos falta es el *gateway de Internet* (Internet Gateway o puerta de enlace de Internet - IGW). Podemos  crear  este  elemento dede la opción **Puerta  de  enlace  de  Internet** que encontraremos en el menú lateral izquierdo del panel del servicio VPC:

![img](../images/ud03/practica1/010b.png)

---
<br>

![img](../images/ud03/practica1/011b.png)

Si visualizamos el listado de los IGWs que hay creados, veremos que el estado del nuevo IGW aparece como **detached**, así que tendremos que asignárselo a la VPC deseada. En las acciones del IGW, le daremos a conectar a VPC:

![img](../images/ud03/practica1/012b.png)

<br>

![img](../images/ud03/practica1/014b.png)

¡Pero seguimos sin poder conectarnos!

Falta configurar un elemento encargado de gestionar el tráfico dentro de la VPC: la tabla de enrutamiento.  

### Tablas de enrutamiento

Al  crear  una  VPC,  se  crea  un  tabla  de  enrutamiento  por defecto, y tenemos que asociarle la subred creada para poder crear rutas para esa subred, desde la opción correspondiente del panel de VPC (puedes localizar la subred entre las distintas que puedan haber observando la VPC a la que pertenece):

![](../images/ud03/practica1/016b.png)

<br>

Asociaremos la subred explícitamente, aunque si no lo hacemos, la subred se asocia con la tabla de enrutamiento por defecto de la VPC.

![](../images/ud03/practica1/017b.png)

Podemos volver a comprobar si nos podemos conectar a la instancia EC2, y seguimos SIN CONEXIÓN. 

Lo único que nos falta es modificar las **rutas de la tabla de enrutamiento** asociada a la subred. Si nos fijamos en las rutas que hay (seleccionando la subred, pestaña ‘Tabla de enrutamiento’), sólo se está enrutando la red de la VPC en local, es  decir  las subredes que tenga a su alcance (192.168.0.0/16). 

Hay que añadir una ruta e indicar  que  todo lo que vaya a `0.0.0.0` (todo el tráfico) salga por el Internet Gateway que hemos creado y asociado a nuestra VPC. Para ello seleccionamos la tabla de enrutamiento, **editamos las rutas**, y seleccionamos la opción **Agregar ruta**:

![](../images/ud03/practica1/018b.png)

Una vez añadida, comprobamos que aparece la nueva ruta en la lista de rutas de la tabla de enrutamiento:

![](../images/ud03/practica1/019b.png)

Una vez hecho esto, ahora sí que podremos conectarnos por ssh a cualquier instancia EC2 lanzada en la subred que hemos creado (siempre que la EC2 tenga asignada una dirección IP pública, y de que el grupo de seguridad asociado, concepto del que hablaremos más adelante, permita tráfico entrante al puerto de ssh).

!!! success "Captura la pantalla"
    Accede por ssh a la instancia EC2 y comprueba con el comando `ip a` su dirección privada. Captura la pantalla.

!!! warning "Recuerda finalizar el laboratorio cuando acabes con la actividad"
    - Termina las instancias
    - Termina el grupo de seguridad
    - Termina el espacio de red
    - Cierra el laboratorio    

