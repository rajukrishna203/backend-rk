# Secure base image
FROM node:20-alpine

# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Securely copy package files first
COPY package.json package-lock.json ./

# Install dependencies securely
RUN npm ci --only=production

# Copy remaining application files
COPY . .

# Set ownership and file permissions securely
RUN chown -R appuser:appgroup /app

# Expose only the required port
EXPOSE 3000

# Use a non-root user
USER appuser

# Secure start command
CMD ["node", "server.js"]
