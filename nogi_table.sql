CREATE TABLE `members` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) DEFAULT NULL,
  `name_english` text,
  `img_url` text CHARACTER SET utf8,
  `birthday` text,
  `blood_type` text,
  `twelve_signs` text,
  `height` int(11) DEFAULT NULL,
  `term` int(11) DEFAULT NULL,
  `birthplace` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4


CREATE TABLE `blog_articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `member_id` varchar(255) DEFAULT NULL,
  `member_name` text,
  `title` text,
  `uploded_at` datetime DEFAULT NULL,
  `day_of_the_week` text CHARACTER SET utf8,
  `body` longtext,
  `image_urls` text CHARACTER SET utf8,
  `comment_cnt` int(11) DEFAULT NULL,
  `comment_url` text CHARACTER SET utf8,
  `page_url` text CHARACTER SET utf8,
  `html` longtext,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12048 DEFAULT CHARSET=utf8mb4
