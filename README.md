# BookStore

# A Simple Database Management System using MySQL & PHP

![](https://github.com/bardakcib/resources/blob/main/badges/built-with-love.svg)       ![](https://github.com/bardakcib/resources/blob/main/badges/vscode.svg)       ![](https://github.com/bardakcib/resources/blob/main/badges/php.svg)       ![](https://github.com/bardakcib/resources/blob/main/badges/mysql.svg)       ![](https://github.com/bardakcib/resources/blob/main/badges/stackover.svg)



Our goal in this project is to create some reporting pages for a bookstore.

To run this project;

1. Download [ammps](https://ampps.com/) ( software stack of Apache, Mysql &amp; PHP )
2. After installation copy all files to &quot;C:\Program Files\Ampps\www\&quot; ( this is default for me )
3. Then go to &quot;[http://localhost/CSE348/install.php](http://localhost/CSE348/install.php)&quot; using your web browser

    **Before running the prohect**, Please go to MYSQL --> Edit --> Preferences --> SQL Editor and set to connection read timeout to at least 60. Because we will be running some scripts to simulate sales transactions on database side


To complete this project I have used :

- [VSCode](https://code.visualstudio.com/download) for PHP and SQL codes
- [MySQL WorkBench](https://dev.mysql.com/downloads/installer/)  ( with ammps, mysql will be installed but I don&#39;t like the browser gui. So I have installed the workbench, workbench is much more capable )
- For database connections I have used [PDO - PHP Data Objects](https://www.php.net/manual/en/book.pdo.php)
- To read and upload .csv files to database I have used **&quot;LOAD DATA INFILE&quot;** command.

To use this command you may need to run this sql command to check default folder path

    - SHOW VARIABLES LIKE &quot;secure\_file\_priv&quot;;

To Change it go to &quot;C:\Program Files\Ampps\mysql\my.ini&quot; file and at under &quot;Server&quot; part add the below line :

    - secure\_file\_priv=&quot;C:/Program Files/Ampps/www/CSE348&quot;


## After Everything is  as expected, then a main page like below should welcome you :


![](https://github.com/bardakcib/Database-Management-Systems/blob/main/resources/mainPageO.png)


## Invoice Report :

![](https://github.com/bardakcib/Database-Management-Systems/blob/main/resources/invoiceBorder.png)


## Sales Income Report :

![](https://github.com/bardakcib/Database-Management-Systems/blob/main/resources/saleIncomeBorder.png)


## Sales Report :

![](https://github.com/bardakcib/Database-Management-Systems/blob/main/resources/salesBorder.png)


## Best Worst Salesman :

![](https://github.com/bardakcib/Database-Management-Systems/blob/main/resources/bestWorstBorder.png)



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
