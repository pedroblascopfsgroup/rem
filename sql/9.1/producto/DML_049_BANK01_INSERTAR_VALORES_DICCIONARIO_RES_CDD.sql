--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20150707
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.12-bk
--## INCIDENCIA_LINK=PRODUCTO-94	
--## PRODUCTO=SI
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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

BEGIN

	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD WHERE DD_RVC_CODIGO = ''Todos''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD
   			(DD_RVC_ID, DD_RVC_CODIGO, DD_RVC_DESCRIPCION, DD_RVC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 			Values (
				'||V_ESQUEMA||'.S_DD_RVC_RES_VALIDACION_CDD.NEXTVAL, 
				''Todos'', 
				''Todos'', 
				''Todos'', 
				0, 
				''DD'', 
				sysdate, 
				null,
				null,
				null,
				null,
				0)';
      EXECUTE IMMEDIATE V_SQL ;      
      DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro');
    END IF ;
	
	V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD WHERE DD_RVC_CODIGO = ''REQUIRED''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD
   			(DD_RVC_ID, DD_RVC_CODIGO, DD_RVC_DESCRIPCION, DD_RVC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 			Values (
				'||V_ESQUEMA||'.S_DD_RVC_RES_VALIDACION_CDD.NEXTVAL, 
				''REQUIRED'', 
				''Campos sin informar'', 
				''Hay campos obligatorios que están sin informar'', 
				0, 
				''DD'', 
				sysdate, 
				null,
				null,
				null,
				null,
				0)';
      EXECUTE IMMEDIATE V_SQL ;      
      DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro');
    END IF ;
    
    
    
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD WHERE DD_RVC_CODIGO = ''PRASREQ''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD
   			(DD_RVC_ID, DD_RVC_CODIGO, DD_RVC_DESCRIPCION, DD_RVC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 			Values (
				'||V_ESQUEMA||'.S_DD_RVC_RES_VALIDACION_CDD.NEXTVAL, 
				''PRASREQ'', 
				''Informar Propiedad Asunto'', 
				''Se tiene que informar la Propiedad Asunto para poder enviar a Cierre de Deuda'', 
				0, 
				''DD'', 
				sysdate, 
				null,
				null,
				null,
				null,
				0)';
      EXECUTE IMMEDIATE V_SQL ;      
      DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro');
    END IF ;
    
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD WHERE DD_RVC_CODIGO = ''PRASBNK''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD
   			(DD_RVC_ID, DD_RVC_CODIGO, DD_RVC_DESCRIPCION, DD_RVC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 			Values (
				'||V_ESQUEMA||'.S_DD_RVC_RES_VALIDACION_CDD.NEXTVAL, 
				''PRASBNK'', 
				''Propiedad asunto bankia'', 
				''No se puede enviar a cierre de deuda una subasta sareb si la propiedad del asunto es bankia'', 
				0, 
				''DD'', 
				sysdate, 
				null,
				null,
				null,
				null,
				0)';
      EXECUTE IMMEDIATE V_SQL ;      
      DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro');
    END IF ;
    
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD WHERE DD_RVC_CODIGO = ''PRASSAB''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD
   			(DD_RVC_ID, DD_RVC_CODIGO, DD_RVC_DESCRIPCION, DD_RVC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 			Values (
				'||V_ESQUEMA||'.S_DD_RVC_RES_VALIDACION_CDD.NEXTVAL, 
				''PRASSAB'', 
				''Propiedad asunto sareb'', 
				''No se puede enviar a cierre de deuda una subasta bankia si la propiedad del asunto es sareb'', 
				0, 
				''DD'', 
				sysdate, 
				null,
				null,
				null,
				null,
				0)';
      EXECUTE IMMEDIATE V_SQL ;      
      DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro');
    END IF ;
    
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD WHERE DD_RVC_CODIGO = ''CONTTAR''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD
   			(DD_RVC_ID, DD_RVC_CODIGO, DD_RVC_DESCRIPCION, DD_RVC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 			Values (
				'||V_ESQUEMA||'.S_DD_RVC_RES_VALIDACION_CDD.NEXTVAL, 
				''CONTTAR'', 
				''No iniciada tarea Contabilizar'', 
				''No esta iniciada la tarea Contabilizar activos/cierre de deudas de la subasta bankia que intenta enviar a cierre de deuda'', 
				0, 
				''DD'', 
				sysdate, 
				null,
				null,
				null,
				null,
				0)';
      EXECUTE IMMEDIATE V_SQL ;      
      DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro');
    END IF ;
    
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD WHERE DD_RVC_CODIGO = ''PRCNOACT''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD
   			(DD_RVC_ID, DD_RVC_CODIGO, DD_RVC_DESCRIPCION, DD_RVC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 			Values (
				'||V_ESQUEMA||'.S_DD_RVC_RES_VALIDACION_CDD.NEXTVAL, 
				''PRCNOACT'', 
				''Procedimiento sin operacion activa'', 
				''El procedimiento no tienen ninguna operacion activa'', 
				0, 
				''DD'', 
				sysdate, 
				null,
				null,
				null,
				null,
				0)';
      EXECUTE IMMEDIATE V_SQL ;      
      DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro');
    END IF ;
    
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD WHERE DD_RVC_CODIGO = ''BIENCNT''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD
   			(DD_RVC_ID, DD_RVC_CODIGO, DD_RVC_DESCRIPCION, DD_RVC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 			Values (
				'||V_ESQUEMA||'.S_DD_RVC_RES_VALIDACION_CDD.NEXTVAL, 
				''BIENCNT'', 
				''Bien sin contrato'', 
				''El bien no tiene relación con ningún contrato'', 
				0, 
				''DD'', 
				sysdate, 
				null,
				null,
				null,
				null,
				0)';
      EXECUTE IMMEDIATE V_SQL ;      
      DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro');
    END IF ;
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD WHERE DD_RVC_CODIGO = ''LOTEPRC''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD
   			(DD_RVC_ID, DD_RVC_CODIGO, DD_RVC_DESCRIPCION, DD_RVC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 			Values (
				'||V_ESQUEMA||'.S_DD_RVC_RES_VALIDACION_CDD.NEXTVAL, 
				''LOTEPRC'', 
				''Ningun lote en procedimiento'', 
				''Se ha de incluir, al menos, un lote en el procedimiento'', 
				0, 
				''DD'', 
				sysdate, 
				null,
				null,
				null,
				null,
				0)';
      EXECUTE IMMEDIATE V_SQL ;      
      DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro');
    END IF ;
    
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD WHERE DD_RVC_CODIGO = ''LOTEBIE''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD
   			(DD_RVC_ID, DD_RVC_CODIGO, DD_RVC_DESCRIPCION, DD_RVC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 			Values (
				'||V_ESQUEMA||'.S_DD_RVC_RES_VALIDACION_CDD.NEXTVAL, 
				''LOTEBIE'', 
				''Lote sin bien'', 
				''El lote no contiene ningún bien'', 
				0, 
				''DD'', 
				sysdate, 
				null,
				null,
				null,
				null,
				0)';
      EXECUTE IMMEDIATE V_SQL ;
      DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro');
    END IF ;
    
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD WHERE DD_RVC_CODIGO = ''BIENLOTES''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD
   			(DD_RVC_ID, DD_RVC_CODIGO, DD_RVC_DESCRIPCION, DD_RVC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 			Values (
				'||V_ESQUEMA||'.S_DD_RVC_RES_VALIDACION_CDD.NEXTVAL, 
				''BIENLOTES'', 
				''Bien en varios lotes'', 
				''El bien se encuentra en más de un lote'', 
				0, 
				''DD'', 
				sysdate, 
				null,
				null,
				null,
				null,
				0)';
      EXECUTE IMMEDIATE V_SQL ;      
      DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro');
    END IF ;

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');

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



   