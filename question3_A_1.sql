SELECT d.title as district,
 br.id as branchID, 
 c.title as province, 
 br.title as branchName, 
 sum(sl.amount * b.price) as totalProfit , 
 finalMax.salesmanName , 
 finalMax.salesmanSurname , 
 finalMax.totalSale , 
 finalMin.salesmanName as worstSalesmanName , 
 finalMin.salesmanSurname as worstSalesmanSurname, 
 finalMin.totalSale as worstTotalSale
from bedirhan_bardakci.sale sl
join bedirhan_bardakci.stock st on st.id = sl.stock_id
join bedirhan_bardakci.book b on b.id = st.book_id
join bedirhan_bardakci.salesman sman on sman.id = sl.salesman_id
join bedirhan_bardakci.branch br on br.id = st.branch_id
join bedirhan_bardakci.city c on c.id = br.city_id
join bedirhan_bardakci.district d on d.id = c.district_id and d.id =  :param_id

LEFT JOIN


(
Select salesAmaountSub.branchID , salesAmaountSub.totalSale , r.salesmanName, r.salesmanSurname
from
(
Select salesAmount.branchID , MAX(salesAmount.totalSale) as totalSale
FROM (
SELECT sman.forename as salesmanName, sman.surname as salesmanSurname , br.id as branchID, sum(sl.amount) as totalSale
from bedirhan_bardakci.sale sl
join bedirhan_bardakci.stock st on st.id = sl.stock_id
join bedirhan_bardakci.book b on b.id = st.book_id
join bedirhan_bardakci.salesman sman on sman.id = sl.salesman_id
join bedirhan_bardakci.branch br on br.id = st.branch_id
join bedirhan_bardakci.city c on c.id = br.city_id
join bedirhan_bardakci.district d on d.id = c.district_id and d.id =  :param_id
group by sman.forename, sman.surname, br.id ) 
as salesAmount
group by salesAmount.branchID 
)  salesAmaountSub

, (
SELECT sman.id as salesmanID, sman.forename as salesmanName, sman.surname as salesmanSurname , br.id as branchID , Count(sman.id)  as totalSale
from bedirhan_bardakci.sale sl
join bedirhan_bardakci.stock st on st.id = sl.stock_id
join bedirhan_bardakci.book b on b.id = st.book_id
join bedirhan_bardakci.salesman sman on sman.id = sl.salesman_id
join bedirhan_bardakci.branch br on br.id = st.branch_id
join bedirhan_bardakci.city c on c.id = br.city_id
join bedirhan_bardakci.district d on d.id = c.district_id and d.id =  :param_id
group by sman.id,sman.forename,sman.surname ,br.id 
) r where r.totalSale =  salesAmaountSub.totalSale
and r.branchID = salesAmaountSub.branchID

) finalMax on finalMax.branchID = br.id
group by salesAmaountSub.branchID , salesAmaountSub.totalSale , r.salesmanName, r.salesmanSurname

LEFT JOIN


(
Select salesAmaountSub.branchID , salesAmaountSub.totalSale , r.salesmanName, r.salesmanSurname
from
(
Select salesAmount.branchID , MIN(salesAmount.totalSale) as totalSale
FROM (
SELECT sman.forename as salesmanName, sman.surname as salesmanSurname , br.id as branchID, sum(sl.amount) as totalSale
from bedirhan_bardakci.sale sl
join bedirhan_bardakci.stock st on st.id = sl.stock_id
join bedirhan_bardakci.book b on b.id = st.book_id
join bedirhan_bardakci.salesman sman on sman.id = sl.salesman_id
join bedirhan_bardakci.branch br on br.id = st.branch_id
join bedirhan_bardakci.city c on c.id = br.city_id
join bedirhan_bardakci.district d on d.id = c.district_id and d.id =  :param_id
group by sman.forename, sman.surname, br.id ) 
as salesAmount
group by salesAmount.branchID 
)  salesAmaountSub

, (
SELECT sman.id as salesmanID, sman.forename as salesmanName, sman.surname as salesmanSurname , br.id as branchID , Count(sman.id)  as totalSale
from bedirhan_bardakci.sale sl
join bedirhan_bardakci.stock st on st.id = sl.stock_id
join bedirhan_bardakci.book b on b.id = st.book_id
join bedirhan_bardakci.salesman sman on sman.id = sl.salesman_id
join bedirhan_bardakci.branch br on br.id = st.branch_id
join bedirhan_bardakci.city c on c.id = br.city_id
join bedirhan_bardakci.district d on d.id = c.district_id and d.id =  :param_id
group by sman.id,sman.forename,sman.surname ,br.id 
) r where r.totalSale =  salesAmaountSub.totalSale
and r.branchID = salesAmaountSub.branchID

) finalMin on finalMin.branchID = br.id


group by  d.title, br.id, branchID, c.title, br.title,finalMax.salesmanName , finalMax.salesmanSurname , finalMax.totalSale , finalMin.salesmanName , finalMin.salesmanSurname , finalMin.totalSale