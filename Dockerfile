FROM eclipse-temurin:25-jdk-jammy AS build
WORKDIR /build
COPY src ./src
RUN javac -d out src/handlers/*.java src/*.java

FROM eclipse-temurin:25-jre-jammy
WORKDIR /app
COPY --from=build /build/out .
EXPOSE 80

CMD ["java", "Launcher"]
