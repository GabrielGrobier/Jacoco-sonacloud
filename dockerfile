# Etapa de tests
FROM eclipse-temurin:17-jdk AS test
WORKDIR /app
COPY . .
RUN chmod +x mvnw
RUN ./mvnw test -B  

# Etapa de compilación (depende de que "test" haya pasado)
FROM eclipse-temurin:17-jdk AS compile
WORKDIR /app
COPY --from=test /app .  
RUN ./mvnw clean package -DskipTests 

# Etapa de producción
FROM alpine/java:17-jdk AS prod
COPY --from=compile /app/target/*.jar /app.jar
CMD ["java", "-jar", "/app.jar"]