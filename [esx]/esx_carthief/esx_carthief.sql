USE `DATABASE_NAME`;

INSERT INTO `addon_account` (name, label, shared) VALUES
  ('society_carthief','Car Thief',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  ('society_carthief','Car Thief',1)
;

INSERT INTO `jobs` (name, label) VALUES
  ('carthief','Car Thief')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('carthief',0,'thief','Thief',0,'{}','{}'),
  ('carthief',1,'bodyguard','Bodyguard',0,'{}','{}'),
  ('carthief',2,'boss','Boss',0,'{}','{}')
;
