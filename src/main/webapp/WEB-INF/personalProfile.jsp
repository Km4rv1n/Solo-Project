<%--
  Created by IntelliJ IDEA.
  User: marvinkika
  Date: 22.1.25
  Time: 11:04 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core"%>
<%@ page isErrorPage="true" %>

<html>
<head>
    <title>MyProfile</title>
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

        <fieldset>
            <legend>My Profile</legend>


<%--            //<form action="/events/${event.id}/image" method="POST" enctype="multipart/form-data" class="shadow row rounded bg-light g-3 mx-0 p-3">--%>
<%--            //					<div>--%>
<%--            //						<input type="hidden" name="_method" value="PUT" />--%>
<%--            //						<div class="">--%>
<%--            //						    <label for="imageURL" class="form-label">Upload a flyer or picture for the event:</label>--%>
<%--            //						    <input type="file" name="imageURL" id="imageURL" accept="image/png, image/jpeg, image/jpg" class="form-control" />--%>
<%--            //						    <div>--%>
<%--            //						    	<img id="thumbnail" src="/img/blank.png" style="width: 50px;" alt="event pic preview" />--%>
<%--            //						    </div>--%>
<%--            //						</div>--%>
<%--            //					</div>--%>
<%--            //					<input type="submit" value="Upload" class="col-1 btn btn-sm btn-moss me-2" /><a href="/dashboard" class="col-1 btn btn-sm btn-offpumpkin">Cancel</a>--%>
<%--            //				</form>--%>

            <p><form:errors path="user.*"/></p>
            <form:form method="post" action="/user/personal-profile" modelAttribute="user" enctype="multipart/form-data">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <input type="hidden" name="_method" value="put">

                <img src="${currentUser.profilePictureUrl}" class="profile-picture" alt="Profile-Picture"><br>
                <input type="file" name="profilePictureFile" accept="image/png, image/jpeg, image/jpg">

                <form:input path="password" type="hidden"/>
                <form:input path="passwordConfirmation" type="hidden"/>

                <p>
                    <form:label path="firstName">First Name:</form:label>
                    <form:input path="firstName"/>
                </p>
                <p>
                    <form:label path="lastName">Last Name:</form:label>
                    <form:input path="lastName"/>
                </p>
                <p>
                    <form:label path="username">Username:</form:label>
                    <form:input path="username"/>
                </p>
                <p>
                    <form:label path="email">Email:</form:label>
                    <form:input path="email"/>
                </p>
                <input type="submit" value="Save Changes">
            </form:form>
        </fieldset>
    </section>

    <footer>
        <span>&copy; <span id="currentYear"></span> BlogHub. All rights reserved.</span>
    </footer>
    <script src="/js/index.js" ></script>
</body>
</html>
