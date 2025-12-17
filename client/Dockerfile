# ---------- Build stage ----------
FROM node:20-alpine AS build

WORKDIR /app

# Copy client package definitions and install dependencies
COPY client/package.json client/package-lock.json* ./client/
WORKDIR /app/client
RUN npm install

# Copy client source code and build
COPY client ./ 
RUN npm run build

# ---------- Runtime stage ----------
FROM nginx:alpine

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy build output from client
COPY --from=build /app/client/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
