USE students;

CREATE TABLE dummo(
	id INT AUTO_INCREMENT PRIMARY KEY,
	sid INTEGER,
    name VARCHAR(60),
    grade CHAR(1),
    FOREIGN KEY(sid) REFERENCES students(id),
    FOREIGN KEY(name) REFERENCES classes(name));
drop table dummo;
DELIMITER //

CREATE PROCEDURE generateClasses (IN ssid INT, IN degree VARCHAR(30))
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
		INSERT INTO dummo (sid, name) VALUES (ssid, cname);
	ELSEIF majmin = 'Chem' THEN
		SET randNum = FLOOR(RAND()*(25)+26);
        SET cname = (SELECT name FROM class WHERE indy = randNum LIMIT 1);
		INSERT INTO dummo (sid, name) VALUES (ssid, cname);
    ELSEIF majmin = 'CS' THEN
		SET randNum = FLOOR(RAND()*(25)+51);
        SET cname = (SELECT name FROM class WHERE indy = randNum LIMIT 1);
		INSERT INTO dummy (sid, name) VALUES (ssid, cname);
    ELSEIF majmin = 'Eng' THEN
		SET randNum = FLOOR(RAND()*(25)+76);
        SET cname = (SELECT name FROM class WHERE indy = randNum LIMIT 1);
		INSERT INTO dummo (sid, name) VALUES (ssid, cname);
    ELSEIF majmin = 'Math' THEN
		SET randNum = FLOOR(RAND()*(25)+101);
        SET cname = (SELECT name FROM class WHERE indy = randNum LIMIT 1);
		INSERT INTO dummo (sid, name) VALUES (ssid, cname);
    ELSE
		SET randNum = FLOOR(RAND()*(25)+126);
        SET cname = (SELECT name FROM class WHERE indy = randNum LIMIT 1);
		INSERT INTO dummo (sid, name) VALUES (ssid, cname);
    END IF;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE freshmanTaken()
BEGIN
	DECLARE randNum INT;
    DECLARE id INT;
    DECLARE indexo INT;
    SET id = 1;
    WHILE id <= 25 DO
		SET randNum = FLOOR(RAND()*(8)+0);
        SET indexo = 0;
        WHILE indexo < randNum DO
			CALL generateClasses(id, 'major');
            SET indexo = indexo + 1;
		END WHILE;
        SET id = id + 1;
	END WHILE;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE sophomoreTaken()
BEGIN
	DECLARE randNum INT;
    DECLARE id INT;
    DECLARE indexo INT;
    DECLARE maj INT;
    DECLARE mino INT;
    SET id = 26;
    SET mino = 4;
    WHILE id <= 50 DO
		SET randNum = FLOOR(RAND()*(8)+7);
        SET maj = randNum - mino;
        SET indexo = 0;
        WHILE indexo < maj DO
			CALL generateClasses(id, 'major');
            SET indexo = indexo + 1;
		END WHILE;
        SET indexo = 0;
        WHILE indexo < mino DO
			CALL generateClasses(id, 'minor');
            SET indexo = indexo + 1;
        END WHILE;
        SET id = id + 1;
	END WHILE;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE juniorTaken()
BEGIN
	DECLARE randNum INT;
    DECLARE id INT;
    DECLARE indexo INT;
    DECLARE maj INT;
    DECLARE mino INT;
    SET id = 51;
    SET mino = 8;
    WHILE id <= 75 DO
		SET randNum = FLOOR(RAND()*(8)+15);
        SET maj = randNum - mino;
        SET indexo = 0;
        WHILE indexo < maj DO
			CALL generateClasses(id, 'major');
            SET indexo = indexo + 1;
		END WHILE;
        SET indexo = 0;
        WHILE indexo < mino DO
			CALL generateClasses(id, 'minor');
            SET indexo = indexo + 1;
        END WHILE;
        SET id = id + 1;
	END WHILE;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE seniorTaken()
BEGIN
	DECLARE randNum INT;
    DECLARE id INT;
    DECLARE indexo INT;
    DECLARE maj INT;
    DECLARE mino INT;
    SET id = 76;
    SET mino = 12;
    WHILE id <= 100 DO
		SET randNum = FLOOR(RAND()*(8)+23);
        SET maj = randNum - mino;
        SET indexo = 0;
        WHILE indexo < maj DO
			CALL generateClasses(id, 'major');
            SET indexo = indexo + 1;
		END WHILE;
        SET indexo = 0;
        WHILE indexo < mino DO
			CALL generateClasses(id, 'minor');
            SET indexo = indexo + 1;
        END WHILE;
        SET id = id + 1;
	END WHILE;
END //

DELIMITER ;

drop procedure freshmanTaken;
drop procedure sophomoreTaken;
drop procedure juniorTaken;
drop procedure seniorTaken;

CALL freshmanTaken;
CALL sophomoreTaken;
CALL juniorTaken;
CALL seniorTaken;

CREATE TABLE grade (gid INT AUTO_INCREMENT PRIMARY KEY, g ENUM('A', 'B', 'C', 'D', 'F'));
drop table grade;

DELIMITER //

CREATE PROCEDURE gradeRand()
BEGIN
	DECLARE county INT;
    DECLARE i INT;
    DECLARE randNum INT;
    
    SET county = (SELECT COUNT(sid) FROM hasTaken);
    SET i = 1;
    SELECT county;
    
	WHILE i <= county DO
		SET randNum = FLOOR((RAND()*(5))+1);
        IF randNum = 1 THEN INSERT INTO grade(g) VALUES('A');
        ELSEIF randNum = 2 THEN INSERT INTO grade(g) VALUES('B');
        ELSEIF randNum = 3 THEN INSERT INTO grade(g) VALUES('C');
        ELSEIF randNum = 4 THEN INSERT INTO grade(g) VALUES('D');
        ELSE INSERT INTO grade(g) VALUES('F');
        END IF;
        SET i = i+1;
	END WHILE;
END //

DELIMITER ;
drop procedure gradeRand;

CALL gradeRand();

UPDATE dummo
JOIN grade ON dummo.id = grade.gid
SET dummo.grade = grade.g;

INSERT INTO hasTaken(sid, name, grade)
SELECT d.sid, d.name, d.grade FROM dummo d;

select* from hasTaken;


