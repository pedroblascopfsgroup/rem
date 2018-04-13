--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171027
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK='||V_USUARIO||'
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de borrado físico de ciertas tablas
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

  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  ERR_NUM NUMBER;-- Numero de errores
  ERR_MSG VARCHAR2(2048);-- Mensaje de error
  V_MSQL VARCHAR2(4000 CHAR);
  V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
  TYPE VALCURTYP IS REF CURSOR;
  V_GES_CURSOR VALCURTYP;
  V_STMT_VAL VARCHAR2(4000 CHAR);
  TABLA VARCHAR2(63 CHAR);
  CLAVE_TABLA VARCHAR(140 CHAR);
  TABLA_REF VARCHAR2(63 CHAR);
  CLAVE_REF VARCHAR(140 CHAR);
  USU_ID NUMBER;
  ACT_ID NUMBER;
  GEE_ID NUMBER;
  CANTIDAD_INSERCIONES NUMBER (16);
  
  
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de inserción PTEC.');

     

    DBMS_OUTPUT.PUT_LINE('');
    V_MSQL := 'SELECT usu.USU_ID,vga.ACT_ID
              FROM  '||V_ESQUEMA||'.V_GESTORES_ACTIVO VGA 
              inner join '||V_ESQUEMA_M||'.USU_USUARIOS usu on usu.USU_USERNAME = vga.USERNAME 
              WHERE VGA.TIPO_GESTOR = ''PTEC'' ';
            OPEN V_GES_CURSOR FOR V_MSQL;
            LOOP
            	FETCH V_GES_CURSOR INTO USU_ID, ACT_ID;
            	EXIT WHEN V_GES_CURSOR%NOTFOUND;
            	
		--obtenemos id para gee
		V_SQL := 'SELECT '||V_ESQUEMA||'.S_GEE_GESTOR_ENTIDAD.NEXTVAL from DUAL';
		EXECUTE IMMEDIATE V_SQL INTO GEE_ID;

		--insertamos en gee
		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD (GEE_ID, USU_ID, DD_TGE_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES
					('||GEE_ID||',
					'||USU_ID||',
					(select dd_tge_id from '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR where dd_tge_codigo = ''PTEC''),
					0,
					''HREOS-4003'',
					SYSDATE,
					0)';
		EXECUTE IMMEDIATE V_SQL; 

		--insertamos en gac
		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO (GEE_ID, ACT_ID) VALUES
					('||GEE_ID||',
					'||ACT_ID||')';
		EXECUTE IMMEDIATE V_SQL; 
		
		--insertamos en geh
		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST (GEH_ID, USU_ID, DD_TGE_ID, GEH_FECHA_DESDE,VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES
					('||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL,
					'||USU_ID||',
					(select dd_tge_id from '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR where dd_tge_codigo = ''PTEC''),
					SYSDATE,
					0,
					''HREOS-4003'',
					SYSDATE,
					0)';
		EXECUTE IMMEDIATE V_SQL; 

		--insertamos en usd
		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS (GEH_ID, USU_ID, DES_ID, USD_GESTOR_DEFECTO,USD_SUPERVISOR,VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES
					('||V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL,
					'||USU_ID||',
					(select des_id from '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO where DES_DESPACHO = ''REMPTEC''),
					1,
					1,
					0,
					''HREOS-4003'',
					SYSDATE,
					0)';
		EXECUTE IMMEDIATE V_SQL; 
		
		
		
		
        	COMMIT;
        
    	    END LOOP;
	    CLOSE V_GES_CURSOR;		

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE(V_MSQL);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
