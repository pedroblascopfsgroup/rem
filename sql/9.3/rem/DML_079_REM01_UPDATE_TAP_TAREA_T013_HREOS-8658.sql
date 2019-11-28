--/*
--##########################################
--## AUTOR=Gabriel De Toni
--## FECHA_CREACION=20191128
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8658
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica la columna TAP_SCRIPT_DECISION para las tarea T013
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
    V_TAP_CODIGO VARCHAR (2000 CHAR);
    V_TAP_SCRIPT_DECISION VARCHAR(30000 CHAR);
    V_USUARIO VARCHAR2(30 CHAR);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	
	
	V_USUARIO := 'HREOS-8658';
	V_TAP_CODIGO := 'T013_DefinicionOferta';
	V_TAP_SCRIPT_DECISION := 'checkFormalizacion() ? valores[''''T013_DefinicionOferta''''][''''comiteSuperior''''] != DDSiNo.SI ? checkAtribuciones() ? checkReserva() == false ? esYubai() ? ''''esYubai''''  : esOmega() ? ''''esOmegaSinReserva'''':''''ConFormalizacionSinTanteoConAtribucionSinReservaSinTanteo'''' : esYubai() ? ''''esYubai'''' : esOmega() ? ''''esOmegaConReserva'''':''''ConFormalizacionSinTanteoConAtribucionConReserva'''' : ''''ConFormalizacionSinTanteoSinAtribucion'''' : ''''ConFormalizacionSinTanteoSinAtribucion'''' : ''''SinFormalizacion''''';
	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    V_MSQL := 'Select count(1) from TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAP_CODIGO||'''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS > 0 THEN
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
		SET TAP_SCRIPT_DECISION = '''||V_TAP_SCRIPT_DECISION||''', 
		USUARIOMODIFICAR = '''||V_USUARIO||''',
		FECHAMODIFICAR = SYSDATE
		WHERE TAP_CODIGO = '''||V_TAP_CODIGO||'''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('	[INFO] REGISTRO MODIFICADO CORRECTAMENTE');
	    COMMIT;
	    DBMS_OUTPUT.PUT_LINE('[FIN] TABLA TAP_TAREA_PROCEDIMIENTO ACTUALIZADA CORRECTAMENTE ');
	ELSE 
		DBMS_OUTPUT.PUT_LINE('No se ha encontrado el registro en la tabla TAP_TAREA_PROCEDIMIENTO CON EL CODIGO ' || V_TAP_CODIGO);
	END IF;
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
