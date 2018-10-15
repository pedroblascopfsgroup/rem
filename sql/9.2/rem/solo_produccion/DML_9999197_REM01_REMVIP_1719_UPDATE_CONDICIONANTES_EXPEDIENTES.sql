--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20180910
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1719
--## PRODUCTO=NO
--##
--## Finalidad: Script que cambia el co ndicionante de los expedientes
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
    V_USUARIOMOD VARCHAR2(50 CHAR):= 'REMVIP-1719';

    V_ERE VARCHAR2(50 CHAR);
    V_EEC VARCHAR2(50 CHAR);
    
    V_NUM_EXPEDIENTE NUMBER(16);
    
BEGIN 
  
  DBMS_OUTPUT.PUT_LINE('[INICIO]: Se van a actualizar el codicionante de los expedientes');


  V_MSQL := ' UPDATE '|| V_ESQUEMA ||'.COE_CONDICIONANTES_EXPEDIENTE COE  
	      SET COE_TIPO_APLICABLE = 0 
		, USUARIOMODIFICAR = '''||V_USUARIOMOD||''' 
	        , FECHAMODIFICAR = SYSDATE 
   		 WHERE COE.ECO_ID IN (SELECT ECO.ECO_ID 
 				      FROM '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO 
                                      JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID
                                      WHERE OFR.OFR_NUM_OFERTA IN (''90067455'',''90067454'',''90067456'',''90067457''))';


	EXECUTE IMMEDIATE V_MSQL;

  DBMS_OUTPUT.PUT_LINE('  [INFO] - '||SQL%ROWCOUNT||' condicionantes expediente actualizados correctamente.');
    
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

EXIT
