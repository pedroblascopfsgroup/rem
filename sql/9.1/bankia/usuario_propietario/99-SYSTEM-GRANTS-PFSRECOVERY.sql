begin
  for rs in (select table_name 
               from ALL_TABLES 
			   where UPPER(OWNER) = 'BANK01') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON BANK01.' || rs.table_name || ' TO PFSRECOVERY';  
  end loop;
  for rs in (select table_name 
               from ALL_TABLES 
			   where UPPER(OWNER) = 'BANKMASTER') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON BANKMASTER.' || rs.table_name || ' TO PFSRECOVERY';  
  end loop;
  for rs in (select table_name 
               from ALL_TABLES 
			   where UPPER(OWNER) = 'RECOVERY_MD') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON RECOVERY_MD.' || rs.table_name || ' TO PFSRECOVERY';  
  end loop;
  for rs in (select table_name 
               from ALL_TABLES 
			   where UPPER(OWNER) = 'MINIREC') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON MINIREC.' || rs.table_name || ' TO PFSRECOVERY';  
  end loop;
  for rs in (select table_name 
               from ALL_TABLES 
			   where UPPER(OWNER) = 'RECOVERY_BANKIA_DATASTAGE') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON RECOVERY_BANKIA_DATASTAGE.' || rs.table_name || ' TO PFSRECOVERY';  
  end loop;
  for rs in (select table_name 
               from ALL_TABLES 
			   where UPPER(OWNER) = 'RECOVERY_BANKIA_DWH') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON RECOVERY_BANKIA_DWH.' || rs.table_name || ' TO PFSRECOVERY';  
  end loop;

--DAR PERMISOS DE SELECT A LAS SECUENCIAS
  for rs in (select SEQUENCE_NAME 
               from ALL_SEQUENCES 
			   where UPPER(SEQUENCE_OWNER) = 'BANK01') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT ON BANK01.' || rs.SEQUENCE_NAME || ' TO PFSRECOVERY';  
  end loop;

  for rs in (select SEQUENCE_NAME 
               from ALL_SEQUENCES 
			   where UPPER(SEQUENCE_OWNER) = 'BANKMASTER') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT ON BANKMASTER.' || rs.SEQUENCE_NAME || ' TO PFSRECOVERY';  
  end loop;

  for rs in (select SEQUENCE_NAME 
               from ALL_SEQUENCES 
			   where UPPER(SEQUENCE_OWNER) = 'MINIREC') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT ON MINIREC.' || rs.SEQUENCE_NAME || ' TO PFSRECOVERY';  
  end loop;

  for rs in (select SEQUENCE_NAME 
               from ALL_SEQUENCES 
			   where UPPER(SEQUENCE_OWNER) = 'RECOVERY_BANKIA_DATASTAGE') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT ON RECOVERY_BANKIA_DATASTAGE.' || rs.SEQUENCE_NAME || ' TO PFSRECOVERY';  
  end loop;

  for rs in (select SEQUENCE_NAME 
               from ALL_SEQUENCES 
			   where UPPER(SEQUENCE_OWNER) = 'RECOVERY_BANKIA_DWH') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT ON RECOVERY_BANKIA_DWH.' || rs.SEQUENCE_NAME || ' TO PFSRECOVERY';  
  end loop;

  --CONCESION DE PERMISOS A MINIREC_CONSULTA
  for rs in (select table_name 
               from ALL_TABLES 
			   where UPPER(OWNER) = 'MINIREC') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT ON MINIREC.' || rs.table_name || ' TO MINIREC_CONSULTA';  
  end loop;

 --CONCESION DE PERMISOS A SV00450
  for rs in (select table_name 
               from ALL_TABLES 
			   where UPPER(OWNER) = 'MINIREC') loop        
    if RS.TABLE_NAME LIKE 'RCV_GEST_%' then    
    EXECUTE IMMEDIATE 'GRANT SELECT ON MINIREC.' || rs.table_name || ' TO SV00450';
    end if;  
  end loop;

-- AÑADIDO POR GONZALO
for rs in (select table_name 
               from ALL_TABLES 
			   where UPPER(OWNER) = 'BANK01') loop        
    EXECUTE IMMEDIATE 'GRANT SELECT ON BANK01.' || rs.table_name || ' TO RECOVERY_BANKIA_DATASTAGE';
  end loop;
for rs in (select table_name 
               from ALL_TABLES 
			   where UPPER(OWNER) = 'BANKMASTER') loop        
    EXECUTE IMMEDIATE 'GRANT SELECT ON BANKMASTER.' || rs.table_name || ' TO RECOVERY_BANKIA_DATASTAGE';
  end loop;
--FIN GONZALO

--AÑADIDO POR PEDRO
  for rs in (select view_name 
               from ALL_VIEWS 
			   where UPPER(OWNER) = 'BANK01') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT ON BANK01.' || rs.view_name || ' TO PFSRECOVERY';  
  end loop;
  for rs in (select view_name 
               from ALL_VIEWS 
			   where UPPER(OWNER) = 'BANKMASTER') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT ON BANKMASTER.' || rs.view_name || ' TO PFSRECOVERY';  
  end loop;

--FIN PEDRO
-- AÑADIDO POR FRAN GUTIERREZ
for rs in (select table_name 
               from ALL_TABLES 
  where UPPER(OWNER) = 'MINIREC' ) loop           
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON MINIREC.' || rs.table_name || ' TO BANK01';
  end loop;
  
FOR RS IN (SELECT OWNER,OBJECT_NAME FROM ALL_PROCEDURES  WHERE UPPER(OWNER) IN ('MINIREC', 'BANKMASTER') AND OBJECT_TYPE IN ('PACKAGE', 'PROCEDURE', 'FUNCTION') ) LOOP
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON ' || RS.OWNER || '.' || RS.OBJECT_NAME || ' TO BANK01';
END LOOP;

FOR RS IN (SELECT OWNER,OBJECT_NAME FROM ALL_PROCEDURES  WHERE UPPER(OWNER) IN ('BANK01', 'MINIREC', 'BANKMASTER') AND OBJECT_TYPE IN ('PACKAGE', 'PROCEDURE', 'FUNCTION') ) LOOP
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON ' || RS.OWNER || '.' || RS.OBJECT_NAME || ' TO PFSRECOVERY';
END LOOP;

--FIN FRAN
-- AÑADIDO POR OSCAR DORADO
--for rs in (select OBJECT_NAME 
 --              from ALL_PROCEDURES 
--			   where UPPER(OWNER) = 'BANK01') loop            
--    EXECUTE IMMEDIATE 'GRANT SELECT ON BANK01.' || rs.OBJECT_NAME || ' TO PFSRECOVERY';  
--  end loop;
for rs in (select OBJECT_name
		from ALL_PROCEDURES
	where UPPER(OWNER) = 'BANK01'
	and object_name like '%ALTA_%' ) loop
	EXECUTE IMMEDIATE 'GRANT EXECUTE ON BANK01.' || rs.object_name || ' TO BANK01';
	end loop;
for rs in (select object_name
		from ALL_PROCEDURES
	where UPPER(OWNER) = 'BANK01'
	and object_name like '%ALTA_%' ) loop
	EXECUTE IMMEDIATE 'GRANT EXECUTE ON BANK01.' || rs.object_name || ' TO PFSRECOVERY';
	end loop;
--FIN OSCAR
-- AÑADIDO POR DIEGO RODRIGUEZ
for rs in (select object_name
        from ALL_PROCEDURES
    where UPPER(OWNER) = 'TEST_RECOVERY_BANKIA_DATASTAGE' ) loop
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON TEST_RECOVERY_BANKIA_DATASTAGE.' || rs.object_name || ' TO TEST_RECOVERY_BANKIA_LX';
    end loop;
for rs in (select object_name
        from ALL_PROCEDURES
    where UPPER(OWNER) = 'TEST_RECOVERY_BANKIA_DWH' ) loop
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON TEST_RECOVERY_BANKIA_DWH.' || rs.object_name || ' TO TEST_RECOVERY_BANKIA_LX';
    end loop;
--FIN DIEGO
--Gonzalo
  for rs in (select table_name from ALL_TABLES where UPPER(OWNER) = 'TEST_RECOVERY_BANKIA_DWH') loop            
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON TEST_RECOVERY_BANKIA_DWH.' || rs.table_name || ' TO TEST_RECOVERY_BANKIA_LX';  
  end loop;
  
  for rs in (select table_name from ALL_TABLES where UPPER(OWNER) = 'TEST_RECOVERY_BANKIA_DATASTAGE') loop            
EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON TEST_RECOVERY_BANKIA_DATASTAGE.' || rs.table_name || ' TO TEST_RECOVERY_BANKIA_LX';  
  end loop;
--Fin Gonzalo
--Joaquin Arnal
for rs in (select table_name 
               from ALL_TABLES 
  where UPPER(OWNER) = 'PFSRECOVERY'
         and table_name like '%TMP_RCV_GEST_%' ) loop           
    EXECUTE IMMEDIATE 'GRANT SELECT ON PFSRECOVERY.' || rs.table_name || ' TO BANK01';
  end loop;
--Fin Joaquin

--Dar permisos a minirec para crear funciones y procedimientos, por scripts de pedro
EXECUTE IMMEDIATE 'GRANT CREATE PROCEDURE TO MINIREC';
EXECUTE IMMEDIATE 'GRANT CREATE PROCEDURE TO RECOVERY_BANKIA_DWH';
EXECUTE IMMEDIATE 'GRANT CREATE PROCEDURE TO RECOVERY_BANKIA_DATASTAGE';
end;
/

exit
