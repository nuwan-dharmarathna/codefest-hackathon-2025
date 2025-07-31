# Get the base image
FROM node:22-alpine

# set the working dir
WORKDIR /backend

# copy the package.json file
COPY package*.json ./

# install the dependancies
RUN npm install

# copy the source code
COPY . .

# Copy your local .env into the image
COPY .env .env

# Expose the port
EXPOSE 8086

# Strart application
CMD ["npm", "start"]