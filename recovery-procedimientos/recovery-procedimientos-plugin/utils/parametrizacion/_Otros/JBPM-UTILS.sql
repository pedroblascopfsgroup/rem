select count(exp.EXP_ID) from  pfs01.exp_expedientes exp where exp.DD_EST_ID = 5; 

select sysdate from dual;

select * from pfsmaster.jbpm_job order by duedate_

select * from pfsmaster.jbpm_processdefinition

update pfsmaster.jbpm_job set duedate_ = sysdate;  -- Avanzar timmers

--update pfsmaster.jbpm_job set locktime_ = '25/03/2009 9:46:20,000000';