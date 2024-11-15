package com.mywebapp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/ConfirmResetPassword")
public class ConfirmResetPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String resetCode = (String) session.getAttribute("resetCode"); // Mã xác nhận lưu trong session
        String userInputCode = request.getParameter("resetCode"); // Mã xác nhận do người dùng nhập

        String errorMessage = null;
        String successMessage = null;

        // Kiểm tra mã xác nhận
        if (resetCode == null || !resetCode.equals(userInputCode)) {
            errorMessage = "Mã xác nhận không chính xác.";
            request.setAttribute("error_message", errorMessage);
            request.getRequestDispatcher("/ConfirmResetPassword.jsp").forward(request, response);
            return;
        }

        // Nếu mã xác nhận đúng, chuyển hướng đến trang nhập mật khẩu mới
        successMessage = "Mã xác nhận thành công! Vui lòng nhập mật khẩu mới.";
        request.setAttribute("success_message", successMessage);
        request.getRequestDispatcher("/SetNewPassword.jsp").forward(request, response);
    }
}
