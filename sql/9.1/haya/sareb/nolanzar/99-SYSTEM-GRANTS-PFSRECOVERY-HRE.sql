--EJECUCION DE PERMISOS PARA ENTORNO HAYA
--EJECUTAR COMO USUARIO SYSTEM ó SYS
--
--AÑADIR PERMISOS CON BLOQUES BEGIN - EXCEPTION - END PARA QUE NO TERMINE EL SCRIPT A MITAD DE EJECUCION
--VALIDO PARA TODOS LOS ENTORNOS DE HAYA
--
set serveroutput on
BEGIN

BEGIN
  for rs in (select table_name 
               from DBA_TABLES 
			   where UPPER(OWNER) = 'HAYA01') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON HAYA01.' || rs.table_name || ' TO PFSRECOVERY';  
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
BEGIN
  for rs in (select table_name 
               from DBA_TABLES 
			   where UPPER(OWNER) = 'HAYAMASTER') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON HAYAMASTER.' || rs.table_name || ' TO PFSRECOVERY';  
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
BEGIN
  for rs in (select table_name 
               from DBA_TABLES 
			   where UPPER(OWNER) = 'RECOVERY_MD') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON RECOVERY_MD.' || rs.table_name || ' TO PFSRECOVERY';  
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
BEGIN
  for rs in (select table_name 
               from DBA_TABLES 
			   where UPPER(OWNER) = 'MINIREC') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON MINIREC.' || rs.table_name || ' TO PFSRECOVERY';  
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
BEGIN
  for rs in (select table_name 
               from DBA_TABLES 
			   where UPPER(OWNER) = 'RECOVERY_HAYA_DATASTAGE') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON RECOVERY_HAYA_DATASTAGE.' || rs.table_name || ' TO PFSRECOVERY';  
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
BEGIN
  for rs in (select table_name 
               from DBA_TABLES 
			   where UPPER(OWNER) = 'RECOVERY_HAYA_DWH') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON RECOVERY_HAYA_DWH.' || rs.table_name || ' TO PFSRECOVERY';  
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

--DAR PERMISOS DE SELECT A LAS SECUENCIAS
BEGIN
  for rs in (select SEQUENCE_NAME 
               from DBA_SEQUENCES 
			   where UPPER(SEQUENCE_OWNER) = 'HAYA01') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT ON HAYA01.' || rs.SEQUENCE_NAME || ' TO PFSRECOVERY';  
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
BEGIN
  for rs in (select SEQUENCE_NAME 
               from DBA_SEQUENCES 
			   where UPPER(SEQUENCE_OWNER) = 'HAYAMASTER') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT ON HAYAMASTER.' || rs.SEQUENCE_NAME || ' TO PFSRECOVERY';  
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
BEGIN
  for rs in (select SEQUENCE_NAME 
               from DBA_SEQUENCES 
			   where UPPER(SEQUENCE_OWNER) = 'MINIREC') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT ON MINIREC.' || rs.SEQUENCE_NAME || ' TO PFSRECOVERY';  
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
BEGIN
  for rs in (select SEQUENCE_NAME 
               from DBA_SEQUENCES 
			   where UPPER(SEQUENCE_OWNER) = 'RECOVERY_HAYA_DATASTAGE') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT ON RECOVERY_HAYA_DATASTAGE.' || rs.SEQUENCE_NAME || ' TO PFSRECOVERY';  
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
BEGIN
  for rs in (select SEQUENCE_NAME 
               from DBA_SEQUENCES 
			   where UPPER(SEQUENCE_OWNER) = 'RECOVERY_HAYA_DWH') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT ON RECOVERY_HAYA_DWH.' || rs.SEQUENCE_NAME || ' TO PFSRECOVERY';  
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
BEGIN
  --CONCESION DE PERMISOS A HRE_QUERY Y HRE_QDS (usuarios de consulta)
  for rs in (select table_name 
               from DBA_TABLES 
			   where UPPER(OWNER) = 'MINIREC') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT ON MINIREC.' || rs.table_name || ' TO HRE_QUERY';  
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
BEGIN
  for rs in (select table_name 
               from DBA_TABLES 
			   where UPPER(OWNER) = 'HAYA01') loop         
    EXECUTE IMMEDIATE 'GRANT SELECT ON HAYA01.' || rs.table_name || ' TO HRE_QUERY';
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
BEGIN
  for rs in (select table_name 
               from DBA_TABLES 
			   where UPPER(OWNER) = 'HAYAMASTER') loop        
    EXECUTE IMMEDIATE 'GRANT SELECT ON HAYAMASTER.' || rs.table_name || ' TO HRE_QUERY';
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
BEGIN
  for rs in (select table_name 
               from DBA_TABLES 
			   where UPPER(OWNER) = 'RECOVERY_HAYA_DATASTAGE') loop        
    EXECUTE IMMEDIATE 'GRANT SELECT ON RECOVERY_HAYA_DATASTAGE.' || rs.table_name || ' TO HRE_QDS';
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
BEGIN
  for rs in (select table_name 
               from DBA_TABLES 
			   where UPPER(OWNER) = 'RECOVERY_HAYA_DWH') loop        
    EXECUTE IMMEDIATE 'GRANT SELECT ON RECOVERY_HAYA_DWH.' || rs.table_name || ' TO HRE_QDS';
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- AÑADIDO POR GONZALO

BEGIN
for rs in (select table_name 
               from DBA_TABLES 
			   where UPPER(OWNER) = 'HAYA01') loop        
    EXECUTE IMMEDIATE 'GRANT SELECT ON HAYA01.' || rs.table_name || ' TO RECOVERY_HAYA_DATASTAGE';
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
BEGIN
for rs in (select table_name 
               from DBA_TABLES 
			   where UPPER(OWNER) = 'HAYAMASTER') loop        
    EXECUTE IMMEDIATE 'GRANT SELECT ON HAYAMASTER.' || rs.table_name || ' TO RECOVERY_HAYA_DATASTAGE';
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
--FIN GONZALO

--AÑADIDO POR PEDRO
BEGIN  
  for rs in (select view_name 
               from DBA_VIEWS 
			   where UPPER(OWNER) = 'HAYA01') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT ON HAYA01.' || rs.view_name || ' TO PFSRECOVERY';  
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
BEGIN
  for rs in (select view_name 
               from DBA_VIEWS 
			   where UPPER(OWNER) = 'HAYAMASTER') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT ON HAYAMASTER.' || rs.view_name || ' TO PFSRECOVERY';  
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

--FIN PEDRO
-- AÑADIDO POR FRAN GUTIERREZ
BEGIN
for rs in (select table_name 
               from DBA_TABLES 
  where UPPER(OWNER) = 'MINIREC' ) loop           
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON MINIREC.' || rs.table_name || ' TO HAYA01';
  end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;  
BEGIN  
	FOR RS IN (SELECT OWNER,OBJECT_NAME FROM DBA_PROCEDURES  WHERE UPPER(OWNER) IN ('MINIREC', 'HAYAMASTER') AND OBJECT_TYPE IN ('PACKAGE', 'PROCEDURE', 'FUNCTION') ) LOOP
		EXECUTE IMMEDIATE 'GRANT EXECUTE ON ' || RS.OWNER || '.' || RS.OBJECT_NAME || ' TO HAYA01';
	END LOOP;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

--FIN FRAN
-- AÑADIDO POR OSCAR DORADO
BEGIN
for rs in (select OBJECT_name
		from DBA_PROCEDURES
	where UPPER(OWNER) = 'HAYA01') loop
	EXECUTE IMMEDIATE 'GRANT EXECUTE ON HAYA01.' || rs.object_name || ' TO HAYA01';
	end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
BEGIN	
for rs in (select object_name
		from DBA_PROCEDURES
	where UPPER(OWNER) = 'HAYA01' ) loop
		EXECUTE IMMEDIATE 'GRANT EXECUTE ON HAYA01.' || rs.object_name || ' TO PFSRECOVERY';
	end loop;
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;	
--FIN OSCAR

BEGIN	
--Dar permisos a minirec para crear funciones y procedimientos, por scripts de pedro
	EXECUTE IMMEDIATE 'GRANT CREATE PROCEDURE TO MINIREC';
	EXECUTE IMMEDIATE 'GRANT CREATE PROCEDURE TO RECOVERY_HAYA_DWH';
	EXECUTE IMMEDIATE 'GRANT CREATE PROCEDURE TO RECOVERY_HAYA_DATASTAGE';
EXCEPTION
 WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

END;  --FINAL GLOBAL END
/

exit
