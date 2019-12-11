--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20191202
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5873
--## PRODUCTO=SI
--##
--## Finalidad: 
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
	
--T004_EleccionPresupuesto ----------------------------
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS 
	SET DD_EOF_ID = (SELECT DD_EOF_ID FROM DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''02''),
	USUARIOMODIFICAR = ''REMVIP-5873'', 
	FECHAMODIFICAR = SYSDATE 
	WHERE OFR_NUM_OFERTA IN (SELECT OFR2.OFR_NUM_OFERTA FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
							JOIN '||V_ESQUEMA||'.ACT_OFR AOF ON AOF.ACT_ID = ACT.ACT_ID 
							JOIN '||V_ESQUEMA||'.ACT_OFR AOF2 ON AOF2.ACT_ID = ACT.ACT_ID 
							JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR2 ON OFR2.OFR_ID = AOF2.OFR_ID 
							JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = AOF.OFR_ID AND OFR.OFR_ID != OFR2.OFR_ID 
							JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID 
							WHERE ECO.DD_EEC_ID = 8 
							AND OFR.DD_EOF_ID = 1
							AND OFR2.DD_EOF_ID != 2)';

	EXECUTE IMMEDIATE V_MSQL;
	      
  	DBMS_OUTPUT.PUT_LINE('[INFO]:'||SQL%ROWCOUNT||' REGISTROS MODIFICADOS CORRECTAMENTE');
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA DD_TPD_TIPO_DOCUMENTO ACTUALIZADA CORRECTAMENTE ');
   			

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