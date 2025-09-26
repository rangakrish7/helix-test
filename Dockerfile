# Use official OpenJDK 17 image
FROM openjdk:17-alpine

# Set working directory
WORKDIR /app

# Copy compiled class file
COPY HelloWorld.class .

# Run the application
CMD ["java", "HelloWorld"]
