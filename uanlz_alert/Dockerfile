FROM centos:8

MAINTAINER "Erick Rodriguez erickrr.tbd93@gmail.com"

RUN yum install gcc -y
RUN yum install make -y
RUN yum install boost-devel -y
RUN yum install epel-release -y
RUN yum install jsoncpp -y
RUN yum install jsoncpp-devel -y
RUN yum install sqlite -y
RUN yum install sqlite-devel -y
RUN yum install openssl -y
RUN yum install openssl-devel -y
RUN yum install qt5-qtbase-devel -y

RUN mkdir /tmp/cxFramework2
RUN mkdir /tmp/uAuditAnalyzer2

ADD cxFramework2-master /tmp/cxFramework2
ADD uAuditAnalyzer2-master /tmp/uAuditAnalyzer2
ADD gcc-base.conf  /usr/lib64/qt5/mkspecs/common/gcc-base.conf

WORKDIR /tmp/cxFramework2
RUN qmake-qt5 . PREFIX=/usr
RUN make -j8 install

WORKDIR /tmp/uAuditAnalyzer2
RUN qmake-qt5 . PREFIX=/usr
RUN make -j8 install


RUN rm -rf /tmp/uAuditAnalyzer2
RUN rm -rf /tmp/cxFramework2

RUN ldconfig

EXPOSE 80/tcp

ENTRYPOINT ["/sbin/uanlz_alert"]
