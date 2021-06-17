# DBMS

# A Simple Database Management System using MySQL & PHP

![](https://github.com/bardakcib/resources/blob/main/badges/built-with-love.svg)
![](https://github.com/bardakcib/resources/blob/main/badges/vscode.svg)
![](https://github.com/bardakcib/resources/blob/main/badges/php.svg)
![](https://github.com/bardakcib/resources/blob/main/badges/mysql.svg)
![](https://github.com/bardakcib/resources/blob/main/badges/stackover.svg)



Our goal in this project is to create some reporting pages for a bookstore.

To run this project;

1. Download [ammps](https://ampps.com/) ( software stack of Apache, Mysql &amp; PHP )
2. After installation, copy all files to &quot;C:\Program Files\Ampps\www\&quot; ( this is default for me )
3. Then go to &quot;[http://localhost/CSE348/install.php](http://localhost/CSE348/install.php)&quot; using your web browser

    **Before running the project**, Please go to MYSQL --> Edit --> Preferences --> SQL Editor and set to connection read timeout to at least 60. Because we will be running some scripts to simulate sales transactions on database side


To complete this project I have used :

- [VSCode](https://code.visualstudio.com/download) for PHP and SQL codes
- [MySQL WorkBench](https://dev.mysql.com/downloads/installer/)  ( with ammps, mysql will be installed but I don&#39;t like the browser gui. So I have installed the workbench, workbench is much more capable )
- For database connections I have used [PDO - PHP Data Objects](https://www.php.net/manual/en/book.pdo.php)
- To read and upload .csv files to database I have used **&quot;LOAD DATA INFILE&quot;** command.

To use this command you may need to run this sql command to check default folder path

    - SHOW VARIABLES LIKE "secure_file_priv";

To change it; go to "C:\Program Files\Ampps\mysql\my.ini" file and find "# SERVER SECTION"  then add the below line under this section :

	- secure_file_priv="C:/Program Files/Ampps/www/CSE348"

Modified my.ini file : 
	![](https://github.com/bardakcib/Database-Management-Systems/blob/main/resources/secure.png)



## After configurations, a main page like below should welcome you :


![](https://github.com/bardakcib/Database-Management-Systems/blob/main/resources/mainPageO.png)


## Invoice Report :

![](https://github.com/bardakcib/Database-Management-Systems/blob/main/resources/invoiceBorder.png)


## Sales Income Report :

![](https://github.com/bardakcib/Database-Management-Systems/blob/main/resources/saleIncomeBorder.png)


## Sales Report :

![](https://github.com/bardakcib/Database-Management-Systems/blob/main/resources/salesBorder.png)


## Best Worst Salesman :

![](https://github.com/bardakcib/Database-Management-Systems/blob/main/resources/bestWorstBorder.png)


## Query For Reading From .csv Files
```sql
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
```


## Cursor For Simulating Random Sales Transactions
```sql
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
```


## PHP PDO Database Connection Sample
```php
    $mysql_host = "localhost";
    $mysql_user = "root";
    $mysql_password = "mysql";
    $db = new PDO("mysql:host=$mysql_host", $mysql_user, $mysql_password);
```


## PHP PDO Data Fetch Sample
```php
    $query2 = file_get_contents(__DIR__ . "\question3_C_1.sql");

    $query2 = $db->prepare($query2);
    $query2->bindParam(':param_id', $selected);
    $query2->execute();
    $tempRowIndex = 1;
    $tempIncome = 0;
    $tempAmount = 0;
    foreach ($query2 as $row2) {
      echo "<tr>";
      echo "<td>" . $tempRowIndex . "</td>";
      echo "<td>" . $row2['customerName'] . " " . $row2['customerSurnmae'] . "</td>";
      echo "<td>" . $row2['totalAmount'] . " pcs</td>";
      echo "<td>" . $row2['totalIncome'] . " TL</td>";
      echo "</tr>";
      $tempIncome = $tempIncome + $row2['totalIncome'];
      $tempAmount = $tempAmount + $row2['totalAmount'];
      $tempRowIndex = $tempRowIndex + 1;
    }
    echo "</table> <br>";
```

# References

1. [Youtube - Run PHP with AMPPS in your local windows machine](https://www.youtube.com/watch?v=l1I0CCOUWug)
2. [Book List sample xlsx](https://www.z-kutuphane.org/z-kutuphane-kitap-listesi/)
3. [Name List](https://gist.github.com/ismailbaskin/1325813)
4. [Surname List](https://gist.github.com/emrekgn/493304c6445de15657b2#file-soyisimler)
5. [PDO Samples](https://kerteriz.net/php-pdo-ile-mysql-veritabani-baglantisi-islemleri/)
6. [PHP Table Sample](https://stackoverflow.com/questions/17902483/show-values-from-a-mysql-database-table-inside-a-html-table-on-a-webpage)
7. [Procedure Sample](https://stackoverflow.com/questions/18409755/create-stored-procedures-with-pdo-in-php/18411103#18411103)
8. [Cursor Sample](https://www.sqlshack.com/an-overview-of-the-sql-cursor-fetch_status-functions/)
9. [Official Turkey City List](https://postakodu.ptt.gov.tr/)   Download Link is kind of hidden on the page, so I want to put a screenshot :) 
	
	![](https://github.com/bardakcib/Database-Management-Systems/blob/main/resources/ptt.png)
	
