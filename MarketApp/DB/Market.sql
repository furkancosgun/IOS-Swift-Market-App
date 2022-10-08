-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: localhost:8889
-- Üretim Zamanı: 08 Eki 2022, 17:46:23
-- Sunucu sürümü: 5.7.34
-- PHP Sürümü: 7.4.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `Market`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `Basket`
--

CREATE TABLE `Basket` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `piece` tinyint(4) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `Basket`
--

INSERT INTO `Basket` (`id`, `product_id`, `piece`, `user_id`) VALUES
(25, 43, 1, 1),
(26, 44, 1, 1);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `Category`
--

CREATE TABLE `Category` (
  `id` int(11) NOT NULL,
  `category_name` varchar(100) COLLATE utf8_turkish_ci NOT NULL,
  `category_img` varchar(1000) COLLATE utf8_turkish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `Category`
--

INSERT INTO `Category` (`id`, `category_name`, `category_img`) VALUES
(1, 'Cips', 'http://localhost:8888/Market/images/doritos-cips.jpeg'),
(2, 'Kola', 'http://localhost:8888/Market/images/cc-kola.jpeg'),
(3, 'Cekirdek', 'http://localhost:8888/Market/images/tadim-cekirdek.jpeg'),
(4, 'Cikolata', 'http://localhost:8888/Market/images/eti-cikolata.jpeg');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `Comments`
--

CREATE TABLE `Comments` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `text` varchar(1000) COLLATE utf8_turkish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `Comments`
--

INSERT INTO `Comments` (`id`, `product_id`, `user_id`, `text`) VALUES
(1, 1, 1, 'cok iyi hersey'),
(2, 12, 34, 'Created BY FCOSGUN'),
(3, 50, 1, 'Kola mı la bu su gibiKola mı la bu su gibiKola mı la bu su gibiKola mı la bu su gibiKola mı la bu su gibiKola mı la bu su gibiKola mı la bu su gibiKola mı la bu su gibiKola mı la bu su gibiKola mı la bu su gibiKola mı la bu su gibiKola mı la bu su gibiKola mı la bu su gibiKola mı la bu su gibiKola mı la bu su gibiKola mı la bu su gibiKola mı la bu su gibiKola mı la bu su gibi'),
(4, 50, 1, 'guzel'),
(5, 43, 1, 'ekonomik'),
(6, 46, 1, 'Oyyy Yilan Gibi heee'),
(7, 43, 1, 'aynn knk ekonomik'),
(8, 46, 1, 'Ayak kokulu'),
(9, 44, 1, 'Nice :)');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `Favorites`
--

CREATE TABLE `Favorites` (
  `id` int(11) NOT NULL,
  `productId` int(11) NOT NULL,
  `userId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `Favorites`
--

INSERT INTO `Favorites` (`id`, `productId`, `userId`) VALUES
(19, 44, 1),
(20, 47, 1),
(21, 50, 1),
(22, 46, 1);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `Product`
--

CREATE TABLE `Product` (
  `id` int(11) NOT NULL,
  `Product_name` varchar(100) COLLATE utf8_turkish_ci NOT NULL,
  `category_id` int(11) NOT NULL,
  `price` tinyint(4) NOT NULL,
  `img` varchar(1000) COLLATE utf8_turkish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `Product`
--

INSERT INTO `Product` (`id`, `Product_name`, `category_id`, `price`, `img`) VALUES
(40, 'Tadim Cekirdek', 3, 11, 'http://localhost:8888/Market/images/tadim-cekirdek.jpeg'),
(42, 'Amigo Cekirdek', 3, 10, 'http://localhost:8888/Market/images/amigo-cekirdek.jpeg'),
(43, 'Cocacola 2.5l', 2, 22, 'http://localhost:8888/Market/images/cc-kola.jpeg'),
(44, 'Cerezza Ciprs', 1, 19, 'http://localhost:8888/Market/images/cerezza-cips.jpeg'),
(45, 'Damak Cikolata', 4, 14, 'http://localhost:8888/Market/images/damak-cikolata.jpeg'),
(46, 'Doritos Cips', 1, 13, 'http://localhost:8888/Market/images/doritos-cips.jpeg'),
(47, 'Eti Cikolata', 4, 19, 'http://localhost:8888/Market/images/eti-cikolata.jpeg'),
(48, 'Lays Cips', 1, 10, 'http://localhost:8888/Market/images/lays-cips.jpeg'),
(49, 'Milka Cikolata', 4, 23, 'http://localhost:8888/Market/images/milka-cikolata.jpeg'),
(50, 'Pepsi 250ml', 2, 8, 'http://localhost:8888/Market/images/pepsi-kola.jpeg'),
(51, 'Ruffles Cips', 1, 18, 'http://localhost:8888/Market/images/ruffles-cips.jpeg'),
(52, 'Sprite 1l', 2, 13, 'http://localhost:8888/Market/images/sprite-kola.jpeg');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `stock`
--

CREATE TABLE `stock` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `piece` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `stock`
--

INSERT INTO `stock` (`id`, `product_id`, `piece`) VALUES
(1, 42, 30),
(2, 44, 30),
(3, 43, 321),
(4, 45, 321),
(5, 46, 32),
(6, 47, 223),
(7, 48, 54),
(8, 49, 21),
(9, 50, 32),
(10, 51, 43),
(11, 52, 54),
(12, 40, 42);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `User`
--

CREATE TABLE `User` (
  `id` int(11) NOT NULL,
  `full_name` varchar(100) COLLATE utf8_turkish_ci NOT NULL,
  `email` varchar(100) COLLATE utf8_turkish_ci NOT NULL,
  `phone` varchar(11) COLLATE utf8_turkish_ci NOT NULL,
  `password` varchar(15) COLLATE utf8_turkish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `User`
--

INSERT INTO `User` (`id`, `full_name`, `email`, `phone`, `password`) VALUES
(1, 'furkan cosgun', 'furkan51cosgun@gmail.com', '05422309573', 'furkan123'),
(2, 'Gizem karagözlü', 'gizemkaragozlu5@gmail.com', '05432101234', 'gizem123');

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `Basket`
--
ALTER TABLE `Basket`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `Category`
--
ALTER TABLE `Category`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `Comments`
--
ALTER TABLE `Comments`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `Favorites`
--
ALTER TABLE `Favorites`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `Product`
--
ALTER TABLE `Product`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `stock`
--
ALTER TABLE `stock`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_id` (`product_id`);

--
-- Tablo için indeksler `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `Basket`
--
ALTER TABLE `Basket`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- Tablo için AUTO_INCREMENT değeri `Category`
--
ALTER TABLE `Category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Tablo için AUTO_INCREMENT değeri `Comments`
--
ALTER TABLE `Comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Tablo için AUTO_INCREMENT değeri `Favorites`
--
ALTER TABLE `Favorites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- Tablo için AUTO_INCREMENT değeri `Product`
--
ALTER TABLE `Product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- Tablo için AUTO_INCREMENT değeri `stock`
--
ALTER TABLE `stock`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Tablo için AUTO_INCREMENT değeri `User`
--
ALTER TABLE `User`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `stock`
--
ALTER TABLE `stock`
  ADD CONSTRAINT `stock_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `Product` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
