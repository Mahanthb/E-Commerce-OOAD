package com.springspartans.shopkart.factory;

import com.springspartans.shopkart.model.Product;

public class ProductFactory {

    public static Product createProduct(int id, String name, String category, String brand, double price, String image, int stock, double discount) {
        return new Product(id, name, category, brand, price, image, stock, discount);
    }
}