# Use an official Node.js runtime as a base image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install app dependencies
RUN npm install

RUN build

# Copy the rest of the application code to the working directory
COPY . .

EXPOSE 8069

# Define the command to run your application
CMD ["node", "app.js"]
