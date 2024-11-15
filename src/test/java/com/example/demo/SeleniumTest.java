package com.example.demo;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;
import org.openqa.selenium.JavascriptExecutor;

public class SeleniumTest {
    public static void main(String[] args) {
        // Đặt đường dẫn cho ChromeDriver
        System.setProperty("webdriver.chrome.driver", "C:\\Users\\ADMIN\\IdeaProjects\\chromedriver-win64\\chromedriver.exe");

        WebDriver driver = new ChromeDriver();

        // Khởi tạo đối tượng WebDriverWait với thời gian chờ tối đa là 10 giây
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));

        // Điều hướng đến trang web cần kiểm thử
        driver.get("http://localhost:8080/Gradle___com_example___demo1_war/");

        // Phóng to cửa sổ trình duyệt
        driver.manage().window().maximize();
        System.out.println("Browser window maximized.");


        // Kiểm tra và nhấn vào nút Đăng nhập
        try {
            WebElement loginButton = wait.until(ExpectedConditions.elementToBeClickable(By.id("loginButton")));
            loginButton.click();

            Thread.sleep(2000);

            // Kiểm tra tiêu đề của trang đăng nhập
            String pageTitle = driver.getTitle();
            if (pageTitle.equals("Đăng nhập")) {
                System.out.println("Go to login page successfully");

                // Tìm và nhấn vào liên kết "Đăng ký tại đây"
                WebElement registerLink = wait.until(ExpectedConditions.elementToBeClickable(By.linkText("Đăng ký tại đây")));
                registerLink.click();

                Thread.sleep(2000);

                // Chờ cho trang đăng ký tải xong
                wait.until(ExpectedConditions.titleContains("Đăng ký tài khoản"));
                String registerPageTitle = driver.getTitle();
                if (registerPageTitle.contains("Đăng ký tài khoản")) {
                    System.out.println("Go to registration page successfully");

                    // Điền vào form đăng ký
                    WebElement usernameField = driver.findElement(By.id("username"));
                    WebElement passwordField = driver.findElement(By.id("password"));
                    WebElement emailField = driver.findElement(By.id("email"));
                    WebElement fullnameField = driver.findElement(By.id("fullname"));
                    WebElement addressField = driver.findElement(By.id("address"));
                    WebElement adminCodeField = driver.findElement(By.id("admin_code"));

                    usernameField.sendKeys("vu001122");
                    passwordField.sendKeys("00112233");
                    emailField.sendKeys("hoangvuvo907@gmail.com");
                    fullnameField.sendKeys("Võ Hoàng Vũ");
                    addressField.sendKeys("440 Thống Nhất");
                    adminCodeField.sendKeys(""); // Nếu không có mã admin, có thể để trống

                    Thread.sleep(2000);

                    // Nhấn nút Đăng ký
                    WebElement registerButton = driver.findElement(By.name("register"));
                    registerButton.click();}
                else{
                    System.out.println("Go to the failed registration page.");
                }

                // Thêm thời gian chờ để có thể kiểm tra trang đăng ký đã thành công chưa
                Thread.sleep(2000);

                // Kiểm tra trang đăng ký có thành công không
                String registerSuccessPageTitle = driver.getTitle();
                if (registerSuccessPageTitle.contains("Đăng nhập")) {
                    System.out.println("Registration successful");

                    Thread.sleep(2000);

                    // Đăng nhập bằng username và password vừa đăng ký
                    WebElement usernameLoginField = driver.findElement(By.id("username"));
                    WebElement passwordLoginField = driver.findElement(By.id("password"));
                    WebElement loginSubmitButton = driver.findElement(By.name("login"));

                    usernameLoginField.sendKeys("vu001122");
                    passwordLoginField.sendKeys("00112233");
                    loginSubmitButton.click();

                    Thread.sleep(2000);

                    // Chờ cho trang đăng nhập xử lý và kiểm tra tiêu đề trang sau khi đăng nhập
                    wait.until(ExpectedConditions.titleContains("Thông tin"));

                    // Kiểm tra xem có đăng nhập thành công không
                    String loginSuccessPageTitle = driver.getTitle();
                    if (loginSuccessPageTitle.contains("Thông tin")) {
                        // Thêm thời gian chờ để trang tải hoàn toàn trước khi nhấn vào sản phẩm
                        Thread.sleep(2000); // Thời gian chờ 3 giây để quay video hoặc chờ trang tải

                        // Tìm sản phẩm thứ hai trong phần "Thông tin Cá" và nhấn vào
                        WebElement secondProductInCaSection = driver.findElement(By.cssSelector("#Ca .char2:nth-of-type(2) a"));
                        secondProductInCaSection.click();

                        // Chờ cho trang sản phẩm tải xong
                        Thread.sleep(2000);

                        // Nhấn vào liên kết "Xem chi tiết"
                        WebElement viewDetailLink = driver.findElement(By.cssSelector(".chitiet a"));
                        viewDetailLink.click();

                        // Thông báo xác nhận
                        System.out.println("Clicked 'View details' for the second product.");
                        Thread.sleep(2000);

                        // Chờ để trang chi tiết tải xong
                        Thread.sleep(2000); // Thời gian chờ có thể điều chỉnh nếu cần

                        // Kiểm tra xem đã vào trang chi tiết hay chưa dựa vào tiêu đề
                        String detailPageTitle = driver.getTitle();
                        if (detailPageTitle.contains("Trang chi tiết")) {
                            System.out.println("Successfully entered the detail page!");

                            // Cuộn xuống cuối trang
                            JavascriptExecutor js = (JavascriptExecutor) driver;
                            js.executeScript("window.scrollTo(0, document.body.scrollHeight);");
                            System.out.println("Scrolled to the bottom of the page.");
                            Thread.sleep(2000);

                            // Nhấn vào nút "Thông tin" trên header
                            WebElement infoButton = driver.findElement(By.linkText("Thông tin"));
                            infoButton.click();

                            // Chờ để trang "Thông tin" tải xong
                            Thread.sleep(2000);

                            // Kiểm tra xem đã vào trang "Thông tin" hay chưa
                            String infoPageTitle = driver.getTitle();

                        if (infoPageTitle.contains("Thông tin")) {
                                System.out.println("Successfully returned to the information page!");

                                // Nhấn vào "Thông tin Hồ"
                                WebElement hoInfoLink = driver.findElement(By.linkText("Thông tin Hồ"));
                                hoInfoLink.click();

                                // Chờ trang "Thông tin Hồ" tải xong
                                Thread.sleep(2000);

                                // Kiểm tra xem đã vào phần "Thông tin Hồ" hay chưa
                                String currentUrl = driver.getCurrentUrl();
                                if (currentUrl.contains("#Ho")) {
                                    System.out.println("Successfully navigated to 'Thông tin Hồ' section!");

                                    // Nhấn vào sản phẩm đầu tiên của phần "Thông tin Hồ"
                                    WebElement firstProductHo = driver.findElement(By.cssSelector("#Ho .char2:nth-of-type(2) a"));
                                    firstProductHo.click();

                                    // Chờ trang tải và nhấn vào nút "Xem chi tiết"
                                    Thread.sleep(2000);
                                    WebElement viewDetailButtonHo = driver.findElement(By.cssSelector(".chitiet1 a"));
                                    viewDetailButtonHo.click();

                                    // Kiểm tra xem đã vào trang chi tiết hay chưa
                                    Thread.sleep(2000);
                                    String detailPageTitleHo = driver.getTitle();
                                    if (detailPageTitleHo.contains("Trang chi tiết")) {
                                        System.out.println("Successfully entered the detail page from 'Thông tin Hồ'!");

                                        // Cuộn xuống cuối trang
                                        JavascriptExecutor js1 = (JavascriptExecutor) driver;
                                        js1.executeScript("window.scrollTo(0, document.body.scrollHeight);");
                                        System.out.println("Scrolled to the bottom of the page.");
                                        Thread.sleep(2000);

                                        // Nhấn vào nút "Thông tin" trên header
                                        try {
                                            WebElement infoButton1 = driver.findElement(By.linkText("Thông tin"));
                                            infoButton1.click();

                                            // Chờ để trang "Thông tin" tải xong
                                            Thread.sleep(2000);

                                            // Kiểm tra xem đã vào trang "Thông tin" hay chưa
                                            String infoPageTitle1 = driver.getTitle();
                                            if (infoPageTitle1.contains("Thông tin")) {
                                                System.out.println("Successfully returned to the information page!");

                                                // Nhấn vào nút "Sản phẩm" trên header
                                                WebElement productButton = driver.findElement(By.linkText("Sản phẩm"));
                                                productButton.click();

                                                // Chờ trang "Sản phẩm" tải xong
                                                Thread.sleep(2000);

                                                // Kiểm tra xem đã vào trang "Sản phẩm" hay chưa
                                                String productPageTitle = driver.getTitle();
                                                if (productPageTitle.contains("Sản phẩm")) {
                                                    // Thêm thời gian chờ để trang tải hoàn toàn trước khi nhấn vào sản phẩm
                                                    Thread.sleep(2000); // Thời gian chờ 3 giây để quay video hoặc chờ trang tải

                                                    // Tìm sản phẩm thứ hai trong phần "Thông tin Cá" và nhấn vào
                                                    WebElement secondProductMedicineCa = driver.findElement(By.cssSelector("#Nuoc .char2:nth-of-type(3) a"));
                                                    secondProductMedicineCa.click();

                                                    // Chờ cho trang sản phẩm tải xong
                                                    Thread.sleep(2000);

                                                    // Nhấn vào liên kết "Xem chi tiết"
                                                    WebElement viewDetailLinkMedicineCa = driver.findElement(By.cssSelector(".chitiet a"));
                                                    viewDetailLinkMedicineCa.click();

                                                    // Thông báo xác nhận
                                                    System.out.println("Clicked 'View details' for the second product.");
                                                    Thread.sleep(2000);

                                                    // Chờ để trang chi tiết tải xong
                                                    Thread.sleep(2000); // Thời gian chờ có thể điều chỉnh nếu cần

                                                    // Kiểm tra xem đã vào trang chi tiết hay chưa dựa vào tiêu đề
                                                    String detailPageTitleMedicineCa = driver.getTitle();
                                                    if (detailPageTitleMedicineCa.contains("Trang chi tiết")) {
                                                        System.out.println("Successfully entered the detail page!");

                                                        // Cuộn xuống cuối trang để tìm form nhập số lượng mua
                                                        JavascriptExecutor js2 = (JavascriptExecutor) driver;
                                                        js2.executeScript("window.scrollTo(0, document.body.scrollHeight)");

                                                        Thread.sleep(2000);

                                                        // Nhập số lượng mua
                                                        WebElement quantityInput = driver.findElement(By.id("quantity")); // giả sử id của input là "quantity"
                                                        quantityInput.sendKeys("1"); // Nhập số lượng muốn mua

                                                        // Nhấn vào nút "Mua ngay"
                                                        WebElement buyNowButton = driver.findElement(By.id("buyNowButton")); // giả sử id của nút là "buyNowButton"
                                                        buyNowButton.click();

                                                        // Thông báo xác nhận
                                                        System.out.println("Clicked 'Mua ngay'.");

                                                        // Chờ để thao tác mua hoàn tất
                                                        Thread.sleep(2000);

                                                        // Nhấn vào nút "Quay lại trang sản phẩm"
                                                        WebElement backToProductPageLink = driver.findElement(By.cssSelector("a[href='Sanpham.jsp']"));
                                                        backToProductPageLink.click();

                                                        // Chờ để trang "Sản phẩm" tải xong
                                                        Thread.sleep(2000);

                                                        // Kiểm tra xem đã trở về trang "Sản phẩm" hay chưa
                                                        String backToProductPageTitle = driver.getTitle();
                                                        if (backToProductPageTitle.contains("Sản phẩm")) {
                                                            System.out.println("Successfully returned to the product page!");
                                                            
                                                            // Nhấn vào "Thông tin Hồ"
                                                            WebElement hoInfoLink1 = driver.findElement(By.linkText("SP điều trị cá"));
                                                            hoInfoLink1.click();

                                                            // Chờ để trang "Thông tin Hồ" tải xong
                                                            Thread.sleep(2000);

                                                            // Nhấn vào sản phẩm thứ hai trong phần "Thông tin Cá"
                                                            WebElement secondProductInCaSection1 = driver.findElement(By.cssSelector("#Ca .char2:nth-of-type(4) a"));
                                                            secondProductInCaSection1.click();

                                                            // Chờ cho trang sản phẩm tải xong
                                                            Thread.sleep(2000);

                                                            // Nhấn vào liên kết "Xem chi tiết" cho sản phẩm đã chọn
                                                            WebElement viewDetailLink1 = driver.findElement(By.cssSelector(".chitiet1 a"));
                                                            viewDetailLink1.click();

                                                            System.out.println("Clicked 'View details' for the second product in 'Sp điều trị Cá'.");

                                                            // Chờ để trang chi tiết tải xong
                                                            Thread.sleep(2000);

                                                            // Kiểm tra xem đã vào trang chi tiết hay chưa
                                                            String detailPageTitle1 = driver.getTitle();
                                                            if (detailPageTitle1.contains("Trang chi tiết")) {
                                                                System.out.println("Successfully entered the detail page!");
                                                                // Cuộn xuống cuối trang để tìm form nhập số lượng mua
                                                                JavascriptExecutor js3 = (JavascriptExecutor) driver;
                                                                js3.executeScript("window.scrollTo(0, document.body.scrollHeight)");

                                                                Thread.sleep(2000);

                                                                // Nhập số lượng mua
                                                                WebElement quantityInput1 = driver.findElement(By.id("quantity")); // giả sử id của input là "quantity"
                                                                quantityInput1.sendKeys("1"); // Nhập số lượng muốn mua

                                                                // Nhấn vào nút "Mua ngay"
                                                                WebElement buyNowButton1 = driver.findElement(By.id("buyNowButton")); // giả sử id của nút là "buyNowButton"
                                                                buyNowButton1.click();

                                                                // Thông báo xác nhận
                                                                System.out.println("Clicked 'Mua ngay'.");

                                                                // Chờ để thao tác mua hoàn tất
                                                                Thread.sleep(2000);

                                                                // Nhấn vào nút "Quay lại trang sản phẩm"
                                                                WebElement backToProductPageLink1 = driver.findElement(By.cssSelector("a[href='Sanpham.jsp']"));
                                                                backToProductPageLink1.click();

                                                                // Chờ để trang "Sản phẩm" tải xong
                                                                Thread.sleep(2000);
                                                                // Kiểm tra xem đã trở về trang "Sản phẩm" hay chưa
                                                                String backToProductPageTitle1 = driver.getTitle();
                                                                if (backToProductPageTitle1.contains("Sản phẩm")) {
                                                                    System.out.println("Successfully returned to the product page!");

                                                                    // Nhấn vào avatar
                                                                    WebElement avatarDiv = driver.findElement(By.cssSelector(".avt img"));
                                                                    avatarDiv.click();
                                                                    System.out.println("Clicked on the avatar.");

                                                                    // Chờ trang thông tin cá nhân tải xong
                                                                    Thread.sleep(2000);

                                                                    // Cuộn xuống phần "Chỉnh sửa thông tin cá nhân"
                                                                    JavascriptExecutor js4 = (JavascriptExecutor) driver;
                                                                    js4.executeScript("arguments[0].scrollIntoView(true);", driver.findElement(By.tagName("h2")));
                                                                    Thread.sleep(2000);

                                                                    // Tải file ảnh cho avatar
                                                                    WebElement avatarInput = driver.findElement(By.id("avatar"));
                                                                    avatarInput.sendKeys("E:\\Downloads\\avatartest.jpg");

                                                                    // Nhập email mới
                                                                    WebElement emailInput = driver.findElement(By.id("email"));
                                                                    emailInput.clear();
                                                                    emailInput.sendKeys("example@example.com");

                                                                    // Nhập mật khẩu mới
                                                                    WebElement passwordInput = driver.findElement(By.id("password"));
                                                                    passwordInput.clear();
                                                                    passwordInput.sendKeys("newpassword123");

                                                                    // Nhập địa chỉ mới
                                                                    WebElement addressInput = driver.findElement(By.id("address"));
                                                                    addressInput.clear();
                                                                    addressInput.sendKeys("123 New Street, New City");

                                                                    Thread.sleep(2000);

                                                                    // Nhấn vào nút "Cập nhật thông tin"
                                                                    WebElement submitButton = driver.findElement(By.cssSelector("input[type='submit']"));
                                                                    submitButton.click();

                                                                    // Thông báo xác nhận
                                                                    System.out.println("Updated personal information successfully.");
                                                                    Thread.sleep(2000);

                                                                    // Cuộn xuống phần "Lịch sử mua hàng"
                                                                    WebElement purchaseHistorySection = driver.findElement(By.xpath("//h2[text()='Lịch sử mua hàng']"));
                                                                    js2.executeScript("arguments[0].scrollIntoView(true);", purchaseHistorySection);
                                                                    System.out.println("Scrolled to the purchase history section.");
                                                                    Thread.sleep(2000);

                                                                    // Nhấn vào nút thông tin trên header
                                                                    WebElement infoButton2 = driver.findElement(By.linkText("Thông tin"));
                                                                    infoButton2.click();
                                                                    System.out.println("Clicked on the 'Thông tin' button.");
                                                                    Thread.sleep(2000);

                                                                    // Kiểm tra tiêu đề trang sản phẩm để chắc chắn quay lại trang sản phẩm
                                                                    String productPageTitle2 = driver.getTitle();
                                                                    if (productPageTitle2.contains("Thông tin")) {
                                                                        System.out.println("Successfully returned to the product page!");

                                                                        // Nhấn vào nút "Quản lý hồ" trên header
                                                                        WebElement manageTankButton = driver.findElement(By.linkText("Quản lí hồ"));
                                                                        manageTankButton.click();
                                                                        System.out.println("Clicked on 'Quản lí hồ'.");
                                                                        Thread.sleep(2000);

                                                                        // Điền thông tin trong form "Thêm thông tin hồ cá mới"
                                                                        WebElement hoName = driver.findElement(By.id("hoName"));
                                                                        hoName.sendKeys("Hồ Cá Thủy Sinh");

                                                                        WebElement hoLength = driver.findElement(By.id("hoLength"));
                                                                        hoLength.sendKeys("150");

                                                                        WebElement hoWidth = driver.findElement(By.id("hoWidth"));
                                                                        hoWidth.sendKeys("60");

                                                                        WebElement hoHeight = driver.findElement(By.id("hoHeight"));
                                                                        hoHeight.sendKeys("50");

                                                                        WebElement fishCount = driver.findElement(By.id("fishCount"));
                                                                        fishCount.sendKeys("20");

                                                                        WebElement plantCount = driver.findElement(By.id("plantCount"));
                                                                        plantCount.sendKeys("15");

                                                                        WebElement hoImage = driver.findElement(By.id("hoImage"));
                                                                        hoImage.sendKeys("E:\\Downloads\\hoCaImage.jpg");

                                                                        Thread.sleep(2000);

                                                                        WebElement saveButton = driver.findElement(By.cssSelector("button[type='submit']"));
                                                                        saveButton.click();

                                                                        System.out.println("Submitted the tank information form successfully.");

                                                                        Thread.sleep(2000);

                                                                        // Cuộn xuống form "Sửa thông tin hồ cá"
                                                                        JavascriptExecutor js5 = (JavascriptExecutor) driver;
                                                                        WebElement suaHoCaForm = driver.findElement(By.id("hoNamemoi"));
                                                                        js5.executeScript("arguments[0].scrollIntoView(true);", suaHoCaForm);
                                                                        Thread.sleep(2000);

                                                                        // Nhập thông tin vào form "Sửa thông tin hồ cá"
                                                                        WebElement hoNamemoi = driver.findElement(By.id("hoNamemoi"));
                                                                        hoNamemoi.clear();
                                                                        hoNamemoi.sendKeys("Hồ Cá Biển");

                                                                        WebElement hoLengthmoi = driver.findElement(By.id("hoLengthmoi"));
                                                                        hoLengthmoi.clear();
                                                                        hoLengthmoi.sendKeys("200");

                                                                        WebElement hoWidthmoi = driver.findElement(By.id("hoWidthmoi"));
                                                                        hoWidthmoi.clear();
                                                                        hoWidthmoi.sendKeys("80");

                                                                        WebElement hoHeightmoi = driver.findElement(By.id("hoHeightmoi"));
                                                                        hoHeightmoi.clear();
                                                                        hoHeightmoi.sendKeys("70");

                                                                        WebElement fishCountmoi = driver.findElement(By.id("fishCountmoi"));
                                                                        fishCountmoi.clear();
                                                                        fishCountmoi.sendKeys("30");

                                                                        WebElement plantCountmoi = driver.findElement(By.id("plantCountmoi"));
                                                                        plantCountmoi.clear();
                                                                        plantCountmoi.sendKeys("25");

                                                                        WebElement hoImagemoi = driver.findElement(By.id("hoImagemoi"));
                                                                        hoImagemoi.sendKeys("E:\\Downloads\\hoCaNewImage.jpg");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn nút lưu thông tin
                                                                        WebElement saveHoCaButton = driver.findElement(By.cssSelector("button[type='submit']"));
                                                                        saveHoCaButton.click();
                                                                        System.out.println("Submitted the updated tank information form successfully.");
                                                                        Thread.sleep(2000);

                                                                        // Cuộn xuống phần kiểm tra thông số nước
                                                                        WebElement waterParametersForm = driver.findElement(By.id("waterParametersForm"));
                                                                        js.executeScript("arguments[0].scrollIntoView(true);", waterParametersForm);

                                                                        // Nhập thông số nước
                                                                        driver.findElement(By.id("temperature")).sendKeys("25");

                                                                        driver.findElement(By.id("salinity")).sendKeys("30");

                                                                        driver.findElement(By.id("ph")).sendKeys("8.2");

                                                                        driver.findElement(By.id("oxygen")).sendKeys("7");

                                                                        driver.findElement(By.id("nitrite")).sendKeys("0.02");

                                                                        driver.findElement(By.id("nitrate")).sendKeys("5");

                                                                        driver.findElement(By.id("phosphate")).sendKeys("0.5");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn nút kiểm tra thông số nước
                                                                        driver.findElement(By.cssSelector("form#waterParametersForm button[type='submit']")).click();
                                                                        System.out.println("Checked water parameters successfully.");
                                                                        Thread.sleep(2000);

                                                                        // Cuộn xuống phần tính lượng thức ăn
                                                                        WebElement foodSection = driver.findElement(By.id("youngQuantity"));
                                                                        js.executeScript("arguments[0].scrollIntoView(true);", foodSection);
                                                                        Thread.sleep(2000);

                                                                        // Nhập thông tin số lượng cá
                                                                        driver.findElement(By.id("youngQuantity")).sendKeys("10");

                                                                        driver.findElement(By.id("juvenileQuantity")).sendKeys("20");

                                                                        driver.findElement(By.id("adultQuantity")).sendKeys("15");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn nút tính lượng thức ăn
                                                                        driver.findElement(By.cssSelector("button[onclick='calculateFood()']")).click();
                                                                        System.out.println("Calculated food quantity successfully.");
                                                                        Thread.sleep(2000);

                                                                        // Cuộn xuống phần tính lượng muối
                                                                        WebElement saltSection = driver.findElement(By.id("tankVolume"));
                                                                        js.executeScript("arguments[0].scrollIntoView(true);", saltSection);
                                                                        Thread.sleep(2000);

                                                                        // Nhập thể tích hồ và tính lượng muối
                                                                        driver.findElement(By.id("tankVolume")).sendKeys("1000");
                                                                        Thread.sleep(2000);

                                                                        driver.findElement(By.cssSelector("button[onclick='calculateSalt()']")).click();
                                                                        System.out.println("Calculated salt quantity successfully.");
                                                                        Thread.sleep(1000);

                                                                        // Cuộn ngay lập tức xuống cuối trang
                                                                        JavascriptExecutor js6 = (JavascriptExecutor) driver;
                                                                        js6.executeScript("window.scrollTo(0, document.body.scrollHeight);");
                                                                        Thread.sleep(2000); // Chờ 2 giây để đảm bảo cuộn hoàn tất

                                                                        // Nhấn vào nút Đăng xuất
                                                                        WebElement logoutButton = driver.findElement(By.linkText("Đăng xuất"));
                                                                        logoutButton.click();
                                                                        System.out.println("Clicked on the 'Đăng xuất' button.");
                                                                        Thread.sleep(3000);

                                                                        // Nhấn vào nút Đăng nhập trên header
                                                                        WebElement loginButton1 = driver.findElement(By.linkText("Đăng nhập"));
                                                                        loginButton1.click();
                                                                        System.out.println("Clicked on the 'Đăng nhập' button.");
                                                                        Thread.sleep(2000);

                                                                        // Nhập tài khoản và mật khẩu
                                                                        WebElement usernameField = driver.findElement(By.id("username")); // Thay đổi ID nếu không khớp
                                                                        usernameField.sendKeys("vuad951236");

                                                                        WebElement passwordField = driver.findElement(By.id("password")); // Thay đổi ID nếu không khớp
                                                                        passwordField.sendKeys("951236vu");

                                                                        // Nhấn nút Đăng nhập
                                                                        WebElement submitLoginButton = driver.findElement(By.cssSelector("button[type='submit']")); // Chọn nút submit
                                                                        submitLoginButton.click();
                                                                        System.out.println("Logged in with provided credentials.");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn vào nút Quản trị trên header
                                                                        WebElement adminButton = driver.findElement(By.linkText("Quản trị")); // Thay đổi text nếu không khớp
                                                                        adminButton.click();
                                                                        System.out.println("Clicked on the 'Quản trị' button.");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn vào liên kết "Thêm thông tin Cá Koi"
                                                                        WebElement addKoiInfoLink = driver.findElement(By.linkText("Thêm thông tin Cá Koi"));
                                                                        addKoiInfoLink.click();
                                                                        System.out.println("Navigated to 'Thêm thông tin Cá Koi' page.");
                                                                        Thread.sleep(2000);

                                                                        // Điền vào form "Thêm thông tin Cá Koi mới"

                                                                        // Nhập tên cá Koi
                                                                        WebElement koiNameField = driver.findElement(By.id("name_ca"));
                                                                        koiNameField.sendKeys("Cá Koi Nhật Bản");
                                                                        Thread.sleep(500);

                                                                        // Nhập ghi chú
                                                                        WebElement noteField = driver.findElement(By.id("ghichu_ca"));
                                                                        noteField.sendKeys("Loại cá phổ biến và đẹp.");
                                                                        Thread.sleep(500);

                                                                        // Upload hình ảnh
                                                                        WebElement image1Field = driver.findElement(By.id("image_path1_ca"));
                                                                        image1Field.sendKeys("E:\\Downloads\\koi1.jpg");
                                                                        Thread.sleep(500);

                                                                        WebElement image2Field = driver.findElement(By.id("image_path2_ca"));
                                                                        image2Field.sendKeys("E:\\Downloads\\koi2.jpg");
                                                                        Thread.sleep(500);

                                                                        WebElement image3Field = driver.findElement(By.id("image_path3_ca"));
                                                                        image3Field.sendKeys("E:\\Downloads\\koi3.jpg");
                                                                        Thread.sleep(500);

                                                                        WebElement image4Field = driver.findElement(By.id("image_path4_ca"));
                                                                        image4Field.sendKeys("E:\\Downloads\\koi4.jpg");
                                                                        Thread.sleep(500);

                                                                        // Nhập khái niệm
                                                                        WebElement conceptField = driver.findElement(By.id("khainiem_ca"));
                                                                        conceptField.sendKeys("Cá Koi là biểu tượng của sự may mắn và thành công.");
                                                                        Thread.sleep(500);

                                                                        // Nhập đặc điểm
                                                                        WebElement featuresField = driver.findElement(By.id("dacdiem_ca"));
                                                                        featuresField.sendKeys("Thân hình bầu dục, màu sắc đa dạng và hoa văn độc đáo.");
                                                                        Thread.sleep(500);

                                                                        // Nhập dinh dưỡng
                                                                        WebElement nutritionField = driver.findElement(By.id("dinhduong_ca"));
                                                                        nutritionField.sendKeys("Chế độ ăn gồm thực phẩm giàu protein và chất xơ.");
                                                                        Thread.sleep(500);

                                                                        // Nhập phân loại
                                                                        WebElement classificationField = driver.findElement(By.id("phanloai_ca"));
                                                                        classificationField.sendKeys("Phân loại theo màu sắc và hoa văn.");
                                                                        Thread.sleep(500);

                                                                        // Nhập phân biệt
                                                                        WebElement differentiationField = driver.findElement(By.id("phanbiet_ca"));
                                                                        differentiationField.sendKeys("Phân biệt bằng kích thước, màu sắc và nguồn gốc.");
                                                                        Thread.sleep(500);

                                                                        // Nhấn nút "Thêm Cá Koi"
                                                                        WebElement submitButton1 = driver.findElement(By.cssSelector("input[type='submit']"));
                                                                        submitButton1.click();
                                                                        System.out.println("Submitted the 'Thêm thông tin Cá Koi' form successfully.");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn vào nút "Thông tin" trên header
                                                                        WebElement infoButton3 = driver.findElement(By.linkText("Thông tin"));
                                                                        infoButton3.click();
                                                                        System.out.println("Navigated to the 'Thông tin' page.");
                                                                        Thread.sleep(2000);

                                                                        // Tìm container chứa danh sách sản phẩm
                                                                        WebElement productList = driver.findElement(By.id("Ca")); // ID của container danh sách sản phẩm

                                                                        // Cuộn đến sản phẩm cuối cùng trong danh sách
                                                                        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollTop = arguments[0].scrollHeight;", productList);
                                                                        System.out.println("Scrolled to the bottom of the product list.");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn vào sản phẩm cuối cùng
                                                                        WebElement lastProduct = driver.findElement(By.cssSelector("#Ca .char2:last-of-type")); // Sản phẩm cuối
                                                                        lastProduct.click();
                                                                        System.out.println("Clicked on the last product.");
                                                                        Thread.sleep(2000);


                                                                        // Tìm phần tử "Xem chi tiết"
                                                                        WebElement xemChiTietButton = driver.findElement(By.cssSelector(".chitiet a"));
                                                                        // Nhấn vào nút "Xem chi tiết"
                                                                        xemChiTietButton.click();
                                                                        System.out.println("Clicked on the 'Xem chi tiết' button.");
                                                                        Thread.sleep(2000);

                                                                        // Cuộn trang xuống cuối sau khi vào trang chi tiết sản phẩm
                                                                        JavascriptExecutor js8 = (JavascriptExecutor) driver;
                                                                        js8.executeScript("window.scrollTo(0, document.body.scrollHeight);");
                                                                        System.out.println("Scrolled to the bottom of the page.");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn vào nút "Quản trị" trên header
                                                                        WebElement adminButton1 = driver.findElement(By.linkText("Quản trị"));
                                                                        adminButton1.click();
                                                                        System.out.println("Clicked on the 'Quản trị' button.");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn vào "Sửa thông tin cá Koi"
                                                                        WebElement suaThongTinCaKoiButton = driver.findElement(By.cssSelector("h2 a[href='SuaThongTinCaKoi.jsp']"));
                                                                        suaThongTinCaKoiButton.click();
                                                                        System.out.println("Clicked on the 'Sửa thông tin cá Koi' button.");
                                                                        Thread.sleep(2000);

                                                                        // Điền vào form "Sửa thông tin cá Koi"
                                                                        WebElement nameCaInput = driver.findElement(By.id("name_suaca"));
                                                                        nameCaInput.sendKeys("Cá Koi Nhật Bản"); // Tên cá Koi cần sửa

                                                                        WebElement newNameCaInput = driver.findElement(By.id("new_name_ca"));
                                                                        newNameCaInput.sendKeys("Cá Koi Mới"); // Tên mới của cá Koi

                                                                        WebElement ghichuInput = driver.findElement(By.id("ghichu_suaca"));
                                                                        ghichuInput.sendKeys("Ghi chú sửa đổi");

                                                                        WebElement khainiemInput = driver.findElement(By.id("khainiem_suaca"));
                                                                        khainiemInput.sendKeys("Khái niệm sửa đổi");

                                                                        WebElement dacdiemInput = driver.findElement(By.id("dacdiem_suaca"));
                                                                        dacdiemInput.sendKeys("Đặc điểm sửa đổi");

                                                                        WebElement dinhduongInput = driver.findElement(By.id("dinhduong_suaca"));
                                                                        dinhduongInput.sendKeys("Dinh dưỡng sửa đổi");

                                                                        WebElement phanloaiInput = driver.findElement(By.id("phanloai_suaca"));
                                                                        phanloaiInput.sendKeys("Phân loại sửa đổi");

                                                                        WebElement phanbietInput = driver.findElement(By.id("phanbiet_suaca"));
                                                                        phanbietInput.sendKeys("Phân biệt sửa đổi");

                                                                        // Tải ảnh lên nếu cần (ví dụ tải một ảnh)
                                                                        WebElement imagePath1Input = driver.findElement(By.id("image_pathca1"));
                                                                        imagePath1Input.sendKeys("E:\\Downloads\\koimoi.jpg"); // Đường dẫn tới ảnh

                                                                        WebElement imagePath2Input = driver.findElement(By.id("image_pathca2"));
                                                                        imagePath2Input.sendKeys("E:\\Downloads\\koimoi.jpg");

                                                                        WebElement imagePath3Input = driver.findElement(By.id("image_pathca3"));
                                                                        imagePath3Input.sendKeys("E:\\Downloads\\koimoi.jpg");

                                                                        WebElement imagePath4Input = driver.findElement(By.id("image_pathca4"));
                                                                        imagePath4Input.sendKeys("E:\\Downloads\\koimoi.jpg");

                                                                        // Nhấn vào nút "Sửa thông tin"
                                                                        WebElement submitButton2 = driver.findElement(By.cssSelector("button[type='submit']"));
                                                                        submitButton2.click();
                                                                        System.out.println("Submitted the 'Sửa thông tin cá Koi' form.");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn vào nút "Thông tin" trên header
                                                                        WebElement infoButton4 = driver.findElement(By.linkText("Thông tin"));
                                                                        infoButton4.click();
                                                                        System.out.println("Navigated to the 'Thông tin' page.");
                                                                        Thread.sleep(2000);

                                                                        // Tìm container chứa danh sách sản phẩm
                                                                        WebElement productList1 = driver.findElement(By.id("Ca")); // ID của container danh sách sản phẩm

                                                                        // Cuộn đến sản phẩm cuối cùng trong danh sách
                                                                        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollTop = arguments[0].scrollHeight;", productList1);
                                                                        System.out.println("Scrolled to the bottom of the product list.");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn vào sản phẩm cuối cùng
                                                                        WebElement lastProduct1 = driver.findElement(By.cssSelector("#Ca .char2:last-of-type")); // Sản phẩm cuối
                                                                        lastProduct1.click();
                                                                        System.out.println("Clicked on the last product.");
                                                                        Thread.sleep(2000);


                                                                        // Tìm phần tử "Xem chi tiết"
                                                                        WebElement xemChiTietButton1 = driver.findElement(By.cssSelector(".chitiet a"));
                                                                        // Nhấn vào nút "Xem chi tiết"
                                                                        xemChiTietButton1.click();
                                                                        System.out.println("Clicked on the 'Xem chi tiết' button.");
                                                                        Thread.sleep(2000);

                                                                        // Cuộn trang xuống cuối sau khi vào trang chi tiết sản phẩm
                                                                        JavascriptExecutor js9 = (JavascriptExecutor) driver;
                                                                        js9.executeScript("window.scrollTo(0, document.body.scrollHeight);");
                                                                        System.out.println("Scrolled to the bottom of the page.");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn vào nút "Quản trị" trên header
                                                                        WebElement adminButton2 = driver.findElement(By.linkText("Quản trị"));
                                                                        adminButton2.click();
                                                                        System.out.println("Clicked on the 'Quản trị' button.");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn vào liên kết "Xóa thông tin cá Koi"
                                                                        WebElement xoaThongTinCaKoiLink = driver.findElement(By.cssSelector("h2 a[href='XoaThongTinCaKoi.jsp']"));
                                                                        xoaThongTinCaKoiLink.click();
                                                                        System.out.println("Navigated to the 'Xóa thông tin cá Koi' page.");
                                                                        Thread.sleep(2000);

                                                                        // Điền thông tin vào form xóa
                                                                        WebElement nameXoaCaInput = driver.findElement(By.id("name_xoaca"));
                                                                        nameXoaCaInput.sendKeys("Cá Koi Mới");
                                                                        System.out.println("Entered the name of the Koi fish to delete.");

                                                                        // Nhấn vào nút "Xóa thông tin"
                                                                        WebElement deleteButton = driver.findElement(By.cssSelector("form[action='XoaKoiServlet'] button[type='submit']"));
                                                                        deleteButton.click();
                                                                        System.out.println("Submitted the delete form for the Koi fish.");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn vào nút "Thông tin" trên header
                                                                        WebElement infoButton5 = driver.findElement(By.linkText("Thông tin"));
                                                                        infoButton5.click();
                                                                        System.out.println("Navigated to the 'Thông tin' page.");
                                                                        Thread.sleep(2000);

                                                                        // Tìm container chứa danh sách sản phẩm
                                                                        WebElement productList2 = driver.findElement(By.id("Ca")); // ID của container danh sách sản phẩm

                                                                        // Cuộn đến sản phẩm cuối cùng trong danh sách
                                                                        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollTop = arguments[0].scrollHeight;", productList2);
                                                                        System.out.println("Scrolled to the bottom of the product list.");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn vào nút "Quản trị" trên header
                                                                        WebElement adminButton3 = driver.findElement(By.linkText("Quản trị"));
                                                                        adminButton3.click();
                                                                        System.out.println("Clicked on the 'Quản trị' button.");
                                                                        Thread.sleep(2000);

                                                                        // Tìm liên kết "Quản lí đơn hàng"
                                                                        WebElement quanLiDonHangLink = driver.findElement(By.cssSelector("h2 a[href='QuanLiDonHang.jsp']"));

                                                                        // Cuộn xuống để liên kết "Quản lí đơn hàng" hiển thị trong khung nhìn
                                                                        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView(true);", quanLiDonHangLink);
                                                                        System.out.println("Scrolled to the 'Quản lí đơn hàng' link.");

                                                                        // Nhấn vào liên kết "Quản lí đơn hàng"
                                                                        quanLiDonHangLink.click();
                                                                        System.out.println("Navigated to the 'Quản lí đơn hàng' page.");

                                                                        // Chờ một khoảng thời gian sau khi nhấn
                                                                        Thread.sleep(2000);


                                                                        // Cuộn xuống cuối trang để hiển thị danh sách đơn hàng
                                                                        WebElement lastOrderRow = driver.findElement(By.cssSelector("tr:last-of-type")); // Chọn dòng đơn hàng cuối cùng
                                                                        JavascriptExecutor js10 = (JavascriptExecutor) driver;
                                                                        js10.executeScript("arguments[0].scrollIntoView(true);", lastOrderRow);
                                                                        System.out.println("Scrolled to the last order row.");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn nút "Giao hàng" của sản phẩm cuối
                                                                        WebElement giaoHangButtonFirst = driver.findElement(By.xpath("//tr[1]//input[@value='Giao hàng']"));
                                                                        giaoHangButtonFirst.click();
                                                                        System.out.println("Clicked on the 'Giao hàng' button.");
                                                                        Thread.sleep(2000);

                                                                        // Tìm phần tử "Hoàn thành"
                                                                        WebElement hoanThanhButton = driver.findElement(By.xpath("//tr[last()]//input[@value='Hoàn thành']"));

                                                                        // Cuộn xuống phần tử trước khi nhấn
                                                                        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView(true);", hoanThanhButton);

                                                                        // Đợi một chút để đảm bảo phần tử đã được cuộn vào vị trí hiển thị
                                                                        Thread.sleep(1000);  // Chờ 1 giây

                                                                        // Nhấn vào nút "Hoàn thành"
                                                                        hoanThanhButton.click();
                                                                        System.out.println("Clicked on the 'Hoàn thành' button.");

                                                                        Thread.sleep(2000);


                                                                        // Nhấn vào nút "Quản trị" trên header
                                                                        WebElement adminButton4 = driver.findElement(By.linkText("Quản trị"));
                                                                        adminButton4.click();
                                                                        System.out.println("Clicked on the 'Quản trị' button.");
                                                                        Thread.sleep(2000);

                                                                        // Tìm liên kết "Quản lí người dùng"
                                                                        WebElement quanLiUsersButton = driver.findElement(By.xpath("//h2/a[@href='QuanLiUsers.jsp']"));

                                                                        // Cuộn xuống để liên kết "Quản lí người dùng" hiển thị trong khung nhìn
                                                                        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView(true);", quanLiUsersButton);
                                                                        System.out.println("Scrolled to the 'Quản lí người dùng' link.");

                                                                        // Nhấn vào liên kết "Quản lí người dùng"
                                                                        quanLiUsersButton.click();
                                                                        System.out.println("Clicked on 'Quản lí người dùng'.");

                                                                        Thread.sleep(2000);

                                                                        // Chờ đến khi trang quản lý hiển thị đầy đủ

                                                                        new WebDriverWait(driver, Duration.ofSeconds(5)).until(
                                                                                ExpectedConditions.presenceOfElementLocated(By.xpath("//td[contains(., 'vu001122')]"))
                                                                        );

                                                                        // Tìm dòng của người dùng 'vu001122' và cuộn xuống
                                                                        WebElement userRow = driver.findElement(By.xpath("//td[contains(., 'vu001122')]"));
                                                                        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView(true);", userRow);
                                                                        System.out.println("Scrolled to user 'vu001122'.");
                                                                        Thread.sleep(2000);

                                                                        // Tìm trường nhập "Thời gian cấm" cho người dùng 'vu001122'
                                                                        WebElement banDurationField = driver.findElement(By.xpath("//td[contains(., 'vu001122')]/following-sibling::td//input[@type='number' and @id='ban_duration']"));

                                                                        // Kiểm tra nếu trường nhập trống, sau đó nhập 1 phút
                                                                        if (banDurationField.getAttribute("value").isEmpty()) {
                                                                            banDurationField.sendKeys("1"); // Nhập 1 phút
                                                                            System.out.println("Entered '1' minute ban duration for user 'vu001122'.");
                                                                        }
                                                                        Thread.sleep(2000);

                                                                        // Tìm nút "Cấm" liên quan đến người dùng 'vu001122'
                                                                        WebElement banButton = driver.findElement(By.xpath("//td[contains(., 'vu001122')]/following-sibling::td//input[@value='Cấm']"));

                                                                        // Nhấn vào nút "Cấm"
                                                                        banButton.click();
                                                                        System.out.println("Banned user 'vu001122' after entering ban duration.");
                                                                        Thread.sleep(2000);

                                                                        // Chờ thêm chút thời gian sau khi nhấn nút "Cấm"
                                                                        new WebDriverWait(driver, Duration.ofSeconds(5)).until(
                                                                                ExpectedConditions.invisibilityOfElementLocated(By.xpath("//td[contains(., 'vu001122')]//input[@value='Cấm']"))
                                                                        );


                                                                        // Nhấn vào nút "Đăng xuất" trên header
                                                                        WebElement logoutButton1 = driver.findElement(By.linkText("Đăng xuất"));
                                                                        logoutButton1.click();
                                                                        System.out.println("Logged out.");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn vào nút "Đăng nhập" trên header
                                                                        WebElement loginButton2 = driver.findElement(By.linkText("Đăng nhập"));
                                                                        loginButton2.click();
                                                                        System.out.println("Clicked on the 'Đăng nhập' button.");
                                                                        Thread.sleep(2000);

                                                                        // Nhập tài khoản 'vu001122' và mật khẩu 'newpassword123'
                                                                        WebElement usernameField1 = driver.findElement(By.id("username"));
                                                                        usernameField1.sendKeys("vu001122");
                                                                        WebElement passwordField1 = driver.findElement(By.id("password"));
                                                                        passwordField1.sendKeys("newpassword123");

                                                                        // Nhấn nút submit để đăng nhập
                                                                        WebElement submitLoginButton1 = driver.findElement(By.cssSelector("button[type='submit']"));
                                                                        submitLoginButton1.click();
                                                                        System.out.println("Logged in with username 'vu001122'.");
                                                                        Thread.sleep(2000);

                                                                        // Đăng nhập với tài khoản khác 'vuad951236' và mật khẩu '951236vu'
                                                                        usernameField1 = driver.findElement(By.id("username"));
                                                                        usernameField1.clear();
                                                                        usernameField1.sendKeys("vuad951236");

                                                                        passwordField1 = driver.findElement(By.id("password"));
                                                                        passwordField1.clear();
                                                                        passwordField1.sendKeys("951236vu");

                                                                        WebElement submitLoginButton2 = driver.findElement(By.cssSelector("button[type='submit']"));
                                                                        // Nhấn submit để đăng nhập
                                                                        submitLoginButton2.click();
                                                                        System.out.println("Logged in with username 'vuad951236'.");
                                                                        Thread.sleep(2000);

                                                                        WebElement adminButton5 = driver.findElement(By.linkText("Quản trị"));
                                                                        adminButton5.click();
                                                                        System.out.println("Clicked on the 'Quản trị' button.");
                                                                        Thread.sleep(2000);

                                                                        // Tìm liên kết "Quản lí người dùng"
                                                                        WebElement quanLiUsersButton1 = driver.findElement(By.xpath("//h2/a[@href='QuanLiUsers.jsp']"));

                                                                        // Cuộn xuống để liên kết "Quản lí người dùng" hiển thị trong khung nhìn
                                                                        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView(true);", quanLiUsersButton1);
                                                                        System.out.println("Scrolled to the 'Quản lí người dùng' link.");

                                                                        // Nhấn vào liên kết "Quản lí người dùng"
                                                                        quanLiUsersButton1.click();
                                                                        System.out.println("Clicked on 'Quản lí người dùng'.");

                                                                        Thread.sleep(2000);

                                                                        // Tìm tài khoản có username là 'vu001122'
                                                                        WebElement userRow1 = driver.findElement(By.xpath("//td[contains(text(),'vu001122')]"));
                                                                        System.out.println("Found user 'vu001122'.");

                                                                        // Cuộn xuống nếu tài khoản không ở trong khung nhìn
                                                                        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView(true);", userRow1);
                                                                        System.out.println("Scrolled to user 'vu001122'.");
                                                                        Thread.sleep(2000);

                                                                        // Tìm nút "Xóa" liên quan đến tài khoản 'vu001122'
                                                                        WebElement deleteButton1 = driver.findElement(By.xpath("//td[contains(text(),'vu001122')]/following-sibling::td//input[@value='Xóa']"));

                                                                        // Nhấn vào nút "Xóa"
                                                                        deleteButton1.click();
                                                                        System.out.println("Clicked on the 'Xóa' button for user 'vu001122'.");

                                                                        Thread.sleep(2000);

                                                                        WebElement quanTriButton = driver.findElement(By.xpath("//a[contains(text(),'Quản trị')]"));
                                                                        quanTriButton.click();
                                                                        System.out.println("Clicked on 'Quản trị' button.");

                                                                        Thread.sleep(2000);

                                                                        // Cuộn xuống và nhấn vào "Tạo ID Admin"
                                                                        WebElement taoIdAdminLink = driver.findElement(By.xpath("//h2/a[@href='TaoIdAdmin.jsp']"));
                                                                        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView(true);", taoIdAdminLink);
                                                                        taoIdAdminLink.click();
                                                                        System.out.println("Navigated to 'Tạo ID Admin'.");

                                                                        Thread.sleep(2000);

                                                                        // Điền thông tin để tạo ID Admin
                                                                        WebElement adminIdField = driver.findElement(By.id("adminId"));
                                                                        adminIdField.sendKeys("admin123");  // ID Admin mới

                                                                        Thread.sleep(2000);

                                                                        WebElement createAdminButton = driver.findElement(By.xpath("//button[text()='Tạo ID']"));
                                                                        createAdminButton.click();
                                                                        System.out.println("Created Admin ID.");

                                                                        // Chờ một khoảng thời gian sau khi tạo ID Admin
                                                                        Thread.sleep(2000);

                                                                        WebElement logoutButton2 = driver.findElement(By.xpath("//a[contains(text(),'Đăng xuất')]"));
                                                                        logoutButton2.click();
                                                                        System.out.println("Logged out.");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn vào nút "Đăng nhập" trên header
                                                                        WebElement loginButton3 = driver.findElement(By.xpath("//a[contains(text(),'Đăng nhập')]"));
                                                                        loginButton3.click();
                                                                        System.out.println("Navigated to login page.");
                                                                        Thread.sleep(2000);

                                                                        // Nhấn vào liên kết "Đăng ký tại đây" sau khi vào trang Đăng nhập
                                                                        WebElement registerLink1 = driver.findElement(By.xpath("//p[contains(text(),'Bạn chưa có tài khoản?')]//a"));
                                                                        registerLink1.click();
                                                                        System.out.println("Navigated to register page.");
                                                                        Thread.sleep(2000);


                                                                        WebElement usernameField2 = driver.findElement(By.id("username"));
                                                                        usernameField2.sendKeys("newuser");

                                                                        WebElement passwordField2 = driver.findElement(By.id("password"));
                                                                        passwordField2.sendKeys("password123");

                                                                        WebElement emailField1 = driver.findElement(By.id("email"));
                                                                        emailField1.sendKeys("newuser@example.com");

                                                                        WebElement fullnameField1 = driver.findElement(By.id("fullname"));
                                                                        fullnameField1.sendKeys("New User");

                                                                        WebElement addressField1 = driver.findElement(By.id("address"));
                                                                        addressField1.sendKeys("123 Main Street");

                                                                        WebElement adminCodeField1 = driver.findElement(By.id("admin_code"));
                                                                        adminCodeField1.sendKeys("admin123");  // Mã Admin vừa tạo

                                                                        WebElement registerButton1 = driver.findElement(By.xpath("//button[@name='register']"));
                                                                        registerButton1.click();
                                                                        System.out.println("Registered new account.");

                                                                        Thread.sleep(2000);

                                                                        WebElement loginUsernameField1 = driver.findElement(By.id("username"));
                                                                        loginUsernameField1.sendKeys("newuser");

                                                                        WebElement loginPasswordField1 = driver.findElement(By.id("password"));
                                                                        loginPasswordField1.sendKeys("password123");

                                                                        WebElement loginSubmitButton1 = driver.findElement(By.xpath("//button[@type='submit']"));
                                                                        loginSubmitButton1.click();
                                                                        System.out.println("Logged in with the new account.");

                                                                        Thread.sleep(3000);

                                                                    } else {
                                                                        System.out.println("Failed to return to the product page.");
                                                                    }

                                                            } else {
                                                                    System.out.println("Failed to return to the product page.");
                                                                }

                                                            } else {
                                                                System.out.println("Failed to enter the detail page.");
                                                            }
                                                            
                                                        } else {
                                                            System.out.println("Failed to return to the product page.");
                                                        }

                                                    } else {
                                                        System.out.println("Failed to enter the detail page.");
                                                    }
                                                } else {
                                                    System.out.println("Login failed.");
                                                }


                                            } else {
                                                System.out.println("Failed to return to the information page.");
                                            }

                                        } catch (Exception e) {
                                            System.out.println("Error while clicking the 'Thông tin' button on the header: " + e.getMessage());
                                        }
                                    } else {
                                        System.out.println("Failed to enter the detail page from 'Thông tin Hồ'.");
                                    }

                                } else {
                                    System.out.println("Failed to navigate to 'Thông tin Hồ' section.");
                                }
                            } else {
                                System.out.println("Failed to return to the information page!");
                            }
                        } else {
                            System.out.println("Failed to enter the detail page!");
                        }

                    } else {
                        System.out.println("Login failed.");
                    }
                } else {
                    System.out.println("Registration failed.");
                }
            } else {
                System.out.println("Go to the failed login page.");
            }
        } catch (Exception e) {
            System.out.println("Bug in test case: " + e.getMessage());
        }

        // Đóng trình duyệt
        driver.quit();
    }
}