#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["CoreDotnetDockerDemo/CoreDotnetDockerDemo.csproj", "CoreDotnetDockerDemo/"]
RUN dotnet restore "CoreDotnetDockerDemo/CoreDotnetDockerDemo.csproj"
COPY . .
WORKDIR "/src/CoreDotnetDockerDemo"
RUN dotnet build "CoreDotnetDockerDemo.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "CoreDotnetDockerDemo.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "CoreDotnetDockerDemo.dll"]