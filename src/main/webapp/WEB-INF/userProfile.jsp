<%--
  Created by IntelliJ IDEA.
  User: marvinkika
  Date: 23.1.25
  Time: 12:54 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isErrorPage="true" %>

<html>
<head>
    <title>View User</title>
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

<section class="d-flex justify-content-between px-5">
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

    <section class="container p-4 border rounded shadow-sm bg-light text-center w-50">
        <img src="${user.profilePictureUrl}" class="profile-picture rounded-circle img-fluid mb-3">
        <h3 class="fw-bold"><c:out value="${user.username}"/></h3>
        <p class="text-muted"><c:out value="${user.firstName}"/>&nbsp;<c:out value="${user.lastName}"/></p>
        <p class="text-secondary"><c:out value="${user.email}"/></p>
        <p class="small">Date joined: <c:out value="${user.createdAt}"/></p>

        <c:if test="${user.lastSeen != null}">
            <p class="small text-muted">Last seen: <c:out value="${user.formattedLastSeen}"/></p>
        </c:if>

        <form method="post" action="/user/block/${user.id}" class="d-inline">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="btn btn-danger">Block</button>
        </form>

        <c:if test="${currentUser.role == 'ROLE_USER'}">
            <a href="/user/report/${user.id}" class="btn btn-warning ms-2">Report User</a>
        </c:if>

        <c:if test="${currentUser.role == 'ROLE_ADMIN'}">
            <form method="post" action="/admin/ban/${user.id}?currentPage=1" class="d-inline">
                <input type="hidden" name="_method" value="put">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="submit" class="btn btn-danger ms-2">Ban</button>
            </form>
        </c:if>
    </section>
</section>

<footer class="bg-primary text-white text-center p-3">
    <span>&copy; <span id="currentYear"></span> BlogHub. All rights reserved.</span>
</footer>
<script src="/js/index.js"></script>
</body>
</html>
