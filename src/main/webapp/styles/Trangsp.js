var tooltip1Visible = false; // Biến để kiểm tra xem tooltip1 đã hiển thị khi tải trang hay chưa
var tooltip50Visible = false; // Biến để kiểm tra xem tooltip1 đã hiển thị khi tải trang hay chưa
var currentTooltip = null; // Biến để lưu trữ tooltip hiện đang hiển thị
var currentTooltip1 = null; // Biến để lưu trữ tooltip hiện đang hiển thị

document.addEventListener('DOMContentLoaded', function() {
    var jsonDataDiv = document.getElementById('jsonData');
    var jsonData = JSON.parse(jsonDataDiv.getAttribute('data-json'));

    // Kiểm tra nếu jsonData chứa ít nhất hai sản phẩm
    if (jsonData.length >= 2) {
        var product1 = jsonData[1];

        // Định dạng giá với 1 chữ số sau dấu phẩy
        var price1 = parseFloat(product1.price1).toFixed(1);
        var url1 = product1.details_link;
        var imagePaths1 = [product1.image_path].filter(function(path) {
            return path !== null;
        }).map(function(path) {
            if (path.startsWith('http://') || path.startsWith('https://')) {
                return path;
            } else {
                return 'http://localhost:8080/Gradle___com_example___demo1_war/' + path;
            }
        });
        showTooltip1(price1, imagePaths1, 'tooltip' + product1.id, url1);

        var product = jsonData[0];
        var price = parseFloat(product.price).toFixed(1); // Định dạng giá với 1 chữ số sau dấu phẩy
        var url = product1.details_link;
        var imagePaths = [product.image_path].filter(function(path) {
            return path !== null;
        }).map(function(path) {
            if (path.startsWith('http://') || path.startsWith('https://')) {
                return path;
            } else {
                return 'http://localhost:8080/Gradle___com_example___demo1_war/' + path;
            }
        });

        showTooltip(price, imagePaths, 'tooltip' + product.id , url);
    } else {
        console.error('Not enough products in JSON data');
    }
});



function showTooltip1(content1, imageUrls1, tooltipId1, pageUrl) {
    var tooltip1 = document.getElementById(tooltipId1);
    var detailsLinkElement = document.querySelector('.chitiet');
    // Trong hàm showTooltip
    tooltip1.classList.add('tooltip');

    // Hiển thị tooltip 1 mặc định khi trang được tải lên
    if (tooltipId1 === 'tooltip50' && !tooltip50Visible ) {
        tooltip50Visible = true;
        detailsLinkElement.style.display = 'block'; // Hiển thị div chi tiết
    }
    
    // Nếu tooltip hiện đang được hiển thị, ẩn nó trước khi hiển thị tooltip mới
    if (currentTooltip1 !== null && currentTooltip1 !== tooltipId1) {
        hideTooltip1(currentTooltip1);
    }

    // Xóa bỏ tất cả các thẻ <img> hiện có trong tooltip
    while (tooltip1.firstChild) {
        tooltip1.removeChild(tooltip1.firstChild);
    }
    
    // Cập nhật tooltip hiện đang được hiển thị
    currentTooltip1 = tooltipId1;
    var imageSizes = [
        { width: '330px', height: '' }, // kích thước của hình ảnh thứ nhất
        { width: '350px', height: '' }, // kích thước của hình ảnh thứ hai
        { width: '100px', height: '' },
        { width: '300px', height: '' },
        { width: '250px', height: '' },
        { width: '250px', height: '' }
        // và tiếp tục cho các hình ảnh khác
    ];
    var imagePositions = [
        { left: '-95px', top: '-490px' }, // Vị trí của hình ảnh thứ nhất
        { left: '-245px', top: '-500px' }, // Vị trí của hình ảnh thứ hai
        { left: '170px', top: '-450px' },
        { left: '-20px', top: '-200px' },
        { left: '-230px', top: '-363px' },
        { left: '-230px', top: '-208px' }
        // và tiếp tục cho các hình ảnh khác
    ];
    var imageOpacities = [
        1, // Độ trong suốt của hình ảnh thứ nhất
        1, // Độ trong suốt của hình ảnh thứ hai
        1,
        1,
        1,
        1
        // và tiếp tục cho các hình ảnh khác
    ];
    
    // Kiểm tra xem hình ảnh đã được hiển thị trong tooltip chưa
    if (!tooltip1.querySelector('img')) {
        imageUrls1.forEach(function(imageUrl1, index1) {
            // Tạo một thẻ <img> mới để hiển thị hình ảnh trong tooltip
            var imgElement = document.createElement('img');
            imgElement.src = imageUrl1; // Đường dẫn của hình ảnh
            // Kiểm tra xem có kích thước nào được định nghĩa không, nếu không thì sử dụng mặc định
            if (imageSizes[index1]) {
                imgElement.style.width = imageSizes[index1].width; // Đặt chiều rộng của hình ảnh
                imgElement.style.height = imageSizes[index1].height; // Đặt chiều cao của hình ảnh
            } else {
                imgElement.style.width = '300px'; // Kích thước mặc định nếu không được định nghĩa
            }
            // Kiểm tra xem có opacity nào được định nghĩa không, nếu không thì sử dụng mặc định
            if (imageOpacities[index1] !== undefined) {
                imgElement.style.opacity = imageOpacities[index1];
            }
            // Kiểm tra xem có vị trí nào được định nghĩa không, nếu không thì sử dụng mặc định
            if (imagePositions[index1]) {
                imgElement.style.position = 'absolute'; // Cần thiết để đặt vị trí tương đối với tooltip
                imgElement.style.left = imagePositions[index1].left; // Đặt vị trí ngang của hình ảnh
                imgElement.style.top = imagePositions[index1].top; // Đặt vị trí dọc của hình ảnh
            }
            // Chèn hình ảnh vào tooltip
            tooltip1.appendChild(imgElement);
        });
    }

    // Kiểm tra xem tooltip đã chứa thẻ <p> chưa
    var textElement1 = tooltip1.querySelector('p');
    if (!textElement1) {
        // Nếu không, tạo một thẻ <p> mới và chèn vào tooltip
        textElement1 = document.createElement('p');
        textElement1.id = 'p1'; // Đặt id để phân biệt
        tooltip1.appendChild(textElement1);
    }
    textElement1.textContent = "$" + content1;

    tooltip1.classList.add('active'); // Thêm class 'active' để hiển thị ghi chú
}

function showTooltip(content, imageUrls, tooltipId, pageUrl) {
    var tooltip = document.getElementById(tooltipId);
    var detailsLinkElement = document.querySelector('.chitiet');
    // Trong hàm showTooltip
    tooltip.classList.add('tooltip');

    // Hiển thị tooltip 1 mặc định khi trang được tải lên
    if (tooltipId === 'tooltip1' && !tooltip1Visible) {
        tooltip1Visible = true;
        detailsLinkElement.style.display = 'block'; // Hiển thị div chi tiết
    }
    
    // Nếu tooltip hiện đang được hiển thị, ẩn nó trước khi hiển thị tooltip mới
    if (currentTooltip !== null && currentTooltip !== tooltipId) {
        hideTooltip(currentTooltip);
    }
    
    // Xóa bỏ tất cả các thẻ <img> hiện có trong tooltip
    while (tooltip.firstChild) {
        tooltip.removeChild(tooltip.firstChild);
    }
    
    // Cập nhật tooltip hiện đang được hiển thị
    currentTooltip = tooltipId;
    var imageSizes = [
        { width: '330px', height: '' }, // kích thước của hình ảnh thứ nhất
        { width: '350px', height: '' }, // kích thước của hình ảnh thứ hai
        { width: '100px', height: '' },
        { width: '300px', height: '' },
        { width: '250px', height: '' },
        { width: '250px', height: '' }
        // và tiếp tục cho các hình ảnh khác
    ];
    var imagePositions = [
        { left: '-95px', top: '-530px' }, // Vị trí của hình ảnh thứ nhất
        { left: '-245px', top: '-500px' }, // Vị trí của hình ảnh thứ hai
        { left: '170px', top: '-450px' },
        { left: '-20px', top: '-200px' },
        { left: '-230px', top: '-363px' },
        { left: '-230px', top: '-208px' }
        // và tiếp tục cho các hình ảnh khác
    ];
    var imageOpacities = [
        1, // Độ trong suốt của hình ảnh thứ nhất
        1, // Độ trong suốt của hình ảnh thứ hai
        1,
        1,
        1,
        1
        // và tiếp tục cho các hình ảnh khác
    ];
    
    // Kiểm tra xem hình ảnh đã được hiển thị trong tooltip chưa
    if (!tooltip.querySelector('img')) {
        imageUrls.forEach(function(imageUrl, index) {
            // Tạo một thẻ <img> mới để hiển thị hình ảnh trong tooltip
            var imgElement = document.createElement('img');
            imgElement.src = imageUrl; // Đường dẫn của hình ảnh
            // Kiểm tra xem có kích thước nào được định nghĩa không, nếu không thì sử dụng mặc định
            if (imageSizes[index]) {
                imgElement.style.width = imageSizes[index].width; // Đặt chiều rộng của hình ảnh
                imgElement.style.height = imageSizes[index].height; // Đặt chiều cao của hình ảnh
            } else {
                imgElement.style.width = '300px'; // Kích thước mặc định nếu không được định nghĩa
            }
            // Kiểm tra xem có opacity nào được định nghĩa không, nếu không thì sử dụng mặc định
            if (imageOpacities[index] !== undefined) {
                imgElement.style.opacity = imageOpacities[index];
            }
            // Kiểm tra xem có vị trí nào được định nghĩa không, nếu không thì sử dụng mặc định
            if (imagePositions[index]) {
                imgElement.style.position = 'absolute'; // Cần thiết để đặt vị trí tương đối với tooltip
                imgElement.style.left = imagePositions[index].left; // Đặt vị trí ngang của hình ảnh
                imgElement.style.top = imagePositions[index].top; // Đặt vị trí dọc của hình ảnh
            }
            // Chèn hình ảnh vào tooltip
            tooltip.appendChild(imgElement);
        });
    }

    // Kiểm tra xem tooltip đã chứa thẻ <p> chưa
    var textElement = tooltip.querySelector('p');
    if (!textElement) {
        // Nếu không, tạo một thẻ <p> mới và chèn vào tooltip
        textElement = document.createElement('p');
        tooltip.appendChild(textElement);
    }
    textElement.textContent = "$" + content;

    tooltip.classList.add('active'); // Thêm class 'active' để hiển thị ghi chú
}

function hideTooltip1(tooltipId1) {
    // Lấy số ID từ tooltipId
    var tooltipNumber1 = parseInt(tooltipId1.replace('tooltip', ''));
    
    // Kiểm tra xem ID có lớn hơn 50 không
    if (49 < tooltipNumber1 < 100) {
        var tooltip1 = document.getElementById(tooltipId1);
        // Nếu tooltip tồn tại và đang hiển thị, ẩn nó
        if (tooltip1 && tooltip1.classList.contains('active') && 49 < tooltipNumber1 < 100) {
            // Xóa nội dung của tooltip để chuẩn bị cho lần hiển thị tiếp theo
            while (tooltip1.firstChild) {
                tooltip1.removeChild(tooltip1.firstChild);
            }
            tooltip1.classList.remove('active');
        }
        // Đặt currentTooltip về null
        currentTooltip1 = null;
    }
}

function hideTooltip(tooltipId) {
    // Lấy số ID từ tooltipId
    var tooltipNumber = parseInt(tooltipId.replace('tooltip', ''));
    
    // Kiểm tra xem ID có lớn hơn 50 không
    if (0 < tooltipNumber < 50) {
        var tooltip = document.getElementById(tooltipId);
        // Nếu tooltip tồn tại và đang hiển thị, ẩn nó
        if (tooltip && tooltip.classList.contains('active') && 0 < tooltipNumber < 50) {
            // Xóa nội dung của tooltip để chuẩn bị cho lần hiển thị tiếp theo
            while (tooltip.firstChild) {
                tooltip.removeChild(tooltip.firstChild);
            }
            tooltip.classList.remove('active');
        }
        // Đặt currentTooltip về null
        currentTooltip = null;
    }
}


// Khai báo biến global để lưu trữ chi tiết đang hiển thị
var currentShownDetails = null;

document.addEventListener("DOMContentLoaded", function() {
    const links = document.querySelectorAll(".tocsp a");

    // Function to check if the top or bottom of a section is visible
    function isSectionVisible(section) {
        const rect = section.getBoundingClientRect();
        return (
            rect.top >= 0 &&
            rect.bottom <= (window.innerHeight || document.documentElement.clientHeight)
        );
    }

    // Update active link based on section visibility
    function updateActiveLink() {
        links.forEach(function(link) {
            const sectionId = link.getAttribute('href').replace('#', '');
            const section = document.getElementById(sectionId);
            if (section && isSectionVisible(section)) {
                links.forEach(function(link) {
                    link.classList.remove('active');
                });
                link.classList.add('active');
            }
        });
    }

    // Add scroll event listener to update active link
    window.addEventListener('scroll', updateActiveLink);

    // Initial check
    updateActiveLink();
});


function showNotification(message) {
    var notification = document.getElementById("notification");
    notification.innerHTML = message;
    notification.style.display = "block";
    setTimeout(function() {
        notification.style.display = "none";
    }, 1000); // Hiển thị thông báo trong 1 giây
}

function copyUID() {
    var uid = document.getElementById("uidValue").innerText;
    navigator.clipboard.writeText(uid).then(function() {
        showNotification("UID đã được sao chép: " + uid);
    }, function(err) {
        console.error('Lỗi khi sao chép UID: ', err);
    });
}

window.addEventListener('scroll', function() {
    var header = document.querySelector('header');
    var main = document.querySelector('.main');
    
    // Nếu vị trí cuộn của trình duyệt lớn hơn hoặc bằng vị trí offset của phần avt
    if (window.scrollY >= main.offsetTop) {
        header.classList.add('scrolled'); // Thêm lớp 'scrolled' cho header
    } else {
        header.classList.remove('scrolled'); // Loại bỏ lớp 'scrolled' khỏi header
    }
});

function addToCart(color, size) {
    // Send color and size information to server using AJAX
    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'add_to_cart.php', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            // Handle response from server if needed
            console.log(xhr.responseText);
        }
    };
    xhr.send('color=' + color + '&size=' + size);
}

function toggleCart() {
    var cartPopup = document.getElementById('cart-popup');
    // Toggle display property of cart popup
    if (cartPopup.style.display === 'block') {
        cartPopup.style.display = 'none';
    } else {
        // Hiển thị cửa sổ giỏ hàng
        cartPopup.style.display = 'block';
        // Gọi hàm để lấy thông tin từ bảng gio_hang và hiển thị trong cửa sổ giỏ hàng
        getCartItems();
    }
}

function getCartItems() {
    // Thực hiện yêu cầu Ajax để lấy thông tin từ bảng gio_hang
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var cartItems = JSON.parse(xhr.responseText);
            // Hiển thị thông tin từ bảng gio_hang trong cửa sổ giỏ hàng
            displayCartItems(cartItems);
        }
    };
    xhr.open("GET", "getCartItems.php", true);
    xhr.send();
}

function displayCartItems(cartItems) {
    var productContainer = document.querySelector('.product-list');
    productContainer.innerHTML = ''; // Xóa nội dung danh sách sản phẩm hiện có

    // Duyệt qua mỗi mục trong giỏ hàng và thêm vào danh sách sản phẩm
    cartItems.forEach(function(item) {
        var listItem = document.createElement('li');
        listItem.textContent = item.ten_san_pham + ' - ' + item.mau + ' - ' + item.kich_co + ' - ' + item.gia_tien + '₫';

        // Tạo một nút để xóa sản phẩm
        var removeButton = document.createElement('button');
        removeButton.textContent = 'X';
        removeButton.classList.add('remove-btn'); // Thêm lớp cho nút X
        removeButton.addEventListener('click', function() {
            removeCartItem(item.id); // Gọi hàm để xóa mục khỏi giỏ hàng
        });

        // Thêm nút xóa vào mục danh sách
        listItem.appendChild(removeButton);

        // Thêm mục danh sách vào container sản phẩm
        productContainer.appendChild(listItem);
    });
}


function removeCartItem(itemId) {
    // Gửi yêu cầu AJAX để xóa mục khỏi giỏ hàng
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            // Xử lý phản hồi từ máy chủ (nếu cần)
            console.log(xhr.responseText);
            window.location.reload();
        }
    };
    xhr.open("POST", "removeCartItem.php", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.send("item_id=" + encodeURIComponent(itemId));
}



document.addEventListener("DOMContentLoaded", function() {
    // Kiểm tra trạng thái của trang khi tải lại
    const navigationEntries = performance.getEntriesByType("navigation");
    const isReloaded = navigationEntries.length > 0 && navigationEntries[0].type === "reload";
    
    if (isReloaded) {
        // Nếu trang được tải lại, ẩn giỏ hàng
        const cartPopup = document.getElementById("cart-popup");
        if (cartPopup) {
            cartPopup.style.display = "none";
        }
    }
});
function checkout() {
    // Gửi yêu cầu AJAX để lấy thông tin màu và size từ bảng gio_hang
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            // Xử lý câu trả lời từ máy chủ
            var response = JSON.parse(xhr.responseText);
            if (response.success) {
                // Lặp qua từng hàng dữ liệu và giảm số lượng
                response.data.forEach(function(row) {
                    decreaseInventory(row.ten_san_pham, row.mau, row.kich_co);
                });
            } else {
                console.log("Error retrieving data from gio_hang table.");
            }
        }
    };
    xhr.open("GET", "getSelectedColorAndSize.php", true);
    xhr.send();
}

function decreaseInventory(productName, color, size) {
    // Gửi yêu cầu AJAX để giảm số lượng sản phẩm cụ thể trong giỏ hàng
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            // Xử lý câu trả lời từ máy chủ (nếu cần)
            console.log(xhr.responseText);
            window.location.reload();
        }
    };
    xhr.open("POST", "decreaseInventory.php", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.send("ten_san_pham=" + encodeURIComponent(productName) + "&mau=" + encodeURIComponent(color) + "&kich_co=" + encodeURIComponent(size));
}



