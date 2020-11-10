# Freight Management System Installation Instructions

## Required Software

- JDK v8 - please use version 8 instead of version 11 because of compatibility issues
- Maven - Download Maven binaries from https://maven.apache.org/download.cgi to a root folder on your hard drive and add the bin directory to your classpath
- Visual Studio Code (VSCode) - This is the preferred text editor and IDE
- VSCode Java Extension Pack - This is recommended to debug java applications in VSCode, this library will also help you diagnose issues with your java installation
- VSCode Lombok extension - By default VSCode does not know how to handle lombok annotations, this is required to configure VSCode correctly

Optional (but extremely helpfull)

- VSCode GitLens extension - This extension makes it easier to view the status of the GIT repository
- GitHub Desktop - Provides a user-friendly way to peruse GIT repositories
- GIT Desktop (https://git-scm.com/) - Integrates GIT into the command line, also provides a very usefull GIT GUI application

## Proprietary libraries and Maven

Run the script in the install folder to load all the JAR files into your local Maven repository

### Crystal Reports

FMS uses CrystalReports for report generation.

Unfortunately, because CrystalReports is a proprietary system, it cannot be automatically installed using maven.


### Microsoft SQL Server JDBC

You will need to download the JDBC driver before executing the above batch file


## Before starting the application

- Open the folder containing pom.xml in visual studio code. VSCode will start compiling the application, ignore this and wait for the process to finish (The Java extension pack will not correctly compile the code untill you have run the commands below)
- By default the application will run on port 8130, to change this open src/main/resources/application-dev.properties and change server.port as required.
- Open up the integrated command prompt by typing Ctrl + ` . In the command window type the following commands
```
set spring.profiles.active=dev
mvn spring-boot:run
```
- Maven will now download all the required libraries, compile the code and start the application.
