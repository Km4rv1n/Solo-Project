<%--
  Created by IntelliJ IDEA.
  User: marvinkika
  Date: 21.1.25
  Time: 9:34 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isErrorPage="true" %>

<html>
<head>
    <title>Registration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link type="text/css" rel="stylesheet" href="/css/styles.css">
</head>
<body class="bg-light">

<div class="container d-flex justify-content-center align-items-center mt-5" style="height: 85vh;">
    <div class="card shadow-lg p-4" style="width: 100%; max-width: 600px;">
        <fieldset class="border p-4 rounded">
            <legend class="w-auto float-none text-center ps-3 pe-3">Create an Account</legend>
            <form:form method="POST" action="/register" modelAttribute="user">
                <div class="form-floating mb-3">
                    <form:input path="firstName" class="form-control" id="first-name" placeholder="First Name"/>
                    <label for="first-name">First Name</label>
                    <i><small class="form-text text-danger"><form:errors path="firstName"/></small></i>
                </div>
                <div class="form-floating mb-3">
                    <form:input path="lastName" class="form-control" id="last-name" placeholder="Last Name"/>
                    <label for="last-name">Last Name</label>
                    <i><small class="form-text text-danger"><form:errors path="lastName"/></small></i>
                </div>
                <div class="form-floating mb-3">
                    <form:input path="username" id="username" class="form-control" placeholder="Username"/>
                    <label for="username">Username</label>
                    <i><small class="form-text text-danger"><form:errors path="username"/></small></i>
                </div>
                <div class="form-floating mb-3">
                    <form:input path="email" class="form-control" id="email" placeholder="Email"/>
                    <label for="email">Email</label>
                    <i><small class="form-text text-danger"><form:errors path="email"/></small></i>
                </div>
                <div class="form-floating mb-3">
                    <form:password path="password" class="form-control" id="password" placeholder="Password"/>
                    <label for="password">Password</label>
                    <i><small class="form-text text-danger"><form:errors path="password"/></small></i>
                </div>
                <div class="form-floating mb-3">
                    <form:password path="passwordConfirmation" class="form-control" id="password-confirm"
                                   placeholder="Password Confirmation"/>
                    <label for="password-confirm">Password Confirmation</label>
                    <i><small class="form-text text-danger"><form:errors path="passwordConfirmation"/></small></i>
                </div>
                <input type="submit" value="Register" class="btn btn-primary w-100"/>
            </form:form>
            <div class="text-center mt-2">
                <a href="/login">Already have an account? <strong>Log In.</strong></a>
            </div>
        </fieldset>
    </div>

</div>

<footer class="bg-primary text-white text-center p-3">
    <span>&copy; <span id="currentYear"></span> BlogHub. All rights reserved.</span>
</footer>
<script src="/js/index.js"></script>
</body>
</html>
