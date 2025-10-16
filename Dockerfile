# build stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
COPY public ./public
RUN npm ci
COPY . .
RUN npm run build

# run stage - IMPORTANT: unprivileged nginx

# ---------- run stage ----------
FROM nginxinc/nginx-unprivileged:stable-alpine

# Temporarily escalate to clean up and copy
USER root
RUN rm -rf /usr/share/nginx/html/*

# Copy build output
COPY --from=builder /app/dist /usr/share/nginx/html

# Drop privileges again (the image’s normal non-root user is uid 101 / 'nginx')
USER 101

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]

