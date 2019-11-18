// -- Stmt 1: insert
INSERT INTO bdscstmr (bdscstmrname, bdscstmrfirstname, bdscstmrdateofbirth, bdscstmrtypeid) 
VALUES ('Test', 'Paul', to_date('1985-12-09', 'YYYY-MM-DD'), 2);

// -- Stmt 2: get inserted autoval
Select LASTVAL();

// -- Stmt 3: select with date and escape in like
SELECT t1.bdscstmrid, t1.bdscstmrname AS Name, t1.bdscstmrfirstname AS Firstname, t1.bdscstmrdateofbirth, t1.bdscstmrpostcode, t1.bdscstmrcity, t1.bdscstmrstreet, t1.bdscstmrtypeid, t1.bdscstmrnotice, t2.bdscstmrtypedesc AS TypeDescJoin, t1.bdscstmrimage, t1.bdscstmrimageext 
FROM bdscstmr t1 LEFT OUTER JOIN bdscstmrtype t2 ON t1.bdscstmrtypeid = t2.bdscstmrtypeid 
WHERE t1.bdscstmrdateofbirth = '1977-05-25' 
AND t1.bdscstmrnotice LIKE '%100#%%' ESCAPE '#' 
ORDER BY t1.bdscstmrname, t1.bdscstmrfirstname

// -- Stmt 4: quotes and search date
Select "bdscstmrid", "bdscstmrname", "bdscstmrfirstname", "bdscstmrdateofbirth"
from "bdscstmr"   
where "bdscstmrdateofbirth" = '1985-12-09';

// -- Stmt 5: insert with quotes
INSERT INTO "bdscstmrorder" ("bdscstmrordercstmrid", "bdscstmrorderdate") 
VALUES (1, to_date('2017-03-22', 'YYYY-MM-DD'));

// -- Stmt 6: get inserted val
Select LASTVAL();

// -- Stmt 7: select without table
Select 1 as bdscstmrid, 'Test' as bdscstmrname, 'Paul' as bdscstmrfirstname, to_date('1985-12-09', 'YYYY-MM-DD') as bdscstmrdateofbirth, 2 as bdscstmrtypeid;

// -- Stmt 8: select in from without table
SELECT t1.* 
FROM (SELECT -1 AS bdscstmrorderid, -1 AS bdscstmrordercstmrid, to_date('2017-03-22', 'YYYY-MM-DD') AS bdscstmrorderdate) t1  
	LEFT OUTER JOIN bdscstmr t2 ON t1.bdscstmrordercstmrid = t2.bdscstmrid 
ORDER BY t1.bdscstmrorderdate Desc

// -- Stmt 9: subqueries/union/subselect in from
SELECT t1.bdscstmrid, t1.bdscstmrname, t1.bdscstmrfirstname, t1.bdscstmrdateofbirth, t1.bdscstmrpostcode, t1.bdscstmrcity, t1.bdscstmrstreet, 'is a customer', t2.bdscstmrsum
from bdscstmr t1 left outer join

(
	SELECT t2s1.bdscstmrid, SUM(t2s3.bdsordersum) as bdscstmrsum
	from bdscstmr t2s1 inner join 
	(
		bdscstmrorder t2s2 inner join
		(
			SELECT s1t1.bdscstmrorderposorderid, SUM(s1t1.bdscstmrorderposquantity * s1t2.bdsarticleprice) as bdsordersum 
			FROM bdscstmrorderpos s1t1 inner join bdsarticle s1t2 on s1t1.bdscstmrorderposartid = s1t2.bdsarticleid
			group by s1t1.bdscstmrorderposorderid
		) t2s3 on t2s2.bdscstmrorderid = t2s3.bdscstmrorderposorderid
	)  on t2s1.bdscstmrid = t2s2.bdscstmrordercstmrid
	group by t2s1.bdscstmrid

) t2 on t1.bdscstmrid = t2.bdscstmrid

where exists
(
	Select te1.bdscstmrtypeid
	from bdscstmrtype te1
	where te1.bdscstmrtypeid = 2
	and te1.bdscstmrtypeid = t1.bdscstmrtypeid
)

UNION

Select tu1.bdscstmrid, tu1.bdscstmrname, tu1.bdscstmrfirstname, tu1.bdscstmrdateofbirth, tu1.bdscstmrpostcode, tu1.bdscstmrcity, tu1.bdscstmrstreet, 'is no customer', NULL
from bdscstmr tu1
where not exists
(
	Select tue1.bdscstmrtypeid
	from bdscstmrtype tue1
	where tue1.bdscstmrtypeid = 2
	and tue1.bdscstmrtypeid = tu1.bdscstmrtypeid
)
;

// -- Stmt 10: nested joins
Select *
from bdscstmr t1
     inner join (bdscstmrorder t2
                inner join (bdscstmrorderpos t3
                      inner join bdsarticle t4
                      on t3.bdscstmrorderposartid = t4.bdsarticleid)
                on t2.bdscstmrorderid = t3.bdscstmrorderposorderid)
     on t1.bdscstmrid = t2.bdscstmrordercstmrid
;
