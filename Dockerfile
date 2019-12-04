ARG VERSION=11
#Build container
FROM openjdk:${VERSION}-jdk-slim as build-base

ENV APP_HOME=/app/
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

#Set up the build env
FROM build-base AS build-deps
COPY *.gradle gradle.* gradlew $APP_HOME
COPY gradle $APP_HOME/gradle
RUN ./gradlew --version

#Build it
FROM build-deps AS build
COPY src/ $APP_HOME/src
RUN ./gradlew build --no-daemon


#Runtime
FROM openjdk:${VERSION}-jdk-slim AS base
RUN mkdir -p /app
WORKDIR /app

FROM base AS container
COPY entrypoint.sh .
COPY --from=build /app/build/libs/sample-boot-0.0.1-SNAPSHOT.jar /app/app.jar

EXPOSE 8080
ENTRYPOINT [ "/app/entrypoint.sh" ]

