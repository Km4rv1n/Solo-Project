<%--
  Created by IntelliJ IDEA.
  User: marvinkika
  Date: 25.1.25
  Time: 9:23 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isErrorPage="true" %>

<html>
<head>
    <title>Admin Dashboard</title>
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

    <table border="1">
        <caption><strong>Manage Users</strong></caption>
        <thead>
            <tr>
                <th>Username</th>
                <th>Email</th>
                <th>Role</th>
                <th>Banned</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${users.content.size() != 0}">
                    <c:forEach var="user" items="${users.content}">
                        <tr>
                            <td><a href="/user/${user.id}"><c:out value="${user.username}"/></a></td>
                            <td><c:out value="${user.email}"/></td>
                            <td>
                                <c:if test="${user.role == 'ROLE_USER'}">
                                    <c:out value="User"/>
                                </c:if>
                                <c:if test="${user.role == 'ROLE_ADMIN'}">
                                    <c:out value="Admin"/>
                                </c:if>
                            </td>
                            <td><c:out value="${user.banned}"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.banned == false}">
                                        <form method="post" action="/admin/ban/${user.id}">
                                            <input type="hidden" name="_method" value="put">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <input type="submit" value="Ban">
                                        </form>
                                        <c:if test="${user.role == 'ROLE_USER'}">
                                            <form method="post" action="/admin/promote/${user.id}">
                                                <input type="hidden" name="_method" value="put">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <input type="submit" value="Promote to Admin">
                                            </form>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <form method="post" action="/admin/unban/${user.id}">
                                            <input type="hidden" name="_method" value="put">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <input type="submit" value="Unban">
                                        </form>
                                    </c:otherwise>
                                </c:choose>

                            </td>
                        </tr>
                    </c:forEach>
                    <c:forEach begin="1" end="${totalPages}" var="index">
                        <a href="/admin/dashboard/${index}">${index}</a>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5">No users found!</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</section>

<footer>
    <span>&copy; <span id="currentYear"></span> BlogHub. All rights reserved.</span>
</footer>
<script src="/js/index.js"></script>
</body>
</html>
