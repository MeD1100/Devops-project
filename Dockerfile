FROM maven as build
WORKDIR /app
COPY . .
RUN mvn install

FROM openjdk:11.0
WORKDIR /app
COPY --from=build /app/target/springboot-1.0.0.jar /app/
EXPOSE 8080
CMD {"java","-jar","springboot-1.0.0.jar"}