# Secure base image
FROM node:20-alpine

# Set non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

WORKDIR /app

# Install dependencies securely
COPY package.json package-lock.json ./
RUN npm ci --only=production

# Securely copy application files
COPY --chown=appuser:appgroup . .

# Expose only required ports
EXPOSE 3000

# Use a non-root user and secure start command
CMD ["node", "server.js"]
