# ---------- Build stage ----------
    FROM maven:3.9-eclipse-temurin-17 AS build
    WORKDIR /build
    COPY pom.xml .
    RUN mvn dependency:go-offline
    COPY src ./src
    RUN mvn clean package -DskipTests
    
    # ---------- Runtime stage ----------
    FROM eclipse-temurin:17-jre
    WORKDIR /app
    
    # ✅ Recommended: non-root user
    RUN useradd -r -u 1001 appuser
    USER appuser
    
    COPY --from=build /build/target/sqlserver-demo-*.jar app.jar
    
    EXPOSE 8080
    ENTRYPOINT ["java","-jar","/app/app.jar"]
    