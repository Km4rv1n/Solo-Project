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
            <li><a href="/user/blocked">Blocked Users</a></li>
        </ul>
    </details>

    <section>
        <h3>My Posts</h3>

        <ul>
            <c:forEach var="post" items="${userPosts.content}">
                <li>
                    <h4><c:out value="${post.title}"/></h4>
                    <p>Date added: <c:out value="${post.formattedCreatedAt}"/></p>
                    <p>Likes: <c:out value="${post.likedBy.size()}"/></p>
                    <p>Comments: <c:out value="${post.comments.size()}"/></p>

                    <a href="/posts/edit/${post.id}">Edit</a>

                    <form method="post" action="/posts/delete/${post.id}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="hidden" name="_method" value="delete">
                        <input type="submit" value="Delete">
                    </form>
                </li>
            </c:forEach>
        </ul>

        <c:forEach begin="1" end="${totalPages}" var="index">
            <a href="/posts/logged-user/${index}">${index}</a>
        </c:forEach>
    </section>

</section>
<footer>
    <span>&copy; <span id="currentYear"></span> BlogHub. All rights reserved.</span>
</footer>
<script src="/js/index.js"></script>
</body>
</html>
