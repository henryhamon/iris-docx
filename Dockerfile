ARG IMAGE=intersystemsdc/iris-community:latest
FROM $IMAGE

COPY assets assets
WORKDIR /home/irisowner/irisbuild

ARG TESTS=0
ARG MODULE="dc-iris-docx"
ARG NAMESPACE="IRISAPP"

USER ${ISC_PACKAGE_MGRUSER}
ENV PIP_TARGET=${ISC_PACKAGE_INSTALLDIR}/mgr/python
RUN pip3 install python-docx pandas

RUN --mount=type=bind,src=.,dst=. \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    ([ $TESTS -eq 0 ] || iris session iris -U $NAMESPACE "##class(%ZPM.PackageManager).Shell(\"test $MODULE -v -only\",1,1)") && \
    iris stop IRIS quietly
