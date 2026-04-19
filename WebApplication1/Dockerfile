# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .
RUN dotnet restore WebApplication1/WebApplication1.csproj \
 && dotnet publish WebApplication1/WebApplication1.csproj -c Release -o /app/out --no-restore

# Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out ./


# Expose default ASP.NET ports
EXPOSE 3000
EXPOSE 3000
ENTRYPOINT ["dotnet", "WebApplication1.dll"]
