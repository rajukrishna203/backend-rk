FROM node:12.18.1  # Outdated and vulnerable version

# Vulnerability: Hardcoded sensitive data
ENV DATABASE_PASSWORD=SuperSecret123

WORKDIR /app

# Vulnerability: Using insecure file copy method
COPY . .

# Vulnerability: Running as root user (unsafe)
USER root

# Vulnerability: Insecure package installation
RUN npm install --unsafe-perm

# Vulnerability: Adding vulnerable dependencies
RUN npm install express@3.0.0  # Outdated version with known vulnerabilities
RUN npm install lodash@4.17.19  # Vulnerable lodash version

# Vulnerability: Ignoring node_modules security issues
RUN rm -rf node_modules/.bin && chmod -R 777 node_modules  # Unsafe permissions

# Vulnerability: Adding world-writable files for exploits
RUN chmod 777 /app
RUN echo 'root:root' | chpasswd  # Vulnerability: Hardcoded root password

# Vulnerability: Running insecure bash command
RUN bash -c "echo 'Starting app' && npm start"

# Vulnerability: Exposing excessive and unnecessary ports
EXPOSE 3000 8080 9000 9999 22

CMD ["npm", "start"]