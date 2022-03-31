FROM continuumio/miniconda3

RUN conda install -y -c conda-forge python fastapi uvicorn &&\
    conda clean -afy

RUN echo "bust cache"
ADD main.py .

EXPOSE 8000

CMD uvicorn main:app --host 0.0.0.0 --port 8000 --proxy-headers
