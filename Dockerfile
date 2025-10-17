FROM mcr.microsoft.com/mssql/server:2022-latest

# Variabili d'ambiente
ENV ACCEPT_EULA=Y
ENV MSSQL_PID=Express
ENV MSSQL_TCP_PORT=1433

# Password caricata da variabile d'ambiente
ARG MSSQL_SA_PASSWORD
ENV MSSQL_SA_PASSWORD=${MSSQL_SA_PASSWORD}

# Crea directory per script di inizializzazione
USER root
RUN mkdir -p /scripts

# Copia script di inizializzazione
COPY scripts/init-schema.sql /scripts/

# Espone la porta standard di SQL Server
EXPOSE 1433

# Mantiene il comando di avvio predefinito
CMD ["/opt/mssql/bin/sqlservr"]