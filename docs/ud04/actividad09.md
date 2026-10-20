# Actividad 09. Publicación de una web estática en S3

Publicación de un sitio web estático en Amazon S3 con control de acceso mediante políticas de bucket.

## Objetivo de la práctica

* Comprender el funcionamiento del alojamiento web estático en Amazon S3.
* Aprender a crear un bucket, subir un sitio web y habilitar su acceso público **mediante una política de bucket**.
* Configurar S3 para que sirva páginas web **estáticas** (HTML, CSS, imágenes, etc.) directamente.
* Comprobar el acceso al sitio web a través de una URL pública de S3.


## Preparación del material

1.- En primer lugar vamos a descargar desde GitHub un repositorio con una web de muestra. Lo haremos en un fichero `.zip` el cual habrá que descomprimir:

- Accede al repositorio de GitHub que contiene una web de muestra:
   [`https://github.com/ies-camp-de-morvedre/hello-cloud`](https://github.com/IES-CAMP-DE-MORVEDRE/hello-cloud).
- Descarga el repositorio en formato ZIP pulsando en **Code → Download ZIP**.
- Descomprime el archivo ZIP en tu equipo local. Deberías tener una carpeta con archivos como `index.html`, `assets/`, etc.

---

## Creación del bucket

2.- Inicia sesión en la **Consola de AWS** y entra en el servicio **S3**. Crea un bucket:

   - Que el bucket sea de **uso general**.
   - Pon un nombre del bucket único, por ejemplo, `web-estatica-nombrealumno`.
   - Deja **deshabilitadas las ACL**.
   - Haz que el acceso al bucket sea público, **desmarca** la casilla *“Bloquear todo el acceso público”*.

!!! danger "Atención"
    Ya sabemos que hacer el bucket público es una práctica peligrosa, pero en este caso no tenemos elección.


---

## Subir los archivos de la web

3.- Entra en el bucket creado y carga los archivos descomprimidos.

!!! warning "Atención"
    A la hora de subir el contenido no subas directamente la carpeta `hello-cloud-main` sino únicamente los ficheros y carpetas que hay en su interior, asegurándote que el fichero `index.html` y el resto de archivos y carpetas de ese nivel quedan en la raíz del bucket.

---

## Activar el alojamiento web estático

4.- Con el contenido ya cargado, vamos a activar el alojamiento web estático. Para ello, en la vista del bucket, ve a la pestaña **“Propiedades”**:

- En la sección **“Alojamiento de sitio web estático”** haz clic en **“Editar”** → selecciona **“Habilitar”**.
- En **Documento de índice** escribe: `index.html`
- Guarda los cambios.
- Nuevamente, en la sección de **“Alojamiento de sitio web estático”** copia la URL del sitio web que aparece (por ejemplo: `http://web-estatica-nombrealumno.s3-website-eu-west-1.amazonaws.com`).

---

## Configurar la política del bucket

5.- Si intentamos acceder a la url de la página web estática nos dará un error de permisos, pues no es suficiente con hacer público el bucket. Es necesario que además concedamos permisos. En la práctica anterior vimo cómo cambiar estos permisos mediante ACLs, pero AWS nos recomienda que lo hagamos por políticas. En esta práctica **vamos a cambiar los permisos mediante políticas**:

- Accede a la pestaña **Permisos** del bucket.
- Localiza **Política de bucket** y pulsa *Editar*.
- Pega la siguiente política en formato JSON, sustituyendo el nombre del bucket por el tuyo:

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "PublicReadGetObject",
         "Effect": "Allow",
         "Principal": "*",
         "Action": "s3:GetObject",
         "Resource": "arn:aws:s3:::web-estatica-nombrealumno/*"
       }
     ]
   }
   ```

   > Esta política `s3:GetObject` junto con la opción `Allow` permite que cualquiera (`*`) pueda leer los archivos del bucket, pero no modificarlos ni borrarlos.

   > El recurso `"Resource": "arn:aws:s3:::web-estatica-nombrealumno/*"` indica el *arn* del bucket seguido de `/*`, que significa cualquier objeto dentro del bucket.

   > El **arn** es el *Amazon Resource Name*, es decir, un identificador único que AWS usa para referirse a cualquier recurso dentro de su infraestructura: un bucket S3, una instancia EC2, una función Lambda, una política IAM, etc.

---

## Comprobar el funcionamiento

- Abre la **URL del sitio web**.
- Si todo está correcto, la página `index.html` y el resto del contenido se mostrará públicamente.

!!! success "Captura la pantalla"
    Captura la pantalla en la que se muestre que ha funcionado el aaceso desde el navegador a la web. Debe verse la url y el contenido de la página web.
