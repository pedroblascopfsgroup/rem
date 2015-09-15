begin
  

 

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


-- AÑADIDO POR FRAN GUTIERREZ
for rs in (select table_name 
               from ALL_TABLES 
  where UPPER(OWNER) = 'MINIREC' ) loop           
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON MINIREC.' || rs.table_name || ' TO BANK01';
  end loop;

--FIN FRAN
-- AÑADIDO POR OSCAR DORADO

for rs in (select OBJECT_name
		from ALL_PROCEDURES
	where UPPER(OWNER) = 'BANK01'
	and object_name like '%ALTA_%' ) loop
	EXECUTE IMMEDIATE 'GRANT EXECUTE ON BANK01.' || rs.object_name || ' TO BANK01';
	end loop;

--FIN OSCAR

--Joaquin Arnal
for rs in (select table_name 
               from ALL_TABLES 
  where UPPER(OWNER) = 'PFSRECOVERY'
         and table_name like '%TMP_RCV_GEST_%' ) loop           
    EXECUTE IMMEDIATE 'GRANT SELECT ON PFSRECOVERY.' || rs.table_name || ' TO BANK01';
  end loop;
--Fin Joaquin
end;
/

exit
