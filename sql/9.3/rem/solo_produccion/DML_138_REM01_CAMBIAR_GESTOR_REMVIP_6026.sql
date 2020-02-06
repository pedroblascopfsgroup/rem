--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200131
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6026
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


    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6026';

    V_TABLA_AUX VARCHAR(100 CHAR):= 'AUX_REMVIP_6026'; --  <<<---- Tabla auxiliar
    V_GESTOR_MODIF VARCHAR(100 CHAR):= 'SUPACT';--  	   <<<---- Gestor a modificar
    V_USERNAME_NUEVO VARCHAR(100 CHAR):= 'mblascop';--    <<<---- Nuevo usuario a informar en el tipo de gestor anterior

    V_SQL VARCHAR2(4000 CHAR);
    V_NUM NUMBER(16);
    V_GEE_ID NUMBER(16);
    V_ACT_ID NUMBER(16);
    V_GEH_ID NUMBER(16);
    V_NUEVO_GEH NUMBER(16);    
    ----------------------------------
	TYPE CurTyp IS REF CURSOR;
	v_cursor    CurTyp;
    ----------------------------------

BEGIN					

-----------------------------------------------------------------------------------------------------------------
--Paso 1: Borra la tabla temporal si existiera:

	DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO.');
	
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA_AUX || ''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	
	IF V_NUM != 0 THEN
	
		V_SQL := 'DROP TABLE '||V_ESQUEMA||'.' || V_TABLA_AUX || '';
		EXECUTE IMMEDIATE V_SQL;
		
	END IF;	


-----------------------------------------------------------------------------------------------------------------
--Paso 2: Crea la tabla temporal

	DBMS_OUTPUT.PUT_LINE('[INFO] LLENA TABLA TEMPORAL');
	
	V_SQL := ' CREATE TABLE '||V_ESQUEMA||'.' || V_TABLA_AUX || ' AS  
			SELECT GEE.GEE_ID, GAC.ACT_ID, GEH.GEH_ID
			FROM 
			REM01.GAC_GESTOR_ADD_ACTIVO GAC,
			REM01.GEH_GESTOR_ENTIDAD_HIST GEH,
			REM01.GEE_GESTOR_ENTIDAD GEE,
			REMMASTER.DD_TGE_TIPO_GESTOR TGE,
			REM01.GAH_GESTOR_ACTIVO_HISTORICO GAH,
			REMMASTER.USU_USUARIOS USU
			WHERE 1 = 1
			AND GAC.GEE_ID = GEE.GEE_ID
			AND GEH.DD_TGE_ID = TGE.DD_TGE_ID
			AND GEE.DD_TGE_ID = TGE.DD_TGE_ID
			AND GAH.GEH_ID = GEH.GEH_ID
            		AND GEE.BORRADO = 0
            		AND GEH.BORRADO = 0
			AND GAH.ACT_ID = GAC.ACT_ID

			AND GAC.ACT_ID IN 
			(
			 SELECT ACT_ID			
			 FROM REM01.ACT_ACTIVO
			 WHERE 1 = 1
			 AND DD_SCR_ID = 163
			 AND DD_SCM_ID <> ( SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''05'' )
			 AND BORRADO = 0

			) 

			 AND TGE.DD_TGE_CODIGO = ''' || V_GESTOR_MODIF || '''
			 AND GEH.USU_ID = USU.USU_ID
 
			 AND GEH_FECHA_HASTA IS NULL 
			 AND USU.USU_USERNAME <> ''' || V_USERNAME_NUEVO || '''

			';

	EXECUTE IMMEDIATE V_SQL;


	DBMS_OUTPUT.PUT_LINE('[INFO] Insertados '||SQL%ROWCOUNT||' registros en tabla temporal ');  

-----------------------------------------------------------------------------------------------------------------
--Paso 3: Se recorre la tabla temporal

	DBMS_OUTPUT.PUT_LINE('[INICIO] Recorriendo activos con gestor incorrecto ');
     
     	-- Busca los activos/gestores
    	V_SQL := ' SELECT DISTINCT GEE_ID, ACT_ID, GEH_ID
		   FROM '||V_ESQUEMA||'.' || V_TABLA_AUX || '
		 ' ;

	OPEN v_cursor FOR V_SQL;
   
   	V_NUM := 0;
   
   	LOOP
       		FETCH v_cursor INTO V_GEE_ID, V_ACT_ID, V_GEH_ID;
       		EXIT WHEN v_cursor%NOTFOUND;
       	
		-- Modifica GEE
		V_SQL := ' UPDATE '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD
			   SET USU_ID = ( SELECT USU_ID FROM REMMASTER.USU_USUARIOS USU WHERE USU.USU_USERNAME = ''' || V_USERNAME_NUEVO || ''' ),
			       USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
			       FECHAMODIFICAR = SYSDATE
			   WHERE GEE_ID = ' || V_GEE_ID || '
			   AND DD_TGE_ID = ( SELECT DD_TGE_ID FROM REMMASTER.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = ''' || V_GESTOR_MODIF || ''' )
		 ' ;

		EXECUTE IMMEDIATE V_SQL;       		

		-- Modifica GEH
		V_SQL := ' UPDATE '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST
			   SET GEH_FECHA_HASTA = SYSDATE,
			       USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
			       FECHAMODIFICAR = SYSDATE
			   WHERE GEH_ID = ' || V_GEH_ID || '
			   AND DD_TGE_ID = ( SELECT DD_TGE_ID FROM REMMASTER.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = ''' || V_GESTOR_MODIF || ''' )
		 ' ;

		EXECUTE IMMEDIATE V_SQL;     

		V_SQL := 'SELECT '||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL
			  FROM DUAL 
			  WHERE 1 = 1 ';
		EXECUTE IMMEDIATE V_SQL INTO V_NUEVO_GEH;

		--Inserta en GEH el nuevo gestor
		V_SQL := ' INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST
			   ( GEH_ID, USU_ID, DD_TGE_ID, GEH_FECHA_DESDE, BORRADO, USUARIOCREAR, FECHACREAR, VERSION )
			   VALUES
			   (  ' || V_NUEVO_GEH || ',
			      ( SELECT USU_ID FROM REMMASTER.USU_USUARIOS USU WHERE USU.USU_USERNAME = ''' || V_USERNAME_NUEVO || ''' ),
			      ( SELECT DD_TGE_ID FROM REMMASTER.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = ''' || V_GESTOR_MODIF || ''' ),
			      SYSDATE,
			      0,
			      ''' || V_USUARIOMODIFICAR || ''',
			      SYSDATE,
			      0
			   )	
		 ' ;

		EXECUTE IMMEDIATE V_SQL;   

		--Inserta en GAH el nuevo gestor
		V_SQL := ' INSERT INTO '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO
			   ( GEH_ID, ACT_ID  )
			   VALUES
			   (  ' || V_NUEVO_GEH || ',
			      ' || V_ACT_ID || '
			   )	
		 ' ;

		EXECUTE IMMEDIATE V_SQL; 

           
       		V_NUM := V_NUM + 1;

   	END LOOP;

	CLOSE v_cursor;    
	DBMS_OUTPUT.PUT_LINE(' [INFO] Se han modificado '||V_NUM||' activos ');

-----------------------------------------------------------------------------------------------------------------

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
