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

<h2 class="text-center">All Reports</h2>

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

    <div class="table-responsive w-75">
        <table class="table table-hover table-bordered">
            <thead class="table-primary">
            <tr>
                <th class="bg-primary text-white px-2 py-2 text-center">Reporter</th>
                <th class="bg-primary text-white px-2 py-2 text-center">Reported User</th>
                <th class="bg-primary text-white px-2 py-2 text-center">Report Date</th>
                <th class="bg-primary text-white px-2 py-2 text-center">Reason</th>
                <th class="bg-primary text-white px-2 py-2 text-center">Status</th>
                <th class="bg-primary text-white px-2 py-2 text-center">Actions</th>
            </tr>
            </thead>

            <tbody>
            <c:choose>
                <c:when test="${reports.content.size() != 0}">
                    <c:forEach var="report" items="${reports.content}">
                        <tr>
                            <td class=" fw-bold"><a class="text-decoration-none"
                                                    href="/user/${report.reporter.id}"><c:out
                                    value="${report.reporter.username}"/></a>
                            </td>
                            <td class="fw-bold">
                                <c:choose>
                                    <c:when test="${report.reportedUser.banned}">
                                        <div class="text-muted"><c:out value="${report.reportedUser.username}"/></div>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="text-decoration-none" href="/user/${report.reportedUser.id}"><c:out
                                                value="${report.reportedUser.username}"/></a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="text-muted"><c:out value="${report.formattedReportDate}"/></div>
                            </td>
                            <td><c:out value="${report.reason}"/></td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${report.status == 'STATUS_ACCEPTED'}">
                                        <div class="badge bg-success">ACCEPTED</div>
                                    </c:when>
                                    <c:when test="${report.status == 'STATUS_REJECTED'}">
                                        <div class="badge bg-danger">REJECTED</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="badge bg-primary mt-1">PENDING</div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="d-flex align-items-center justify-content-center gap-5"><c:choose>
                                <c:when test="${report.status == 'STATUS_PENDING'}">
                                    <form method="post"
                                          action="/admin/reports/accept/${report.id}?currentPage=${currentPage}">
                                        <input type="hidden" name="_method" value="put">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <input type="submit" value="Ban Reported User" class="btn btn-danger btn-sm">
                                    </form>

                                    <form method="post"
                                          action="/admin/reports/reject/${report.id}?currentPage=${currentPage}">
                                        <input type="hidden" name="_method" value="put">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <input type="submit" value="Reject Report" class="btn btn-warning btn-sm">
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-muted"><c:out value="No actions available"/></div>
                                </c:otherwise>
                            </c:choose></td>
                        </tr>
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

        <ul class="pagination justify-content-center">
            <c:forEach begin="1" end="${totalPages}" var="index">
                <li class="page-item">
                    <a href="/admin/reports/${index}" class="page-link nav-link">${index}</a>
                </li>
            </c:forEach>
        </ul>

    </div>
</section>

<footer class="bg-primary text-white text-center p-3">
    <span>&copy; <span id="currentYear"></span> BlogHub. All rights reserved.</span>
</footer>
<script src="/js/index.js"></script>
</body>
</html>


