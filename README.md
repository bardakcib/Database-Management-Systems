# BookStore

# A Simple Database Management System using MySQL + PHP

![](https://camo.githubusercontent.com/e5031d971f0fe1cfff21f7e99dc0406eecd41b9f294d17db7523340bdf9fcccb/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f56697375616c53747564696f2d3543324439312e7376673f7374796c653d666f722d7468652d6261646765266c6f676f3d76697375616c2d73747564696f266c6f676f436f6c6f723d7768697465)



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
