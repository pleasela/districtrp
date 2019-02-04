INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(83, 'avocat', 0, 'boss', 'Patron', 500, '', '');

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('avocat', 'Advokat', 1);

INSERT INTO `addon_account` (name, label, shared) VALUES 
    ('society_avocat','Advokat',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
    ('society_avocat','Advokat',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
    ('society_avocat', 'Advokat', 1)
;
