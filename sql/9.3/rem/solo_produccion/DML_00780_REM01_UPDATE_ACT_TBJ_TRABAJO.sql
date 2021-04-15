--/*
--###########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210331
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9244
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar proveedor de trabajos sobre activos de Barcelona Caixabank
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-9244';
  V_CRA_ID NUMBER(16);
  V_STR_ID NUMBER(16);
  
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO] PASO 1 - Cambiar configuración de trabajos Caixabank de subtipo CEE');

    V_MSQL:= 'SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''03''';
	  EXECUTE IMMEDIATE V_MSQL INTO V_CRA_ID;

    V_MSQL:= 'SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = ''18''';
	  EXECUTE IMMEDIATE V_MSQL INTO V_STR_ID;

    V_MSQL:= 'UPDATE '||V_ESQUEMA||'.CFG_PVE_PREDETERMINADO SET
					PVE_ID = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_UVEM = ''311082937''),
          USUARIOMODIFICAR = '''||V_USUARIO||''',
          FECHAMODIFICAR = SYSDATE
					WHERE DD_CRA_ID = '||V_CRA_ID||'
          AND DD_STR_ID = '||V_STR_ID||'
          AND USUARIOMODIFICAR = ''REMVIP-8775''';
		EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en CFG_PVE_PREDETERMINADO');

    -----------------------------------------------------------------------------------------------------------------------------------

    DBMS_OUTPUT.PUT_LINE('[INFO] PASO 2 - Modificar proveedor de trabajos CEE');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO T1 USING (
              SELECT DISTINCT TBJ.TBJ_ID FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
              JOIN '||V_ESQUEMA||'.ACT_TBJ ATB ON TBJ.TBJ_ID = ATB.TBJ_ID
              JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ATB.ACT_ID = ACT.ACT_ID
              JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ACT.ACT_ID = ICO.ACT_ID
              JOIN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC ON TBJ.PVC_ID = PVC.PVC_ID
              JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVC.PVE_ID = PVE.PVE_ID 
              WHERE TBJ.DD_STR_ID = '||V_STR_ID||' AND PVE.PVE_COD_UVEM NOT LIKE ''311082937'' AND TBJ.BORRADO = 0 AND ACT.DD_CRA_ID = '||V_CRA_ID||' AND TBJ.DD_EST_ID IN (4, 23, 61, 66)) T2
      ON (T1.TBJ_ID = T2.TBJ_ID)
      WHEN MATCHED THEN UPDATE SET
      PVC_ID = 176237, 
      USUARIOMODIFICAR = '''||V_USUARIO||''',
      FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;         
	
	  DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_TBJ_TRABAJO');
		
    COMMIT;

   	DBMS_OUTPUT.PUT_LINE('[FIN] ');

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
