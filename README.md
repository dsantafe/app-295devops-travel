FROM ubuntu:22.04
COPY setup.sh /setup.sh
RUN chmod +x /setup.sh
EXPOSE 80
CMD ["/setup.sh"]

docker build -t my-ubuntu-image .

docker run -it my-ubuntu-image

# run with connected bash with closing after exit
docker run -it --rm --name ubuntu ubuntu:18.04 /bin/bash
# run in detached mode
docker run -id --name ubuntu ubuntu:18.04
docker exec -it ubuntu /bin/bash
# run in detached mode with mounted directories
docker run -v /dir-on-host:/dir-in-container -id --name ubuntu ubuntu:18.04
docker exec -it ubuntu /bin/bash

FROM ubuntu:22.04
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && apt-get install -y python3 \
  && rm -rf /var/lib/apt/lists/*
RUN useradd -ms /bin/bash apprunner
USER apprunner