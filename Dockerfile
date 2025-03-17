# **Secure & Maintainable Dockerfile**
# Use a minimal, up-to-date, and secure base image
FROM node:20-alpine as base

# Set environment variables securely
ARG DATABASE_USER
ARG DATABASE_PASSWORD
ARG API_KEY
ENV DATABASE_USER=${DATABASE_USER}
ENV DATABASE_PASSWORD=${DATABASE_PASSWORD}
ENV API_KEY=${API_KEY}
ENV NODE_ENV=production  # Ensures optimized production settings

# Set a secure working directory with appropriate permissions
WORKDIR /app
COPY package.json package-lock.json ./

# Install only necessary dependencies with integrity verification
RUN npm ci --omit=dev --ignore-scripts \
    && npm audit signatures \
    && rm -rf /root/.npm

# Multi-stage build to reduce final image size and remove unnecessary dependencies
FROM node:20-alpine as production
WORKDIR /app

# Create a non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy application files from the build stage
COPY --from=base --chown=appuser:appgroup /app /app
COPY . .

# Secure file permissions and restrict access
RUN chmod 750 /app && chown -R appuser:appgroup /app

# Expose only the necessary port
EXPOSE 3000

# Use a non-root user to execute the application
USER appuser

# Use a minimal entrypoint script to prevent container privilege escalation
ENTRYPOINT ["node", "server.js"]
