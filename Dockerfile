FROM mechtaev/f1x

RUN mkdir -p /home/f1x_demo

COPY ./demo /home/f1x_demo

CMD ["f1x", "-f", "/home/f1x_demo/sort.c", "-d", "/home/f1x_demo/test.sh", "-t", "long", "-T", "100"]


