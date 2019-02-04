
INSERT INTO `jobs` (`id`, `name`, `label`) VALUES
(NULL, 'rally', 'Rallikuski');


CREATE TABLE `rally_times` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `track` int(10) COLLATE utf8mb4_bin NOT NULL,
  `driver` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  `laptime` bigint DEFAULT 99999,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

INSERT INTO `items` (`id`, `name`, `label`, `limit`, `rare`, `can_remove`) VALUES 
(NULL, 'goldmedal', 'Rallin kultamitali', '-1', '0', '1'),
(NULL, 'silvermedal', 'Rallin hopeamitali', '-1', '0', '1'),
(NULL, 'bronzemedal', 'Rallin pronssimitali', '-1', '0', '1');

INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(NULL, 'rally', 0, 'employee', 'Urheilija', 135, '{"shoes_1":55,"lipstick_4":0,"age_1":10,"beard_2":10,"decals_1":12,"decals_2":0,"beard_3":0,"lipstick_2":0,"mask_2":0,"hair_color_2":0,"eyebrows_4":2,"makeup_3":0,"beard_4":0,"makeup_2":0,"ears_1":11,"tshirt_1":15,"torso_1":148,"ears_2":1,"shoes_2":3,"lipstick_1":0,"helmet_1":72,"age_2":4,"sex":0,"beard_1":10,"skin":0,"hair_color_1":2,"glasses_2":1,"hair_1":21,"bags_1":0,"tshirt_2":0,"eyebrows_1":17,"bproof_1":0,"eyebrows_2":10,"glasses_1":15,"pants_1":66,"hair_2":1,"mask_1":0,"makeup_1":0,"torso_2":4,"bags_2":0,"face":31,"chain_2":0,"helmet_2":5,"pants_2":2,"arms":1,"chain_1":0,"bproof_2":0,"lipstick_3":0,"eyebrows_3":3,"makeup_4":0}',
	'{"shoes_1":55,"lipstick_4":0,"age_1":10,"beard_2":10,"decals_1":12,"decals_2":0,"beard_3":0,"lipstick_2":0,"mask_2":0,"hair_color_2":0,"eyebrows_4":2,"makeup_3":0,"beard_4":0,"makeup_2":0,"ears_1":11,"tshirt_1":15,"torso_1":148,"ears_2":1,"shoes_2":3,"lipstick_1":0,"helmet_1":72,"age_2":4,"sex":0,"beard_1":10,"skin":0,"hair_color_1":2,"glasses_2":1,"hair_1":21,"bags_1":0,"tshirt_2":0,"eyebrows_1":17,"bproof_1":0,"eyebrows_2":10,"glasses_1":15,"pants_1":66,"hair_2":1,"mask_1":0,"makeup_1":0,"torso_2":4,"bags_2":0,"face":31,"chain_2":0,"helmet_2":5,"pants_2":2,"arms":1,"chain_1":0,"bproof_2":0,"lipstick_3":0,"eyebrows_3":3,"makeup_4":0}');
