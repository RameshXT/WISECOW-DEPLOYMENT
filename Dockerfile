# Use the official Python image.
FROM python:3.9-slim

RUN apt-get update && apt-get install -y fortune

# Set the working directory in the container.
WORKDIR /app

# Copy the requirements file into the container.
COPY requirements.txt .

# Install the dependencies.
RUN pip install -r requirements.txt

# Copy the rest of the application code into the container.
COPY . .

# Expose the port that the application will run on.
EXPOSE 80

# Define the command to run the application.
CMD ["python", "app.py"]
