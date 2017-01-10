--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20161214
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1306
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza descripciones del diccionario de subtipos de documentos del expediente
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
  
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    --TABLA PARA ACTUALIZAR
    V_SDE_TABLA VARCHAR2(1000 CHAR) := '';

    --REGISTRO ELEGIDO
    V_SDE_CODIGO_CAMPO VARCHAR2(100 CHAR)  := '';
    V_SDE_CODIGOS VARCHAR2(4000 CHAR) := '';

    --CAMPO PARA ACTUALIZAR
    V_SDE_CAMPO VARCHAR2(100 CHAR)  := '';
    V_SDE_VALOR VARCHAR2(1000 CHAR) := '';


BEGIN 
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] Cambio a tipo doc Formalización del contrato de alquiler');


  --ACTUALIZACION DE VALORES DE DICCIONARIO SUBTIPO DE EXPEDIENTES
  V_SDE_TABLA := 'DD_SDE_SUBTIPO_DOC_EXP';
  V_SDE_CODIGO_CAMPO := 'DD_SDE_CODIGO';
  V_SDE_CAMPO := 'DD_TDE_ID';

  -- Documento justificativo de la oferta --> Resolucion comite
  V_SDE_CODIGOS := ' ''09'' ';
  V_SDE_VALOR := 'SELECT DD_TDE_ID FROM DD_TDE_TIPO_DOC_EXP WHERE DD_TDE_CODIGO = ''04'' ';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_SDE_TABLA||'
             SET '||V_SDE_CAMPO||'=('||V_SDE_VALOR||')
             ,FECHAMODIFICAR = sysdate
             ,USUARIOMODIFICAR = ''DML_99900026''
             WHERE '||V_SDE_CODIGO_CAMPO||' IN ('||V_SDE_CODIGOS||')
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADO CORRECTAMENTE ');


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
