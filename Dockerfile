FROM maven:3.9.1-ibm-semeru-17-focal AS build-env
WORKDIR /var/www/java  

# Use the maven archetype for 'hello-world' as the sample app
RUN mvn archetype:generate \
    -DgroupId=com.hsbc.et.shared.tutorials \
    -DartifactId=hello-world \
    -DarchetypeArtifactId=maven-archetype-quickstart \
    -DarchetypeVersion=1.4 \
    -DinteractiveMode=false  
WORKDIR /var/www/java/hello-world

# Add a manifest file to the pom. This makes it easier to run
# in the distroless container
ARG TARGET_STR="<plugin>   \n\
	<groupId>org.apache.maven.plugins<\/groupId> \n\
	<artifactId>maven-jar-plugin<\/artifactId> \n\
	<version>2.4<\/version> \n\
	<configuration> \n\
	  <archive> \n\
	    <manifest> \n\
		<mainClass>com.hsbc.et.shared.tutorials.App<\/mainClass> \n\
	    <\/manifest> \n\ 
	  <\/archive> \n\
	<\/configuration> \n\
    <\/plugin> \n\
    <\/plugins> " 

# Not too fussed about spearating the RUN commands
# in the build stage as this doesn't persist in the runtime
RUN sed -i "s/<\/plugins>/$TARGET_STR/g" pom.xml
RUN mvn package

# Switch to distroless for the runtime. This saves a lot of 
# memory and reduces the cyber surface area. Still need to scan though. 
FROM gcr.io/distroless/java17-debian11

COPY --from=build-env /var/www/java/hello-world/target/hello-world-1.0-SNAPSHOT.jar /var/www/java/hello-world/target/hello-world-1.0-SNAPSHOT.jar
WORKDIR /var/www/java/hello-world/target
CMD [ "hello-world-1.0-SNAPSHOT.jar"]

