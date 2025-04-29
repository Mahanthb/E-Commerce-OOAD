package com.springspartans.shopkart.service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.springspartans.shopkart.exception.InvalidImageUploadException;
import com.springspartans.shopkart.model.Product;
import com.springspartans.shopkart.repository.ProductRepository;
import com.springspartans.shopkart.util.ImageUploadValidator;
import com.springspartans.shopkart.factory.ProductFactory;

public void addProduct(int id, String name, String category, String brand, double price, MultipartFile image, int stock, double discount) 
        throws IOException, InvalidImageUploadException {
    String imageName = null;
    if (image != null && !image.isEmpty()) {
        if (!imageUploadValidator.isValidImage(image)) { 
            throw new InvalidImageUploadException("Improper file format!");
        }
        imageName = image.getOriginalFilename();
    }
    Product product = ProductFactory.createProduct(id, name, category, brand, price, imageName, stock, discount);
    productRepository.save(product);
    if (imageName != null)
        saveImageToDirectory(image, imageName, "product");
}

@Service
public class ProductService {
	
	@Autowired
	private String uploadPath;
	
	@Autowired
	private ProductRepository productRepository;
	
	@Autowired
    private ImageUploadValidator imageUploadValidator;

	public List<Product> getAllProducts() {
		return productRepository.findAll();
	}

	public Product getProductById(int id) {
		return productRepository.findById(id).orElse(null);
	}

	public List<String> getAllCategories() {
		List<String> categoryList = new ArrayList<>();
		categoryList.add("All");
		categoryList.addAll(productRepository.findAllCategories());
		return categoryList;
	}

	public List<Product> getProductsByCategory(String category) {
		if (category.equals("All"))
			return getAllProducts();
		return productRepository.findByCategory(category);
	}

	public List<Product> getProductsByStartName(String prefix) {
		return productRepository.findByStartName(prefix);
	}
	
	public void addProduct(int id, String name, String category, String brand, double price, MultipartFile image, int stock, double discount) 
			throws IOException, InvalidImageUploadException {
		String imageName = null;
		if (image != null && !image.isEmpty()) {
			if (! imageUploadValidator.isValidImage(image)) { 
	            throw new InvalidImageUploadException("Improper file format!");
	        }
	        imageName = image.getOriginalFilename();
	    }
		Product product = new Product(id, name, category, brand, price, imageName, stock, discount);
		productRepository.save(product);
		if (imageName != null)
			saveImageToDirectory(image, imageName, "product");
	}
	
	public void updateProduct(int id, String name, String category, String brand, double price, MultipartFile image, int stock, double discount) 
			throws IOException, InvalidImageUploadException {
		Product existingProduct = productRepository.findById(id)
		        .orElseThrow(() -> new RuntimeException("Product not found"));
		existingProduct.setName(name);
	    existingProduct.setCategory(category);
	    existingProduct.setBrand(brand);
	    existingProduct.setPrice(price);
	    existingProduct.setStock(stock);
	    existingProduct.setDiscount(discount); 
		if (image != null && !image.isEmpty()) {
			if (!imageUploadValidator.isValidImage(image)) { 
	            throw new InvalidImageUploadException("Improper file format!");
	        }
	        String imageName = image.getOriginalFilename();
	        existingProduct.setImage(imageName);
	        saveImageToDirectory(image, imageName, "product");
		}
		productRepository.save(existingProduct);
	}
	
	private void saveImageToDirectory(MultipartFile image, String imageName, String folderName) throws IOException {
	    String imageUploadPath = uploadPath + "/product" ;
	    File destination = new File(imageUploadPath);
	    if (!destination.exists()) {
	        boolean created = destination.mkdirs(); 
	        destination.setWritable(true);
	        if (created) {
        		System.out.println("Created directory : " + destination.getAbsolutePath());
        	} else {
        		System.out.println(destination.getAbsolutePath() + "already exists");
        	}
	    }
	    File fileToSave = new File(destination, imageName);
	    image.transferTo(fileToSave);
	    System.out.println("Saved file : " + fileToSave.getAbsolutePath());
	}

	public void deleteProduct(int id) {
		productRepository.deleteById(id);
	}
	
	public int countProducts() {
		return (int) productRepository.count();
	}

	public String checkProductStock(int productId) {
		Product product = productRepository.findById(productId).orElse(null);
		if (product == null) {
			return "Product not found!";
		}
		if (product.getStock() <= 0) {
			return "Out of Stock";
		}
		return "In Stock: " + product.getStock();
	}
	
}
