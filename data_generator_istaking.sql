USE students;

CREATE TABLE class (
	indy INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(60), credits INT
    );

CREATE TABLE dummy(
	id INT AUTO_INCREMENT PRIMARY KEY,
	sid INTEGER,
    name VARCHAR(60),
    FOREIGN KEY(sid) REFERENCES students(id),
    FOREIGN KEY(name) REFERENCES classes(name));

drop table dummy;

DELIMITER //

CREATE PROCEDURE generateCurrentClasses (IN ssid INT, IN degree VARCHAR(30))
BEGIN
    DECLARE randNum INT;
    DECLARE majmin VARCHAR(30);
    DECLARE cname VARCHAR(60);
	
    IF degree = 'major'  THEN SET majmin = (SELECT dname FROM majors WHERE ssid = majors.sid LIMIT 1);
    ELSE SET majmin = (SELECT dname FROM minors WHERE ssid = minors.sid LIMIT 1);
    END IF;
    
    IF majmin = 'Bio' THEN
		SET randNum = FLOOR(RAND()*(25)+1);	
        SET cname = (SELECT name FROM class WHERE indy = randNum LIMIT 1);
		INSERT INTO dummy (sid, name) VALUES (ssid, cname);
	ELSEIF majmin = 'Chem' THEN
		SET randNum = FLOOR(RAND()*(25)+26);
        SET cname = (SELECT name FROM class WHERE indy = randNum LIMIT 1);
		INSERT INTO dummy (sid, name) VALUES (ssid, cname);
    ELSEIF majmin = 'CS' THEN
		SET randNum = FLOOR(RAND()*(25)+51);
        SET cname = (SELECT name FROM class WHERE indy = randNum LIMIT 1);
		INSERT INTO dummy (sid, name) VALUES (ssid, cname);
    ELSEIF majmin = 'Eng' THEN
		SET randNum = FLOOR(RAND()*(25)+76);
        SET cname = (SELECT name FROM class WHERE indy = randNum LIMIT 1);
		INSERT INTO dummy (sid, name) VALUES (ssid, cname);
    ELSEIF majmin = 'Math' THEN
		SET randNum = FLOOR(RAND()*(25)+101);
        SET cname = (SELECT name FROM class WHERE indy = randNum LIMIT 1);
		INSERT INTO dummy (sid, name) VALUES (ssid, cname);
    ELSE
		SET randNum = FLOOR(RAND()*(25)+126);
        SET cname = (SELECT name FROM class WHERE indy = randNum LIMIT 1);
		INSERT INTO dummy (sid, name) VALUES (ssid, cname);
    END IF;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE makeSchedule()
BEGIN
	DECLARE id INT;
    SET id = 1;
	WHILE id <= 100 DO
		CALL generateCurrentClasses(id, 'major');
		CALL generateCurrentClasses(id, 'major');
		CALL generateCurrentClasses(id, 'minor');
		CALL generateCurrentClasses(id, 'minor');
		SET id = id + 1;
	END WHILE;
END //

DELIMITER ;

drop procedure generateCurrentClasses;
CALL makeSchedule();

DELETE FROM dummy WHERE id = 52;
INSERT INTO dummy(id, sid, name) VALUE(52, 13, 'Numerical Analysis');
DELETE FROM dummy WHERE id = 104;
INSERT INTO dummy(id, sid, name) VALUE(104, 26, 'Nonlinear Dynamics and Chaos');
DELETE FROM dummy WHERE id = 126;
INSERT INTO dummy(id, sid, name) VALUE(126, 32, 'Postcolonial Literature');
DELETE FROM dummy WHERE id = 142;
INSERT INTO dummy(id, sid, name) VALUE(142, 36, 'Operating Systems');
DELETE FROM dummy WHERE id = 152;
INSERT INTO dummy(id, sid, name) VALUE(152, 38, 'Nonlinear Dynamics and Chaos');
DELETE FROM dummy WHERE id = 156;
INSERT INTO dummy(id, sid, name) VALUE(156, 39, 'Numerical Analysis');
DELETE FROM dummy WHERE id = 162;
INSERT INTO dummy(id, sid, name) VALUE(162, 41, 'Materials Chemistry');
DELETE FROM dummy WHERE id = 228;
INSERT INTO dummy(id, sid, name) VALUE(228, 57, 'Numerical Analysis');
DELETE FROM dummy WHERE id = 266;
INSERT INTO dummy(id, sid, name) VALUE(266, 67, 'Operating Systems');
DELETE FROM dummy WHERE id = 374;
INSERT INTO dummy(id, sid, name) VALUE(374, 94, 'Linear Algebra');

INSERT INTO isTaking(sid, name)
SELECT d.sid, d.name FROM dummy d;









    

