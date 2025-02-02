<%--
  Created by IntelliJ IDEA.
  User: marvinkika
  Date: 23.1.25
  Time: 6:48 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isErrorPage="true" %>

<html>
<head>
    <title>My Posts</title>
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

    <section class="w-75 container p-3 border rounded">
        <h2 class="mb-3 text-center">My Posts</h2>

        <c:if test="${not empty message}">
            <p class="alert alert-success"><c:out value="${message}"/></p>
        </c:if>

        <c:choose>
            <c:when test="${userPosts.content.size() != 0}">
                <ul class="list-group">
                    <c:forEach var="post" items="${userPosts.content}">
                        <li class="list-group-item d-flex flex-column gap-2">
                            <h4 class="mb-1 text-primary"><c:out value="${post.title}"/></h4>
                            <p class="text-muted mb-1">Topic: <c:out value="${post.topic.name}"/></p>
                            <p class="text-muted mb-1">Date added: <c:out value="${post.formattedCreatedAt}"/></p>
                            <p class="text-muted mb-1">Likes: <c:out value="${post.likedBy.size()}"/> | Comments: <c:out
                                    value="${post.comments.size()}"/></p>

                            <div class="d-flex gap-2">
                                <a href="/posts/edit/${post.id}" class="btn btn-primary btn-sm">Edit</a>
                                <button class="btn btn-danger btn-sm"
                                        onclick="document.getElementById('modal-${post.id}').showModal()">Delete
                                </button>
                            </div>

                            <dialog id="modal-${post.id}" class="p-3 rounded border-0 shadow-lg">
                                <h2 class="mb-3 text-primary">Are you sure you want to delete this post?</h2>
                                <h4 class="text-danger"><c:out value="${post.title}"/></h4>
                                <p class="text-muted">Date added: <c:out value="${post.formattedCreatedAt}"/></p>
                                <p class="text-muted">Likes: <c:out value="${post.likedBy.size()}"/> | Comments: <c:out
                                        value="${post.comments.size()}"/></p>

                                <div class="d-flex gap-3 mt-3">
                                    <form method="dialog">
                                        <button type="submit" class="btn btn-secondary">Cancel</button>
                                    </form>
                                    <form method="post" action="/posts/delete/${post.id}?currentPage=${currentPage}">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <input type="hidden" name="_method" value="delete">
                                        <button type="submit" class="btn btn-danger">Delete</button>
                                    </form>
                                </div>
                            </dialog>
                        </li>
                    </c:forEach>
                </ul>

                <ul class="pagination justify-content-center mt-4">
                    <c:forEach begin="1" end="${totalPages}" var="index">
                        <li class="page-item">
                            <a href="/posts/logged-user/${index}" class="page-link nav-link">${index}</a>
                        </li>
                    </c:forEach>
                </ul>

            </c:when>
            <c:otherwise>
                <p class="text-center text-muted">No posts found.</p>
            </c:otherwise>
        </c:choose>
    </section>


</section>
<footer class="bg-primary text-white text-center p-3">
    <span>&copy; <span id="currentYear"></span> BlogHub. All rights reserved.</span>
</footer>

<script src="/js/index.js"></script>
</body>
</html>
