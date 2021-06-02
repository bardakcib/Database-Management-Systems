<!DOCTYPE html>
<html>

<head>
  <title>CSE 348 Database Management Systems Project - Bedirhan Bardakci</title>
</head>

<body>

  <h1>CSE 348 Database Management Systems Project - Bedirhan Bardakci</h1>
  <br><br><br>

  <a href="https://postakodu.ptt.gov.tr/" target="_blank"> Posta Kodu Özet Tablosu</a>
  <br> <br>
  <a href="https://dev.mysql.com/downloads/windows/installer/8.0.html" target="_blank"> My SQL Workbanch ( Optional )</a>
  <br> <br>
  <a href="http://s2.softaculous.com/a/ampps/files/Ampps-3.9-x86_64-setup.exe " target="_blank"> Ampps 3.9</a>
  <br> <br>
  <a href="https://www.youtube.com/watch?v=l1I0CCOUWug" target="_blank"> Youtube - Run Php with AMPPS in your local windows machine</a>
  <p>For local test , I have used : C:\Program Files\Ampps\www\CSE348 </p>
  <br> 
  <a href="https://www.z-kutuphane.org/z-kutuphane-kitap-listesi/" target="_blank"> Kitap Listesi</a>
  <br> <br>
  <a href="https://gist.github.com/ismailbaskin/1325813" target="_blank"> İsim Listesi</a>
  <br> <br>
  <a href="https://gist.github.com/emrekgn/493304c6445de15657b2#file-soyisimler" target="_blank"> Soyad Listesi</a>
  <br> <br>
  <a href="https://kerteriz.net/php-pdo-ile-mysql-veritabani-baglantisi-islemleri/" target="_blank"> PDO Sample Connection</a>
  <br> <br>
  <a href="https://stackoverflow.com/questions/17902483/show-values-from-a-mysql-database-table-inside-a-html-table-on-a-webpage" target="_blank"> Php Table Sample</a>
  <br> <br>
  <a href="https://stackoverflow.com/questions/18409755/create-stored-procedures-with-pdo-in-php/18411103#18411103" target="_blank"> MYSQL scriptleri içerisinde iterasyon yapabilmek için Procedure nasıl kullanır</a>
  <br> <br>
  <a href="https://www.sqlshack.com/an-overview-of-the-sql-cursor-fetch_status-functions/" target="_blank"> MYSQL Cursor kullanımı</a>
  
  <p><br><br>
  C:\Program Files\Ampps\mysql --> my.ini dosyasına   Server Section --> [mysqld] altına "secure_file_priv="C:/Program Files/Ampps/www/CSE348" satırını ekledim. Böylelikle local .csv dosyalarını okuyabildim.
  <br><br><br><br>
  MySql de default secure_file_priv nedir kontrol etmek için : 
  <br><br>
  SHOW VARIABLES LIKE "secure_file_priv";
  <br><br>
  secure_file_priv="C:/Program Files/Ampps/www/CSE348"
  </p>
</body>


</html>