<!DOCTYPE html>
<html>

<head>
  <title>CSE 348 Database Management Systems Project - Bedirhan Bardakci</title>
</head>

<body>

  <h1>CSE 348 Database Management Systems Project - Bedirhan Bardakci</h1>
  <a href="http://localhost/CSE348/ShowDistrictSalesInformation.php" target="_blank"> Go To Report Page</a>
  <br> <br>
  <a href="http://localhost/CSE348/ShowInvoiceInformation.php" target="_blank"> Go To Invoice Page</a>
  <br> <br>
  <a href="http://localhost/CSE348/ShowBranchSalesInformation.php" target="_blank"> Go To Branch Sales Information Page</a>
  <br> <br>
  <a href="http://localhost/CSE348/About.php" target="_blank"> About Page</a>
  <br><br>
  <hr>
  <p>
    INFORMATION !!! <br> <br>
    Below Cities does not have 5 branches <br> <br>
    BARTIN has 4 branches <br>
    BAYBURT has 3 branches <br>
    IĞDIR has 4 branches <br>
    KİLİS has 4 branches <br>
  </p>
  <br>
  <hr>
  <form method="post">
    <p>Before Start, Please go to MYSQL --> Edit -> Preferences --> SQL Editor and set to connection read timeout to 240.</p>
    <br>
    <hr><br><br>
    <input type="submit" name="installationButton" class="button" value="Create Tables and Generate Random Sales Transactions" />
    <br><br>
    Takes around 55 seconds to Create Schema + Generate about 7000-8000 random sales transaction
  </form>
  <br>
  <hr>
  <form method="post">
    <br><br>
    <input type="submit" name="MoreButton" class="button" value="Generate More Random Sales Transactions For Detailed Test IF DB Already Created" />
    <br><br>
    Takes around 35 seconds to generate around 7000-8000 random sales transaction
  </form>

  <?php
  $mysql_host = "localhost";
  $mysql_user = "root";
  $mysql_password = "mysql";
  $db = new PDO("mysql:host=$mysql_host", $mysql_user, $mysql_password);
  try {
    if (array_key_exists('installationButton', $_POST)) {
      echo "<br><br><hr><br>Connected to " . $mysql_host . " successfully with user " . $mysql_user . "<br><br>";

      $query = file_get_contents(__DIR__ . "\mainScripts.sql");

      $stmt = $db->prepare($query);

      if ($stmt->execute()) {
        echo "Scripts Successfully Executed";
      } else {
        echo "Script Execution Failed";
      }

      $dbh = null;
    }

    if (array_key_exists('MoreButton', $_POST)) {
      echo "<br><br><hr><br>Connected to " . $mysql_host . " successfully with user " . $mysql_user . "<br><br>";

      $query = file_get_contents(__DIR__ . "\scriptsMoreData.sql");

      $stmt = $db->prepare($query);

      if ($stmt->execute()) {
        echo "More Data Successfully Generated";
      } else {
        echo "Script Execution Failed";
      }

      $dbh = null;
    }
  } catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
  }
  ?>
</body>

</html>