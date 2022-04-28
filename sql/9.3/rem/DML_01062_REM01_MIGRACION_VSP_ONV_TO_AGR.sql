--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220428
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17539
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en USU_USUARIOS los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(100 CHAR):= 'HREOS-17539';
    
BEGIN	
	
	  DBMS_OUTPUT.PUT_LINE('[INICIO] MIGRACION ONV_VENTA_PLANO TO AGR_VENTA_PLANO');

	  V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = ''ONV_VENTA_PLANO'' and TABLE_NAME = ''ACT_ONV_OBRA_NUEVA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
    IF V_NUM_TABLAS = 1 THEN
    
        DBMS_OUTPUT.PUT_LINE('[INFO] EXISTE CAMPO ONV_VENTA_PLANO EN ACT_ONV_OBRA_NUEVA. OPERAMOS');
	 
        DBMS_OUTPUT.PUT_LINE('[INFO] MERGE EN ACT_AGR_AGRUPACION');

        V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AGR_AGRUPACION T1 USING 
                        (SELECT DISTINCT AGR_ID, ONV_VENTA_PLANO
                        FROM '||V_ESQUEMA||'.ACT_ONV_OBRA_NUEVA
                        WHERE ONV_VENTA_PLANO IS NOT NULL) T2
                    ON (T1.AGR_ID = T2.AGR_ID)
                    WHEN MATCHED THEN UPDATE SET
                    T1.AGR_VENTA_PLANO = T2.ONV_VENTA_PLANO,
                    T1.USUARIOMODIFICAR = '''||V_USR||''',
                    T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] MIGRADOS '||SQL%ROWCOUNT||' REGISTROS ONV_VENTA_PLANO TO AGR_VENTA_PLANO.');

        DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINAMOS CAMPO ONV_VENTA_PLANO DE ACT_ONV_OBRA_NUEVA.');

        EXECUTE IMMEDIATE 'ALTER TABLE ACT_ONV_OBRA_NUEVA DROP COLUMN ONV_VENTA_PLANO';

        DBMS_OUTPUT.PUT_LINE('[INFO] CAMPO BORRADO');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE CAMPO ONV_VENTA_PLANO EN ACT_ONV_OBRA_NUEVA. TERMINAMOS');
    END IF;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT