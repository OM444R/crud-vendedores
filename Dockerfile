# Usar una imagen base de Node.js
FROM node:18-alpine AS builder

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar los archivos de configuración
COPY package*.json ./

# Instalar dependencias
RUN npm ci

# Copiar el resto de los archivos del proyecto
COPY . .

# Etapa de producción
FROM node:18-alpine

WORKDIR /app

# Copiar solo los archivos necesarios desde la etapa de builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/crud-vendedores ./crud-vendedores
COPY --from=builder /app/package*.json ./

# Exponer el puerto que usa la aplicación
EXPOSE 3000

# Variables de entorno
ENV NODE_ENV=production
ENV DB_HOST=mysql
ENV DB_USER=root
ENV DB_PASSWORD=password
ENV DB_NAME=ventas

# Comando para iniciar la aplicación
CMD ["node", "crud-vendedores/app.js"] 