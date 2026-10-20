# Actividad 10.  Gestión de volúmenes EBS

Creación de un volumen EBS y montaje en varias instancias EC2.

!!! tip "Recuerda"
    - Los volúmenes EBS equivalen a los **discos duros virtuales** que utilizan las instancias EC2.
	- Un volumen sólo puede estar **conectado a una instancia** simultáneamente.
	- Pero una instancia puede **conectar varios volúmes EBS** simultáneamente.


## Objetivo de la práctica

* Comprender el funcionamiento del almacenamiento **EBS (Elastic Block Store)**.
* Crear y asociar un volumen EBS a una instancia EC2.
* Formatear, montar y usar un volumen EBS desde Linux.
* Desasociar y reutilizar un volumen en otra instancia.
* Crear y restaurar una instantánea (snapshot) de un volumen.


---

## Creación de una instancia EC2

1.- Vamos a crear una instancia EC2 sobre la que montaremos el volumen EBS. Configura:

* **Nombre:** `Servidor-A`
* **AMI:** Ubuntu
* **Instance type:** `t2.micro`
* **Key pair:** selecciona o crea uno nuevo
* **Network settings:** pulsa **Editar** y deja VPC y subred por defecto (zona de disponibilidad → `us-east-1b`)
* **Storage:** deja el volumen raíz predeterminado (8 GB)

!!! warning "Importante"
    Recuerda la zona de disponibilidad en la que se ha creado la máquina. El volumen EBS que crearemos debe estar necesariamente en la misma AZ que la EC2.

2.- Lanza la instancia y espera a que el estado sea **Running**.

3.- Podemos conectarnos por ssh, pero esta vez lo vamos a hacer desde el propio navegador:

- Selecciona la instancia `Servidor-A` y pulsa sobre el botón **Conectar**
- En la pestaña **En el navegador web** pulsa **Conectar**
- Nos aparecerá una consola de terminal en el navegador conectada a la instancia `Servidor-A`.

<img src="../images/ud04/practica3/ebs01.png">

---

<img src="../images/ud04/actividad10/act10_01.png">

---

## Crear y adjuntar un volumen EBS

4.- Estando en la pantalla de las instancia de EC2, en el panel lateral aparece un menú **Elastic Block Store → Volúmenes**. Accede a él y selecciona:

   * **Crear volumen**
   * **Tipo:** gp3
   * **Tamaño:** 20 GiB
   * **Availability Zone:** la misma que tu EC2
   * Deja los valores por defecto que te propone para las **IOPS** y el **Rendimiento**.
   * No marques la opción de **cifrado**
   * Crea el volumen.

5.- Una vez creado, selecciona el volumen y pulsa sobre **Acciones → Asociar volumen**

   * **Instancia:** elige la instancia `Servidor-A`
   * **Nombre de dispositivo:** selecciona uno de la lista, por ejemplo `/dev/sdf`
   * Finalmente asocia el volumen.

---

## Formatear y montar el volumen
6.- Accede al terminal de la máquina EC2 y verifica desde la instancia que se haya detectado el nuevo disco (puedes verificar que el número de serie coincide con el de la consola de EBS):

   ```bash
   lsblk -o NAME,SIZE,SERIAL,TYPE,MOUNTPOINTS
   ```

!!! warning "Atención"
    Es posible que la máquina EC2 no le asigne el nombre `/dev/sdf` que hemos seleccionado y en su lugar utilice la nomenclatura `/dev/xvdf` que corresponde a los discos NVME.

<img src="../images/ud04/actividad10/act10_02.png">    

7.- Formatea el volumen (sustituye por el nombre de dispositivo que te haya asignado):

   ```bash
   sudo mkfs -t ext4 /dev/xvdf
   ```
!!! note "Partición de disco"
    Fíjate que no hemos creado ninguna partición en el disco, sino que hemos creado el sistema de ficheros directamente sobre todo el disco. Esto puede ser peligroso, pero en el caso de los discos EBS no hay problema de hacerlo así.

8.- Crea un punto de montaje:

   ```bash
   sudo mkdir /datos
   ```
9.- Monta el volumen:

   ```bash
   sudo mount /dev/xvdf /datos
   ```
10.- Comprueba que '/datos' se ha montado correctamente:

   ```bash
   df -h
   ```
11.- Crea un archivo de prueba:

   ```bash
   echo "Prueba EBS" | sudo tee /datos/info.txt
   ```

12.- Muestra el contenido del archivo creado:

   ```bash
   echo cat /datos/info.txt
   ```

---

## Desmontar y conectar el volumen a otra EC2

13.- Vamos ahora a desmontar el volumen en `Servidor-A` para dejarlo disponible para ser utilizado por otra instancia:

   ```bash
   sudo umount /datos
   ```

14.- En la consola AWS:

   * Selecciona el volumen EBS y pulsa sobre **Desasociar el volumen** desde el menú de acciones.

<img src="../images/ud04/actividad10/act10_03.png">

15.- Crea una **segunda instancia EC2** de Ubuntu:

   * **Nombre:** `Servidor-B`
   * **Importante**: Misma AZ que el `Servidor-A`

16.- Esperar a que la instancia esté en ejecución.

17.- Una vez en ejecución, abrir la instancia y seleccionar **Elastick block Store** → **Volumenes**

18.- Abrir el volumen que creamos anteriormente y del panel de **Acciones** haremos clic en **Asociar volumen**

19.- Asociarás el volumen EBS a `Servidor-B`.

<img src="../images/ud04/actividad10/act10_04.png">

20.- Conéctate a `Servidor-B` y monta el volumen:

```
sudo mkdir /datos
```

``` bash
sudo mount /dev/nvme1n1 /datos
```

``` bash
cat /datos/info.txt
```

   Verás el contenido creado en la otra máquina:

   ```
   Prueba EBS
   ```

!!! success "Captura la pantalla"
    Captura la pantalla en la que se muestre que han funcionado todos los comandos ejecutados en `Servidor-B`

---

## Crear y restaurar una instantánea (snapshot)

18.- Desde la consola **EBS → Volumenes**, selecciona tu volumen y pulsa **Crear instantánea** dentro del menú **Acciones**.

   * **Descripción:** “Snapshot de prueba del volumen EBS”

19.- Espera a que el estado del snapshot sea **Completed**.

20.- Ahora, vamos a crear un nuevo volumen a partir de la instantánea creada. Para ello accedemos al panel lateral **Elastic Block Store → Instantáneas**:

- Seleccionamos la instantánea que acabamos de crear.
- En el menú **Acciones** pulsamos sobre **Crear volumen a partir de una instantánea**:

    - Seleccionamos el mismo tipo y AZ que el volumen anterior.
    - Dejamos es resto de los valores por defecto.


21.- Busca el volumen disponible y conéctalo a cualquiera de las instancias y verifica que el archivo `/datos/info.txt` sigue existiendo.

<img src="../images/ud04/actividad10/act10_05.png">

## Liberación de recursos

!!! warning "Eliminar recursos"
   
    - Una vez finalizada la práctica hay que eliminar los recursos creados para que no nos consuman crédito:
    - Finaliza las instancias **pero no las elimines** (nos harán falta para la siguiente práctica).
    - Elimina los volúmenes EBS creados.
    - <img src="../images/ud04/actividad10/act10_06.png">

