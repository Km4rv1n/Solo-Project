<%--
  Created by IntelliJ IDEA.
  User: marvinkika
  Date: 21.1.25
  Time: 9:35 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isErrorPage="true" %>

<html>
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
        <h2>All Posts</h2>
        <c:choose>
            <c:when test="${posts.content.size() != 0}">
                <c:forEach var="post" items="${posts.content}">
                    <div>
                        <h3><c:out value="${post.title}"/></h3>
                        <p>Topic: <c:out value="${post.topic.name}"/></p>
                        <p><a href="/user/${post.creator.id}"><c:out value="${post.creator.username}"/>&nbsp;<img
                                src="${post.creator.profilePictureUrl}" class="profile-icon"></a></p>
                        <p><c:out value="${post.formattedCreatedAt}"/></p>
                        <c:if test="${post.imageUrl != null}">
                            <img src="${post.imageUrl}" class="post-image">
                        </c:if>
                        <p>
                            <c:choose>
                                <c:when test="${fn:length(post.description) > 50}">
                                    <c:out value="${fn:substring(post.description, 0, 50)}"/>...
                                </c:when>
                                <c:otherwise>
                                    <c:out value="${post.description}"/>
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <div>
                            <p><c:out value="${post.likedBy.size()}"/> likes</p>
                            <p><c:out value="${post.comments.size()}"/> comments</p>
                            <a href="/posts/view/${post.id}">View Full Post</a>
                        </div>

                    </div>
                </c:forEach>

                <c:forEach begin="1" end="${totalPages}" var="index">
                    <a href="/user/home/${index}">${index}</a>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p>No posts found!</p>
            </c:otherwise>
        </c:choose>
    </section>

    <c:if test="${popularTopics.size() != 0}">
        <details open>
            <summary>Popular Topics</summary>
            <ul>
                <c:forEach var="topic" items="${popularTopics}">
                    <li>
                        <a href="/posts/search/1?searchQuery=${topic.name}"><c:out value="${topic.name}"/>
                        &nbsp;<span>(<c:out value="${topic.posts.size()}"/>)</span>
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </details>
    </c:if>


</section>

<footer>
    <span>&copy; <span id="currentYear"></span> BlogHub. All rights reserved.</span>
</footer>
<script src="/js/index.js"></script>
</body>
</html>
