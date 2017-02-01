--/*
--##########################################
--## AUTOR=DANIEL GUTIÉRREZ
--## FECHA_CREACION=20170127
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1461
--## PRODUCTO=NO
--##
--## Finalidad: 
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
 


BEGIN
	-- 1.- NºActivoHRE: 6795449 -El problema es que es una asistida y no debería consultar comité Bankia. Se tiene que ver el check de formalización para consultar el comite.
	-- 2.- Al dar de alta una oferta en comité y devolver C.PLATAFORMA (comité de haya), el expediente debe irse recto como si tuviera atribuciones.
	
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
		  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''checkFormalizacion() ? (checkDeDerechoTanteo() == false ? (checkBankia() ? (altaComite() ? null : ''''Ha fallado el alta del comite'''')   : null) : null) : null '' '||
		  ' WHERE TAP_CODIGO = ''T013_DefinicionOferta'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[COMMIT] Commit realizado');
    COMMIT;

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