# Use a secure, up-to-date Node.js version
FROM node:20-alpine

# Create a non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Securely copy package files first for caching dependencies
COPY package.json package-lock.json ./

# Install dependencies in a secure way
RUN npm ci --only=production

# Copy remaining application files
COPY . .

# Set proper ownership and file permissions
RUN chown -R appuser:appgroup /app

# Expose only the necessary port
EXPOSE 3000

# Switch to non-root user
USER appuser

# Use a secure start command
CMD ["node", "server.js"]

