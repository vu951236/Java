<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Cá Koi</title>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  <link rel="icon" type = "image/x-icon" href="logo.png">
  <link rel="stylesheet" type="text/css" href="styles/index.css">
  <link rel="stylesheet" type="text/css" href="styles/Trangchu.css">
</head>
<body class="bg-gray-100">

<!-- Header -->
<header>
  <div class="container mx-auto flex justify-between items-center">
    <div class="header-content">
      <img src="logo.png" alt="Cá Koi" class="header-logo">
      <h2>
        <a href="index.jsp" class="home-link font-bold text-xl">Trang chủ</a>
      </h2>
    </div>
      <nav>
        <ul>
          <%
            String username = (String) session.getAttribute("username");
            Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");

            if (username != null) {
              if (isAdmin != null && isAdmin) {
          %>
          <li><a class="text-white" href="admin.jsp">Quản trị</a></li>

            <%
            }
            %>
            <li><a class="text-white" href="Logout.jsp">Đăng xuất</a></li>

            <%
              // If the user is not an admin
              if (isAdmin == null || !isAdmin) {
            %>
            <li class="cart-icon">
            <!-- Add onclick event to trigger cart popup -->

            <a href="#" id="cart-toggle" onclick="toggleCart()">Giỏ hàng</a>
              <!-- Cart popup -->
            <div id="cart-popup" class="cart-popup">
              <span class="close-btn" onclick="toggleCart()">X</span>
              <ul class="product-list">
                <!-- Product items will be dynamically added here -->
              </ul>
              <a href="#" class="checkout-btn" onclick="checkout()">Thanh toán</a>
            </div>
          </li>
          <%
            }
          } else {
          %>
          <li><a id="loginButton" class="text-white" href="Login.jsp">Đăng nhập</a></li>
          <%
            }
          %>
          <li><a class="text-white" href="Hotro.jsp">Hỗ trợ</a></li>
        </ul>
      </nav>
    </div>
</header>

<!-- Carousel -->
<div class="carousel mt-0">
  <div class="carousel-item active relative">
    <img src="https://img.pikbest.com/wp/202345/black-koi-an-orange-with-spots-is-swimming_9597133.jpg!w700wp" alt="Cá Koi" class="w-full h-screen object-cover"/>
    <a href="Thongtin.jsp" class="cta-button absolute bottom-10 left-1/2 transform -translate-x-1/2 bg-blue-500 text-white py-2 px-4 rounded">Xem thông tin cá Koi</a>
  </div>
  <div class="carousel-item relative">
    <img src="https://img.pikbest.com/ai/illus_our/20230413/15b5af1879079a3ca60dafa14a540c05.jpg!w700wp" alt="Cá Koi" class="w-full h-screen object-cover"/>
    <a href="Thongtin.jsp" class="cta-button absolute bottom-10 left-1/2 transform -translate-x-1/2 bg-blue-500 text-white py-2 px-4 rounded">Xem thông tin cá Koi</a>
  </div>
  <div class="carousel-item relative">
    <img src="https://img.pikbest.com/ai/illus_our/20230424/56e8da84cca313019c4d06456e4ee3a2.jpg!w700wp" alt="Cá Koi" class="w-full h-screen object-cover"/>
    <a href="Thongtin.jsp" class="cta-button absolute bottom-10 left-1/2 transform -translate-x-1/2 bg-blue-500 text-white py-2 px-4 rounded">Xem thông tin cá Koi</a>
  </div>
  <button id="prevBtn" class="carousel-btn absolute left-0 top-1/2 transform -translate-y-1/2 bg-white p-2 shadow-lg">&#9664;</button>
  <button id="nextBtn" class="carousel-btn absolute right-0 top-1/2 transform -translate-y-1/2 bg-white p-2 shadow-lg">&#9654;</button>
</div>

<!-- Footer -->
<footer>
  <div class="footer-content">
    <div class="footer-logo-section">
      <img src="logo.png" alt="Koi Logo" class="footer-logo">
      <p class="hotline">Liên hệ hotline: 123-456-789</p>
    </div>
    <ul class="footer-links">
      <li><a href="#">Về chúng tôi</a></li>
      <li><a href="#">Giới thiệu</a></li>
      <li><a href="#">Lĩnh vực hoạt động</a></li>
    </ul>
    <p class="footer-bottom">© 2024 Công ty của bạn. Mọi quyền được bảo lưu.</p>
  </div>
</footer>

<script src="styles/index.js"></script>
</body>
</html>
