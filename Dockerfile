# build stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
COPY public ./public
RUN npm ci
COPY . .
RUN npm run build

# run stage - IMPORTANT: unprivileged nginx
FROM nginxinc/nginx-unprivileged:stable-alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
