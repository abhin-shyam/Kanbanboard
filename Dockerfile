FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
COPY public ./public

RUN npm ci
COPY . .
RUN npm run build

FROM nginx:stable-alpine

RUN rm -rf /usr/share/nginx/html/*
RUN mkdir -p /var/cache/nginx/client_temp /var/cache/nginx/proxy_temp && \
    chown -R 1001:0 /var/cache/nginx && \
    chmod -R 775 /var/cache/nginx

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
