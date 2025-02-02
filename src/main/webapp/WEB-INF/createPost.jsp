<%--
  Created by IntelliJ IDEA.
  User: marvinkika
  Date: 22.1.25
  Time: 8:37 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isErrorPage="true" %>

<html>
<html>
<head>
    <title>New Post</title>
    <link type="text/css" rel="stylesheet" href="/css/styles.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-primary border-bottom px-5 py-3 mb-5 text-white">
    <ul class="navbar-nav w-100 d-flex justify-content-between align-items-center">
        <li class="nav-item">
            <h1 class="navbar-brand mb-0 fs-3 text-white">BlogHub<small class="fw-light">&trade;</small></h1>
        </li>
        <li class="nav-item">
            <form method="get" action="/posts/search/1" class="d-flex">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <input type="search" class="form-control me-2" placeholder="Search by Topic, Author or Title..."
                       name="searchQuery">
                <button type="submit" class="btn btn-dark">Search</button>
            </form>
        </li>
        <li class="nav-item">
            <label for="languageSelect" class="me-1">Translate to: </label>
            <select id="languageSelect" class="form-select form-select-sm d-inline w-auto">
                <option value="sq">🇦🇱&emsp;Albanian</option>
                <option value="en">🇺🇸&emsp;English</option>
                <option value="fr">🇫🇷&emsp;French</option>
                <option value="de">🇩🇪&emsp;German</option>
                <option value="es">🇪🇸&emsp;Spanish</option>
            </select>
        </li>
        <li class="nav-item">
            <a href="/user/personal-profile" class="d-flex align-items-center text-decoration-none text-dark">
                <img src="${currentUser.profilePictureUrl}" class="rounded-circle me-2" alt="profile-picture" width="40"
                     height="40">
                <span class="text-white"><c:out value="${currentUser.username}"/></span>
            </a>
        </li>
        <li class="nav-item">
            <form method="post" action="/logout">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <input type="submit" class="btn btn-danger btn-sm text-white" value="Log out">
            </form>
        </li>
    </ul>
</nav>

<section class="d-flex justify-content-evenly px-5">
    <details open>
        <summary class="menu-summary bg-primary text-white p-2 rounded-top text-center fw-bold">Menu</summary>
        <ul class="menu-list list-unstyled">
            <li class="border p-2 text-center"><a href="/user/home/1">Home</a></li>
            <li class="border p-2 text-center"><a href="/posts/new">Create a Post</a></li>
            <li class="border p-2 text-center"><a href="/user/blocked">Blocked Users</a>&emsp;<span
                    class="badge bg-danger"><c:out
                    value="${currentUser.blockedUsers.size()}"/></span></li>
            <li class="border p-2 text-center"><a href="/posts/logged-user/1">My Posts</a>&emsp;<span
                    class="badge bg-primary"><c:out
                    value="${currentUser.posts.size()}"/></span></li>
            <c:if test="${currentUser.role == 'ROLE_ADMIN'}">
                <li class="border p-2 text-center"><a href="/admin/dashboard/1">Admin Dashboard</a></li>
                <li class="border p-2 rounded-bottom text-center"><a href="/admin/reports/1">Reports</a></li>
            </c:if>
            <c:if test="${currentUser.role == 'ROLE_USER'}">
                <li class="border p-2 rounded-bottom text-center"><a href="/user/my-reports/1">My Reports</a></li>
            </c:if>
        </ul>
    </details>

    <div class="card shadow-lg p-4  w-75 ">
        <fieldset class="border p-4 rounded">
            <legend class="w-auto float-none text-center ps-3 pe-3">Create a Post</legend>
            <form:form method="post" action="/posts/new" modelAttribute="blogPost" enctype="multipart/form-data">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <div class="form-floating mb-3">
                    <form:input class="form-control" path="title" id="title" placeholder="Title"/>
                    <label for="title">Title</label>
                    <i><small class="form-text text-danger"><form:errors path="title"/></small></i>
                </div>

                <div class="form-floating mb-3">
                    <form:input id="topic" class="form-control" path="topic.name" list="listOfTopics"
                                placeholder="Topic" autocomplete="false"/>
                    <label for="topic">Topic</label>
                    <i><small class="form-text text-danger"><form:errors path="topic.name"/></small></i>
                    <datalist id="listOfTopics">
                        <c:forEach var="existingTopic" items="${allTopics}">
                            <option><c:out value="${existingTopic.name}"/></option>
                        </c:forEach>
                    </datalist>
                </div>
                <div class="mb-3">
                    <label for="img-file" class="form-label">Image (optional)</label>
                    <input id="img-file" type="file" class="form-control w-50" name="postImageFile"
                           accept="image/png, image/jpeg, image/jpg">
                </div>
                <div class="form-floating mb-3">
                    <form:textarea id="description" class="form-control" rows="5" path="description"
                                   placeholder="Description"/>
                    <label for="description">Description</label>
                    <i><small class="form-text text-danger"><form:errors path="description"/></small></i>
                </div>
                <input type="submit" value="Submit" class="btn w-100 btn-primary">
            </form:form>
        </fieldset>
    </div>
</section>

<footer class="bg-primary text-white text-center p-3">
    <span>&copy; <span id="currentYear"></span> BlogHub. All rights reserved.</span>
</footer>

<script src="/js/index.js"></script>
</body>
</html>


<%--<div class="container d-flex justify-content-center align-items-center mt-5" style="height: 85vh;">--%>
<%--    <div class="card shadow-lg p-4" style="width: 100%; max-width: 600px;">--%>
<%--        <fieldset class="border p-4 rounded">--%>
<%--            <legend class="w-auto float-none text-center ps-3 pe-3">Create an Account</legend>--%>
<%--            <form:form method="POST" action="/register" modelAttribute="user">--%>
<%--                <div class="form-floating mb-3">--%>
<%--                    <form:input path="firstName" class="form-control" id="first-name" placeholder="First Name"/>--%>
<%--                    <label for="first-name">First Name</label>--%>
<%--                    <i><small class="form-text text-danger"><form:errors path="firstName"/></small></i>--%>
<%--                </div>--%>
<%--                <div class="form-floating mb-3">--%>
<%--                    <form:input path="lastName" class="form-control" id="last-name" placeholder="Last Name"/>--%>
<%--                    <label for="last-name">Last Name</label>--%>
<%--                    <i><small class="form-text text-danger"><form:errors path="lastName"/></small></i>--%>
<%--                </div>--%>
<%--                <div class="form-floating mb-3">--%>
<%--                    <form:input path="username" id="username" class="form-control" placeholder="Username"/>--%>
<%--                    <label for="username">Username</label>--%>
<%--                    <i><small class="form-text text-danger"><form:errors path="username"/></small></i>--%>
<%--                </div>--%>
<%--                <div class="form-floating mb-3">--%>
<%--                    <form:input path="email" class="form-control" id="email" placeholder="Email"/>--%>
<%--                    <label for="email">Email</label>--%>
<%--                    <i><small class="form-text text-danger"><form:errors path="email"/></small></i>--%>
<%--                </div>--%>
<%--                <div class="form-floating mb-3">--%>
<%--                    <form:password path="password" class="form-control" id="password" placeholder="Password"/>--%>
<%--                    <label for="password">Password</label>--%>
<%--                    <i><small class="form-text text-danger"><form:errors path="password"/></small></i>--%>
<%--                </div>--%>
<%--                <div class="form-floating mb-3">--%>
<%--                    <form:password path="passwordConfirmation" class="form-control" id="password-confirm" placeholder="Password Confirmation"/>--%>
<%--                    <label for="password-confirm">Password Confirmation</label>--%>
<%--                    <i><small class="form-text text-danger"><form:errors path="passwordConfirmation"/></small></i>--%>
<%--                </div>--%>
<%--                <input type="submit" value="Register" class="btn btn-primary w-100"/>--%>
<%--            </form:form>--%>
<%--            <div class="text-center">--%>
<%--                <a href="/login">Already have an account? <strong>Log In.</strong></a>--%>
<%--            </div>--%>
<%--        </fieldset>--%>
<%--    </div>--%>

<%--</div>--%>