#!/bin/bash

# 1. Limpieza preventiva
echo "🧹 Limpiando ambiente previo..."
docker-compose down -v

# 2. Levantamiento
echo "🚀 Levantando contenedores..."
docker-compose up -d --build

# 3. Espera activa (Wait-for-it logic)
echo "⏳ Esperando a que la base de datos esté lista..."
# Ejecutamos el smoke-check en un bucle hasta que pase o agote el tiempo
MAX_RETRIES=10
COUNT=0

while ! ./smoke-check.sh > /dev/null; do
    ((COUNT++))
    if [ $COUNT -ge $MAX_RETRIES ]; then
        echo "❌ ERROR: La base de datos nunca arrancó. Abortando."
        docker-compose logs database_qa
        exit 1
    fi
    echo "Retento $COUNT/$MAX_RETRIES..."
    sleep 3
done

# 4. Preparación de la App
echo "📦 Ejecutando migraciones..."
docker exec -it laravel_qa_container php artisan migrate:fresh --seed

echo "✅ AMBIENTE LISTO Y TESTEADO"
echo "URL: http://localhost:8080/api/health"