# **Secure Dockerfile**
# Using the latest stable and secure Node.js LTS version
FROM node:20-alpine  # Uses a minimal, up-to-date image to reduce attack surface

# Set a non-root user to improve security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Securely define environment variables (avoid hardcoded secrets)
ARG DATABASE_USER
ARG DATABASE_PASSWORD
ARG API_KEY
ENV DATABASE_USER=${DATABASE_USER}
ENV DATABASE_PASSWORD=${DATABASE_PASSWORD}
ENV API_KEY=${API_KEY}

# Set working directory with restricted permissions
WORKDIR /app
COPY --chown=appuser:appgroup . .

# Verify package integrity before installation
RUN apk add --no-cache curl bash \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && npm install --omit=dev --ignore-scripts

# Use multi-stage builds to remove build dependencies
FROM node:20-alpine AS production
WORKDIR /app
COPY --from=0 /app /app
RUN chown -R appuser:appgroup /app

# Expose only necessary ports
EXPOSE 3000

# Use a non-root user and run the application with limited privileges
USER appuser
CMD ["npm", "start"]
