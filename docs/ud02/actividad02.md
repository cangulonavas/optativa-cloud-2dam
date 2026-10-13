# Actividad 02. Creación de una Máquina Virtual (práctica guiada)

## Objetivo de la práctica

En esta práctica vamos a crear en la nube una máquina virtual de Windows Server 2025 y nos conectaremos a ella por RDP. Conoceremos los recursos de AWS asociados a la creación de esa máquina virtual:

- La instancia EC2 (la propia máquina virtual).
- El volumen EBS asociado (el disco duro de la máquina virtual).
- La red (VPC) y la subred virtual a la que está conectada la máquina.
- Un Internet Gateway (puerta de enlace) para salir a Internet desde la red virtual.
- Una dirección IP Pública para conectarnos desde el exterior.
- Un grupo de seguridad (firewall) para controlar los accesos.


## Esquema en AWS

<img src="../images/ud02/practica1/EC2.drawio.png">


## Práctica a Realizar

### Acceso a EC2

1.- Vamos a crear directamente una máquina en la red virtual (VPC) creada por defecto. Para ello accedemos directamente al servicio de máquinas virtuales de AWS llamado EC2 (Amazon Elastic Compute Cloud).

- Buscamos el servicio **EC2** en la consola.
- Accedemos y pulsamos sobre **Lanzar la Instancia**.

!!! note "Nota"
    
    Tenemos una red creada de manera predeterminada con una dirección de red **172.31.0.0/16**, la cual tiene 6 subredes ubicadas en 6 zonas de disponibilidad distintas de la región en la que se lanza el laboratorio (Norte de Virginia: *us-east-1*). Vamos a crear la máquina en esta red por defecto.

<br>
___

### Lanzamiento de la instancia

2.- Para lanzar la instancia EC2 es necesario asignarle una serie de parámetros obligatorios y configurar otros opcionales.

- El nombre del equipo será **W2025**
- Seleccionamos una imagen (AMI) de **Microsoft Windows Server 2025 Base**.
- En el tamaño de la máquina seleccionamos un tipo de instancia **t3.medium** (2 CPUS y 4 GiB de RAM)
- En el par de claves podemos elegir entre crear un nuevo par de claves o utilizar las ya creadas de nuestro laboratorio (*vockey*). Seleccionamos las ya creadas **vockey**.
- En la configuración de red pulsamos en Editar:
    - Dejamos la VPC (la red virtual) predeterminada.
    - Seleccionamos una subred (por ejemplo la asociada a la zona de disponibilidad 2 cuyo nombre es **us-east-1b** y su dirección de red es *172.31.16.0/20*)
    - Habilitamos la **asignación de una IP Pública** para conectarnos desde Internet a esta máquina.
    - Creamos un grupo de seguridad (reglas de firewall) nuevo y lo llamamos **acceso-remoto** y le ponemos una descripción (*acceso remoto a W2025*)
    - Como regla de entrada dejamos la que viene por defecto que habilita el **puerto 3389 (RDP)** desde **cualquier lugar** de Internet (0.0.0.0/0)
- Dejamos las opciones de almacenamiento que nos propone por defecto: 30GiB en un disco **SSD de uso general**.
- Lanzamos la instancia.

<br>
___

### Comprobación de los recursos creados

Tras unos minutos se nos crea la instancia, y con ella los siguientes recursos que podemos comprobar.

3.- Accede al panel principal de EC2.

<img src="../images/ud02/practica1/creacion_MV_01.jpg">


Comprueba pinchando sobre el enlace correspondiente que se ha creado:

- Una **instancia** (máquina).
- Un **volumen EBS** (disco duro).
- 2 **Grupos de seguridad** (el que venía por defecto y el que hemos creado llamado *acceso-remoto*).

<br>

4.- Accede en la consola al panel de VPC.

<img src="../images/ud02/practica1/creacion_MV_02.jpg">

Comprueba que nos aparece una VPC que ya venía creada por defecto. Accede a ella y verás las subredes y recursos asociados:

- 6 **Subredes** en 6 AZs
- 1 **Tabla de enrutamiento** utilizada por todas las subredes.
- 1 Conexión de red a Internet: **Internet Gateway**

<img src="../images/ud02/practica1/creacion_MV_03.jpg">

<br>
___


### Acceso por RDP

Vamos a iniciar una sesión de escritorio remoto en la máquina creada. Al crear la máquina no nos ha solicitado nombre de usuario y contraseña. Por seguridad, nos crea una contraseña compleja que solamente podemos ver utilizando el par de claves pública y privada que hemos seleccionado al crear la máquina.

El primer paso para poder ver la contraseña es descargarnos el fichero de la clave o copiar el contenido. 

5.- Accede a la **consola de lanzamiento del laboratorio** y en *Detalles* pulsa sobre una de las opciones de descarga o visualización de la clave privada. Descarga, por ejemplo, el fichero PEM.

<img src="../images/ud02/practica1/creacion_MV_04.jpg">

6.- En la **consola de AWS** accede al panel de la instancia EC2 que acabamos de lanzar y pulsa sobre *Conectar*. En la pestaña de *Cliente RDP* descarga el archivo RDP y pulsa sobre *Obtener Contraseña*. Para descifrarla te pide la clave privada que acabas de descargar.


7.- Una vez descifrada la contraseña, ya podemos abrir el fichero RDP descargado e introducir el usuario (*Administrator*) y la contraseña para iniciar sesión.

!!! success "Captura la pantalla"
    Haz una captura de pantalla en la que se vea la conexión por RDP a la máquina Windows Server 2025 como parte de las prácticas a entregar.


<img src="../images/ud02/ud02_07.png" width="500">
___

### Liberación de recursos

8.- Una vez finalizada la práctica hay que eliminar los recursos creados para que no nos consuman crédito:

- Terminamos la instancia. En el panel de EC2, con la instancia seleccionada, pulsamos sobre la Acción **Terminar (eliminar) instancia**. Nos informa que el volumen EBS asociado también se eliminará.

<img src="../images/ud02/ud02_08.png" width="100%">

- Por último, eliminamos el grupo de seguridad *acceso-remoto*.

<img src="../images/ud02/ud02_09.png" width="100%">
<img src="../images/ud02/ud02_10.png" width="100%">

!!! warning Recuerda
Recuerda finalizar el laboratorio cuando acabes con las prácticas.
