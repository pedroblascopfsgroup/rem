--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8813
--## PRODUCTO=NO
--## 
--## Finalidad: Revivir tarea
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8813';
	V_COUNT NUMBER(16); -- Vble. para comprobar
    V_ID_CONTABILIZADO NUMBER(16);
    V_ID_PAGADO NUMBER(16);

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL := 'SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''04''';
    EXECUTE IMMEDIATE V_MSQL INTO V_ID_CONTABILIZADO;

    V_MSQL := 'SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''05''';
    EXECUTE IMMEDIATE V_MSQL INTO V_ID_PAGADO;

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR T1 USING (
					SELECT DISTINCT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                    INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_8813 AUX ON GPV.GPV_NUM_GASTO_HAYA = AUX.GPV_NUM_GASTO_HAYA
                    WHERE GPV.BORRADO = 0 AND GPV.DD_EGA_ID = '||V_ID_CONTABILIZADO||') T2
				ON (T1.GPV_ID = T2.GPV_ID)
				WHEN MATCHED THEN UPDATE SET
				DD_EGA_ID = '||V_ID_PAGADO||',
				USUARIOMODIFICAR = '''||V_USUARIO||''',
				FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN GPV_GASTOS_PROVEEDOR');  
            
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