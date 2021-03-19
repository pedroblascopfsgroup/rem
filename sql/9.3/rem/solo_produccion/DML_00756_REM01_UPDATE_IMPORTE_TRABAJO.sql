--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210312
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9190
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar precio total trabajo
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE


    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9190'; --Vble USUARIOMODIFICAR/USUARIOCREAR

    V_ID NUMBER(16); -- Vble. para el id del activo

    V_ID_PROVEEDOR NUMBER(16); -- Vble. para el id del proveedor

    V_TABLA VARCHAR2(50 CHAR):= 'ACT_TBJ_TRABAJO'; --Vble. Tabla a modificar proveedores
    V_AUX VARCHAR2(50 CHAR):= 'AUX_REMVIP_9190';
   

	V_COUNT NUMBER(16); -- Vble. para comprobar


BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS PRECIO TOTAL TRABAJO');


        V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
		USING (
		    SELECT DISTINCT AUX.TBJ_NUM_TRABAJO,AUX.PRECIO FROM '||V_ESQUEMA||'.'||V_AUX||' AUX
            JOIN '||V_ESQUEMA||'.'||V_TABLA||' TBJ ON TBJ.TBJ_NUM_TRABAJO=AUX.TBJ_NUM_TRABAJO
            WHERE TBJ.BORRADO=0
		) T2
		ON (T1.TBJ_NUM_TRABAJO = T2.TBJ_NUM_TRABAJO)
		WHEN MATCHED THEN UPDATE SET 
		    T1.TBJ_IMPORTE_PRESUPUESTO = T2.PRECIO,		
		    T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
		    T1.FECHAMODIFICAR = SYSDATE';
		
	EXECUTE IMMEDIATE V_MSQL;
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');   
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