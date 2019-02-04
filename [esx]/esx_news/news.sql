USE `essentialmode`;

CREATE TABLE `news_main` (
  
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(100),
  `bait_title` VARCHAR(100),
  `content` VARCHAR(1000),
  `author_name` VARCHAR(50) DEFAULT NULL,
  `author_id` VARCHAR(60) NOT NULL,
  `news_type` VARCHAR(60) NOT NULL,
  `imgurl` VARCHAR(255),
   
  PRIMARY KEY (`id`)
);


CREATE TABLE `news_likes` (
  
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `news_id` int(11) NOT NULL,
  `author_id` VARCHAR(60) NOT NULL,
  `liker_id` VARCHAR(60) NOT NULL,
  `liker_name` varchar(60) NOT NULL,
  PRIMARY KEY (`id`)
);
