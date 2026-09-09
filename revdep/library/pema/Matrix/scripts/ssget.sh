#!/bin/sh

pkg=Matrix
if [ ! -f DESCRIPTION -o -z "$(grep "^Package: ${pkg}$" DESCRIPTION)" ]; then
	echo "script must be run in package [${pkg}] root directory"
	exit 1
fi
ssdir=SuiteSparse
ssver=7.6.0
sspfx=${ssdir}-${ssver}
sstgz=${sspfx}.tar.gz
ssurl=https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${ssver}.tar.gz
if [ -f ${sstgz} ]; then
	echo "Using existing ${sstgz}"
else
	echo "Downloading ${sstgz} from GitHub ..."
	wget ${ssurl} -O ${sstgz} || exit 1
	echo "done"
fi
echo "Extracting files under inst/doc and src ..."
for d in inst/doc/${ssdir} src/${ssdir}; do
	if [ -d ${d} ]; then
		echo "Moving existing ${d} to ${d}.bak ..."
		rm -rf ${d}.bak
		mv ${d} ${d}.bak
		echo "done"
	fi
done
## {root}
tar -zxvf ${sstgz} -C inst/doc \
	${sspfx}/README.md \
	${sspfx}/ChangeLog \
	${sspfx}/LICENSE.txt
## SuiteSparse_config
sslib=SuiteSparse_config
tar -zxvf ${sstgz} -C inst/doc \
	${sspfx}/${sslib}/README.txt
tar -zxvf ${sstgz} -C src \
	${sspfx}/${sslib}/SuiteSparse_config.c \
	${sspfx}/${sslib}/SuiteSparse_config.h
## CXsparse
sslib=CXSparse
tar -zxvf ${sstgz} -C inst/doc \
	${sspfx}/${sslib}/README.txt \
	${sspfx}/${sslib}/Doc/ChangeLog \
	${sspfx}/${sslib}/Doc/License.txt
tar -zxvf ${sstgz} -C src \
	${sspfx}/${sslib}/Include/*.h \
	${sspfx}/${sslib}/Source/*.[ch]
## AMD
sslib=AMD
tar -zxvf ${sstgz} -C inst/doc \
	${sspfx}/${sslib}/README.txt \
	${sspfx}/${sslib}/Doc/ChangeLog \
	${sspfx}/${sslib}/Doc/License.txt
tar -zxvf ${sstgz} -C src \
	${sspfx}/${sslib}/Include/*.h \
	${sspfx}/${sslib}/Source/*.[ch]
## COLAMD
sslib=COLAMD
tar -zxvf ${sstgz} -C inst/doc \
	${sspfx}/${sslib}/README.txt \
	${sspfx}/${sslib}/Doc/ChangeLog \
	${sspfx}/${sslib}/Doc/License.txt
tar -zxvf ${sstgz} -C src \
	${sspfx}/${sslib}/Include/*.h \
	${sspfx}/${sslib}/Source/*.[ch]
## CAMD
sslib=CAMD
tar -zxvf ${sstgz} -C inst/doc \
	${sspfx}/${sslib}/README.txt \
	${sspfx}/${sslib}/Doc/ChangeLog \
	${sspfx}/${sslib}/Doc/License.txt
tar -zxvf ${sstgz} -C src \
	${sspfx}/${sslib}/Include/*.h \
	${sspfx}/${sslib}/Source/*.[ch]
## CCOLAMD
sslib=CCOLAMD
tar -zxvf ${sstgz} -C inst/doc \
	${sspfx}/${sslib}/README.txt \
	${sspfx}/${sslib}/Doc/ChangeLog \
	${sspfx}/${sslib}/Doc/License.txt
tar -zxvf ${sstgz} -C src \
	${sspfx}/${sslib}/Include/*.h \
	${sspfx}/${sslib}/Source/*.[ch]
## CHOLMOD
sslib=CHOLMOD
tar -zxvf ${sstgz} -C inst/doc \
	${sspfx}/${sslib}/README.txt \
	${sspfx}/${sslib}/Doc/ChangeLog \
	${sspfx}/${sslib}/Doc/License.txt \
	${sspfx}/${sslib}/SuiteSparse_metis/Changelog \
	${sspfx}/${sslib}/SuiteSparse_metis/LICENSE.txt \
	${sspfx}/${sslib}/SuiteSparse_metis/README.txt
tar -zxvf ${sstgz} -C src \
	${sspfx}/${sslib}/Include/*.h \
	${sspfx}/${sslib}/Check/*.[ch] \
	${sspfx}/${sslib}/Cholesky/*.[ch] \
	${sspfx}/${sslib}/Utility/*.[ch] \
	${sspfx}/${sslib}/MatrixOps/*.[ch] \
	${sspfx}/${sslib}/Modify/*.[ch] \
	${sspfx}/${sslib}/Partition/*.[ch] \
	${sspfx}/${sslib}/Supernodal/*.[ch] \
	${sspfx}/${sslib}/SuiteSparse_metis/include/*.h \
	${sspfx}/${sslib}/SuiteSparse_metis/GKlib/*.[ch] \
	${sspfx}/${sslib}/SuiteSparse_metis/libmetis/*.[ch]
echo "done"
echo "Changing prefix ${sspfx} to ${ssdir} ..."
mv inst/doc/${sspfx} inst/doc/${ssdir}
mv src/${sspfx} src/${ssdir}
echo "done"
inc=inst/include/Matrix
h=cholmod.h
echo "Copying ${h} into ${inc} ..."
if [ -f ${inc}/${h} ]; then
	echo "Moving existing ${inc}/${h} to ${inc}/${h}.bak ..."
	mv ${inc}/${h} ${inc}/${h}.bak
	echo "done"
fi
cp src/${ssdir}/CHOLMOD/Include/${h} ${inc}
echo "done"
echo "Applying our patches ..."
patch -p0 < inst/scripts/${ssdir}.patch
patch -p0 < inst/scripts/${h}.patch
echo "done"
metis=src/${ssdir}/CHOLMOD/SuiteSparse_metis
echo "Adding disclaimer to comply with Apache-2.0 ..."
for f in $(find ${metis} \( ! -path "${metis}/*/*" -o -prune \) -type f); do
	mv ${f} ${f}.bak
	cat inst/scripts/disclaimer.txt ${f}.bak > ${f}
	rm ${f}.bak
done
echo "done"
