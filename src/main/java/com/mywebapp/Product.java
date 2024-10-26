package com.mywebapp;

public class Product {
    private int id;
    private String name;
    private String imagePath;
    private double price;
    private String ghichu;
    private String loai;

    public Product(String ghichu) {
        this.ghichu = ghichu;
        this.id = id;
        this.name = name;
        this.imagePath = imagePath;
        this.price = price;
        this.loai = loai;
    }

    public Product() {

    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getPrice() {
        return price;
    }

    public String getghichu() {
        return ghichu;
    }

    public void setghichu(String ghichu) {
        this.ghichu = ghichu;
    }

    public void setloai(String loai) {
        this.loai = loai;
    }
    public String getloai() {
        return loai;
    }
}

