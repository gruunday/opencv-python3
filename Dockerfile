FROM ubuntu:latest

MAINTAINER Tom Doyle <thomas.doyle9@mail.dcu.ie>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \ 
    build-essential \
    cmake \
    git \
    pkg-config \
    wget \
    python3-dev \
    libopencv-dev \ 
    ffmpeg  \ 
    libjpeg-dev \ 
    libpng-dev \ 
    libtiff-dev \ 
    opencv-data \
    libopencv-dev \
    libgtk2.0-dev \ 
    python3-numpy \ 
    python3-pycurl \ 
    libatlas-base-dev \
    gfortran \
    webp \ 
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libatlas-base-dev && apt-get clean

RUN wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py && \
    pip3 install numpy && \
    rm -rf get-pip.py

RUN git clone git://github.com/trendmicro/tlsh.git && \
    cd tlsh && git checkout master && ./make.sh && \
    cd py_ext/ && python3 ./setup.py build && python3 ./setup.py install && \
    cd ../.. && rm -rf tlsh

RUN cd ~/ && git clone https://github.com/opencv/opencv.git && \
             git clone https://github.com/opencv/opencv_contrib.git && \
             mkdir -p ~/opencv/build && cd ~/opencv/build && \
             cmake -D CMAKE_BUILD_TYPE=RELEASE \ 
                   -DCMAKE_INSTALL_PREFIX=/usr/local \
                   -DOPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
                   -DBUILD_opencv_python3=ON \
                   -DPYTHON_DEFAULT_EXECUTABLE=/usr/bin/python3.6 \
                   -DOPENCV_ENABLE_NONFREE=ON \
                   -DBUILD_EXAMPLES=ON .. && \ 
             make -j`cat /proc/cpuinfo | grep MHz | wc -l` && \
             make install && ldconfig && \
             rm -rf ~/opencv && rm -rf ~/opencv_contrib
 
