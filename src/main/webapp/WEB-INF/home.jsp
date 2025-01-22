<%--
  Created by IntelliJ IDEA.
  User: marvinkika
  Date: 21.1.25
  Time: 9:35 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core"%>
<%@ page isErrorPage="true" %>

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
                <li><a href="/user/home">Home</a></li>
            </ul>
        </details>

        <section>
<%--            here posts will be displayed --%>
        </section>

        <c:if test="${popularTopics.size() != 0}">
            <details open>
                <summary>Popular Topics</summary>
                <ul>
                    <c:forEach var="topic" items="${popularTopics}">
                        <li><a><c:out value="${topic.name}"/></a></li>
                    </c:forEach>
                </ul>
            </details>
        </c:if>

    </section>

    <footer>
        <span>&copy; <span id="currentYear"></span> BlogHub. All rights reserved.</span>
    </footer>
    <script src="/js/index.js" ></script>
</body>
</html>
