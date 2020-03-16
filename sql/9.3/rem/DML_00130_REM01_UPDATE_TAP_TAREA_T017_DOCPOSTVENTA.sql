--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20200313
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9808
--## PRODUCTO=SI
--##
--## Finalidad: Actualizar Trámite Cerberus Documentos Post Venta
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(8000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.  
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'HREOS-9808';
    
BEGIN 
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T017_DocsPosVenta'' AND BORRADO = 0';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
  
    IF V_NUM_TABLAS > 0 THEN
    
      V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
            SET TAP_SCRIPT_VALIDACION_JBPM = ''existeAdjuntoUGValidacion("19,E;17,E;15,E")''
      ,USUARIOMODIFICAR = '''||V_INCIDENCIA||''', FECHAMODIFICAR = SYSDATE
            WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T017_DocsPosVenta'')';  
      EXECUTE IMMEDIATE V_MSQL;   
      DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de insercion/actualizacion de la tabla '''||V_ESQUEMA||'''.'''||V_TEXT_TABLA||''' ha finalizado correctamente');   
    END IF;
    COMMIT;
    EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;          
END;
/

EXIT;
