FROM continuumio/anaconda3:2023.03-1
WORKDIR /root
RUN apt-get update && apt-get install -y curl file
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH=$PATH:/root/.cargo/bin
RUN apt-get update && apt install build-essential --fix-missing -y
RUN wget --no-check-certificate https://dl.xpdfreader.com/xpdf-tools-linux-4.04.tar.gz &&  \
    tar -xvf xpdf-tools-linux-4.04.tar.gz && cp xpdf-tools-linux-4.04/bin64/pdftotext /usr/local/bin
RUN apt-get install ffmpeg -y
COPY requirements-prod.txt /root/
RUN pip3 install -r requirements-prod.txt
COPY ./main.py /root/
COPY ./cloud_storage_oci.py /root/
COPY ./query_with_langchain.py /root/
COPY ./io_processing.py /root/
COPY ./translator.py /root/
COPY ./logger.py /root/
EXPOSE 8000
COPY script.sh /root/
ENTRYPOINT ["bash","script.sh"]