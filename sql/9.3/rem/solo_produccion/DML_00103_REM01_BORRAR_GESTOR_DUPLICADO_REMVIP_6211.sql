--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200208
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


    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6211_DUP2';
    V_TABLA_AUX VARCHAR(100 CHAR):= 'AUX_REMVIP_6211_DUP2'; --  <<<---- Tabla auxiliar

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

			SELECT GEH.GEH_ID
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
			 AND DD_SCR_ID <> 163
			 AND DD_SCM_ID NOT IN ( SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''05'' )
			 AND BORRADO = 0

			) 
           
			 AND GEE.USU_ID = USU.USU_ID
             		AND GEH.USU_ID = GEE.USU_ID
			 AND GEH.GEH_FECHA_HASTA IS NULL                     
             		AND EXISTS ( SELECT 1 FROM REM01.ACT_GES_DIST_GESTORES GES
                         		WHERE BORRADO = 1
                          		AND GES.TIPO_GESTOR = TGE.DD_TGE_CODIGO
                          		AND USU.USU_USERNAME = GES.USERNAME )                        

		AND EXISTS ( 

			SELECT 1
			FROM 
			REM01.GAC_GESTOR_ADD_ACTIVO GAC2,
			REM01.GEH_GESTOR_ENTIDAD_HIST GEH2,
			REM01.GEE_GESTOR_ENTIDAD GEE2,
			REMMASTER.DD_TGE_TIPO_GESTOR TGE2,
			REM01.GAH_GESTOR_ACTIVO_HISTORICO GAH2,
			REMMASTER.USU_USUARIOS USU2
			WHERE 1 = 1
			AND GAC2.GEE_ID = GEE2.GEE_ID
			AND GEH2.DD_TGE_ID = TGE2.DD_TGE_ID
			AND GEE2.DD_TGE_ID = TGE2.DD_TGE_ID
			AND GAH2.GEH_ID = GEH2.GEH_ID
            		AND GEE2.BORRADO = 0
            		AND GEH2.BORRADO = 0
			AND GAH2.ACT_ID = GAC2.ACT_ID

			AND GAC2.ACT_ID IN 
			(
			 SELECT ACT_ID			
			 FROM REM01.ACT_ACTIVO
			 WHERE 1 = 1
			 AND DD_SCR_ID <> 163
			 AND DD_SCM_ID NOT IN ( SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''05'' )
			 AND BORRADO = 0
  
			) 
           
			 AND GEE2.USU_ID = USU2.USU_ID
             AND GEE2.USU_ID = GEH2.USU_ID
             
			 AND GEH2.GEH_FECHA_HASTA IS NULL                     
             AND EXISTS ( SELECT 1 FROM REM01.ACT_GES_DIST_GESTORES GES2
                          WHERE BORRADO = 0
                          AND GES2.TIPO_GESTOR = TGE2.DD_TGE_CODIGO
                          AND USU2.USU_USERNAME = GES2.USERNAME )
                          
            AND GAC2.ACT_ID = GAC.ACT_ID
            AND TGE2.DD_TGE_CODIGO = TGE.DD_TGE_CODIGO
            AND GEE2.GEE_ID <> GEE.GEE_ID
            AND GEH2.GEH_ID <> GEH.GEH_ID
          )       

			';

	EXECUTE IMMEDIATE V_SQL;


	DBMS_OUTPUT.PUT_LINE('[INFO] Insertados '||SQL%ROWCOUNT||' registros en tabla temporal ');  

-----------------------------------------------------------------------------------------------------------------
--Paso 3: Se recorre la tabla temporal

	DBMS_OUTPUT.PUT_LINE('[INICIO] Recorriendo activos con gestor incorrecto ');
     
     	-- Busca los activos/gestores
    	V_SQL := ' SELECT DISTINCT GEH_ID
		   FROM '||V_ESQUEMA||'.' || V_TABLA_AUX || '
		 ' ;

	OPEN v_cursor FOR V_SQL;
   
   	V_NUM := 0;
   
   	LOOP
       		FETCH v_cursor INTO V_GEH_ID;
       		EXIT WHEN v_cursor%NOTFOUND;   		

		-- Modifica GEH
		V_SQL := ' UPDATE '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST
			   SET GEH_FECHA_HASTA = SYSDATE,
			       USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
			       FECHAMODIFICAR = SYSDATE
			   WHERE GEH_ID = ' || V_GEH_ID || '
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
