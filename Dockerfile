# Use the official Node.js image with version 20.8.0 as the base image
FROM node:20.8.0 AS build

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the entire project to the working directory
COPY . .

# Build the Angular app (production build)
RUN ng build

# Use a lighter image for serving the Angular app
FROM nginx:1-alpine-slim

# Copy the build artifacts from the 'build' stage to the nginx server
COPY --from=build /app/dist/keyword-location /usr/share/nginx/html

# Start the nginx server when the container starts
CMD ["nginx", "-g", "daemon off;"]
