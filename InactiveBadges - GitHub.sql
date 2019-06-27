  WITH BI AS
(
  SELECT BADGE_C.CARDNO, BADGE_V.BADGE_EMPLOYEE_NO
  FROM BADGE_V 
  INNER join BADGE_C ON BADGE_C.ID = BADGE_V.ID
),
empScans as 
(select evnt_dat, location, cast(cardno as varchar(5)) as CARDNO, fname, lname, PANEL_DESCRP, CARDSTATUS.DESCRP as statDescrp
from EV_LOG
inner join CARDSTATUS ON CARDSTATUS.STATUS = EV_LOG.STAT_COD
where (EVNT_DAT is not null)
and (LNAME is not null)
group by CARDNO, LOCATION, fname, lname, EVNT_DAT, PANEL_DESCRP, CARDSTATUS.DESCRP
)
select * from empScans
inner join BI on BI.cardno = empScans.CARDNO
where (evnt_dat >  '20190620 06:00:00')	--Start Date
and (evnt_dat < '20190625 19:00:00') --End Date
and (statDescrp='Active' OR statDescrp='Disabled')
order by evnt_dat desc