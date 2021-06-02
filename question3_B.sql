SELECT d.title as districtName,
ci.title as province,
b.title as branchName,
sman.forename as salesmanName,
sman.surname  as salesmanSurname,
c.forename as customerName,
c.surname as customerSurname,
s.amount as bookAmount, 
s.saledate as saleDate, 
bo.title as bookTitle, 
bo.price as bookPrice
FROM bedirhan_bardakci.sale s
join bedirhan_bardakci.customer c on c.id = s.customer_id
join bedirhan_bardakci.salesman sman on sman.id = s.salesman_id
join bedirhan_bardakci.branch b on b.id = sman.branch_id
join bedirhan_bardakci.city ci on ci.id = b.city_id
join bedirhan_bardakci.district d on d.id = ci.district_id
join bedirhan_bardakci.stock st on st.id = s.stock_id
join bedirhan_bardakci.book bo on bo.id = st.book_id
where c.id = :param_id