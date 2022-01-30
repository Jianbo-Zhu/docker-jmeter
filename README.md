
# Jmeter
This how-to has been proved working on Mac OS.
## Set up earthly environment
1. [Install docker ](https://docs.docker.com/desktop/mac/install/)
2. [Install git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
3. Install earthly : `brew install earthly/earthly/earthly && earthly bootstrap`

## change the arguments accordingly 
Before run the earthly command, please update these arguments accordingly in the `Earthfile`.
* *IMAGE_NAME*, probably you want set it to `justb4/jmeter`;
* *JMETER_VERSION_LIST*, the jmeter versions you want to build;
* *CUSTOM_JAR_URL*, make sure it points to the download url of the custom jar file;

## Run the earthly command
It will build images for all listed jmeter versions and push to docker hub.
``` shell
docker login -u {username}  # replace username with docker hub account, and input the password
earthly --push +buildAll
```
## How to use the image with parameters
To run jmeter, just append all parameters to the `docker run` command as is `jmeter`. See below:
```
docker run -d --name jmeter railflow/jmeter:5.4.2 {PARAMETERS_GO_HERE}  #client mode
docker run -d --name jmeter railflow/jmeter:5.4.2 server {PARAMETERS_GO_HERE}  #server mode
```
E.g.
```
# nogui mode, start the test script:/opt/apache-jmeter-5.4.3/scripts/jmeter_test_script.jmx, override the JMV args by JVM_ARGS
docker run -d --name jmeter railflow/jmeter:5.4.2 -n -t /opt/apache-jmeter-5.4.3/scripts/jmeter_test_script.jmx -DJVM_ARGS="-Xmx1g -Xms256m"
# nongui mode, with proxy
docker run -d --name jmeter railflow/jmeter:5.4.2 -n -t /opt/apache-jmeter-5.4.3/scripts/jmeter_test_script.jmx -H my.proxy.server -P 8000
```
## How to run jmeter in client/server(master/slave) mode
The image support `client` and `server` mode, by default it start with `client` mode, if you want to start with `server` mode, pass *server* as the first parameter to the command. e.g.
```
docker run -d --name jmeter-server -p 1099:1099 railflow/jmeter:5.4.2 server -n 
```

and to start with `client` mode:
```
docker run --name jmeter-client railflow/jmeter:5.4.2 -n -t test.jmx -R server1,server2,…
```