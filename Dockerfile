FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /
COPY ["ConversaoPeso.Web/ConversaoPeso.Web.csproj", "ConversaoPeso.Web/"]
RUN dotnet restore "ConversaoPeso.Web/ConversaoPeso.Web.csproj"
COPY . .
WORKDIR "ConversaoPeso.Web"
RUN dotnet build "ConversaoPeso.Web.csproj" -p:PublishProfile=ConversaoPeso.Web -c Release -o /app

FROM build AS publish
RUN dotnet publish "ConversaoPeso.Web.csproj" -p:PublishProfile=ConversaoPeso.Web -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "ConversaoPeso.Web.dll"]

