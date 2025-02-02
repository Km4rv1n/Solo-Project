<%--
  Created by IntelliJ IDEA.
  User: marvinkika
  Date: 25.1.25
  Time: 11:28 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isErrorPage="true" %>

<html>
<head>
    <title>Post Details</title>
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

    <section class="w-75 border p-3 mb-4 rounded shadow-sm">
        <div class="d-flex justify-content-between">
            <h3 class="text-primary"><c:out value="${post.title}"/></h3>
            <p class="text-muted">Author: <a href="/user/${post.creator.id}" class="text-decoration-none"><c:out
                    value="${post.creator.username}"/>&nbsp;<img src="${post.creator.profilePictureUrl}"
                                                                 class="profile-icon rounded-circle me-2"
                                                                 alt="profile picture"></a></p>
        </div>

        <p><strong>Topic:</strong> <a href="/posts/search/1?searchQuery=${post.topic.name}"
                                      class="btn btn-secondary btn-sm"><c:out value="${post.topic.name}"/></a></p>
        <p class="text-muted">On <c:out value="${post.formattedCreatedAt}"/></p>

        <c:if test="${post.imageUrl != null}">
            <img src="${post.imageUrl}" class="post-image img-fluid rounded mb-3 w-100">
        </c:if>

        <p><c:out value="${post.description}"/></p>

        <div class="d-flex justify-content-between align-items-center">
            <a href="#" id="show-likes-modal" class="text-primary fw-bold text-decoration-none">
                <c:out value="${filteredListOfLikes.size()}"/> likes
            </a>

            <dialog id="likes-modal" class="p-3 rounded border-0 shadow-lg">
                <h3 class="text-center">Likes</h3>
                <ul id="list-of-likes" class="list-unstyled overflow-auto">
                    <c:choose>
                        <c:when test="${filteredListOfLikes.size() != 0}">
                            <c:forEach var="user" items="${filteredListOfLikes}">
                                <li class="d-flex align-items-center mb-2">
                                    <a href="/user/${user.id}" class="text-decoration-none d-flex align-items-center">
                                        <img src="${user.profilePictureUrl}" class="profile-icon rounded-circle me-2">
                                        <span><c:out value="${user.username}"/></span>
                                    </a>
                                </li>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted text-center">No likes yet!</p>
                        </c:otherwise>
                    </c:choose>
                </ul>

                <form method="dialog" class="text-center">
                    <input type="submit" value="Back" class="btn btn-secondary">
                </form>
            </dialog>
        </div>

        <div class="mt-3">
            <c:choose>
                <c:when test="${!post.likedBy.contains(currentUser)}">
                    <form method="post" action="/posts/like/${post.id}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="submit" value="Like" class="btn btn-primary btn-sm">
                    </form>
                </c:when>
                <c:otherwise>
                    <form method="post" action="/posts/unlike/${post.id}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="hidden" name="_method" value="delete">
                        <input type="submit" value="Unlike" class="btn btn-outline-danger btn-sm">
                    </form>
                </c:otherwise>
            </c:choose>
        </div>


        <section class="comments-section border rounded p-3 bg-light my-5">
            <h4>Comments (<c:out value="${filteredListOfComments.size()}"/>)</h4>

            <section class="all-comments overflow-auto" style="max-height: 400px;">
                <c:choose>
                    <c:when test="${post.comments.size() != 0}">
                        <c:forEach var="comment" items="${filteredListOfComments}">
                            <div class="border-bottom p-2">
                                    <a href="/user/${comment.author.id}" class="d-flex align-items-center mb-2 text-decoration-none">
                                        <img src="${comment.author.profilePictureUrl}"
                                             class="profile-icon rounded-circle me-2" width="40" height="40" alt="profile-picture">
                                        <h5 class="mb-0"><c:out value="${comment.author.username}"/></h5>
                                    </a>
                                <p class="text-muted small">On: <c:out value="${comment.formattedCreatedAt}"/></p>
                                <p class="mb-2"><c:out value="${comment.content}"/></p>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted">No comments yet!</p>
                    </c:otherwise>
                </c:choose>
            </section>

            <form:form method="post" action="/posts/comment/${post.id}" modelAttribute="comment" class="mt-3">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="mb-3">
                    <form:label path="content" class="form-label fw-bold">Write a comment:</form:label>
                    <form:textarea path="content" rows="5" class="form-control"/>
                    <i><small class="form-text text-danger"><form:errors path="content"/></small></i>
                </div>
                <input type="submit" value="Send" class="btn btn-primary">
            </form:form>
        </section>

    </section>
</section>
</section>
<footer class="bg-primary text-white text-center p-3">
    <span>&copy; <span id="currentYear"></span> BlogHub. All rights reserved.</span>
</footer>
<script src="/js/index.js"></script>
</body>
</html>
