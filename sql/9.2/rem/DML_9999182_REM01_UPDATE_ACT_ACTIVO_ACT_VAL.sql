--/*
--##########################################
--## AUTOR=Alberto Garcia
--## FECHA_CREACION=20181114
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4777
--## PRODUCTO=NO
--##
--## Finalidad: Eliminar todos los precios aprobados en venta/alquiler = 0 y a esos mismos activos si el estado es publicado pasarlos a oculto sin precio.
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Actualizo estado y borro registros de precios
--##        0.3 Quito la actualización de motivo de ocultacion manual
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
	type t_num is table of number(16);
  	T_IDS t_num;
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	V_MSQL := 'SELECT DISTINCT ACT.ACT_ID 
	FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
	JOIN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = ACT.ACT_ID
	JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID
	    AND TPC.DD_TPC_CODIGO IN (''02'',''03'')
	JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
	    AND SCM.DD_SCM_CODIGO NOT IN  (''05'',''06'')
	WHERE VAL.VAL_FECHA_INICIO IS NOT NULL AND VAL.VAL_FECHA_FIN IS NULL
	    AND VAL.BORRADO = 0 AND (VAL.VAL_IMPORTE = 0 OR VAL.VAL_IMPORTE IS NULL)';

	EXECUTE IMMEDIATE V_MSQL BULK COLLECT INTO T_IDS;
	DBMS_OUTPUT.PUT_LINE('[FIN]: INSERCION DE IDS DE ACTIVO EN TEMPORAL ');
	
	FOR elemId IN 1 .. T_IDS.COUNT loop
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_VAL_VALORACIONES 
        SET BORRADO = 1,
        USUARIOBORRAR = ''HREOS-4777'', 
        FECHABORRAR = SYSDATE 
        WHERE ACT_ID = '''||T_IDS(elemId)||''' AND VAL_FECHA_INICIO IS NOT NULL AND VAL_FECHA_FIN IS NULL
        AND BORRADO = 0 AND (VAL_IMPORTE = 0 OR VAL_IMPORTE IS NULL) AND DD_TPC_ID IN (SELECT DD_TPC_ID FROM '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO IN (''02'',''03''))';
        EXECUTE IMMEDIATE V_MSQL;
	  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
    	SET APU.APU_CHECK_OCULTAR_V = 1, 
		APU.DD_EPV_ID = (SELECT DD_EPV_ID FROM DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO = ''04''),
		APU.DD_MTO_V_ID = (SELECT DD_MTO_ID FROM DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = ''14''),
        APU.USUARIOMODIFICAR = ''HREOS-4777'', 
        APU.FECHAMODIFICAR = SYSDATE 
		WHERE APU.DD_EPV_ID = (SELECT DD_EPV_ID FROM DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO = ''03'') 
        AND APU.DD_TCO_ID IN (SELECT DD_TCO_ID FROM DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = ''01'' OR DD_TCO_CODIGO = ''02'')
        AND APU.ACT_ID = '''||T_IDS(elemId)||'''';
        EXECUTE IMMEDIATE V_MSQL;
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
    	SET APU.APU_CHECK_OCULTAR_A = 1, 
		APU.DD_EPA_ID = (SELECT DD_EPA_ID FROM DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO = ''04''),
		APU.DD_MTO_A_ID = (SELECT DD_MTO_ID FROM DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = ''14''),
        APU.USUARIOMODIFICAR = ''HREOS-4777'', 
        APU.FECHAMODIFICAR = SYSDATE 
		WHERE APU.DD_EPA_ID = (SELECT DD_EPA_ID FROM DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO = ''03'') 
        AND APU.DD_TCO_ID IN (SELECT DD_TCO_ID FROM DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = ''02'' OR DD_TCO_CODIGO = ''03'' OR DD_TCO_CODIGO = ''04'')
        AND APU.ACT_ID = '''||T_IDS(elemId)||'''';
        EXECUTE IMMEDIATE V_MSQL;
  	END LOOP;
  	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
	   	
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
