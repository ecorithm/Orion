FROM python:3.6

EXPOSE 8888

RUN mkdir /cuda
COPY docker/cuda_10.0.* /cuda
RUN chmod +x /cuda/cuda_10.0.*
RUN /cuda/cuda_10.0.130_410.48_linux.run --silent --override --toolkit --samples --toolkitpath=/usr/local/cuda-10.0 --samplespath=/usr/local/cuda --no-opengl-libs
RUN ln -s /usr/local/cuda-10.0 /usr/local/cuda
RUN /cuda/cuda_10.0.130.1_linux.run --silent --accept-eula
COPY docker/cudnn-10.0-linux-x64-v7.6.0.64.tgz /cuda
RUN tar -xzvf /cuda/cudnn-10.0-linux-x64-v7.6.0.64.tgz --directory /cuda
RUN cp /cuda/cuda/include/cudnn.h /usr/local/cuda/include
RUN cp /cuda/cuda/lib64/libcudnn* /usr/local/cuda/lib64
RUN chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
RUN rm -rf /cuda

RUN mkdir /app
COPY setup.py /app
RUN pip install -e /app && pip install jupyter
RUN pip install tensorflow-gpu==1.15.5
RUN pip install tensorflow==1.15.5

COPY orion /app/orion
COPY notebooks /app/pametan/notebooks
COPY docker/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents
# kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--", "/docker-entrypoint.sh"]

RUN adduser jupyter --uid 1000 --disabled-password --system && chown -R jupyter /app

WORKDIR /app
USER jupyter
