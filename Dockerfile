FROM mechtaev/f1x

RUN mkdir -p /home/f1x_demo

COPY ./demo /home/f1x_demo

WORKDIR /home/f1x_demo

CMD ["f1x", "-f", "sort.c", "-d", "test.sh", "-t", "long", "-T", "100"]


