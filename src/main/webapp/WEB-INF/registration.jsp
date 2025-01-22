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
    <title>Registration</title>
</head>
<body>
<fieldset>
  <legend>Create an Account</legend>
  <p><form:errors path="user.*"/></p>

  <form:form method="POST" action="/register" modelAttribute="user">
    <p>
      <form:label path="firstName">First Name:</form:label>
      <form:input path="firstName"/>
    </p>
    <p>
      <form:label path="lastName">Last Name:</form:label>
      <form:input path="lastName"/>
    </p>
    <p>
      <form:label path="username">Username:</form:label>
      <form:input path="username"/>
    </p>
    <p>
      <form:label path="email">Email:</form:label>
      <form:input path="email"/>
    </p>
    <p>
      <form:label path="password">Password:</form:label>
      <form:password path="password"/>
    </p>
    <p>
      <form:label path="passwordConfirmation">Password Confirmation:</form:label>
      <form:password path="passwordConfirmation"/>
    </p>
    <input type="submit" value="Register"/>
  </form:form>
  <a href="/login">Already have an account? <strong>Log In.</strong></a>
</fieldset>
</body>
</html>
