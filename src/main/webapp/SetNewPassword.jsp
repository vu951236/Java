<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Đặt mật khẩu mới</title>
  <link rel="icon" type = "image/x-icon" href="logo.png">
  <link rel="stylesheet" type="text/css" href="styles/Trangchu.css">
  <style>
    body {
      font-family: Arial, sans-serif;
      background-image: url('styles/1.jpg');
      background-size: cover;
      margin: 0;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .container {
      background: rgba(255, 255, 255, 0.85);
      padding: 30px;
      border-radius: 15px;
      box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
      width: 350px;
      text-align: center;
      margin: auto;
    }

    .container h2 {
      margin-bottom: 20px;
      font-size: 24px;
      color: #333;
    }

    .container input[type="password"] {
      width: 100%;
      padding: 10px;
      margin: 10px 0;
      border: 1px solid #ddd;
      border-radius: 8px;
      box-sizing: border-box;
      font-size: 16px;
    }

    .container button {
      width: 100%;
      padding: 10px;
      background-color: #28a745;
      color: #fff;
      border: none;
      border-radius: 8px;
      font-size: 16px;
      cursor: pointer;
    }

    .container button:hover {
      background-color: #218838;
    }

    .container p {
      margin-top: 20px;
      color: #333;
    }

    .error-message {
      color: red;
      font-weight: bold;
      margin-top: 10px;
    }
  </style>
</head>
<body>
<header>
  <div class="header-content">
    <img src="logo.png" alt="Cá Koi" class="img_header-thongtin">
    <h2><a href="index.jsp" class="home-link">Trang chủ</a></h2>
  </div>
  <nav>
    <ul>
      <li><a class="text-white" href="Hotro.jsp">Hỗ trợ</a></li>
    </ul>
  </nav>
</header>
<div class="main" style="text-align: center;">
  <div class="spacer"></div> <!-- Khoảng trống -->
  <div class="container" style="text-align: center;">
    <h2>Đặt mật khẩu mới</h2>
    <form method="post" action="SetNewPassword">
      <input type="password" name="newPassword" placeholder="Nhập mật khẩu mới" required>
      <input type="password" name="confirmPassword" placeholder="Xác nhận mật khẩu mới" required>
      <button type="submit">Đặt mật khẩu mới</button>
    </form>
    <p>
      <% if (request.getAttribute("error_message") != null) { %>
      <span class="error-message"><%= request.getAttribute("error_message") %></span>
      <% } %>
    </p>
    <p><a href="Login.jsp">Quay lại trang đăng nhập</a></p>
  </div>
  <div class="spacer"></div> <!-- Khoảng trống -->
</div>
</body>
</html>
