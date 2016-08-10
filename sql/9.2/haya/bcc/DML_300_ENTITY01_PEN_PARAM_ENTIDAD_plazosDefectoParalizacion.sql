--/*
--##########################################
--## AUTOR=SERGIO NIETO
--## FECHA_CREACION=20160624
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-1840
--## PRODUCTO=NO
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN


  DBMS_OUTPUT.PUT_LINE('[INICIO]');

  V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD WHERE PEN_PARAM = ''plazoParalizacionIndefinido''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
    DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
  ELSE
    DBMS_OUTPUT.put_line('[INFO] Insertando nuevo valor');

    V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD
    		(PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
    	VALUES
    		('||V_ESQUEMA||'.s_pen_param_entidad.nextval, ''plazoParalizacionIndefinido'', ''31/12/2199'', ''Devuelve la fecha de plazo para la paralización indefinida'', 0, ''RECOVERY-1984'', sysdate, 0)';
    EXECUTE IMMEDIATE V_SQL;
  END IF;
  
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD WHERE PEN_PARAM = ''plazoParalizacion1mes''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
    DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
  ELSE
    DBMS_OUTPUT.put_line('[INFO] Insertando nuevo valor');

    V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD
    		(PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
    	VALUES
    		('||V_ESQUEMA||'.s_pen_param_entidad.nextval, ''plazoParalizacion1mes'', ''2629800'', ''Devuelve el tiempo en segundos de plazo para la paralización de 1 mes'', 0, ''RECOVERY-1984'', sysdate, 0)';
    EXECUTE IMMEDIATE V_SQL;
  END IF;
  
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD WHERE PEN_PARAM = ''plazoParalizacion6meses''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
    DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
  ELSE
    DBMS_OUTPUT.put_line('[INFO] Insertando nuevo valor');

    V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD
    		(PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
    	VALUES
    		('||V_ESQUEMA||'.s_pen_param_entidad.nextval, ''plazoParalizacion6meses'', ''15778800'', ''Devuelve el tiempo en segundos de plazo para la paralización de 6 meses'', 0, ''RECOVERY-1984'', sysdate, 0)';
    EXECUTE IMMEDIATE V_SQL;
  END IF;


COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');

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

