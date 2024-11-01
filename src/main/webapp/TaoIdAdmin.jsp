<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.IOException" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng</title>
    <link rel="stylesheet" type="text/css" href="styles/Trangchu.css">
    <link rel="icon" type="image/x-icon" href="logo.png">
</head>
<body>
<header>
    <div class="header-content">
        <img src="logo.png" alt="Cá Koi" class="img_header-thongtin">
        <h2><a href="index.jsp" class="home-link">Trang chủ</a></h2>
    </div>
    <nav>
        <ul>
            <li><a href="admin.jsp">Quản trị</a></li>
            <li><a href="Logout.jsp">Đăng xuất</a></li>
        </ul>
    </nav>
</header>
<div class="main">

<h1>Tạo ID Admin</h1>
<form action="TaoIdAdmin" method="post">
    <label for="adminId">Nhập ID Admin:</label>
    <input type="text" id="adminId" name="adminId" required>
    <button type="submit">Tạo ID</button>
</form>

<c:if test="${not empty errorMessage}">
    <p style="color:red;">${errorMessage}</p>
</c:if>

</div>
</body>
</html>
