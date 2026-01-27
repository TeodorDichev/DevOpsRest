# Use official OpenJDK 25 image
FROM eclipse-temurin:25-jdk-jammy

# Set working directory
WORKDIR /app

# Copy source files
COPY src ./src

# Compile Java files
RUN javac src/handlers/*.java src/*.java

# Expose port 80
EXPOSE 80

# Run the app
CMD ["java", "-cp", "src", "Launcher"]
