<link href="https://raw.github.com/clownfart/Markdown-CSS/master/markdown.css" rel="stylesheet"></link>

# J2EE Container Managed Security Example 

This is a sample program that demonstrates the configuration needed
to implement J2EE container-managed security on Web resources, and EJB 
resources. 

The deployment package consists of a simple Web Application that
contains an HTML home page which includes a JSP page.  That JSP page makes a 
call to a stateless session EJB, and the data returned is displayed on the
Web page.  In order to access the page, the user must authenticate using 
HTTP Basic authentication.  Once the user is authenticated, the J2EE container
will make a determination of whether the user is authorized to access the requested page.
The user must be granted a specific role, "WebUserRole," in order to see the page.
In addition, the use must have the specific role "PrivateBeanMethodUserRole" in order
to invoke the EJB method "getTimePrivate()".  Users with the role "PublicBeanMethodUserRole"
are able to invoke a different EJB method, "getTime()".  (Both methods will return the current time).

This code is based on the "mytime" sample stateless session bean application originally provided in 
the `/samples/javaee5` subdirectory, within the Geronimo 3.0 distribution.  We have slightly modified that example  
for this use, mainly by adding one additional EJB method, and supplying the necessary deployment descriptors to 
invoke the J2EE container managed security. 


## Co-ordinates

* Team:
  * John Field (`jfield@gopivotal.com`)
  * Add Your Name Here (`my-mail@my-company.com`)


## Quick Start

As prerequisites, you'll need to have Geronimo 3.x or another standards-compliant J2EE container in which to deploy the EAR file.
You can download Geronimo from [here.](http://geronimo.apache.org/downloads.html)
You'll also need to have an LDAP directory available.  This will be used as the back end authority for the custom authentication realm.  
The use of OpenLDAP or [IAMfortress OpenLDAP](http://http://iamfortress.org/download) is recommended. 

If this works you are in business:

    $ git clone git://github.com/johnpfield/mytime.git
    $ cd mytime
    $ mvn clean install -P no-plugin

This will create the EAR file in the mytime-ear target directory, which you can then deploy using the Geronimo management console.

### Prerequisites

1. Install and run Geronimo as per [these instructions.](http://geronimo.apache.org/GMOxDOC30/quick-start-apache-geronimo-for-the-impatient.html)
2. Install and run IAMfortress OpenLAP as per [these instructions.](http://www.jts.us/iamfortress/guides/README-QUICKSTART.html) 
3. In the Geronimo Management Console pages, add a new Security Realm.  Specific details are available in file FortressRealm.xml, which can be found in the `mytime/config` subdirectory.
 
### Build and Deploy

If this works you are in business:

    $ git clone git://github.com/johnpfield/mytime.git
    $ cd mytime
    $ mvn clean install -P no-plugin

The generated EAR file can be found in the `mytime-ear/target` subdirectory.  This can be deployed to Geronimo via the Navigatoir's `Basic` console view.  Choose "Deployer," and then navigate to the EAR file on your local disk, and then click `install` to upload and start the application.
 

### Demo 

Point your browser at the home page of the application at the Geronimo server, i.e. `http://localhost:8080/mytime/`  

You will see an HTTP Basic Authentication pop-up dialog box.

You can log in using any username (uid) and password from your LDAP directory.

### Discussion

You can log in with any user that is present in the LDAP OU=People DIT subtree.   However, if the user does not have the appropriate group memberships in LDAP then they will not have authorization to access the page, or execute the EJB method calls needed to render the text on the page.  

* If your authentication fails (i.e. bad password), then you will get a 401 Unauthorized status and will be prompted again for credentials.

* If your authentication succeeds, but you haven't got any of the correct roles, you'll get 403 Forbidden, and you are done.

* If your authentication succeeds, and you have at least one EJB-relevent role, you will see a page with the current time displayed.

* If you have both EJB-relevent roles (i.e. the public method access and the private method access), then you will see the current time displayed twice, labeled as the `public` time and `private` time. Unless your system is heavilly loaded, these will likely be the same time as the requests are run in succession.  If you are denied access to an EJB method you will see the exception text displayed where the time string should be.


### Logical Role Mappings

The application designer must make choices about what roles are required to access what functions.  This information is decided at design and implementation time, and is captured in the application deployment artifacts.  Note that these decisions do not change on a per-deployment basis.

* In order to access the `/mytime` page the user must be a member of an LDAP group that has been mapped to the `WebUserRole`.
* In order to access the `getTime()` EJB method, the user must be a member of an LDAP group that has been mapped to the `PublicBeanMethodUserRole`.
* In order to access the `getTimePrivate()` EJB method the user must be a member of an LDAP group that has been mapped to the `PrivateBeanMethodUserRole`.
 
The mapping of the abstract role `WebUserRole` as a necessary permission to access the home page is done in 
the file `mytime/mytime-war/src/main/webapp/WEB-INF/web.xml`.

The mapping of the abstract roles `PublicBeanMethodUserRole` and `PrivateBeanMethodUserRole` as a necessary permission to access the EJB methods is done in the file `mytime/mytime-ejb/src/main/resources/META-INF/ejb-jar.xml`.

Note that with EJB 3 these assignments might also be done via annotations, however in this example we rely on the XML declarations.

### Declarative Security Implementation

The mapping of the abstract role `WebUserRole` to an `actual` LDAP group is done in the file `mytime/mytime-ear/src/main/resources/META-INF/geronimo-application.xml`.

In that file, we see that `WebUserRole` is mapped to `EnmasseSuperUser` ...this is done for absolutely no compelling reason.  This was just a random choice of a role available in Fortress.  Feel free to try something else.

The mapping of the abstract roles `PublicBeanMethodUserRole` and `PrivateBeanMethodUserRole` to an `actual` LDAP group is also done in the file `mytime/mytime-ear/src/main/resources/META-INF/geronimo-application.xml`.

Notice that the stuff that is enterprise-specific is done in one container-specific deployment descriptor, in the case of geronimo 3 this is the geronimo-application.xml.  We have secured both the Web tier resources and the EJB tier resources in one file, an artifact that is owned by the enterprise deployer.  

Conversely, the stuff that is fixed at application design time (the mapping of abstract roles to pages and bean methods) is done in the web.xml and ejb-jar.xml files, respectively.  These files are owned by the application supplier, and would not change on a per-deployment basis.
As noted, the geronimo-application.xml file would be customized by the enterprise deployment team.


