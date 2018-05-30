--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20180529
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-904
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade la excel de la operacion de carga masiva
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
    V_NUM_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(25 CHAR) := 'DD_OPM_OPERACION_MASIVA';
    V_TEXT_TABLA_2 VARCHAR2(25 CHAR) := 'POP_PLANTILLAS_OPERACION';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_OPM_OPERACION_MASIVA] ');
    
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_OPM_CODIGO = ''AGP''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_COUNT;
    
    IF V_NUM_COUNT = 1 THEN
    
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_2||' (POP_ID, POP_NOMBRE, POP_DIRECTORIO, DD_OPM_ID, USUARIOCREAR, FECHACREAR)
    VALUES (S_POP_PLANTILLAS_OPERACION.NEXTVAL, ''LISTADO_ACTIVOS_GASTO_PORCENTAJE'', ''plantillas/plugin/masivo/LISTADO_ACTIVOS_GASTO_PORCENTAJE.xls'',
    (SELECT DD_OPM_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_OPM_CODIGO = ''AGP''), ''REMVIP-904'', SYSDATE)';              

		EXECUTE IMMEDIATE V_MSQL;
    
    END IF;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_OPM_OPERACION_MASIVA ACTUALIZADO CORRECTAMENTE ');
   

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
