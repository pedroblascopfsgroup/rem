--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20180702
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1211
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica las situaciones comercialoes de los activos con las condiciones dadas
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    	EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO PTO_OLD USING (
        SELECT PTO.PTO_ID
          FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
	  JOIN '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO PTO ON ACT.ACT_ID = PTO.ACT_ID
	  JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON PTO.EJE_ID = EJE.EJE_ID
	  JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID
	  WHERE EJE.EJE_ANYO = 2018
	  AND PTO.PTO_IMPORTE_INICIAL = 50000
	  AND CRA.DD_CRA_CODIGO = ''02'')PTO_NEW
	  ON (PTO_NEW.PTO_ID = PTO_OLD.PTO_ID)
	  WHEN MATCHED THEN UPDATE SET
	  PTO_OLD.PTO_IMPORTE_INICIAL = 1000000,
	  PTO_OLD.USUARIOMODIFICAR = ''REMVIP-1211'',
	  PTO_OLD.FECHAMODIFICAR = SYSDATE';

	DBMS_OUTPUT.PUT_LINE('[FIN]: '||SQL%ROWCOUNT||' registros mergeados');

	COMMIT;
  

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

EXIT;
