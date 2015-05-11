--/*
--##########################################
--## Author: Óscar
--## Finalidad: DML
--##            
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

    V_TEXT1 VARCHAR(1500 CHAR);
    
BEGIN

	execute immediate 'DELETE FROM '||V_ESQUEMA||'.fun_pef WHERE FUN_ID  = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.fun_funciones WHERE FUN_DESCRIPCION =''REORGANIZAR_PROCEDIMIENTO'') AND PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_DESCRIPCION = ''LETRADO'')';
	
	execute immediate 'Insert into '||V_ESQUEMA_M||'.FUN_FUNCIONES
 		(FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 	Values
 	 	('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.NEXTVAL, ''Botón finalizar asunto'', ''BTN_FINALIZAR_ASUNTO'', 0, ''DD'', sysdate, 0)';
   
	execute immediate 'Insert into '||V_ESQUEMA||'.FUN_PEF
	   (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
	 Values
	   ((SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''BTN_FINALIZAR_ASUNTO''), (select pef_id from '||V_ESQUEMA||'.pef_perfiles where pef_descripcion = ''SUPERVISOR''), s_fun_pef.nextval, 0, ''DD'', SYSDATE, 0)';
	
	
	execute immediate 'Insert into '||V_ESQUEMA_M||'.FUN_FUNCIONES
	   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
	 Values
	   ('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.NEXTVAL, ''Adjuntar contratos asunto'', ''BTN_ADJUNTAR_CONTRATOS_ASUNTO'', 0, ''DD'', sysdate, 0)';
	   
	execute immediate 'Insert into '||V_ESQUEMA||'.FUN_PEF
	   (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
	 Values
	   ((SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''BTN_ADJUNTAR_CONTRATOS_ASUNTO''), (select pef_id from '||V_ESQUEMA||'.pef_perfiles where pef_descripcion = ''SUPERVISOR''), s_fun_pef.nextval, 0, ''DD'', SYSDATE, 0)';
		

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN] INCIDENCIA');

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

