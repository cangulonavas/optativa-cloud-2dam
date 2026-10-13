## ¿Es necesaria una arquitectura de red en la nube de AWS?

La necesidad de una arquitectura de red en AWS no es una cuestión secundaria, sino una decisión estratégica fundamental. Esta arquitectura impacta directamente en el rendimiento, la seguridad y la capacidad de crecimiento de cualquier solución tecnológica desplegada en la nube. Los siguientes pilares justifican claramente su implementación

#### Escalabilidad

Una arquitectura de red bien diseñada en AWS permite escalar los recursos de forma automática y según la demanda, sin comprometer la continuidad operativa.

Servicios como Amazon VPC, Auto Scaling, Elastic Load Balancing y Route 53 permiten distribuir el tráfico de manera eficiente y agregar ecursos de computación sin rediseñar toda la infraestructura. Elementos como Elastic IPs, subredes en múltiples zonas de disponibilidad y recursos elásticos garantizan disponibilidad incluso ante aumentos súbitos de tráfico.

Además, esta arquitectura permite escalar horizontalmente (añadiendo más instancias) o verticalmente (potenciando las existentes) sin nterrumpir los servicios en producción.

#### Seguridad

AWS permite implementar una estrategia de seguridad multicapa, desde el nivel de red hasta el de la aplicación.
A través de VPCs configurables, subredes segmentadas, grupos de seguridad y listas de control de acceso (NACLs), es posible definir reglas precisas para controlar el tráfico. Además posee servicios que protegen frente a amenazas externas y ataques DDoS.

La infraestructura puede reforzarse mediante conexiones cifradas (VPN, Direct Connect), lo que asegura la confidencialidad de la nformación en tránsito.

#### Conectividad

La arquitectura de red en AWS facilita la integración fluida entre distintos recursos, ya sea en la nube o en entornos híbridos.

Soluciones como VPC Peering, Transit Gateway y PrivateLink permiten conectar instancias, bases de datos, contenedores y otros servicios sin fricción. También es posible establecer conectividad híbrida mediante túneles VPN cifrados o AWS Direct Connect.

Por otro lado, servicios como AWS Global Accelerator optimizan la velocidad de acceso para usuarios distribuidos geográficamente, mejorando la experiencia del cliente final.

---

Diseñar una arquitectura de red sólida en AWS no es una opción, sino un requisito. Esta arquitectura constituye el cimiento que permite que las soluciones cloud sean escalables, seguras y conectadas. De su planificación depende en gran medida la disponibilidad del servicio, la protección de los datos y la agilidad de la organización para adaptarse a nuevos desafíos.


## Los servicios que ofrece AWS para gestionar las redes son:

*Amazon Virtual Private Cloud* (**Amazon VPC**): permite aprovisionar secciones aisladas de forma lógica de la nube de AWS.

*Elastic Load Balancing*: distribuye automáticamente el tráfico entrante de las aplicaciones en varios destinos, tales como instancias de Amazon EC2, contenedores, direcciones IP y funciones Lambda.

*Amazon	CloudFront*: servicio rápido de red de entrega de contenido (CDN) que suministra datos, videos, aplicaciones y APIs de manera segura a clientes de	todo el mundo, con baja latencia y altas velocidades de transferencia.

*AWS Transit Gateway*: servicio que permite a los clientes conectar sus nubes privadas virtuales de Amazon (VPC) y sus redes en las instalaciones ( *on-premise* ) a un único *gateway* .

*Amazon Route 53*: servicio web de DNS escalable y en la nube diseñado para direccionar a los usuarios finales a las aplicaciones de Internet de	una forma confiable.

*AWS Global Accelerator*: utiliza las ubicaciones de borde para encontrar la ruta óptima a la región donde reside nuestra aplicación (haciendo uso tanto de protocolos HTTP como TCP/UDP).

*AWS Direct Connect*: ofrece una manera de establecer una conexión de red privada dedicada desde un centro de datos u oficina a AWS, lo que puede reducir los costes de red y aumentar el rendimiento del ancho de	banda.

*AWS VPN*: proporciona un túnel privado seguro desde una red o dispositivo a la red global de AWS.

Haciendo usos de esos servicios se puede mostrar una solución sencilla:

<img src="../images/ud03/vpc1.png" width="75%">

!!! question "Actividad 05. Solución sencilla con servicios AWS"
    - Dado el siguiente esquema realizado con servicios AWS:
    - Describe la solución propuesta con tus propias palabras.
    - Debes indicar lo que crees entender. 
    - Después sube el texto a Aules en un PDF


## Redes en AWS

Suponemos que los conceptos de red, subred y dirección IP y el modelo de la OSI están claros.

Dentro de AWS se utiliza el método CIDR para describir redes, por ejemplo, `192.0.2.0/24` (los primeros 24 bits son estáticos, y los últimos 8 flexibles). 

!!! note "Nota"
    Cabe destacar que AWS reserva las primeras cuatro direcciones IP y la última dirección IP de cada subred para fines de redes internas. 

Por ejemplo, una subred `/28` tendría 16 direcciones IP disponibles. De ahí hay que restar las 5 IP reservadas por AWS, obteniendo 11 direcciones IP para nuestro uso dentro de la subred.

Muchos de los conceptos de redes físicas son válidos para las redes  *cloud*, con la ventaja que en la nube nos ahorraremos gran parte de la complejidad.

## Amazon VPC

AWS utiliza las VPC (*AmazonVirtual Private Cloud* ) como redes privadas virtuales donde están conectados todos los recursos con los que trabajamos, de manera que el acceso queda aislado de otros usuarios. Dicho de otro modo, Amazon VPC permite lanzar recursos de AWS en la red virtual que definamos. Esta red virtual se asemeja en gran medida a una red tradicional que ejecutaríamos en nuestro propio centro de datos, con los beneficios de utilizar la infraestructura escalable de AWS, pudiendo crear una VPC que abarque varias AZ.

Al definir la red virtual podemos seleccionar nuestro propio intervalo de direcciones IP, crear subredes y configurar las tablas de enrutamiento y gateways de red. También podemos colocar el *backend* (servidores de aplicaciones o de bases de datos) en una subred privada sin acceso a Internet público. Finalmente, podemos añadir varias capas de seguridad, como grupos de seguridad y listas de control de acceso a la red (ACL de red), para ayudar a controlar el acceso a las instancias de EC2 en cada subred.

Sin entrar en mayor detalle, vamos a repasar algunos de los componentes más importantes:

#### Gateway de Internet (IGW)

Un *gateway de Internet* (Internet Gateway, IGW) es un componente de la VPC que permite la comunicación entre instancias de la VPC e Internet. 

Un caso específico es un *Gateway NAT*(o Nat Gateway), que se utiliza para proporcionar conectividad a Internet a instancias EC2 en las subredes privadas.

Después	de crear una VPC, podemos agregar subredes. Cada **subred** está ubicada por completo dentro de una **zona de disponibilidad** y no puede abarcar otras zonas. 

Si el tráfico de una subred se direcciona a un *Internet Gateway*, la subred recibe el nombre de **subred	pública**. Si una subred no dispone de una ruta al *Internet Gateway*, recibe el nombre de **subred privada**.

Para que las subredes privadas puedan conectarse a Internet dirigiendo el tráfico al *NAT Gateway* hemos de configurar las tablas enrutamiento.

#### Tabla de enrutamiento

Una tabla de enrutamientocontiene un conjunto de reglas, llamadas rutas, que se utilizan para	determinar el destino del tráfico de red. Cada subred de una VPC debe estar asociada a una tabla de enrutamiento, que es la que controla el direccionamiento de la subred. Las reglas de las tablas de enrutamiento se colocan de más a menos restrictivas. Tienen una ruta local integrada, la cual no se puede eliminar. Las rutas adicionales se agregan a la tabla.

#### Grupo de seguridad

Las VPC utilizan un *grupo de seguridad* que actúa como un *firewall* virtual.

Cuando se lanza una instancia, se asocia uno o varios grupos de seguridad a ella. Los grupos de seguridad tienen reglas que controlan el tráfico de entrada y de salida de las instancias, las	cuales podemos modificar. 

!!! warning "Atención"
    Los grupos de seguridad predeterminados deniegan todo el tráfico de entrada y permiten todo el tráfico de salida.

A continuación veremos algunas prácticas de creación de VPC que nos ayudarán a entender y afianzar estos conceptos.
