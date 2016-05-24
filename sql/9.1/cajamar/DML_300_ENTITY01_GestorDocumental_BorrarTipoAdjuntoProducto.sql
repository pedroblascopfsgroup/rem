/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20151124
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-477
--## PRODUCTO=NO
--##
--## Finalidad: DML Borrado logico del tipo de adjunto Otros, ya que corresponde para producto y no aplica en cajamar
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    V_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    V_TABLENAME2 VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    V_SEQUENCENAME2 VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('Borrado logico TAE_EIN');
    V_SQL := 'UPDATE ' || V_ESQUEMA || '.TAE_EIN SET BORRADO = 1 WHERE DD_TAE_ID = (SELECT DD_TAE_ID FROM ' || V_ESQUEMA || '.DD_TAE_TIPO_ADJUNTO_ENTIDAD WHERE DD_TAE_CODIGO = ''99999'') ';
    EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('Borrado logico DD_TAE_TIPO_ADJUNTO_ENTIDAD');
    V_SQL := 'UPDATE ' || V_ESQUEMA || '.DD_TAE_TIPO_ADJUNTO_ENTIDAD SET BORRADO = 1 WHERE DD_TAE_CODIGO = ''99999''';
    EXECUTE IMMEDIATE V_SQL;

DBMS_OUTPUT.PUT_LINE('[FIN]');

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
