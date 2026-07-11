FROM tomcat:10.1-jdk21-openjdk-slim

# Instalamos Java 25 manualmente en el contenedor para que reconozca tus archivos .jar modernos
RUN apt-get update && apt-get install -y wget && \
    wget https://download.oracle.com/java/25/latest/jdk-25_linux-x64_bin.tar.gz && \
    tar -xvf jdk-25_linux-x64_bin.tar.gz && \
    mv jdk-25.* /opt/jdk25 && \
    rm jdk-25_linux-x64_bin.tar.gz

# Configurar las variables de entorno para usar Java 25
ENV JAVA_HOME=/opt/jdk25
ENV PATH=$JAVA_HOME/bin:$PATH

RUN rm -rf /usr/local/tomcat/webapps/*
COPY web/ /usr/local/tomcat/webapps/ROOT/
COPY build/web/WEB-INF/ /usr/local/tomcat/webapps/ROOT/WEB-INF/
EXPOSE 8080
CMD ["catalina.sh", "run"]
