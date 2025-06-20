# ---- Build Stage ----
FROM maven:3.9.6-eclipse-temurin-17 AS builder

# Optional workaround for Lombok + JDK 17 module access
ENV MAVEN_OPTS="--add-exports jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED"

# Set working directory
WORKDIR /app

# Copy Maven project files
COPY pom.xml .
COPY src ./src

# Build the project (skip tests for faster build)
RUN mvn clean package -DskipTests

# ---- Runtime Stage ----
FROM eclipse-temurin:17-jdk

# Create app directory
WORKDIR /app

# Copy built JAR from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Run the JAR
CMD ["java", "-jar", "app.jar"]
