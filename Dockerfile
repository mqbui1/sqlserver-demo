# ---------- BUILD STAGE ----------
    FROM maven:3.9-eclipse-temurin-17 AS build
    WORKDIR /build
    
    # Copy build files
    COPY pom.xml .
    COPY src ./src
    
    # Compile and package
    RUN mvn clean package -DskipTests
    
    
    # ---------- RUNTIME STAGE ----------
    FROM eclipse-temurin:17-jre
    WORKDIR /app
    
    # Copy only the JAR from the build stage
    COPY --from=build /build/target/sqlserver-demo-0.0.1-SNAPSHOT.jar app.jar
    
    EXPOSE 8080
    ENTRYPOINT ["java","-jar","/app/app.jar"]
    