--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8841
--## PRODUCTO=NO
--## 
--## Finalidad: MODIFICAR 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE


    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8841'; --Vble USUARIOMODIFICAR/USUARIOCREAR

    V_ID NUMBER(16); -- Vble. para el id del activo

    V_TABLA VARCHAR2(50 CHAR):= 'ACT_TBJ_TRABAJO'; --Vble. Tabla a modificar proveedores

	V_COUNT NUMBER(16); -- Vble. para comprobar
    
    --CODIGO TIPO TRABAJO 07 "EDIFICACION"

    --IMPORTE_TOTAL -> IMPORTE CLIENTE
    --IMPORTE_PRESUPUESTO -> IMPORTE PROVEEDOR

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS IMPORTES TRABAJOS');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
                USING(
                    SELECT TBJ.TBJ_ID,TBJ_IMPORTE_TOTAL,TBJ.TBJ_IMPORTE_PRESUPUESTO FROM '||V_ESQUEMA||'.'||V_TABLA||' TBJ
                    WHERE TBJ.DD_TTR_ID=(SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO=07) AND TBJ.BORRADO=0 
                    AND TBJ_IMPORTE_TOTAL IS NOT NULL AND TBJ_IMPORTE_PRESUPUESTO IS NULL

                ) AUX
                ON (T1.TBJ_ID = AUX.TBJ_ID)
                WHEN MATCHED THEN UPDATE SET                
                T1.TBJ_IMPORTE_PRESUPUESTO=AUX.TBJ_IMPORTE_TOTAL,
                T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
                T1.FECHAMODIFICAR = SYSDATE
                ';
		
	EXECUTE IMMEDIATE V_MSQL;  
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' TRABAJOS');

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