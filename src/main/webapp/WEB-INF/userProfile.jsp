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
</head>
<body>
<nav>
    <h1>BlogHub</h1>
    <form method="get" action="/posts/search/1">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="search" placeholder="Search by Topic, Author or Title..." name="searchQuery">
        <input type="submit" value="&#128270;">
    </form>

    <a href="/user/personal-profile">
        <img src="${currentUser.profilePictureUrl}" class="profile-icon" alt="profile-picture">
        <span><c:out value="${currentUser.username}"/></span>
    </a>

    <form method="post" action="/logout">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="submit" value="Logout">
    </form>
</nav>

<section class="middle">
    <details open>
        <summary>Menu</summary>
        <ul>
            <li><a href="/user/home/1">Home</a></li>
            <li><a href="/posts/new">Create a Post</a></li>
        </ul>
    </details>

    <section>
        <img src="${user.profilePictureUrl}" class="profile-picture">
        <h3><c:out value="${user.username}"/></h3>
        <p><c:out value="${user.firstName}"/>&nbsp;<c:out value="${user.lastName}"/></p>
        <p><c:out value="${user.email}"/></p>
        <p>Date joined: <c:out value="${user.createdAt}"/></p>
        <c:if test="${user.lastSeen != null}">
            <p>Last seen: <c:out value="${user.formattedLastSeen}"/></p>
        </c:if>

        <form method="post" action="/user/block/${user.id}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="submit" value="Block">
        </form>

        <c:choose>
            <c:when test="${currentUser.role == 'ROLE_USER'}">
                report
            </c:when>
            <c:otherwise>
                ban
            </c:otherwise>
        </c:choose>
    </section>
</section>

<footer>
    <span>&copy; <span id="currentYear"></span> BlogHub. All rights reserved.</span>
</footer>
<script src="/js/index.js"></script>
</body>
</html>
