--/*
--##########################################
--## AUTOR=SERGIO SALT
--## FECHA_CREACION=20190110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5134
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar la pestaña patrimonio para cuando el estado alquiler es nulo se cambia a Libre, es decir, Libre ahora es la opción predeterminada.
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

     MERGE INTO #ESQUEMA#.ACT_PTA_PATRIMONIO_ACTIVO pta
     USING (SELECT act.ACT_ID
     FROM #ESQUEMA#.ACT_PTA_PATRIMONIO_ACTIVO pta
     INNER JOIN #ESQUEMA#.ACT_ACTIVO act ON pta.ACT_ID = act.ACT_ID
     INNER JOIN #ESQUEMA#.DD_TCO_TIPO_COMERCIALIZACION  tco ON act.DD_TCO_ID = tco.DD_TCO_ID
     WHERE tco.DD_TCO_CODIGO IN ('02','03','04') AND pta.DD_EAL_ID IS NULL) tmp
     ON ( pta.ACT_ID = tmp.ACT_ID)
     WHEN MATCHED THEN UPDATE SET 
     pta.DD_EAL_ID = (SELECT DD_EAL_ID FROM #ESQUEMA#.DD_EAL_ESTADO_ALQUILER WHERE DD_EAL_CODIGO = '01'),
     pta.USUARIOMODIFICAR = 'HREOS-5134',
     pta.FECHAMODIFICAR = SYSDATE,
     pta.VERSION = VERSION + 1;

     DBMS_OUTPUT.PUT_LINE ('Filas actualizadas ' || SQL%ROWCOUNT);

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
