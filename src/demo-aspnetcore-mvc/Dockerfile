FROM microsoft/dotnet:2.2-sdk as build
ARG BUILD_CONFIGURATION=Release
ENV PORT 8080
EXPOSE 8080

RUN mkdir -p /app

WORKDIR /app
COPY . ./
RUN ls

RUN dotnet publish -c $BUILD_CONFIGURATION -o out

FROM microsoft/dotnet:2.2-aspnetcore-runtime AS runtime
WORKDIR /app
COPY --from=build /app/out ./
ENTRYPOINT ["dotnet", "demo-aspnetcore-mvc.dll"]
