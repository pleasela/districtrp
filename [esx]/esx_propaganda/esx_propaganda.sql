USE `essentialmode`;

INSERT INTO `addon_account` (name, label, shared) VALUES
  ('society_reporter','Reporter',1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('reporter',1,'experienced','Experienced Reporter',20,'{}','{}'),
  ('reporter',2,'journalist','Journalist',30,'{}','{}'),
  ('reporter',3,'manager','Manager',40,'{}','{}'),
  ('reporter',4,'boss','Boss',0,'{}','{}')
;
