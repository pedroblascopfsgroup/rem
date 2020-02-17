--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200209
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6211
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.

    V_SQL VARCHAR2(4000 CHAR);
    V_NUM NUMBER(16);
    V_GEH_ID NUMBER(16);
    V_NUEVO_GEH NUMBER(16);    
    ----------------------------------
	TYPE CurTyp IS REF CURSOR;
	v_cursor    CurTyp;
    ----------------------------------

BEGIN			

-----------------------------------------------------------------------------------------------------------------
--Desactiva constraints:

--		and ( constraint_name not like '%_PK' )

  for v_cursor in (select fk.owner, fk.constraint_name , fk.table_name 
    from all_constraints fk, all_constraints pk 
     where fk.CONSTRAINT_TYPE = 'R' and 
           pk.owner = 'REM01' and
           fk.r_owner = pk.owner and
           fk.R_CONSTRAINT_NAME = pk.CONSTRAINT_NAME and 
           pk.TABLE_NAME  IN ( 'GAH_GESTOR_ACTIVO_HISTORICO',
			     'GEH_GESTOR_ENTIDAD_HIST',
			     'GAC_GESTOR_ADD_ACTIVO',
			     'GEE_GESTOR_ENTIDAD' 			
				) 

	) loop
    execute immediate 'ALTER TABLE "'||v_cursor.owner||'"."'||v_cursor.table_name||'" MODIFY CONSTRAINT "'||v_cursor.constraint_name||'" DISABLE';
  end loop;

  for v_cursor in (select owner, constraint_name , table_name 
    		   from all_constraints
     		   where ( owner = 'REM01' and
             	TABLE_NAME IN ( 'GAH_GESTOR_ACTIVO_HISTORICO',
			     'GEH_GESTOR_ENTIDAD_HIST',
			     'GAC_GESTOR_ADD_ACTIVO',
			     'GEE_GESTOR_ENTIDAD' 			
				) )

	   ) loop
     execute immediate 'ALTER TABLE '||v_cursor.owner||'.'||v_cursor.table_name||' MODIFY CONSTRAINT "'||v_cursor.constraint_name||'" DISABLE ';
  end loop; 		

-----------------------------------------------------------------------------------------------------------------
--Paso 1: Borra GAH:

	DBMS_OUTPUT.PUT_LINE('[INFO] Truncado de GAH_GESTOR_ACTIVO_HISTORICO ... ');

        OPERACION_DDL.DDL_TABLE('TRUNCATE','GAH_GESTOR_ACTIVO_HISTORICO');

	DBMS_OUTPUT.PUT_LINE('[INFO] Truncados '||SQL%ROWCOUNT||' registros en GAH_GESTOR_ACTIVO_HISTORICO ');  


-----------------------------------------------------------------------------------------------------------------
--Paso 2: Borra GEH:

	DBMS_OUTPUT.PUT_LINE('[INFO] Truncado de GEH_GESTOR_ENTIDAD_HIST ...');

        OPERACION_DDL.DDL_TABLE('TRUNCATE','GEH_GESTOR_ENTIDAD_HIST');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Truncados '||SQL%ROWCOUNT||' registros en GEH_GESTOR_ENTIDAD_HIST ');


-----------------------------------------------------------------------------------------------------------------
--Paso 3: Borra GAC:

	DBMS_OUTPUT.PUT_LINE('[INFO] Truncado de GAC_GESTOR_ADD_ACTIVO ... ');

        OPERACION_DDL.DDL_TABLE('TRUNCATE','GAC_GESTOR_ADD_ACTIVO');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Truncados '||SQL%ROWCOUNT||' registros en GAC_GESTOR_ADD_ACTIVO ');


-----------------------------------------------------------------------------------------------------------------
--Paso 4: Borra GEE:

	DBMS_OUTPUT.PUT_LINE('[INFO] Truncado de GEE_GESTOR_ENTIDAD ... ');

        OPERACION_DDL.DDL_TABLE('TRUNCATE','GEE_GESTOR_ENTIDAD');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrados '||SQL%ROWCOUNT||' registros en GEE_GESTOR_ENTIDAD ');



-----------------------------------------------------------------------------------------------------------------
--Paso 5: Restaura registros correctos de GAH:

	DBMS_OUTPUT.PUT_LINE('[INFO] Restaura registros correctos de GAH_GESTOR_ACTIVO_HISTORICO ... ');
	
	V_SQL := ' INSERT INTO REM01.GAH_GESTOR_ACTIVO_HISTORICO
		   ( GEH_ID, ACT_ID )	
		   SELECT GEH_ID, ACT_ID 
		   FROM REM01.AUX_GAH_REMVIP_6211 ';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Restaurados '||SQL%ROWCOUNT||' registros en GAH_GESTOR_ACTIVO_HISTORICO ');  


-----------------------------------------------------------------------------------------------------------------
--Paso 6: Restaura registros correctos de  GEH:

	DBMS_OUTPUT.PUT_LINE('[INFO]  Restaura registros correctos de GEH_GESTOR_ENTIDAD_HIST ...');

	
	V_SQL := ' INSERT INTO REM01.GEH_GESTOR_ENTIDAD_HIST
		   ( GEH_ID, USU_ID, DD_TGE_ID, GEH_FECHA_DESDE, GEH_FECHA_HASTA,
		     VERSION, BORRADO, FECHABORRAR, USUARIOBORRAR, 
		     USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR )
		   SELECT GEH_ID, USU_ID, DD_TGE_ID, GEH_FECHA_DESDE, GEH_FECHA_HASTA,
		     VERSION, BORRADO, FECHABORRAR, USUARIOBORRAR, 
		     USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR
		   FROM REM01.AUX_GEH_REMVIP_6211  ';
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Restaurados '||SQL%ROWCOUNT||' registros en GEH_GESTOR_ENTIDAD_HIST ');


-----------------------------------------------------------------------------------------------------------------
--Paso 7: Restaura registros correctos de GAC:

	DBMS_OUTPUT.PUT_LINE('[INFO] Restaura registros correctos de GAC_GESTOR_ADD_ACTIVO ... ');

	
	V_SQL := ' INSERT INTO REM01.GAC_GESTOR_ADD_ACTIVO
		   ( GEE_ID, ACT_ID )	
		   SELECT GEE_ID, ACT_ID
		   FROM REM01.AUX_GAC_REMVIP_6211 ';
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Restaurados '||SQL%ROWCOUNT||' registros en GAC_GESTOR_ADD_ACTIVO ');


-----------------------------------------------------------------------------------------------------------------
--Paso 8: Restaura registros correctos de GEE:

	DBMS_OUTPUT.PUT_LINE('[INFO] Restaura registros correctos de GEE_GESTOR_ENTIDAD ... ');

	
	V_SQL := ' INSERT INTO REM01.GEE_GESTOR_ENTIDAD
		   ( GEE_ID, USU_ID, DD_TGE_ID,
		     VERSION, BORRADO, FECHABORRAR, USUARIOBORRAR, 
		     USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR )
		   SELECT GEE_ID, USU_ID, DD_TGE_ID,
		     VERSION, BORRADO, FECHABORRAR, USUARIOBORRAR, 
		     USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR
		   FROM REM01.AUX_GEE_REMVIP_6211 ';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Restaurados '||SQL%ROWCOUNT||' registros en GEE_GESTOR_ENTIDAD ');


	DBMS_OUTPUT.PUT_LINE(' [INFO] Proceso realizado ');


	COMMIT;


-----------------------------------------------------------------------------------------------------------------
--Activa constraints:

--		and ( constraint_name not like '%_PK' )

  for v_cursor in (select owner, constraint_name , table_name 
    		   from all_constraints
     		   where ( owner = 'REM01' and
             	TABLE_NAME IN ( 
			     'GEH_GESTOR_ENTIDAD_HIST',
			     'GEE_GESTOR_ENTIDAD' 			
				) )

	   ) loop

	DBMS_OUTPUT.PUT_LINE('ALTER TABLE '||v_cursor.owner||'.'||v_cursor.table_name||' MODIFY CONSTRAINT "'||v_cursor.constraint_name||'" ENABLE ');
     execute immediate 'ALTER TABLE '||v_cursor.owner||'.'||v_cursor.table_name||' MODIFY CONSTRAINT "'||v_cursor.constraint_name||'" ENABLE ';
  end loop; 


  for v_cursor in (select owner, constraint_name , table_name 
    		   from all_constraints
     		   where ( owner = 'REM01' and
             	TABLE_NAME IN ( 'GAH_GESTOR_ACTIVO_HISTORICO',
			     'GAC_GESTOR_ADD_ACTIVO'	
				) )

	   ) loop

	DBMS_OUTPUT.PUT_LINE('ALTER TABLE '||v_cursor.owner||'.'||v_cursor.table_name||' MODIFY CONSTRAINT "'||v_cursor.constraint_name||'" ENABLE ');
     execute immediate 'ALTER TABLE '||v_cursor.owner||'.'||v_cursor.table_name||' MODIFY CONSTRAINT "'||v_cursor.constraint_name||'" ENABLE ';
  end loop; 


  for v_cursor in (select fk.owner, fk.constraint_name , fk.table_name 
    from all_constraints fk, all_constraints pk 
     where fk.CONSTRAINT_TYPE = 'R' and 
           pk.owner = 'REM01' and
           fk.r_owner = pk.owner and
           fk.R_CONSTRAINT_NAME = pk.CONSTRAINT_NAME and 
           pk.TABLE_NAME  IN ( 'GAH_GESTOR_ACTIVO_HISTORICO',
			     'GAC_GESTOR_ADD_ACTIVO'			
				) 

	) loop

	DBMS_OUTPUT.PUT_LINE('ALTER TABLE "'||v_cursor.owner||'"."'||v_cursor.table_name||'" MODIFY CONSTRAINT "'||v_cursor.constraint_name||'" ENABLE');
    execute immediate 'ALTER TABLE "'||v_cursor.owner||'"."'||v_cursor.table_name||'" MODIFY CONSTRAINT "'||v_cursor.constraint_name||'" ENABLE';
  end loop;

  for v_cursor in (select fk.owner, fk.constraint_name , fk.table_name 
    from all_constraints fk, all_constraints pk 
     where fk.CONSTRAINT_TYPE = 'R' and 
           pk.owner = 'REM01' and
           fk.r_owner = pk.owner and
           fk.R_CONSTRAINT_NAME = pk.CONSTRAINT_NAME and 
           pk.TABLE_NAME  IN (  'GEH_GESTOR_ENTIDAD_HIST',
			         'GEE_GESTOR_ENTIDAD' 			
				) 

	) loop

	DBMS_OUTPUT.PUT_LINE('ALTER TABLE "'||v_cursor.owner||'"."'||v_cursor.table_name||'" MODIFY CONSTRAINT "'||v_cursor.constraint_name||'" ENABLE');
    execute immediate 'ALTER TABLE "'||v_cursor.owner||'"."'||v_cursor.table_name||'" MODIFY CONSTRAINT "'||v_cursor.constraint_name||'" ENABLE';
  end loop;


	DBMS_OUTPUT.PUT_LINE(' [INFO] Proceso realizado ');

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');
	

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT
