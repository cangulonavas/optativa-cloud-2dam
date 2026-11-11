#!/bin/bash
echo "Cargando datos..."
aws dynamodb batch-write-item --request-items file://elementos/items-1.json
echo "¡Datos cargados!"


