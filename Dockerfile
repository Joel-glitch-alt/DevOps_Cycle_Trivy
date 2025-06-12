# Use safer Node.js base image with Bookworm (newer Debian release)
FROM node:18-bookworm

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci

# Copy the rest of the app
COPY . .

# Expose port and start the app
EXPOSE 3000
CMD ["node", "main.js"]
