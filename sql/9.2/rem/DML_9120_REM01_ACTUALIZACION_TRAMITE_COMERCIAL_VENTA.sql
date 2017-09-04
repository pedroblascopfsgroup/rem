--/*
--##########################################
--## AUTOR=CARLOS PONS
--## FECHA_CREACION=20170125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=0
--## PRODUCTO=SI
--##
--## Finalidad: Realiza las modificaciones necesarias para item HREOS-2161 (Validar rellenado campo ReservaNecesaria)
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

    --REGISTRO ELEGIDO
    V_TAP_CODIGO VARCHAR2(100 CHAR);

    --CAMPOS PARA ACTUALIZAR
    V_TAP_VALOR1 VARCHAR2(4000 CHAR);
    V_TAP_VALOR2 VARCHAR2(4000 CHAR);
    V_TAP_VALOR3 VARCHAR2(4000 CHAR);
    V_TAP_VALOR4 VARCHAR2(4000 CHAR);

    --TABLA PARA ACTUALIZAR
    V_TAP_TABLA VARCHAR2(100 CHAR);
    
BEGIN 

    DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO TRAMITE DEFINICION OFERTA');   
    V_TAP_TABLA := 'TAP_TAREA_PROCEDIMIENTO';
	  V_TAP_VALOR1 := 'valores[''''T013_DefinicionOferta''''][''''comboConflicto''''] == DDSiNo.SI || valores[''''T013_DefinicionOferta''''][''''comboRiesgo''''] == DDSiNo.SI ? ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' : definicionOfertaT013()';    
    V_TAP_VALOR2 := 'valores[''''T013_ResolucionComite''''][''''comboResolucion''''] != DDResolucionComite.CODIGO_APRUEBA ? (valores[''''T013_ResolucionComite''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_CONTRAOFERTA ? existeAdjuntoUGValidacion("22","E") : null) : resolucionComiteT013()';
    V_TAP_VALOR3 := 'valores[''''T013_RespuestaOfertante''''][''''comboRespuesta''''] == DDSiNo.NO ? null : respuestaOfertanteT013()';
    V_TAP_VALOR4 := 'ratificacionComiteT013()';

    V_TAP_CODIGO := 'T013_DefinicionOferta'; 
  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TAP_TABLA||'
                SET TAP_SCRIPT_VALIDACION_JBPM = '''||V_TAP_VALOR1||''' 
                WHERE  TAP_CODIGO = '''||V_TAP_CODIGO||''' ';
    DBMS_OUTPUT.PUT_LINE('[SQL1]: '||V_MSQL);                	
  	EXECUTE IMMEDIATE V_MSQL;

    V_TAP_CODIGO := 'T013_ResolucionComite';  
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TAP_TABLA||'
                SET TAP_SCRIPT_VALIDACION_JBPM = '''||V_TAP_VALOR2||''' 
                WHERE  TAP_CODIGO = '''||V_TAP_CODIGO||''' ';
    DBMS_OUTPUT.PUT_LINE('[SQL2]: '||V_MSQL);                  
    EXECUTE IMMEDIATE V_MSQL;

    V_TAP_CODIGO := 'T013_RespuestaOfertante';  
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TAP_TABLA||'
                SET TAP_SCRIPT_VALIDACION_JBPM = '''||V_TAP_VALOR3||''' 
                WHERE  TAP_CODIGO = '''||V_TAP_CODIGO||''' ';
    DBMS_OUTPUT.PUT_LINE('[SQL3]: '||V_MSQL);                  
    EXECUTE IMMEDIATE V_MSQL;

    V_TAP_CODIGO := 'T013_RatificacionComite';
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TAP_TABLA||'
                SET TAP_SCRIPT_VALIDACION_JBPM = '''||V_TAP_VALOR4||''' 
                WHERE  TAP_CODIGO = '''||V_TAP_CODIGO||''' ';
    DBMS_OUTPUT.PUT_LINE('[SQL4]: '||V_MSQL);                  
    EXECUTE IMMEDIATE V_MSQL;

	  DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADO CORRECTAMENTE');  
    
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