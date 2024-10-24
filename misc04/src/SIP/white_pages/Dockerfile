# 1. Base image: Using Node.js LTS version
FROM node:20-alpine

# 2. Set the working directory inside the container
WORKDIR /app

# 3. Copy package.json and package-lock.json files to the working directory
COPY backend/package*.json ./

# 4. Install project dependencies
RUN npm install

# 5. Copy the rest of the application code
COPY backend/ .

# 8. Define the command to run the app
CMD ["node", "index.js"]