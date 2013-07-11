<%@ page contentType="text/html" import="javax.naming.Context, javax.naming.InitialContext " %>
<%@ page import="org.apache.geronimo.samples.mytimepak.MyTimeLocal" %>
<!--
Licensed to the Apache Software Foundation (ASF) under one or more
contributor license agreements. See the NOTICE file distributed with
this work for additional information regarding copyright ownership.
The ASF licenses this file to You under the Apache License, Version 2.0
(the "License"); you may not use this file except in compliance with
the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->
<html>
<head><title>Time</title></head>
<body>
<%
    String s = "-"; // Just declare a string
	String s2 = " Go Bruins!";
	String s3 = " Go Blackhawks!";

	try {
        // This creates a context, it can be used to lookup EJBs. 
        Context context = new InitialContext();
        // MyTimeLocalHome is a reference to the EJB.
        MyTimeLocal myTimeLocal = (MyTimeLocal) context.lookup("java:comp/env/ejb/MyTimeBean");
        // So, just go ahead and call a method (in this case the only public method).
        s = myTimeLocal.getTime(s2);
    }
    catch (Exception e) {
        s = e.toString();
    }

    String private_s = "-";  //Another time string, to be used for the protected call.	

    try {
        // Call the private method.
        // This creates *another* context. 
        // Not efficient, but we are focused on isolating the security, not page load speed.  
        Context context = new InitialContext();
        // MyTimeLocalHome is a reference to the EJB
        MyTimeLocal myTimeLocal = (MyTimeLocal) context.lookup("java:comp/env/ejb/MyTimeBean");
        // go ahead and call a method (in this case the only private method).
        private_s = myTimeLocal.getTimePrivate(s3); // throw exception if caller is not authorized
    }
    catch (Exception e) {
        private_s = e.toString();
    }

%>
<div align="center">
    <H2>MyTime Sample</H2>
    <BR><BR>
     The public time returned from the EJB: <%=s%>
    <BR><BR>
     The private time returned from the EJB: <%=private_s%>
    <BR><BR>
</div>
</body>
</html>
