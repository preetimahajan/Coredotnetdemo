#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

WORKDIR /src
COPY *.sln ./
COPY ["CoreDotnetDockerDemo/CoreDotnetDockerDemo.csproj", "CoreDotnetDockerDemo/"]
COPY ["CoreDotnetClassLibrary/CoreDotnetClassLibrary.csproj", "CoreDotnetClassLibrary/"]
COPY ["CoreDotnetTest/CoreDotnetTest.csproj", "CoreDotnetTest/"]
RUN dotnet restore
COPY . .
WORKDIR "/src/CoreDotnetDockerDemo"
RUN dotnet build -c Release -o /app

FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "CoreDotnetDockerDemo.dll"]

