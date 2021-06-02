SELECT sman.id as SalesmanID, 
       sman.forename as SalesmanName,
       sman.surname as SalesmanSurnmae,
       count(price) as totalAmount,
       summary.mySum as totalIncome
FROM bedirhan_bardakci.sale s
Join bedirhan_bardakci.stock st on st.id = s.stock_id
join bedirhan_bardakci.book bo on bo .id = st.book_id
join bedirhan_bardakci.salesman sman on sman .id = s.salesman_id
,(
SELECT sman.id , sman.forename , sman.surname , sum(price) as mySum
FROM bedirhan_bardakci.sale s
Join bedirhan_bardakci.stock st on st.id = s.stock_id
join bedirhan_bardakci.book bo on bo .id = st.book_id
join bedirhan_bardakci.salesman sman on sman .id = s.salesman_id
group by sman.id , sman.forename , sman.surname
)summary
where summary.id =  sman.id and sman.branch_id = :param_id
group by sman.id , sman.forename , sman.surname