<%--
  Created by IntelliJ IDEA.
  User: marvinkika
  Date: 24.1.25
  Time: 9:47 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isErrorPage="true" %>

<html>
<head>
    <title>Search</title>
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
                       name="searchQuery" value="${searchQuery}">
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

<h2 class="text-center">Search results for: <c:out value="${searchQuery}"/></h2>

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

    <section class="w-50 mx-auto mb-4">
        <c:choose>
            <c:when test="${posts.content.size() != 0}">
                <c:forEach var="post" items="${posts.content}">
                    <div class="border p-3 mb-4 rounded shadow-sm">
                        <div class="d-flex justify-content-between">
                            <h3 class="text-primary"><c:out value="${post.title}"/></h3>
                            <p class="text-muted">Author: <a href="/user/${post.creator.id}"
                                                             class="text-decoration-none"><c:out
                                    value="${post.creator.username}"/>&nbsp;<img src="${post.creator.profilePictureUrl}"
                                                                                 class="profile-icon rounded-circle me-2"
                                                                                 alt="profile picture"></a></p>
                        </div>


                        <p><strong>Topic:</strong> <a href="/posts/search/1?searchQuery=${post.topic.name}"
                                                      class="btn btn-secondary btn-sm"><c:out
                                value="${post.topic.name}"/></a></p>
                        <p class="text-muted">On <c:out value="${post.formattedCreatedAt}"/></p>
                        <c:if test="${post.imageUrl != null}">
                            <img src="${post.imageUrl}" class="post-image img-fluid rounded mb-3 w-100"
                                 alt="Post image">
                        </c:if>
                        <p>
                            <c:choose>
                                <c:when test="${fn:length(post.description) > 100}">
                                    <c:out value="${fn:substring(post.description, 0, 100)}"/>...
                                </c:when>
                                <c:otherwise>
                                    <c:out value="${post.description}"/>
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <div class="d-flex justify-content-between align-items-center">
                            <p class="mb-0"><strong><c:out value="${filteredLikesCount[post.id]}"/> likes</strong></p>
                            <p class="mb-0"><strong><c:out value="${filteredCommentsCount[post.id]}"/> comments</strong>
                            </p>
                            <a href="/posts/view/${post.id}" class="btn btn-outline-primary btn-sm">Continue Reading
                                &gt;&gt;</a>
                        </div>
                    </div>
                </c:forEach>

                <ul class="pagination justify-content-center">
                    <c:forEach begin="1" end="${totalPages}" var="index">
                        <li class="page-item">
                            <a class="page-link nav-link"
                               href="/posts/search/${index}?searchQuery=${searchQuery}">${index}</a>
                        </li>
                    </c:forEach>
                </ul>
            </c:when>
            <c:otherwise>
                <p>No posts found!</p>
            </c:otherwise>
        </c:choose>
    </section>

    <c:if test="${popularTopics.size() != 0}">
        <details open>
            <summary class="topic-summary bg-primary text-white p-2 rounded-top text-center fw-bold">Popular Topics
            </summary>
            <ul class="topic-list list-unstyled">
                <c:forEach var="topic" items="${popularTopics}">
                    <li class="border p-2 text-center">
                        <a href="/posts/search/1?searchQuery=${topic.name}"><c:out value="${topic.name}"/></a>
                    </li>
                </c:forEach>
            </ul>
        </details>
    </c:if>
</section>

<footer class="bg-primary text-white text-center p-3">
    <span>&copy; <span id="currentYear"></span> BlogHub. All rights reserved.</span>
</footer>
<script src="/js/index.js"></script>
</body>
</html>
