USE `essentialmode`;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  ('society_airlines','Airlines',1)
;

INSERT INTO `jobs` (name, label) VALUES
  ('airlines','Airlines')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('taxi',0,'recrue','Recrue',12,'{}','{}'),
  ('taxi',1,'chauffeur','Chauffeur',24,'{}','{}'),
  ('taxi',2,'pilote','Pilote',36,'{}','{}'),
  ('taxi',3,'gerant','Gerant',48,'{}','{}'),
  ('taxi',4,'boss','Patron',0,'{}','{}')
;
