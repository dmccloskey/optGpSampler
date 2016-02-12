# Dockerfile to build optGpSampler container images
# Based on Ubuntu

# Set the base image for the solver
FROM dmccloskey/glpk:latest

# File Author / Maintainer
MAINTAINER Douglas McCloskey <dmccloskey87@gmail.com>

# switch to root for install
USER root

# Install optGpSampler from http
# instructions and documentation for python installation: http://cs.ru.nl/~wmegchel/optGpSampler/#install-python.xhtml
WORKDIR /usr/local/
RUN wget http://cs.ru.nl/~wmegchel/optGpSampler/downloads/optGpSampler_1.1_Python_Linux64.tar.gz
RUN tar -zxvf optGpSampler_1.1_Python_Linux64.tar.gz

# Convert python 2 to 3:
WORKDIR /usr/local/optGpSampler_1.1
RUN 2to3-3.4 -w setup.py
RUN 2to3-3.4 -w optGpSampler/

# Run setup.py
RUN python3 setup.py install

# Install optGpSampler dependencies from http
WORKDIR /usr/local/
RUN wget http://cs.ru.nl/~wmegchel/optGpSampler/downloads/optGpSampler_1.1_Python_Linux64_dependencies.tar.gz
RUN tar -zxvf optGpSampler_1.1_Python_Linux64_dependencies.tar.gz
WORKDIR /usr/local/optGpSampler_1.1_Python_Linux64_dependencies

#Copy the files in libs/lin64 to a directory $LIB_DIR (for example /home/wout/optGpSamplerLibs) on your computer
RUN mv libs /usr/local/lib/python3.4/dist-packages/optGpSampler
RUN mv models /usr/local/lib/python3.4/dist-packages/optGpSampler

# add environment variables for optGpSampler
ENV LD_LIBRARY_PATH /usr/local/lib/python3.4/dist-packages/optGpSampler/libs
ENV OPTGPSAMPLER_LIBS_DIR /usr/local/lib/python3.4/dist-packages/optGpSampler/libs
#RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LIB_DIR
#RUN export OPTGPSAMPLER_LIBS_DIR=$LIB_DIR

# Cleanup
WORKDIR /
RUN rm -rf /usr/local/optGpSampler_1.1_Python_Linux64.tar.gz
RUN rm -rf /usr/local/optGpSampler_1.1
RUN rm -rf /usr/local/optGpSampler_1.1_Python_Linux64_dependencies.tar.gz
RUN rm -rf /usr/local/optGpSampler_1.1_Python_Linux64_dependencies
RUN apt-get clean

# switch back to user
WORKDIR $HOME
USER user

# set the command
CMD ["python3"]
