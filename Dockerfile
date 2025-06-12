# Use official Node.js base image
FROM node:18

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
