# SeDeF #

SeDeF is a tool I have made to learn Ruby language. Subdomain Finder Application has 2 tools and 4 web services. With these we are finding the subdomains of the domain. Firstly, app is looking to the status codes of these subdomains.

| Tools | Web Services |
| ----- | ------------ |
| theHarvester | DNSdumpster |
| Fierce | Netcraft |
| | Pkey |
| | WolframAlpha |

Subdomain Finder looking the **robots.txt**, **readme.html**, **components** and **wp-content**’s for detect that the site using wordpress or using joomla.

If subdomain uses the wordpress my app executing the wpcan tool and creating a report. The report saving into the **/reports/domain/wpscan/subdomain.txt**

If subdomain uses the joomla my app executing the joomlavs tool and creating a report. The report saving into the **/reports/domain/joomlavs/subdomain.txt**  

We’re hiding these in  the hash structure.


```
#!ruby
Subdomain: {
  :http_status,
  :https_status,
  wordpress: {
    :readme,
    :robots,
    :wp_content
  },
  joomla: {
    :robots,
    :components
  }
}
```

## The Scanners requirements
SubdomainFinder has a lot of requirements so I don’t want to exhause the last user. Because of that I have used the Docker feature. With these writed a code to create Docker file. We are assuming the docker has already installed on  the user’s system. With these command, we are creating the docker image:

```
#!bash
docker build -t [tagname] [path]
docker build -t sedef .
```

Then, if we executed the “**docker images**” command, we can see the all other images. Our docker image name is sedef, so now we can see the “sedef”

We are running the docker image and popping a shell.
We are executing our tools with “**sedef -d [domain_name]**” command.

```
#!bash
docker images
docker run -v $PWD/reports:/opt/subdomainfinder/reports -it sedef
sedef -d [domain_name]
```

*I have named as a “Sedef”, because it is a Turkish project so it have to demonstrate Turkish architecture ;)*
