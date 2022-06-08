SET FOREIGN_KEY_CHECKS = 0;

/*
 * Type: Table
 * Name: player
 * Primary key: id_player
 * --------------------------------
 */

DROP TABLE IF EXISTS `player`;
CREATE TABLE `player` (
    `id_player` INT(11) PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(255) DEFAULT NULL,
    `year` INT(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `player` (`name`, `year`) VALUES ('Antonio', 1993);
INSERT INTO `player` (`name`, `year`) VALUES ('Bruno', 1995);
INSERT INTO `player` (`name`, `year`) VALUES ('Carlo', 1983);
INSERT INTO `player` (`name`, `year`) VALUES ('Diego', 1975);
INSERT INTO `player` (`name`, `year`) VALUES ('Elio', 2001);
INSERT INTO `player` (`name`, `year`) VALUES ('Francesco', 1984);
INSERT INTO `player` (`name`, `year`) VALUES ('Giovanni', 1977);
INSERT INTO `player` (`name`, `year`) VALUES ('Homer', 1989);
INSERT INTO `player` (`name`, `year`) VALUES ('Ignazio', 1973);
INSERT INTO `player` (`name`, `year`) VALUES ('Jacopo', 1998);
INSERT INTO `player` (`name`, `year`) VALUES ('Kevin', 1981);
INSERT INTO `player` (`name`, `year`) VALUES ('Mario', 1990);
INSERT INTO `player` (`name`, `year`) VALUES ('Nino', 1982);
INSERT INTO `player` (`name`, `year`) VALUES ('Olmo', 1982);


/*
 * Type: Table
 * Name: pair
 * Foreign key: player_1
 * Foreign key: player_2
 * --------------------------------
 */

DROP TABLE IF EXISTS `pair`;
CREATE TABLE `pair` (
    `player_1` INT(11) NOT NULL,
    `player_2` INT(11) NOT NULL,
    FOREIGN KEY (`player_1`) REFERENCES `player`(`id_player`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`player_2`) REFERENCES `player`(`id_player`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


/*
 * Type: Procedure
 * Name: mateGenerator
 * --------------------------------
 */

DROP PROCEDURE IF EXISTS `mateGenerator`;

DELIMITER $$
CREATE PROCEDURE `mateGenerator`()
    BEGIN
        DECLARE `i` INT DEFAULT 0;
        DECLARE `totalRows` INT DEFAULT 0;
        SET `i` = 0;
        SET `totalRows` = (SELECT COUNT(*) FROM `player`);
        TRUNCATE TABLE `pair`;
        WHILE `i` < `totalRows` DO
            INSERT INTO `pair` (`player_1`, `player_2`) SELECT a.`id_player`, b.`id_player`
            FROM `player` a
            INNER JOIN `player` b ON a.`id_player` < b.`id_player`
            WHERE NOT EXISTS (
                SELECT *
                FROM `pair` c
                WHERE c.`player_1` IN (a.`id_player`, b.`id_player`))
            AND NOT EXISTS (
                SELECT *
                FROM `pair` c
                WHERE c.`player_2` IN (a.`id_player`, b.`id_player`))
            ORDER BY a.`id_player` * RAND()
            LIMIT 1;
            SET `i` = `i` + 1;
        END WHILE;
    END $$
DELIMITER ;


/*
 * Type: View
 * Name: match
 * --------------------------------
 */

DROP VIEW IF EXISTS `match`;
CREATE VIEW `match` AS
SELECT
    p1.`name` AS `player`,
    p2.`name` AS `opponent`,
    ABS(p1.`year` - p2.`year`) AS `differenceAge`
FROM `pair`
JOIN `player` p1 ON `pair`.`player_1` = p1.`id_player`
JOIN `player` p2 ON `pair`.`player_2` = p2.`id_player`;

SET FOREIGN_KEY_CHECKS = 1;
