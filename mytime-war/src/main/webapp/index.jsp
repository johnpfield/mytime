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
    try {
        // This creates a context, it can be used to lookup EJBs. Using normal RMI you would
        // have to know port number and stuff. The InitialContext holds info like
        // server names, ports and stuff I guess.
        Context context = new InitialContext();
        // MyTimeLocalHome is a reference to the EJB
        MyTimeLocal myTimeLocal = (MyTimeLocal) context.lookup("java:comp/env/ejb/MyTimeBean");
        // So, just go ahead and call a method (in this case the only method).
        s = myTimeLocal.getTime();
    }
    catch (Exception e) {
        s = e.toString();
    }
%>
<div align="center">
    <H2>MyTime Sample</H2>
    <BR><BR>
     This is the time returned from the EJB: <%=s%>
    <BR><BR>
</div>
</body>
</html>
