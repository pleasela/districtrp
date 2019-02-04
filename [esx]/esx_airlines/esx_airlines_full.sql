USE `essentialmodedev`;

INSERT INTO `addon_account` (name, label, shared) VALUES
  ('society_airlines','Airlines',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  ('society_airlines','Airlines',1)
;


INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('airlines',0,'recrue','Recruit',30,'{}','{}'),
  ('airlines',1,'chauffeur','Chauffeur',40,'{}','{}'),
  ('airlines',2,'pilote','Pilot',50,'{}','{}'),
  ('airlines',3,'gerant','chief',60,'{}','{}'),
  ('airlines',4,'boss','owner',0,'{}','{}')
;
