-- adatbázis létrehozása

CREATE DATABASE IF NOT EXISTS `sharehub`
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- adatbázisba belépés

USE sharehub;

-- táblák kódja:
CREATE TABLE `customers` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50)NOT NULL,
  `email` varchar(255) UNIQUE NOT NULL,
  `phone_number` varchar(50),
  `password` varchar(255) NOT NULL,
  `role` ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `is_deleted` tinyint DEFAULT 0
);

CREATE TABLE `categories` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE `products` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `owner_id` int NOT NULL,
  `category_id` int NOT NULL,
  `name` varchar(100),
  `price` decimal(10,2) NOT NULL,
  `description` text,
  `city` varchar(100) NOT NULL,
  `county` ENUM(
    'Bács-Kiskun', 'Baranya', 'Békés', 'Borsod-Abaúj-Zemplén', 
    'Csongrád-Csanád', 'Fejér', 'Győr-Moson-Sopron', 'Hajdú-Bihar', 
    'Heves', 'Jász-Nagykun-Szolnok', 'Komárom-Esztergom', 'Nógrád', 
    'Pest', 'Somogy', 'Szabolcs-Szatmár-Bereg', 'Tolna', 
    'Vas', 'Veszprém', 'Zala', 'Budapest'
  ) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `is_deleted` tinyint DEFAULT 0,
  FOREIGN KEY (`owner_id`) REFERENCES `customers`(`id`),
  FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`)
);

CREATE TABLE `rentals` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `product_id` int NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `status` ENUM('pending', 'approved', 'active', 'completed', 'cancelled') DEFAULT 'pending',
  `total_price` decimal(10,2),
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`),
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`)
);

CREATE TABLE `favourites` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `product_id` int NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `unique_favourite` (`customer_id`, `product_id`),
  FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`),
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`)
);

CREATE TABLE `reviews` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `product_id` int NOT NULL,
  `rating` tinyint NOT NULL CHECK (rating BETWEEN 1 AND 5), 
  `comment` text,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `unique_review` (`customer_id`, `product_id`),
  FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`),
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`)
);

CREATE TABLE `products_images` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `url` varchar(255) NOT NULL,
  `is_primary` tinyint(1) DEFAULT 0,
  `sort_order` int DEFAULT 0,
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`)
)

