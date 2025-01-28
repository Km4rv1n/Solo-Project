<%--
  Created by IntelliJ IDEA.
  User: marvinkika
  Date: 23.1.25
  Time: 6:22 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isErrorPage="true" %>

<html>
<head>
    <title>BlockedUsers</title>
</head>
<head>
    <title>Home</title>
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

    <div>
        <label for="languageSelect">Translate to: </label>
        <select id="languageSelect">
            <option value="sq">🇦🇱&emsp;Albanian</option>
            <option value="en">🇺🇸&emsp;English</option>
            <option value="fr">🇫🇷&emsp;French</option>
            <option value="de">🇩🇪&emsp;German</option>
            <option value="es">🇪🇸&emsp;Spanish</option>
        </select>
    </div>

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
            <li><a href="/user/blocked">Blocked Users</a>&nbsp;<span><c:out
                    value="${currentUser.blockedUsers.size()}"/></span></li>
            <li><a href="/posts/logged-user/1">My Posts</a>&nbsp;<span><c:out
                    value="${currentUser.posts.size()}"/></span></li>
            <c:if test="${currentUser.role == 'ROLE_ADMIN'}">
                <li><a href="/admin/dashboard/1">Admin Dashboard</a></li>
                <li><a href="/admin/reports/1">Reports</a></li>
            </c:if>
            <c:if test="${currentUser.role == 'ROLE_USER'}">
                <li><a href="/user/my-reports/1">My Reports</a></li>
            </c:if>
        </ul>
    </details>

    <section class="blocked-users-section">
        <h2>Blocked Users</h2>
        <c:choose>
            <c:when test="${blockedUsers.size() != 0}">
                <c:forEach var="blockedUser" items="${blockedUsers}">
                    <div>
                        <img src="${blockedUser.profilePictureUrl}" class="profile-icon">
                        <h3><c:out value="${blockedUser.username}"/></h3>

                        <c:if test="${blockedUser.lastSeen != null}">
                            <p>Last seen: <c:out value="${blockedUser.formattedLastSeen}"/></p>
                        </c:if>

                        <form method="post" action="/user/unblock/${blockedUser.id}">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="_method" value="delete">
                            <input type="submit" value="Unblock">
                        </form>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p>No blocked users found.</p>
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
