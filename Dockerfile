# Используем современную стабильную версию Python
FROM python:3.11-slim

# Устанавливаем системные зависимости: Java 21 для Spark, curl и procps
RUN apt-get update && apt-get install -y \
    openjdk-21-jre-headless \
    curl \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Настраиваем переменные окружения для Java 21
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Устанавливаем Python-пакеты (Стек для данных + Jupyter + GUI инструменты)
RUN pip install --no-cache-dir \
    pyspark==3.5.1 \
    pandas==2.2.2 \
    pyarrow \
    jupyterlab==4.2.1 \
    jupyterlab-widgets \
    mitosheet \
    itables

# Создаем рабочую директорию внутри контейнера
WORKDIR /home/jovyan/work

# Открываем порт для Jupyter Lab
EXPOSE 8888

# Запуск Jupyter Lab с флагами, разрешающими WebSockets (исправленный синтаксис параметров)
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=", "--NotebookApp.password=", "--NotebookApp.allow_origin='*'", "--NotebookApp.allow_remote_access=True"]