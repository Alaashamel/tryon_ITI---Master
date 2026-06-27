# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Vite requires build-time env variables to be available during `npm run build`
# Pass this when building: --build-arg VITE_API_URL=https://your-backend/api
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 8080

CMD ["sh", "-c", "sed -i 's/listen       80;/listen 8080;/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'" ]

