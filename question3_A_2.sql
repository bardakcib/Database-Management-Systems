SELECT  d.title as district,
        c.title as province,
        br.id as branchID,
        br.title as branch,
        sman.id as salesmanID,
        sman.forename as salesmanName,
        sman.surname as salesmanSurname,
        SUM(sl.amount) as amount,
        SUM(sl.amount * b.price) as salesIncome,
        hence.forename as CustomerName,
        hence.surname as CustomerSurname
from bedirhan_bardakci.sale sl
join bedirhan_bardakci.stock st on st.id = sl.stock_id
join bedirhan_bardakci.book b on b.id = st.book_id
join bedirhan_bardakci.salesman sman on sman.id = sl.salesman_id
join bedirhan_bardakci.branch br on br.id = st.branch_id
join bedirhan_bardakci.city c on c.id = br.city_id
join bedirhan_bardakci.district d on d.id = c.district_id and d.id = :param_id,
    (
        Select summary.salesman_id,
                summary.branch_id,
                summary.totalSalee,
                resultConc.forename,
                resultConc.surname
        FROM (
                Select  maxresult.salesman_id,
                        maxresult.branch_id,
                        MAX(totalSale2) as totalSalee
                From (
                        Select  c.id as customerID,
                                c.forename,
                                c.surname,
                                sl.salesman_id,
                                s.branch_id,
                                SUM(sl.amount * b.price) as totalSale2
                        from bedirhan_bardakci.sale sl
                            join bedirhan_bardakci.customer c on c.id = sl.customer_id
                            join bedirhan_bardakci.stock s on s.id = sl.stock_id
                            join bedirhan_bardakci.book b on b.id = s.book_id
                        group by c.id,
                            c.forename,
                            c.surname,
                            sl.salesman_id,
                            s.branch_id
                    ) maxresult
                group by maxresult.salesman_id,
                    maxresult.branch_id
            ) summary,
            (
                Select c.id as customerID,
                    c.forename,
                    c.surname,
                    sl.salesman_id,
                    s.branch_id,
                    SUM(sl.amount * b.price) as totalSale
                from bedirhan_bardakci.sale sl
                    join bedirhan_bardakci.customer c on c.id = sl.customer_id
                    join bedirhan_bardakci.stock s on s.id = sl.stock_id
                    join bedirhan_bardakci.book b on b.id = s.book_id
                group by c.id,
                    c.forename,
                    c.surname,
                    sl.salesman_id,
                    s.branch_id
            ) resultConc
        where resultConc.salesman_id = summary.salesman_id
            and summary.branch_id = resultConc.branch_id
            and resultConc.totalSale = summary.totalSalee
    ) as hence
where hence.salesman_id = sman.id
    and hence.branch_id = br.id
group by d.title,
    c.title,
    br.id,
    br.title,
    sman.id,
    sman.forename,
    sman.surname,
    hence.forename,
    hence.surname