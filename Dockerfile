FROM alpine:3.10.2
USER root
RUN mkdir /eqelart
RUN wget https://files.eqela.com/eqelart/6.x/eqelart-6.0.8_linux.zip
RUN unzip eqelart-6.0.8_linux.zip -d /eqelart

FROM scratch
LABEL maintainer="Eqela <contact@eqela.com>"
COPY --from=0 /eqelart/eqela /eqela
