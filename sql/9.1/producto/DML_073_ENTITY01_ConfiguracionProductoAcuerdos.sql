--/*
--##########################################
--## AUTOR=PEDROBLASCOS
--## FECHA_CREACION=20151014
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=PRODUCTO-174
--## PRODUCTO=SI
--##
--## Finalidad: INSERCIÓN DE CONFIGURACIÓN DE ACUERDOS POR DEFECTO
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    
    V_INSERT VARCHAR2(4000 CHAR);
    V_VALUES VARCHAR2(4000 CHAR);
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('INSERCIÓN DE CONFIGURACIÓN DE ACUERDOS POR DEFECTO');
	DBMS_OUTPUT.PUT_LINE('***** Inserción -- Nuevos tipos de gestor ******');

	V_INSERT := 'Insert into ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR (DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,' || 
		'VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TGE_EDITABLE_WEB) values ('||
		V_ESQUEMA_M || '.S_DD_TGE_TIPO_GESTOR.nextval,';
		
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''PROPACU'' ';
    EXECUTE IMMEDIATE V_SQL INTO table_count;
    
    IF table_count > 0 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR... Ya existe el DD_TGE_CODIGO ''PROPACU'' ');
    ELSE
    	V_VALUES := q'['PROPACU','Proponente acuerdo extrajudicial','Proponente acuerdo extrajudicial','0','DD',sysdate,null,null,null,null,'0','0')]';
		DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
    END IF;
    
    
   	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''VALIACU'' ';
    EXECUTE IMMEDIATE V_SQL INTO table_count;
    
    IF table_count > 0 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR... Ya existe el DD_TGE_CODIGO ''VALIACU'' ');
    ELSE
		V_VALUES := q'['VALIACU','Validador acuerdo extrajudicial','Validador acuerdo extrajudicial','0','DD',sysdate,null,null,null,null,'0','0')]';  
		DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
    END IF;
    

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''DECIACU'' ';
    EXECUTE IMMEDIATE V_SQL INTO table_count;
    
    IF table_count > 0 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR... Ya existe el DD_TGE_CODIGO ''DECIACU'' ');
    ELSE
		V_VALUES := q'['DECIACU','Decisor acuerdo extrajudicial','Decisor acuerdo extrajudicial','0','DD',sysdate,null,null,null,null,'0','0')]';
 		DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
    END IF;

	
EXCEPTION


	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		ROLLBACK;
		RAISE;
END;
/

EXIT;