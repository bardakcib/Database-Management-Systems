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

  <form id="form1" name="form1" action="" method="post">
    <div>
      <label for="list">Branch : </label>
      <select name="list">
        <option value=''>-----SELECT-----</option>

        <?php
        try {
          $data = $db->query("SELECT * FROM bedirhan_bardakci.branch")->fetchAll();
          // and somewhere later:
          foreach ($data as $row) {
            echo "<option value='$row[id]'>$row[title]</option>";
          }
        } catch (PDOException $e) {
          print "Error!: " . $e->getMessage() . "<br/>";
        }
        ?>
      </select>

      <input type="submit" name="submit" vlaue="Choose options">
    </div>
  </form>


  <?php
  if (isset($_POST['submit'])) {
    if (!empty($_POST['list'])) {
      try {
        $selected = $_POST['list'];

        $query = $db->prepare("SELECT b.title as branchName , c.title as province FROM bedirhan_bardakci.branch b, bedirhan_bardakci.city c WHERE b.id=:param_id and c.id = b.city_id  Limit 1");
        $query->bindParam(':param_id', $selected);
        $query->execute();

        if ($query->rowCount()) {
          foreach ($query as $row) {
            echo '<br>You have chosen ' . $row['branchName'] . "  branch of  " . $row['province'] . "  Province<br><br><br>";
            echo "<table border='1'>
                  <tr>
                  <th>#</th>
                  <th>Customer</th>
                  <th>Amount</th>
                  <th>Income</th>
                   </tr>";


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

            echo $tempAmount . " pcs = " . $tempIncome . " TL <br> <hr> <br> <br>";

            echo "<table border='1'>
                  <tr>
                  <th>#</th>
                  <th>Salesman</th>
                  <th>Amount</th>
                  <th>Income</th>
                  </tr>";

            $query2 = file_get_contents(__DIR__ . "\question3_C_2.sql");

            $query2 = $db->prepare($query2);
            $query2->bindParam(':param_id', $selected);
            $query2->execute();
            $tempRowIndex = 1;
            $tempIncome = 0;
            $tempAmount = 0;
            foreach ($query2 as $row2) {
              echo "<tr>";
              echo "<td>" . $tempRowIndex . "</td>";
              echo "<td>" . $row2['SalesmanName'] . " " . $row2['SalesmanSurnmae'] . "</td>";
              echo "<td>" . $row2['totalAmount'] . " pcs</td>";
              echo "<td>" . $row2['totalIncome'] . " TL</td>";
              echo "</tr>";

              $tempIncome = $tempIncome + $row2['totalIncome'];
              $tempAmount = $tempAmount + $row2['totalAmount'];
              $tempRowIndex = $tempRowIndex + 1;
            }
            echo "</table> <br>";
            echo $tempAmount . " pcs = " . $tempIncome . " TL";
          }
        } else {
          echo "Kayıt bulunamadı";
        }
      } catch (PDOException $e) {
        echo "Error!: " . $e->getMessage() . "<br/>";
      }
    } else {
      echo 'Please select a district !!!';
    }
  }
  ?>

</body>

</html>
