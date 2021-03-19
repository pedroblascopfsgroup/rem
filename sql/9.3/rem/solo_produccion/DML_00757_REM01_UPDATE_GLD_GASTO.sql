--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210312
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9196
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar proveedor contacto trabajos y proveedor prefacturas
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9196'; --Vble USUARIOMODIFICAR/USUARIOCREAR

    V_ID NUMBER(16); -- Vble. para el id del activo


    V_TABLA_GASTO VARCHAR2(50 CHAR):= 'GPV_GASTOS_PROVEEDOR'; --Vble. Tabla a modificar proveedores
    V_TABLA_LINEA VARCHAR2(50 CHAR):='GLD_GASTOS_LINEA_DETALLE';
    V_TABLA_LINEA_TBJ VARCHAR2(50 CHAR):='GLD_TBJ';

	V_COUNT NUMBER(16); -- Vble. para comprobar
    V_GASTO NUMBER(16):= 13650834;
	

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS AUDITORIA LINEA DETALLE Y TRABAJOS ASOCIADOS');

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_GASTO||' WHERE GPV_NUM_GASTO_HAYA ='||V_GASTO||' AND BORRADO=0 ';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

    IF V_COUNT = 1 THEN

        V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_LINEA||' T1
                    USING (SELECT DISTINCT GLD.GLD_ID FROM REM01.GPV_GASTOS_PROVEEDOR GPV
                            JOIN REM01.GLD_GASTOS_LINEA_DETALLE GLD ON GPV.GPV_ID=GLD.GPV_ID
                            JOIN REM01.GLD_TBJ GLTJ ON GLTJ.GLD_ID=GLD.GLD_ID
                            WHERE GPV.GPV_NUM_GASTO_HAYA='||V_GASTO||' AND GPV.BORRADO=0 AND GLD.BORRADO=1
                            ) T2 
                    ON (T1.GLD_ID = T2.GLD_ID)
                    WHEN MATCHED THEN UPDATE SET 
                    T1.USUARIOBORRAR=NULL,
                    T1.FECHABORRAR=NULL,        
                    T1.BORRADO=0,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||''', 
                    T1.FECHAMODIFICAR = SYSDATE';

        EXECUTE IMMEDIATE V_MSQL;
        
        DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TABLA_LINEA||' ');

            V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_LINEA_TBJ||' T1
                    USING (SELECT DISTINCT GLTJ.GLD_TBJ_ID FROM REM01.GPV_GASTOS_PROVEEDOR GPV
                            JOIN REM01.GLD_GASTOS_LINEA_DETALLE GLD ON GPV.GPV_ID=GLD.GPV_ID
                            JOIN REM01.GLD_TBJ GLTJ ON GLTJ.GLD_ID=GLD.GLD_ID
                            WHERE GPV.GPV_NUM_GASTO_HAYA='||V_GASTO||' 
                            AND GPV.BORRADO=0 AND GLD.BORRADO=1 AND GLTJ.BORRADO=1
                            ) T2 
                    ON (T1.GLD_TBJ_ID = T2.GLD_TBJ_ID)
                    WHEN MATCHED THEN UPDATE SET 
                    T1.USUARIOBORRAR=NULL,
                    T1.FECHABORRAR=NULL,        
                    T1.BORRADO=0,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||''', 
                    T1.FECHAMODIFICAR = SYSDATE';

        EXECUTE IMMEDIATE V_MSQL;
        
        DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TABLA_LINEA_TBJ||' ');

        

    ELSE
         DBMS_OUTPUT.PUT_LINE('[INFO] No existe el gasto indicado '||V_GASTO||' ');
    END IF;

    
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