<%--
  Created by IntelliJ IDEA.
  User: marvinkika
  Date: 27.1.25
  Time: 10:40 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <title>All Reports</title>
</head>
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
        <caption><strong>All Reports</strong></caption>
        <thead>
            <tr>
                <th>Reporter</th>
                <th>Reported User</th>
                <th>Report Date</th>
                <th>Reason</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>

        <tbody>
            <c:choose>
                <c:when test="${reports.content.size() != 0}">
                    <c:forEach var="report" items="${reports.content}">
                        <tr>
                            <td><a href="/user/${report.reporter.id}"><c:out value="${report.reporter.username}"/></a></td>
                            <td>
                                <c:choose>
                                    <c:when test="${report.reportedUser.banned}">
                                        <c:out value="${report.reportedUser.username}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="/user/${report.reportedUser.id}"><c:out value="${report.reportedUser.username}"/></a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><c:out value="${report.formattedReportDate}"/></td>
                            <td><c:out value="${report.reason}"/></td>
                            <td><c:set var="statusString" value="${report.status.toString()}" />
                                <p>${fn:replace(statusString, 'STATUS_', '')}</p></td>
                            <td><c:choose>
                                <c:when test="${report.status == 'STATUS_PENDING'}">
                                    <form method="post" action="/admin/reports/accept/${report.id}?currentPage=${currentPage}">
                                        <input type="hidden" name="_method" value="put">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <input type="submit" value="Ban Reported User">
                                    </form>

                                    <form method="post" action="/admin/reports/reject/${report.id}?currentPage=${currentPage}">
                                        <input type="hidden" name="_method" value="put">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <input type="submit" value="Reject Report">
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <c:out value="No actions available."/>
                                </c:otherwise>
                            </c:choose></td>
                        </tr>
                    </c:forEach>
                    <c:forEach begin="1" end="${totalPages}" var="index">
                         <a href="/admin/reports/${index}">${index}</a>
                    </c:forEach>
                </c:when>

                <c:otherwise>
                    <tr>
                        <td colspan="6">No reports found!</td>
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


