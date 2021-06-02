DROP DATABASE IF EXISTS `bedirhan_bardakci`;

CREATE DATABASE IF NOT EXISTS bedirhan_bardakci;

USE bedirhan_bardakci;

CREATE TABLE IF NOT EXISTS district (
id INT(6) AUTO_INCREMENT PRIMARY KEY,
title VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS city (
id INT(6) AUTO_INCREMENT PRIMARY KEY,
district_id INT(6) NOT NULL,
title VARCHAR(30) NOT NULL UNIQUE
);

ALTER TABLE city
ADD FOREIGN KEY (district_id) REFERENCES district(id);

CREATE TABLE IF NOT EXISTS branch (
id INT(6) AUTO_INCREMENT PRIMARY KEY,
city_id INT(6) NOT NULL,
title VARCHAR(30) NOT NULL
);

ALTER TABLE branch
ADD FOREIGN KEY (city_id) REFERENCES city(id);


CREATE TABLE IF NOT EXISTS customer (
id INT(6) AUTO_INCREMENT PRIMARY KEY,
forename VARCHAR(30) NOT NULL,
surname VARCHAR(30) NOT NULL
);


CREATE TABLE IF NOT EXISTS salesman (
id INT(6) AUTO_INCREMENT PRIMARY KEY,
branch_id INT(6) NOT NULL,
forename VARCHAR(30) NOT NULL,
surname VARCHAR(30) NOT NULL
);

ALTER TABLE salesman
ADD FOREIGN KEY (branch_id) REFERENCES branch(id);


CREATE TABLE IF NOT EXISTS book (
id INT(6) AUTO_INCREMENT PRIMARY KEY,
title  VARCHAR(100) NOT NULL,
price  INT(6) NOT NULL
);


CREATE TABLE IF NOT EXISTS stock (
id INT(6) AUTO_INCREMENT PRIMARY KEY,
branch_id  INT(6) NOT NULL,
book_id INT(6) NOT NULL,
isSold INT(6) DEFAULT 0
);

ALTER TABLE stock
ADD FOREIGN KEY (branch_id) REFERENCES branch(id);

ALTER TABLE stock
ADD FOREIGN KEY (book_id) REFERENCES book(id);


CREATE TABLE IF NOT EXISTS sale (
id INT(6) AUTO_INCREMENT PRIMARY KEY,
customer_id INT(6) NOT NULL,
salesman_id INT(6) NOT NULL,
stock_id INT(6) NOT NULL,
amount INT(6) NOT NULL,
saledate  DATETIME NOT NULL
);

ALTER TABLE sale
ADD FOREIGN KEY (customer_id) REFERENCES customer(id);

ALTER TABLE sale
ADD FOREIGN KEY (salesman_id) REFERENCES salesman(id);

ALTER TABLE sale
ADD FOREIGN KEY (stock_id) REFERENCES stock(id);


CREATE TABLE IF NOT EXISTS temp (
id INT(6) AUTO_INCREMENT PRIMARY KEY,
district_name  VARCHAR(30) NOT NULL,
city_name  VARCHAR(30) NOT NULL,
branch_name VARCHAR(30) NOT NULL
);

LOAD DATA  INFILE 'C:\\Program Files\\Ampps\\www\\CSE348\\turkey.csv' 
IGNORE INTO TABLE temp 
FIELDS TERMINATED BY ';' 
ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @col2, @col3)
set district_name = TRIM(@col1),
    city_name = TRIM(@col2),
    branch_name = TRIM(@col3);



CREATE TABLE IF NOT EXISTS tempSalesman (
id INT(6) AUTO_INCREMENT PRIMARY KEY,
forename  VARCHAR(30) NOT NULL,
surname  VARCHAR(30) NOT NULL
);

LOAD DATA  INFILE 'C:\\Program Files\\Ampps\\www\\CSE348\\salesman.csv' 
IGNORE INTO TABLE tempSalesman 
FIELDS TERMINATED BY ';' 
ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @col2)
set forename = TRIM(@col1),
    surname = TRIM(@col2);


CREATE TABLE IF NOT EXISTS tempCustomer (
id INT(6) AUTO_INCREMENT PRIMARY KEY,
forename  VARCHAR(30) NOT NULL,
surname  VARCHAR(30) NOT NULL
);

LOAD DATA  INFILE 'C:\\Program Files\\Ampps\\www\\CSE348\\customer.csv' 
IGNORE INTO TABLE tempCustomer 
FIELDS TERMINATED BY ';' 
ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @col2)
set forename = TRIM(@col1),
    surname = TRIM(@col2);




CREATE TABLE IF NOT EXISTS tempBook (
id INT(6) AUTO_INCREMENT PRIMARY KEY,
title  VARCHAR(100) NOT NULL,
price  INT(6) NOT NULL
);

LOAD DATA  INFILE 'C:\\Program Files\\Ampps\\www\\CSE348\\books.csv' 
IGNORE INTO TABLE tempBook 
FIELDS TERMINATED BY ';' 
ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @col2)
set title = TRIM(@col1),
    price = TRIM(@col2);




INSERT INTO district (title)
SELECT district_name FROM temp
group by district_name;



INSERT INTO city (district_id, title)
SELECT d.id 
     , t.city_name 
FROM temp t
JOIN district d ON d.title = t.district_name
Group by d.id
	   , t.city_name;


INSERT INTO branch (city_id, title)
SELECT c.id 
     , t.branch_name 
FROM temp t
JOIN city c ON c.title = t.city_name
Group by c.id
	   , t.branch_name;
       
 
 INSERT INTO customer (forename, surname)
SELECT forename 
     , surname 
FROM tempCustomer;
       
       
SET @row_number = 0;       
INSERT INTO salesman (branch_id, forename, surname)
SELECT ceil((@row_number:=@row_number + 1) / 4) AS num, 
       forename, 
       surname
FROM tempsalesman
Limit 1600;


 INSERT INTO book (title, price)
SELECT title 
     , price 
FROM tempBook;



CREATE TABLE IF NOT EXISTS tempStocks (
branch_id  INT(6) NOT NULL,
stock  INT(6) NOT NULL
);


Drop Procedure IF EXISTS procedure_SimulateStocks;
-- DELIMITER $$
-- CREATE PROCEDURE procedure_SimulateStocks()
CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_SimulateStocks`()
BEGIN
   DECLARE done INT DEFAULT FALSE;
   DECLARE stockCount INT DEFAULT 0;
   DECLARE branchId INT DEFAULT 0;
  
   DECLARE c1 CURSOR FOR
    -- Generate random number between 40 and 500 for every branch
                    SELECT id, 
                           (FLOOR( 40 + RAND( ) *461 )) AS stockCount
                    FROM branch;

   DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

   OPEN c1;
   WHILE NOT done DO
        -- yukarıda attığımız selectin sonucunu branchId ve kitap sayısı olarak stock table'ına kaydediyoruz
		FETCH NEXT FROM c1 INTO branchId, stockCount;
            IF (done = FALSE ) THEN -- Prevent Last row of inner cursor fetched twice
                Insert Into stock (branch_id, book_id)
                SELECT branchId, 
                    id as bookId 
                FROM book
                ORDER BY RAND()
                LIMIT stockCount;
            END IF;
   END WHILE;
   CLOSE c1;
END;
-- END$$
-- DELIMITER ;

CALL procedure_SimulateStocks();



CREATE TABLE IF NOT EXISTS tampRandomCustomers (
id  INT(6) NULL
);




DROP PROCEDURE IF EXISTS procedure_SimulateSales;



SET @row_number = 0;    
                   
-- DELIMITER $$
-- CREATE PROCEDURE procedure_SimulateSales()             
CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_SimulateSales`()
BEGIN
   DECLARE done INT DEFAULT FALSE;
   DECLARE branchCount INT DEFAULT (Select Count(1) from branch);
   DECLARE customerID INT DEFAULT 0;
   DECLARE branchID INT DEFAULT 0;
   DECLARE stockID INT DEFAULT 0;
   DECLARE bookAmount INT DEFAULT 0;
   DECLARE totalStock INT DEFAULT 0;
   DECLARE minDate DATETIME DEFAULT '2020-04-30 14:53:27';
   DECLARE maxDate DATETIME DEFAULT '2021-04-30 14:53:27';
   
   DECLARE c1 CURSOR FOR
    -- Generate random number between 40 and 500 for every branch
                     SELECT id as customerID, 
							CASE
								WHEN @row_number < branchCount THEN @row_number:=@row_number + 1
								ELSE @row_number:=@row_number + 1 - branchCount
							END as branchID,
							(FLOOR( 10 + RAND( ) *10 )) AS bookAmount
						FROM bedirhan_bardakci.tampRandomCustomers;

   DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; -- not found olursa true yap

    CREATE TABLE IF NOT EXISTS tampRandomCustomers (
    id  INT(6) NULL
    );


   Delete from bedirhan_bardakci.tampRandomCustomers;
   INSERT INTO bedirhan_bardakci.tampRandomCustomers (id )
    SELECT  id
    FROM bedirhan_bardakci.customer
    order by RAND();


   OPEN c1;
   WHILE NOT done DO
        FETCH NEXT FROM c1 INTO customerID, branchID, bookAmount;
		    SELECT Count(1) into totalStock FROM bedirhan_bardakci.stock where branch_id = branchID and isSold = 0;
            IF (done = FALSE ) THEN -- Prevent Last row of inner cursor fetched twice
				WHILE bookAmount > 0 and totalStock > 0 DO
                
					SELECT id   
                      into stockID 
                      FROM bedirhan_bardakci.stock
					 where branch_id = branchID
					   and isSold = 0 
					 LIMIT 1;
                     

					INSERT INTO bedirhan_bardakci.sale (customer_id, salesman_id, stock_id, amount, saledate)
						VALUES  (
                        customerID,
                        (select id from bedirhan_bardakci.salesman where branch_id = branchID order by RAND() LIMIT 1),
                        stockID,
                        1,
                        (SELECT TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, minDate, maxDate)), minDate))
                        );
                        
					Update bedirhan_bardakci.stock set isSold = 1 where id = stockID;
                    
					SET bookAmount = bookAmount - 1;
                    SET totalStock = totalStock - 1;
                END WHILE;
            END IF;
   END WHILE;
   CLOSE c1;
   DROP TABLE IF EXISTS tampRandomCustomers;
END;
-- END$$
-- DELIMITER ;

CALL procedure_SimulateSales();



-- Remove Temps
DROP TABLE IF EXISTS tempStocks;
DROP TABLE IF EXISTS temp;
DROP TABLE IF EXISTS tempCustomer;
DROP TABLE IF EXISTS tempSalesman;
DROP TABLE IF EXISTS tempBook;
DROP TABLE IF EXISTS tampRandomCustomers;

-- NOTLAR

-- 5 den az ilçesi olan şehirler
-- SELECT count(b.city_id) , c.title
-- FROM branch b
-- join city c on c.id = b.city_id 
-- group by b.city_id ,  c.title
-- having  count(b.city_id) < 5

-- TEST
-- SELECT d.title,c.title, b.title FROM branch b
-- JOIN city c on c.id = b.city_id
-- JOIN district d on d.id = c.district_id 


-- SELECT branch_id, count(book_id) 
-- FROM bedirhan_bardakci.stock
-- group by branch_id
-- order by 2 desc


-- LOAD DATA  INFILE 'C:\\Program Files\\Ampps\\www\\CSE348\\turkey.csv' 
-- IGNORE INTO TABLE city 
-- FIELDS TERMINATED BY ';' 
-- ENCLOSED BY ''
-- LINES TERMINATED BY '\n'
-- (@col1, @col2, @col3)
-- set title = TRIM(@col2);