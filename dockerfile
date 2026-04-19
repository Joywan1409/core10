# Use the appropriate base image (adjust to your runtime needs)
FROM ubuntu:22.04 AS build

# Install dependencies required by build.sh
# Add whatever tools your script calls (dotnet, gcc, npm, etc.)
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    git \
    dotnet-sdk-8.0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /artifacts

# Copy build.sh into /artifacts
COPY build.sh /artifacts/build.sh

# Ensure the script is executable
RUN chmod +x /artifacts/build.sh

# Run the build script
RUN
# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy project file(s) and restore dependencies
COPY ["MyApp/MyApp.csproj", "MyApp/"]
RUN dotnet restore "MyApp/MyApp.csproj"

# Copy everything else and build
COPY . .
WORKDIR "/src/MyApp"
RUN dotnet publish "MyApp.csproj" -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MyApp.dll"]

# Expose default ASP.NET ports
EXPOSE 3000
EXPOSE 3000
