# SeDeF #

SeDeF is a tool that I have made to learn Ruby language. The Subdomain Finder Application has 2 tools and 4 web services. We get the subdomains of a domain through those things.

First of all, the app checks of the status codes of the subdomains.

| Tools | Web Services |
| ----- | ------------ |
| theHarvester | DNSdumpster |
| Fierce | Netcraft |
| | Pkey |
| | WolframAlpha |

The Subdomain Finder looks for **robots.txt**, **readme.html**, **components** and **wp-content** to detect that the site uses WordPress or uses Joomla.

If the subdomain uses the WordPress then my app executes the wpcan tool and it creates a report. The report can be saved in **/reports/domain/wpscan/subdomain.txt**

If the subdomain uses the Joomla my app executes the joomlavs tool and it creates a report. The report can be saved in **/reports/domain/joomlavs/subdomain.txt**  

The app keep these keywords on the hash structure.

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
SubdomainFinder has a lot of requirements. So, I don’t want to occupy the end user. So, that's why I used Docker. We assume that Docker installed on the user’s system. 

We can create a Docker image through those commands;

```
#!bash
docker build -t [tagname] [path]
docker build -t sedef .
```

If we execute the “**docker images**” command then we can see all images. Our docker image's name is sedef. So, we can see the “sedef”

The Docker image runs and poke up it through the shell.
We execute our tools with “**sedef -d [domain_name]**” command.

```
#!bash
docker images
docker run -v $PWD/reports:/opt/subdomainfinder/reports -it sedef
sedef -d [domain_name]
```

*I have entitled as “Sedef”. Because it is a Turkish project. So it proves the Turkish architecture ;)*
