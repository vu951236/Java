var currentImageIndex = []; // Mảng để lưu chỉ số hình ảnh hiện tại của từng banner

document.addEventListener("DOMContentLoaded", function () {
    var banners = document.querySelectorAll('.banner-container');
    for (var j = 0; j < banners.length; j++) {
        currentImageIndex[j] = 0; // Khởi tạo tất cả các chỉ số hình ảnh cho từng banner
    }
});

function nextImagethongtin() {
    var banners = document.querySelectorAll('.banner-container');
    for (var j = 0; j < banners.length; j++) {
        currentImageIndex[j] = (currentImageIndex[j] + 1) % banners.length; // Tăng chỉ số, nếu vượt quá số lượng hình, quay lại 0
        showCurrentImagethongtin(j); // Hiển thị hình ảnh hiện tại
    }
}

function prevImagethongtin() {
    var banners = document.querySelectorAll('.banner-container');
    for (var j = 0; j < banners.length; j++) {
        currentImageIndex[j] = (currentImageIndex[j] - 1 + banners.length) % banners.length; // Giảm chỉ số, nếu nhỏ hơn 0, quay lại cuối
        showCurrentImagethongtin(j); // Hiển thị hình ảnh hiện tại
    }
}

function showCurrentImagethongtin(index) {
    var banners = document.querySelectorAll('.banner-container');
    for (var j = 0; j < banners.length; j++) {
        banners[j].style.display = 'none'; // Ẩn tất cả các banner
    }
    banners[currentImageIndex[index]].style.display = 'block'; // Hiển thị banner theo chỉ số hiện tại
}


document.addEventListener("DOMContentLoaded", function () {
    const links = document.querySelectorAll(".toc a");

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
        links.forEach(function (link) {
            const sectionId = link.getAttribute('href').replace('#', '');
            const section = document.getElementById(sectionId);
            if (section && isSectionVisible(section)) {
                links.forEach(function (link) {
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


window.addEventListener('scroll', function () {
    var header = document.querySelector('header');
    var avt = document.querySelector('.main');

    // Nếu vị trí cuộn của trình duyệt lớn hơn hoặc bằng vị trí offset của phần avt
    if (window.scrollY >= avt.offsetTop) {
        header.classList.add('scrolled'); // Thêm lớp 'scrolled' cho header
    } else {
        header.classList.remove('scrolled'); // Loại bỏ lớp 'scrolled' khỏi header
    }
});


// JavaScript để hiển thị banner của màu đầu tiên sau khi tải lại trang
window.onload = function () {
    var firstColorOption = document.querySelector('.color-option');
    if (firstColorOption) {
        var firstColor = firstColorOption.getAttribute('data-color');
        showImage(firstColor);
    }
};
window.addEventListener('beforeunload', function () {
    const banners = document.querySelectorAll('.banner-container');
    banners.forEach(function (banner) {
        banner.style.display = 'none';
    });
});

function showImage(color) {
    var banners = document.querySelectorAll('.banner-container');
    for (var i = 0; i < banners.length; i++) {
        banners[i].style.display = 'none';
    }
    var selectedBanner = document.querySelector('.banner-' + color);
    if (selectedBanner) {
        selectedBanner.style.display = 'block';
        currentImageIndex[color] = 0;
        showCurrentImage(color);
    }
    else{
        console.log('Banner for color ' + color + ' not found.');
    }
    // Ẩn dấu chấm từ tất cả các màu
    var colorOptions = document.querySelectorAll('.color-option');
    colorOptions.forEach(function (option) {
        option.innerHTML = option.innerHTML.replace('● ', ''); // Xóa dấu chấm (nếu có)
    });
    // Ẩn dấu chấm từ tất cả các size
    var sizeLabels = document.querySelectorAll('.size-label');
    sizeLabels.forEach(function (label) {
        label.innerHTML = label.innerHTML.replace('● ', ''); // Xóa dấu chấm (nếu có)
    });
    // Thêm dấu chấm vào màu được chọn
    var selectedColorOption = document.querySelector('.color-option[data-color="' + color + '"]');
    if (selectedColorOption) {
        selectedColorOption.innerHTML = '● ' + selectedColorOption.innerHTML;
        selectedColor = color;
    }
}
var currentImageIndex = {}; // Đảm bảo bạn đã khởi tạo đối tượng này ở nơi khác trong mã




function showCurrentImage(color) {
    var images = document.querySelectorAll('.banner-' + color + ' .banner-img');
    for (var i = 0; i < images.length; i++) {
        images[i].style.display = 'none';
    }
    images[currentImageIndex[color]].style.display = 'block';
}


function nextImage(color) {
    var images = document.querySelectorAll('.banner-' + color + ' .banner-img');
    currentImageIndex[color]++;
    if (currentImageIndex[color] >= images.length) {
        currentImageIndex[color] = 0;
    }
    showCurrentImage(color);
}

function prevImage(color) {
    var images = document.querySelectorAll('.banner-' + color + ' .banner-img');
    currentImageIndex[color]--;
    if (currentImageIndex[color] < 0) {
        currentImageIndex[color] = images.length - 1;
    }
    showCurrentImage(color);
}

function selectSize(sizeElement) {
    // Xóa dấu chấm từ tất cả các size
    var sizeLabels = document.querySelectorAll('.size-label');
    sizeLabels.forEach(function (label) {
        label.innerHTML = label.innerHTML.replace('● ', ''); // Xóa dấu chấm (nếu có)
    });

    // Thêm dấu chấm vào size được chọn
    var selectedLabel = sizeElement.querySelector('.size-label');
    selectedLabel.innerHTML = '● ' + selectedLabel.innerHTML;

    // Lấy màu của size được chọn
    var localSelectedColor = sizeElement.getAttribute('data-color'); // Sử dụng biến cục bộ khác tên

    // Hiển thị dấu chấm trước màu của size đang được chọn
    var colorOptions = document.querySelectorAll('.color-option');
    var sizeOptions = document.querySelectorAll('.size-option');
    colorOptions.forEach(function (option) {
        // Kiểm tra xem đã có dấu chấm cho màu này chưa
        var existingDot = option.innerHTML.startsWith('● ');
        if (option.getAttribute('data-color') === localSelectedColor && !existingDot) {
            option.innerHTML = '● ' + option.innerHTML;
        } else if (option.getAttribute('data-color') !== localSelectedColor && existingDot) {
            option.innerHTML = option.innerHTML.replace('● ', ''); // Xóa dấu chấm (nếu có)
        }
    });
    // Hiển thị dấu chấm trước size được chọn
    sizeOptions.forEach(function (option) {
        var existingDot = option.innerHTML.startsWith('● ');
        if (option === sizeElement && !existingDot) {
            selectedLabel.innerHTML = '● ' + selectedLabel.innerHTML;
        } else if (option !== sizeElement && existingDot) {
            option.querySelector('.size-label').innerHTML = option.querySelector('.size-label').innerHTML.replace('● ', ''); // Xóa dấu chấm (nếu có)
        }
    });

    // Lấy màu của size được chọn
    selectedColor = localSelectedColor; // Sử dụng biến toàn cục
    var selectedSize = sizeElement.getAttribute('data-size');

    // Hiển thị banner của màu tương ứng
    showImage(localSelectedColor);

    var selectedColor = sizeElement.getAttribute('data-color');
    var selectedSize = sizeElement.getAttribute('data-size');

    // Send data to server using AJAX
    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'update_database.php', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            // Handle response from server if needed
            console.log(xhr.responseText);
        }
    };
    xhr.send('color=' + selectedColor + '&size=' + selectedSize);
        
}    
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

