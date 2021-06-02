SELECT c.id as customerID, 
       c.forename as customerName,
       c.surname as customerSurnmae,
       count(price) as totalAmount,
       summary.mySum as totalIncome
FROM bedirhan_bardakci.sale s
Join bedirhan_bardakci.stock st on st.id = s.stock_id
join bedirhan_bardakci.book bo on bo .id = st.book_id
join bedirhan_bardakci.salesman sman on sman .id = s.salesman_id
join bedirhan_bardakci.customer c on C .id = s.customer_id
,(
SELECT c.id , c.forename , c.surname , sum(price) as mySum
FROM bedirhan_bardakci.sale s
Join bedirhan_bardakci.stock st on st.id = s.stock_id
join bedirhan_bardakci.book bo on bo .id = st.book_id
join bedirhan_bardakci.salesman sman on sman .id = s.salesman_id
join bedirhan_bardakci.customer c on C .id = s.customer_id
where sman.branch_id = :param_id
group by c.id , c.forename , c.surname
)summary
where summary.id =  c.id and sman.branch_id = :param_id
group by c.id , c.forename , c.surname