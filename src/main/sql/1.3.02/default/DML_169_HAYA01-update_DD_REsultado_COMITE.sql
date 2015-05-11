/*
--######################################################################
--## Author: Roberto
--## Finalidad: Dejar en el diccionario los valores que había antes
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    

    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO DICCIONARIO '||V_ESQUEMA||'.DD_RCC_RES_COMITE_CONCURS');
    
	--V_SQL := 'UPDATE '||V_ESQUEMA||'.DD_RCC_RES_COMITE_CONCURS SET DD_RCC_DESCRIPCION=''ACEPTADA'',DD_RCC_DESCRIPCION_LARGA=''ACEPTADA'',DD_RCC_CODIGO=''ACEPTADA'' WHERE DD_RCC_CODIGO=''CONCEDIDO''';
    --EXECUTE IMMEDIATE V_SQL;
    
	--V_SQL := 'UPDATE '||V_ESQUEMA||'.DD_RCC_RES_COMITE_CONCURS SET DD_RCC_DESCRIPCION=''ACEPTADA CON CAMBIOS'',DD_RCC_DESCRIPCION_LARGA=''ACEPTADA CON CAMBIOS'',DD_RCC_CODIGO=''ACCONCAM'' WHERE DD_RCC_CODIGO=''CONCONMOD''';
    --EXECUTE IMMEDIATE V_SQL;
    
	V_SQL := 'UPDATE '||V_ESQUEMA||'.DD_RCC_RES_COMITE_CONCURS SET BORRADO=0,FECHABORRAR=null,USUARIOBORRAR=null WHERE DD_RCC_CODIGO=''MODIFICAR''';
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.PUT_LINE(' DICCIONARIO ACTUALIZADO '||V_ESQUEMA||'.DD_RCC_RES_COMITE_CONCURS');

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