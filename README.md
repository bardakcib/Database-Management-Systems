# BookStore

# A Simple Database Management System using MySQL + PHP

[!(https://forthebadge.com/images/badges/built-with-love.svg)]



Our goal in this project is to create some reporting pages for a bookstore.

To run this project;

1. Download [ammps](https://ampps.com/) ( software stack of Apache, Mysql &amp; PHP )
2. After installation copy all files to &quot;C:\Program Files\Ampps\www\&quot; ( this is default for me )
3. Then go to &quot;[http://localhost/CSE348/install.php](http://localhost/CSE348/install.php)&quot; using your web browser

\*\*\*Before Start, Please go to MYSQL --\&gt; Edit -\&gt; Preferences --\&gt; SQL Editor and set to connection read timeout to at least 60. Because we will be running some scripts to simulate sales transactions on database side\*\*\*

To Complete This Project I have used :

- VSCode for PHP and SQL codes
- MySQL WorkBench ( with ammps, mysql will be installed but I don&#39;t like the browser gui. So I have installed the workbench, workbench is much more capable )
- For database connections I have used PDO
- To read and upload .csv files to database I have used &quot;LOAD DATA INFILE&quot; command.

To use this command you may need to run this sql command to check default folder path

    - SHOW VARIABLES LIKE &quot;secure\_file\_priv&quot;;

To Change it go to &quot;C:\Program Files\Ampps\mysql\my.ini&quot; file and at under &quot;Server&quot; part add the below line :

    - secure\_file\_priv=&quot;C:/Program Files/Ampps/www/CSE348&quot;

Main Page :
