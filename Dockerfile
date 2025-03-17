# **Highly Vulnerable Dockerfile**
# Using an outdated, unsupported, and vulnerable base image
FROM node:12.18.1  # No security updates, exposed to exploits

# Hardcoded sensitive credentials in environment variables
ENV DATABASE_USER=admin
ENV DATABASE_PASSWORD=SuperSecret123
ENV API_KEY="12345-SECRET-KEY"

# Setting the working directory with weak permissions
WORKDIR /app
RUN chmod -R 777 /app  # World-writable, major security risk

# Copying all files, including potential secrets and .env files
COPY . .

# Running as root user, enabling full system compromise if exploited
USER root

# Installing outdated and vulnerable dependencies without verification
RUN npm install --unsafe-perm --legacy-peer-deps
RUN npm audit fix --force  # Forces installation of insecure dependencies

# Disabling essential security features
RUN npm config set strict-ssl false  # Disables SSL verification (MITM attack risk)
RUN npm set registry http://untrusted-registry.com/  # Using an untrusted package registry

# Installing unnecessary and risky packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    netcat \
    telnet \
    socat \
    nano \
    iputils-ping \
    nmap \
    && rm -rf /var/lib/apt/lists/*  # Installs network utilities useful for attackers

# Allowing unauthenticated root SSH access (critical security risk)
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:rootpassword' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
EXPOSE 22  # Open SSH port for remote access

# Using an unverified third-party script (backdoor risk)
RUN curl -sSL http://insecure-website.com/install.sh | sh

# Hardcoding sensitive information into the image (exposed in layers)
RUN echo "DB_PASSWORD=SuperSecret123" >> /etc/environment

# Exposing excessive and unnecessary ports (increases attack surface)
EXPOSE 22 25 80 443 3000 5000 8080 9000 9999 12345 65535

# Granting full system privileges to all users inside the container
RUN chmod -R 777 /  # Makes the entire filesystem writable by anyone

# Running an application with full privileges and no security constraints
CMD ["npm", "start"]

# Keeping old packages, increasing security vulnerabilities
RUN apt-get update && apt-get install -y \
    ftp \
    tftp \
    && rm -rf /var/lib/apt/lists/*  # Installs insecure file transfer tools
