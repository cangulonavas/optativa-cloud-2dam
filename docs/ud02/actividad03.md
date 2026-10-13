# Actividad 03. Creación de una Máquina Linux

Necesitamos una máquina que actúe como **servidor de Bases de Datos** y para ello vamos a crear una instancia EC2.

Queremos que el tamaño de la máquina se adapte a esa función de servidor de Base de Datos. Decide tú qué **familia** de instancias utilizar.

Como sistema operativo utilizaremos **Ubuntu**, y deseamos que al crearse la máquina se **instale automáticamente** el paquete del gestor de base de datos **mysql**.

No vamos a utilizar el par de claves del laboratorio, sino **crear un par de claves nuevo** para conectarnos por ssh. El usuario de conexión será el que nos cree [por defecto](https://docs.aws.amazon.com/es_es/AWSEC2/latest/UserGuide/managing-users.html#ami-default-user-names).

!!! tip "Instalación de Mysql Server"
    Para instalar mysql hay que actualizar los repositios de Linux y a continuación instalar el paquete con el comando `apt install mysql-server -y`

!!! tip "Permisos"
    Recuerda cambiar los [permisos del fichero de la clave privada](https://docs.aws.amazon.com/es_es/AWSEC2/latest/UserGuide/connection-prereqs-general.html#connection-prereqs-private-key) y añadirlo con el parámetro `-i` dentro del comando `ssh`

!!! tip "Usuario de tu máquina"
    El usuario de conexión será el que nos cree por defecto: **ubuntu**

Una vez creada la base de datos, crea una tabla simple con alumnos (nombre e email).

Realiza la siguiente inserción de datos:

| Nombre        | Email                |
| ------------- | ---------------------|
| Javier García | javigarcia@gmail.com |
| Marta López   | martalopez@gmail.com |
| Daniel Pérez  | daniperez@gmail.com  |
| Ana Martín    | anamartin@gmail.com  |


Realiza consultas simples y comprueba que funciona.

!!! tip "Ayuda"
    - Para instalar mysql hay que actualizar los repositios de Linux
    - A continuación instalar el paquete con el comando apt install mysql-server -y
    - Recuerda cambiar los permisos del fichero de la clave privada y añadirlo con el parámetro -i dentro del comando ssh
    - La creación de la BD, la tabla, las inserciones y consultas deben hacerse a través de la conexión SSH por linea de comandos.


!!! success "Entrega"
    - Debes entregar una bitácora con capturas de pantalla.
    - Razona porqué has elegido ese tipo de máquina y no otra.
    - Se debe ver el tamaño de la instancia, los datos de usuario y el par de claves utilizado
    - también queremos ver la conexión por ssh a la máquina Linux.

