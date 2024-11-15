function checkWaterParameters() {
    const temperature = parseFloat(document.getElementById('temperature').value);
    const salinity = parseFloat(document.getElementById('salinity').value);
    const ph = parseFloat(document.getElementById('ph').value);
    const oxygen = parseFloat(document.getElementById('oxygen').value);
    const nitrite = parseFloat(document.getElementById('nitrite').value);
    const nitrate = parseFloat(document.getElementById('nitrate').value);
    const phosphate = parseFloat(document.getElementById('phosphate').value);

    let message = "Các thông số nước không đạt chuẩn:\n";
    let hasIssues = false;

    // Kiểm tra các thông số theo tiêu chuẩn
    if (temperature < 22 || temperature > 28) {
        message += "- Nhiệt độ nên từ 22°C đến 28°C.\n";
        hasIssues = true;
    }
    if (salinity < 0.5 || salinity > 2.0) {
        message += "- Nồng độ muối nên từ 0.5 g/l đến 2.0 g/l.\n";
        hasIssues = true;
    }
    if (ph < 6.5 || ph > 7.5) {
        message += "- pH nên từ 6.5 đến 7.5.\n";
        hasIssues = true;
    }
    if (oxygen < 5 || oxygen > 18) {
        message += "- Lượng O₂ nên từ 5 mg/l đến 18 mg/l.\n";
        hasIssues = true;
    }
    if (nitrite > 0.5) {
        message += "- Nồng độ NO₂ không nên vượt quá 0.5 mg/l.\n";
        hasIssues = true;
    }
    if (nitrate > 20) {
        message += "- Nồng độ NO₃ không nên vượt quá 20 mg/l.\n";
        hasIssues = true;
    }
    if (phosphate > 0.5) {
        message += "- Nồng độ PO₄ không nên vượt quá 0.5 mg/l.\n";
        hasIssues = true;
    }

    const notificationDiv = document.getElementById('waterQualityNotification');
    if (hasIssues) {
        notificationDiv.innerText = message;
    } else {
        notificationDiv.innerText = "Tất cả các thông số nước đều đạt chuẩn.";
    }
}
