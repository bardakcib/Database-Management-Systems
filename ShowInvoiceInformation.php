<!DOCTYPE html>
<html>

<head>
  <title>Database Management Systems - BookStore Project - Bedirhan Bardakci</title>
</head>

<body>

  <h1>Database Management Systems - BookStore Project - Bedirhan Bardakci</h1>

  <?php
  $mysql_host = "localhost";
  $mysql_user = "root";
  $mysql_password = "mysql";

  $db = new PDO("mysql:host=$mysql_host", $mysql_user, $mysql_password);
  ?>
  <p>
  Some customer name to test : <br><br>
  Bozdoğan BOLAÇ <br>
  Abır YALNIZ <br>
  Erduran YİĞİT KUPLAY <br><br>
  </p>

  <form name="form" action="" method="post">
    <p>Customer Name & Surname</p>
    <input type="text" name="name" id="subject" value="">
    <input type="text" name="surname" id="subject" value="">
    <input type="submit" name="submit" vlaue="Get Invoice">
  </form>


  <?php
  if (isset($_POST['surname']) && (isset($_POST['name']))) {
    $name =  $_POST['name'];
    $surname = $_POST['surname'];

    $query = $db->prepare("SELECT id FROM bedirhan_bardakci.customer WHERE forename = '" .  $name . "' and surname = '" .  $surname . "'");
    $query->execute();
    if ($query->rowCount()) {
      foreach ($query as $row) {
        $selected = $row['id'];
        echo "<br><br>CUSTOMER : " . $name . " " . $surname . "<br><br>";

        echo "<table border='1'>
          <tr>
          <th>#</th>
          <th>District</th>
          <th>Province</th>
          <th>Branch Name</th>
          <th>Salesman</th>
          <th>Book Amount</th>
          <th>Book Title</th>
          <th>Price</th>
          <th>Sale Date</th>
          </tr>";


        $query2 = file_get_contents(__DIR__ . "\question3_B.sql");

        $query2 = $db->prepare($query2);
        $query2->bindParam(':param_id', $selected);
        // $query2->bindParam(':param_surname', '"ŞEN"');
        $query2->execute();
        $tempRowIndex = 1;
        foreach ($query2 as $row2) {
          echo "<tr>";
          echo "<td>" . $tempRowIndex . "</td>";
          echo "<td>" . $row2['districtName'] . "</td>";
          echo "<td>" . $row2['province'] . "</td>";
          echo "<td>" . $row2['branchName'] . "</td>";
          echo "<td>" . $row2['salesmanName'] . " " . $row2['salesmanSurname'] . "</td>";;
          echo "<td>" . $row2['bookAmount'] . " pcs</td>";
          echo "<td>" . $row2['bookTitle'] . "</td>";
          echo "<td>" . $row2['bookPrice'] .  " TL</td>";
          echo "<td>" . $row2['saleDate'] .  "</td>";
          echo "</tr>";
          $tempRowIndex = $tempRowIndex + 1;
        }
        echo "</table>";
      }
    }
  }
  ?>
</body>

</html>
