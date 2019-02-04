INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('plongee1', 'Plongee courte', -1, 0, 1),
	('plongee2', 'Plongee longue', -1, 0, 1)
;

INSERT INTO `shops` (name, item, price) VALUES
	('LTDgasoline', 'plongee1', 250),
	('RobsLiquor', 'plongee1', 250),
	('TwentyFourSeven', 'plongee1', 250),
	('LTDgasoline', 'plongee2', 350),
	('RobsLiquor', 'plongee2', 350),
	('TwentyFourSeven', 'plongee2', 350)
;
