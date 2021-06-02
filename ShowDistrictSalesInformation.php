<!DOCTYPE html>
<html>

<head>
  <title>CSE 348 Database Management Systems Project - Bedirhan Bardakci</title>
</head>

<body>

  <h1>CSE 348 Database Management Systems Project - Bedirhan Bardakci</h1>

  <?php
  $mysql_host = "localhost";
  $mysql_user = "root";
  $mysql_password = "mysql";

  $db = new PDO("mysql:host=$mysql_host", $mysql_user, $mysql_password);
  ?>

  <form id="form1" name="form1" action="" method="post">
    <div>
      <label for="list">District : </label>
      <select name="list">
        <option value=''>-----SELECT-----</option>

        <?php
        try {
          $data = $db->query("SELECT * FROM bedirhan_bardakci.district")->fetchAll();
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

        $query = $db->prepare("SELECT title FROM bedirhan_bardakci.district WHERE id=:param_id Limit 1");
        $query->bindParam(':param_id', $selected);
        $query->execute();

        if ($query->rowCount()) {
          foreach ($query as $row) {
            echo '<br>You have chosen: ' . $row['title'] . " DISTIRCT <br><br><br>";
            echo "<table border='1'>
                  <tr>
                  <th>#</th>
                  <th>District</th>
                  <th>Province</th>
                  <th>Branch Name</th>
                  <th>Total Profit</th>
                  <th>BEST Salesman</th>
                  <th>BEST Salesman Total Sale</th>
                  <th>WORST Salesman</th>
                  <th>WORST Salesman Total Sale</th>
                  </tr>";


            $query2 = file_get_contents(__DIR__ . "\question3_A_1.sql");

            $query2 = $db->prepare($query2);
            $query2->bindParam(':param_id', $selected);
            $query2->execute();
            $tempBranchID = 0;
            $tempRowIndex = 1;
            foreach ($query2 as $row2) {
              if ($tempBranchID ==  $row2['branchID']) {

                $tempSalesman = $tempSalesman . " , " . $row2['salesmanName'] . " " . $row2['salesmanSurname'];
                $tempSalesmanWorst = $tempSalesmanWorst . " , " . $row2['worstSalesmanName'] . " " . $row2['worstSalesmanSurname'];
              } else {
                if ($tempBranchID > 0) {
                  echo "<tr>";
                  echo "<td>" . $tempRowIndex . "</td>";
                  echo "<td>" . $tempDistrict . "</td>";
                  echo "<td>" . $tempProvince . "</td>";
                  echo "<td>" . $tempBranchName . "</td>";
                  echo "<td>" . $tempTotalProfit  . " TL" . "</td>";
                  echo "<td>" . $tempSalesman . "</td>";
                  echo "<td>" . $tempTotalSale . " Books" . "</td>";
                  echo "<td>" . $tempSalesmanWorst . "</td>";
                  echo "<td>" . $tempTotalSaleWorst . " Books" . "</td>";
                  echo "</tr>";
                  $tempRowIndex = $tempRowIndex + 1;
                }
                $tempBranchID =  $row2['branchID'];
                $tempDistrict =  $row2['district'];
                $tempProvince =  $row2['province'];
                $tempBranchName =  $row2['branchName'];
                $tempTotalProfit =  $row2['totalProfit'];
                $tempSalesman =  $row2['salesmanName'] . " " . $row2['salesmanSurname'];
                $tempTotalSale =  $row2['totalSale'];
                $tempSalesmanWorst =  $row2['worstSalesmanName'] . " " . $row2['worstSalesmanSurname'];
                $tempTotalSaleWorst =  $row2['worstTotalSale'];
              }
            }
            echo "<tr>";
            echo "<td>" . $tempRowIndex . "</td>";
            echo "<td>" . $tempDistrict . "</td>";
            echo "<td>" . $tempProvince . "</td>";
            echo "<td>" . $tempBranchName . "</td>";
            echo "<td>" . $tempTotalProfit  . " TL" . "</td>";
            echo "<td>" . $tempSalesman . "</td>";
            echo "<td>" . $tempTotalSale . " Books" . "</td>";
            echo "<td>" . $tempSalesmanWorst . "</td>";
            echo "<td>" . $tempTotalSaleWorst . " Books" . "</td>";
            echo "</tr>";
            echo "</table>";

            echo "<br/><br/><br/><table border='1'>
            <tr>
            <th>#</th>
            <th>District</th>
            <th>Province</th>
            <th>Branch Name</th>
            <th>Salesman</th>
            <th>Sales Income</th>
            <th>Customer Name</th>
            </tr>";


            $query3 = file_get_contents(__DIR__ . "\question3_A_2.sql");
   
            $query3 = $db->prepare($query3);
            $query3->bindParam(':param_id', $selected);
            $query3->execute();
     
            $tempBranchID = 0;
            $tempRowIndex = 1;
            foreach ($query3 as $row3) {
              echo "<tr>";
              echo "<td>" . $tempRowIndex . "</td>";
              echo "<td>" . $row3['district'] . "</td>";
              echo "<td>" . $row3['province'] . "</td>";
              echo "<td>" . $row3['branch'] . "</td>";
              echo "<td>" . $row3['salesmanName'] . " " . $row3['salesmanSurname'] . "</td>";;
              echo "<td>" . $row3['salesIncome'] . " TL </td>";
              echo "<td>" . $row3['CustomerName'] . " " . $row3['CustomerSurname'] . "</td>";;
              echo "</tr>";
              $tempRowIndex = $tempRowIndex + 1;
            }
            echo "</table>";
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