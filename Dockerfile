# Set the base image to Debian
FROM debian:latest

# File Author / Maintainer
MAINTAINER Tiffany Delhomme <delhommet@students.iarc.fr>

RUN apt-get clean && \
	apt-get update -y && \

	# Install dependences
	DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
	g++ \
	make \
	zlib1g-dev \
	libncurses5-dev \
	ca-certificates \
	dialog \
	wget \
	bzip2 && \

	# Install samtools 
	wget https://github.com/samtools/samtools/releases/download/1.3/samtools-1.3.tar.bz2 && \
	tar -jxf samtools-1.3.tar.bz2 && \
	cd samtools-1.3 && \
	make && \
	make install && \
	cd .. && \
	rm -rf samtools-1.3 samtools-1.3.tar.bz2 && \
	
	# Install bwa
        wget -q http://downloads.sourceforge.net/project/bio-bwa/bwa-0.7.13.tar.bz2 \
        tar xjf bwa-0.7.13.tar.bz2 \
	cd bwa-0.7.13 \
	sed -i 's/CFLAGS=\\t\\t-g -Wall -Wno-unused-function -O2/CFLAGS=-g -Wall -Wno-unused-function -O2 -static/' Makefile \
	make \
	cp -p bwa /usr/local/bin \
        cd .. \
        rm -rf bwa-0.7.13* && \

	# Install sambamba 
	wget https://github.com/lomereiter/sambamba/releases/download/v0.5.9/sambamba_v0.5.9_linux.tar.bz2 \
	tar jxf sambamba_v0.5.9_linux.tar.bz2 \
	chmod +x sambamba_v0.5.9 \
	cp -p sambamba_v0.5.9 /usr/local/bin/sambamba \
	rm -rf sambamba_v0.5.9_linux.tar.bz2 \
	rm sambamba_v0.5.9 && \
 
	# Install samblaster
	wget https://github.com/GregoryFaust/samblaster/releases/download/v.0.1.22/samblaster-v.0.1.22.tar.gz \
	tar zxvf samblaster-v.0.1.22.tar.gz \
	cd samblaster-v.0.1.22 \
	make \
	cp samblaster /usr/local/bin/ \
	cd .. \
	rm -rf samblaster-v.0.1.22* && \

	# Remove unnecessary dependences
	DEBIAN_FRONTEND=noninteractive apt-get remove -y \
	g++ \
	make \
	zlib1g-dev \
	libncurses5-dev \
	dialog \
	wget \
	bzip2 \
	software-properties-common && \

	# Clean
	DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \ 
	apt-get clean
