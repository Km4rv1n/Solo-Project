<%--
  Created by IntelliJ IDEA.
  User: marvinkika
  Date: 30.1.25
  Time: 10:57 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Error Page</title>
</head>
<body>
    <h1><c:out value="${message}"/></h1>
    <a href="/user/home/1">Return to dashboard</a>
</body>
</html>
