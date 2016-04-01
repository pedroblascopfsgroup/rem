--/*
--##########################################
--## AUTOR=RAFAEL ARACIL
--## FECHA_CREACION=20160323
--## ARTEFACTO=BATCH
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=BKREC-2015
--## PRODUCTO=NO
--##
--## Finalidad: Actualiza DICCIONARIO DD_TRI_TRIBUTACION
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN		
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DD_TRI_TRIBUTACION CODIGO NO ATRIBUIBLE A BANKIA');
    V_SQL := 
    'UPDATE '||V_ESQUEMA||'.DD_TRI_TRIBUTACION
        SET BORRADO=1 
        WHERE DD_TRI_CODIGO IN 
        (''TPO'',
''IGIC'',
''IGICREN'',
''IVA'',
''IVAREN''
)
    ';
    EXECUTE IMMEDIATE V_SQL;
    --DBMS_OUTPUT.PUT_LINE(V_SQL);
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DD_TRI_TRIBUTACION CODIGO NO ATRIBUIBLE A BANKIA');

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