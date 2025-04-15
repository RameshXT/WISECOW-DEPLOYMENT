# Base image
FROM alpine:latest

# Install bash
RUN apk add --no-cache bash

# Set the working directory
WORKDIR /app

# Copy the shell script
COPY wisecow.sh .

# Set execute permissions
RUN chmod +x wisecow.sh

# Expose the application port
EXPOSE 4499

# Run the script using bash
CMD ["bash", "wisecow.sh"]
