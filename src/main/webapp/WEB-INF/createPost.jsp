<%--
  Created by IntelliJ IDEA.
  User: marvinkika
  Date: 22.1.25
  Time: 8:37 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core"%>
<%@ page isErrorPage="true" %>

<html>
<html>
<head>
    <title>Home</title>
    <link type="text/css" rel="stylesheet" href="/css/styles.css">
</head>
<body>
    <nav>
        <h1>BlogHub</h1>
        <form method="get" action="">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="search" placeholder="Search by Topic, Author or Title...">
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

    <section>
        <details open>
            <summary>Menu</summary>
            <ul>
                <li><a href="/user/home/1">Home</a></li>
                <li><a href="/posts/new">Create a Post</a></li>
            </ul>
        </details>

        <fieldset>
            <legend>Create a Post</legend>
            <form:form method="post" action="/posts/new" modelAttribute="blogPost" enctype="multipart/form-data">
                <p><form:errors path="*"/></p>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <p>
                    <form:label path="title">Title:</form:label>
                    <form:input path="title"/>
                </p>
                <p>
                    <label>Topic:</label>
                    <form:input path="topic.name" list="listOfTopics"/>
                    <datalist id="listOfTopics">
                        <c:forEach var="topic" items="${allTopics}">
                            <option><c:out value="${topic.name}"/></option>
                        </c:forEach>
                    </datalist>
                </p>
                <p>
                    <label>Image (optional):</label>
                    <input type="file" name="postImageFile" accept="image/png, image/jpeg, image/jpg">
                </p>
                <p>
                    <form:label path="description">Description:</form:label>
                    <form:textarea path="description"/>
                </p>
                <input type="submit" value="Submit">
            </form:form>
        </fieldset>

    </section>

    <footer>
        <span>&copy; <span id="currentYear"></span> BlogHub. All rights reserved.</span>
    </footer>
<script src="/js/index.js"></script>
</body>
</html>
