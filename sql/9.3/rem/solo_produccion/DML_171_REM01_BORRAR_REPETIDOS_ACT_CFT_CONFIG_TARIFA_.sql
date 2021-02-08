--/*
--#########################################
--## AUTOR= Lara Pablo 
--## FECHA_CREACION=20210202
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12981
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
  
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
	V_TEXT_TABLA VARCHAR2(2400 CHAR) :='ACT_CFT_CONFIG_TARIFA';--Variable para la tabla de volcado	
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-12981';
   ----------------------------------
   
BEGIN
  
   DBMS_OUTPUT.put_line('[INICIO]');
   
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' t1
				USING( 
				SELECT tf.cft_id, ROW_NUMBER() 
				OVER( PARTITION BY tf.dd_Cra_id, tf.dd_scr_id, tf.dd_ttf_id, tf.dd_Ttr_id, tf.dd_str_id, tf.pve_id, tf.CFT_FECHA_INI, tf.CFT_FECHA_FIN ORDER BY 1) RN
				FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'  tf where borrado = 0) t2
				On (T1.CFT_ID = T2.CFT_ID AND T2.RN > 1) WHEN MATCHED THEN UPDATE SET T1.BORRADO = 1, T1.USUARIOBORRAR = '''|| V_USUARIO ||''', T1.FECHABORRAR=SYSDATE';
				
	 EXECUTE IMMEDIATE V_MSQL;
    
	COMMIT;

EXCEPTION
   WHEN OTHERS THEN
        ERR_NUM := SQLCODE;
        ERR_MSG := SQLERRM;
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(ERR_MSG);
        ROLLBACK;
        RAISE;   
END;
/
EXIT;
