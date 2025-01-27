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

    <section>
        <h3>My Posts</h3>

        <c:choose>
            <c:when test="${userPosts.content.size() != 0}">
                <ul>
                    <c:forEach var="post" items="${userPosts.content}">
                        <li>
                            <h4><c:out value="${post.title}"/></h4>
                            <p>Topic: <c:out value="${post.topic.name}"/></p>
                            <p>Date added: <c:out value="${post.formattedCreatedAt}"/></p>
                            <p>Likes: <c:out value="${post.likedBy.size()}"/></p>
                            <p>Comments: <c:out value="${post.comments.size()}"/></p>

                            <a href="/posts/edit/${post.id}">Edit</a>

                            <button onclick="document.getElementById('modal-${post.id}').showModal()">Delete</button>
                            <dialog id="modal-${post.id}" class="modal">
                                <h2>Are you sure you want to delete this post?</h2>
                                <h4><c:out value="${post.title}"/></h4>
                                <p>Date added: <c:out value="${post.formattedCreatedAt}"/></p>
                                <p>Likes: <c:out value="${post.likedBy.size()}"/></p>
                                <p>Comments: <c:out value="${post.comments.size()}"/></p>

                                <form method="dialog">
                                    <input type="submit" value="Cancel">
                                </form>

                                <form method="post" action="/posts/delete/${post.id}">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <input type="hidden" name="_method" value="delete">
                                    <input type="submit" value="Delete">
                                </form>
                            </dialog>
                        </li>
                    </c:forEach>
                </ul>

                <c:forEach begin="1" end="${totalPages}" var="index">
                    <a href="/posts/logged-user/${index}">${index}</a>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p>No posts found.</p>
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
