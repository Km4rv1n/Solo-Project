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
        </ul>
    </details>
    <section>
        <h3><c:out value="${post.title}"/></h3>
        <p>Topic: <c:out value="${post.topic.name}"/></p>
        <p><a href="/user/${post.creator.id}"><c:out value="${post.creator.username}"/>&nbsp;<img
                src="${post.creator.profilePictureUrl}" class="profile-icon"></a></p>
        <p><c:out value="${post.formattedCreatedAt}"/></p>
        <c:if test="${post.imageUrl != null}">
            <img src="${post.imageUrl}" class="post-image">
        </c:if>
        <p><c:out value="${post.description}"/></p>
        <div>
            <p>
                <a href="#" id="show-likes-modal"><c:out value="${post.likedBy.size()}"/> likes</a>

                <dialog id="likes-modal">
                    <h3>Likes</h3>
                    <ul id="list-of-likes">
                        <c:forEach var="user" items="${post.likedBy}">
                            <li>
                                <a href="/user/${user.id}">
                                    <img src="${user.profilePictureUrl}" class="profile-icon">
                                    <span><c:out value="${user.username}"/></span>
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                    <form method="dialog">
                        <input type="submit" value="Back">
                    </form>
                </dialog>

                <c:choose>
                <c:when test="${!post.likedBy.contains(currentUser)}">
            <form method="post" action="/posts/like/${post.id}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <input type="submit" value="Like">
            </form>
            </c:when>
            <c:otherwise>
                <form method="post" action="/posts/unlike/${post.id}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="_method" value="delete">
                    <input type="submit" value="Unlike">
                </form>
            </c:otherwise>
            </c:choose>
        </div>


        <section class="comments-section">
            <h4>Comments (<c:out value="${post.comments.size()}"/>)</h4>
            <section class="all-comments">
                <c:choose>
                    <c:when test="${post.comments.size() != 0}">
                        <c:forEach var="comment" items="${post.comments}">
                            <div>
                                <img src="${comment.author.profilePictureUrl}" class="profile-icon">
                                <h4><c:out value="${comment.author.username}"/></h4>
                                <p>On: <c:out value="${comment.formattedCreatedAt}"/></p>
                                <p><c:out value="${comment.content}"/></p>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p>No comments yet!</p>
                    </c:otherwise>
                </c:choose>
            </section>

            <form:form method="post" action="/posts/comment/${post.id}" modelAttribute="comment">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <form:errors path="content"/>
                <form:label path="content">Write a comment:</form:label>
                <form:input path="content"/>
                <input type="submit" value="Send">
            </form:form>
        </section>
    </section>
</section>
<footer>
    <span>&copy; <span id="currentYear"></span> BlogHub. All rights reserved.</span>
</footer>
<script src="/js/index.js"></script>
</body>
</html>
