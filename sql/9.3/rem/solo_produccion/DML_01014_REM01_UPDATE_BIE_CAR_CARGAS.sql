--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210820
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10244
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar BIE_CAR_ECONOMICA a 0
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';

DECLARE


    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-10244'; --Vble USUARIOMODIFICAR/USUARIOCREAR

    V_ID NUMBER(16); -- Vble. para el id del activo


    V_TABLA VARCHAR2(50 CHAR):= 'BIE_CAR_CARGAS'; --Vble. Tabla a modificar proveedores

	V_COUNT NUMBER(16); -- Vble. para comprobar
	

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS '||V_TABLA||'');

        V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
                    USING (
                        SELECT DISTINCT bie_car_id FROM '||V_ESQUEMA||'.BIE_cAR_CARGAS WHERE BIE_CAR_ECONOMICA IS NULL
                            ) T2 
                    ON (T1.bie_car_id = T2.bie_car_id)
                    WHEN MATCHED THEN UPDATE SET 
                    T1.BIE_CAR_ECONOMICA=0,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||''', 
                    T1.FECHAMODIFICAR = SYSDATE';

        EXECUTE IMMEDIATE V_MSQL;
        
        DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TABLA||' ');
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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