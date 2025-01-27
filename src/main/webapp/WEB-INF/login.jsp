<%--
  Created by IntelliJ IDEA.
  User: marvinkika
  Date: 21.1.25
  Time: 9:34 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core"%>
<%@ page isErrorPage="true" %>

<html>
<head>
    <title>Login</title>
</head>
<body>
    <c:if test="${logoutMessage != null}">
        <c:out value="${logoutMessage}"/>
    </c:if>

    <c:if test="${successMessage != null}">
        <c:out value="${successMessage}"/>
    </c:if>

    <fieldset>
        <legend>Login</legend>
        <c:if test="${errorMessage != null}">
            <c:out value="${errorMessage}"/>
        </c:if>

        <c:if test="${bannedMessage != null}">
            <c:out value="${bannedMessage}"/>
        </c:if>
        <form method="POST" action="/login">
            <p>
                <label for="username">Email:</label>
                <input type="text" id="username" name="username"/>
            </p>
            <p>
                <label for="password">Password:</label>
                <input type="password" id="password" name="password"/>
            </p>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="submit" value="Login!"/>
        </form>
        <a href="/register">Don't have an account? <strong>Register.</strong></a>
    </fieldset>

    <footer>
        <span>&copy; <span id="currentYear"></span> BlogHub. All rights reserved.</span>
    </footer>
    <script src="/js/index.js"></script>
</body>
</html>
