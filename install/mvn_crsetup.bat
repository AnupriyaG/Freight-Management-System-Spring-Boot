REM Microsoft SQL Server Driver
CALL mvn install:install-file -Dfile=sqlserver-4.2.jar -DgroupId=com.microsoft -DartifactId=sqlserver -Dversion=4.2 -Dpackaging=jar
REM icu4j
CALL mvn install:install-file -Dfile=icu4j-3.8.jar -DgroupId=com.ibm.icu -DartifactId=icu4j -Dversion=3.8 -Dpackaging=jar
REM CrystalDecisions Runtimwe
CALL mvn install:install-file -Dfile=runtime-12.2.217.2158.jar -DgroupId=com.crystaldecisions -DartifactId=runtime -Dversion=12.2.217.2158 -Dpackaging=jar
REM CrystalDecisions WebReporting
CALL mvn install:install-file -Dfile=webreporting-LOCAL.jar -DgroupId=com.crystaldecisions -DartifactId=webreporting -Dversion=12.2.217.2158 -Dpackaging=jar
REM CrystalDecisions jrcerom
CALL mvn install:install-file -Dfile=jrcerom-12.2.217.2158.jar -DgroupId=com.crystaldecisions -DartifactId=jrcerom -Dversion=12.2.217.2158 -Dpackaging=jar
REM CrystalDecisions XMLConnector
CALL mvn install:install-file -Dfile=XMLConnector-LOCAL.jar -DgroupId=com.crystaldecisions -DartifactId=XMLConnector -Dversion=LOCAL -Dpackaging=jar
REM Crystal Reports Runtime
CALL mvn install:install-file -Dfile=runtime-12.2.217.2158.jar -DgroupId=com.crystaldecisions -DartifactId=runtime -Dversion=12.2.217.2158 -Dpackaging=jar
REM Webreporting
CALL mvn install:install-file -Dfile=webreporting-LOCAL.jar -DgroupId=com.crystaldecisions -DartifactId=webreporting -Dversion=LOCAL -Dpackaging=jar
REM webreporting jsf
CALL mvn install:install-file -Dfile=webreporting.jsf-LOCAL.jar -DgroupId=com.crystaldecisions -DartifactId=webreporting-jsf -Dversion=LOCAL -Dpackaging=jar
REM JRCEROM
CALL mvn install:install-file -Dfile=jrcerom-12.2.217.2158.jar -DgroupId=com.crystaldecisions -DartifactId=jrcerom -Dversion=12.2.217.2158 -Dpackaging=jar
REM CrystalCommons2
CALL mvn install:install-file -Dfile=common-12.2.217.2158.jar -DgroupId=com.crystaldecisions -DartifactId=common -Dversion=12.2.217.2158 -Dpackaging=jar
REM BO Foundation
CALL mvn install:install-file -Dfile=foundation-12.2.217.2158.jar -DgroupId=com.businessobjects -DartifactId=foundation -Dversion=12.2.217.2158 -Dpackaging=jar
REM BO PFJGraphics
CALL mvn install:install-file -Dfile=pfjgraphics-12.2.217.r2158_v20131126.jar -DgroupId=com.businessobjects -DartifactId=pfjgraphics -Dversion=12.2.217.r2158_v20131126 -Dpackaging=jar
REM CVOM
CALL mvn install:install-file -Dfile=cvom-12.2.217.r2158_v20131126.jar -DgroupId=com.businessobjects -DartifactId=cvom -Dversion=12.2.217.r2158_v20131126 -Dpackaging=jar
REM JDBInterface
CALL mvn install:install-file -Dfile=JDBInterface-12.2.217.2158.jar -DgroupId=com.businessobjects -DartifactId=JDBInterface -Dversion=12.2.217.2158 -Dpackaging=jar
REM DBConnectors
CALL mvn install:install-file -Dfile=DatabaseConnectors-12.2.217.2158.jar -DgroupId=com.businessobjects -DartifactId=DatabaseConnectors -Dversion=12.2.217.2158 -Dpackaging=jar
REM KeyCode Decoder
CALL mvn install:install-file -Dfile=keyCodeDecoder-12.2.217.2158.jar -DgroupId=com.crystaldecisions -DartifactId=keyCodeDecoder -Dversion=12.2.217.2158 -Dpackaging=jar
REM CR Logging
CALL mvn install:install-file -Dfile=logging-LOCAL.jar -DgroupId=com.crystaldecisions -DartifactId=logging -Dversion=LOCAL -Dpackaging=jar
REM CR QueryBuilder
CALL mvn install:install-file -Dfile=QueryBuilder-LOCAL.jar -DgroupId=com.crystaldecisions -DartifactId=QueryBuilder -Dversion=LOCAL -Dpackaging=jar
REM XPP3
CALL mvn install:install-file -Dfile=xpp3-LOCAL.jar -DgroupId=com.crystaldecisions -DartifactId=xpp3 -Dversion=LOCAL -Dpackaging=jar
REM MS JDBInterface
CALL mvn install:install-file -Dfile=JDBInterface-12.2.217.2158.jar -DgroupId=com.microsoft -DartifactId=jdbc -Dversion=LOCAL -Dpackaging=jar
REM MS BASE
CALL mvn install:install-file -Dfile=base-LOCAL.jar -DgroupId=com.microsoft -DartifactId=base -Dversion=LOCAL -Dpackaging=jar
REM MS UTIL
CALL mvn install:install-file -Dfile=util-LOCAL.jar -DgroupId=com.microsoft -DartifactId=util -Dversion=LOCAL -Dpackaging=jar
REM AZALEA BarCode Library
CALL mvn install:install-file -Dfile=BarCodeLibrary-1.0.jar -DgroupId=com.azalea.ufl -DartifactId=BarCodeLibrary -Dversion=1.0 -Dpackaging=jar
REM JAI IMAGEIO
CALL mvn install:install-file -Dfile=imageio-LOCAL.jar -DgroupId=com.sun -DartifactId=imageio -Dversion=LOCAL -Dpackaging=jar
pause