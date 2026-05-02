#!/bin/bash

# Realizamos la petición y guardamos la respuesta en una variable
RESPONSE=$(curl -s http://localhost:8080/api/health)

echo "Validando ambiente..."

# --- TU LÓGICA AQUÍ ---
# Pista: Puedes usar un bloque 'if' con el comando 'grep' 
# para buscar la cadena "connected" dentro de $RESPONSE

if [[ $RESPONSE == *"connected"* ]]; then
    echo "✅ AMBIENTE LISTO"
    exit 0
else
    echo "❌ FALLO DE INFRAESTRUCTURA"
    echo "Respuesta recibida: $RESPONSE"
    exit 1
fi