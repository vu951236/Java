let currentIndex = 0;
const items = document.querySelectorAll('.carousel-item');
const totalItems = items.length;

function showItem(index) {
    items.forEach((item, i) => {
        item.classList.remove('active');
        if (i === index) {
            item.classList.add('active');
        }
    });
}

document.getElementById('nextBtn').addEventListener('click', function() {
    currentIndex = (currentIndex + 1) % totalItems;
    showItem(currentIndex);
});

document.getElementById('prevBtn').addEventListener('click', function() {
    currentIndex = (currentIndex - 1 + totalItems) % totalItems;
    showItem(currentIndex);
});

// Automatic carousel rotation
setInterval(() => {
    currentIndex = (currentIndex + 1) % totalItems;
    showItem(currentIndex);
}, 3000);