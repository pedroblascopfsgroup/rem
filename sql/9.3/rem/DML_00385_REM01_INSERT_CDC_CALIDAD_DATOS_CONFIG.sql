--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201029
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8302
--## PRODUCTO=NO
--##
--## Finalidad: Insertar nuevo campo para MSV Calidad dato > 31 - Parcela
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'CDC_CALIDAD_DATOS_CONFIG'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8302';    

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO]');

  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (CDC_ID, TABLA, CAMPO, COD_CAMPO, CAMPO_ID,
                VALIDACION, TABLA_AUX, CAMPO_ID_TABLA_AUX, USUARIOCREAR, FECHACREAR) VALUES (
                31, ''ACT_REG_INFO_REGISTRAL'', ''REG_SUPERFICIE_PARCELA'', ''31'', ''ACT_ID'', ''N'', 
                ''ACT_ACTIVO'',''ACT_NUM_ACTIVO'', '''||V_USUARIO||''', SYSDATE)';
  EXECUTE IMMEDIATE V_MSQL;

  COMMIT;

  DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

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
