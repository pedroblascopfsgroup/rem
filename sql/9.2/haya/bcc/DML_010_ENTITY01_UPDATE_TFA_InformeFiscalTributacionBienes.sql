/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20160406
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1051
--## PRODUCTO=NO
--##
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
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('Se habilita el tipo fichero adjunto Informe Fiscal para la tributacion de bienes para haya cajamar');

    V_MSQL := 'UPDATE ' || V_ESQUEMA || '.DD_TFA_FICHERO_ADJUNTO SET DD_TFA_DESCRIPCION=''Informe Fiscal (Tributación de Bienes)'', DD_TFA_DESCRIPCION_LARGA=''Informe Fiscal (Tributación de Bienes)'', USUARIOMODIFICAR=''PRODUCTO-1051'', FECHAMODIFICAR=SYSDATE, BORRADO=0 WHERE DD_TFA_CODIGO = ''INFFIS''';

    EXECUTE IMMEDIATE V_MSQL;

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