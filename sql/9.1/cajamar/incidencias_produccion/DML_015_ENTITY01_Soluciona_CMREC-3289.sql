--/*
--##########################################
--## AUTOR=Joaquín Sánchez Valverde
--## FECHA_CREACION=20160504
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=CMREC-3289
--## PRODUCTO=NO
--## Finalidad: DML Soluciona CMREC-3289
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'CM01'; -- Configuracion Esquema este caso haya01
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; --'CMMASTER'; -- Configuracion Esquema Master este caso hayamaster
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
	V_AUXILIAR VARCHAR2(200 CHAR); -- Vble. auxiliar en este caso peticion o nombre del sql
    V_TABLA VARCHAR2(50 CHAR); -- Vble. Tabla con la que trabajamos.
	V_Campo VARCHAR2(50 CHAR);--Campo de búsqueda.
	V_Valor VARCHAR2(1000 CHAR);--Valor buscado.

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO PROCEDIMIENTO]******** Soluciona_CMREC-3289 ********'); 
	
	V_AUXILIAR := 'CMREC-3289'; --identificador del item que soluciona o nombre del sql.
	
	
    --Asignamos DESPACHO A USUARIO
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.usd_usuarios_despachos usd WHERE usd.usu_id = (select usu.usu_id from '||V_ESQUEMA_M||'.usu_usuarios usu where usu.usu_username = ''fgl55090'') '
			|| 'and usd.des_id = (select des.des_id from '||V_ESQUEMA||'.des_despacho_externo des where des.borrado = 0 and des.DES_CODIGO = ''D-SUCON-CAN'')'
	;
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    DBMS_OUTPUT.PUT_LINE (V_SQL);
	
	IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro con valor:'''||V_Valor||''' en la tabla '||V_ESQUEMA||'.' ||V_TABLA);
	ELSE
	--Asignamos DESPACHO A USUARIO
		V_MSQL := 'insert into '||V_ESQUEMA||'.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values' ||
				'('||V_ESQUEMA||'.s_usd_usuarios_despachos.nextval,(select usu.usu_id from '||V_ESQUEMA_M||'.usu_usuarios usu where usu.usu_username = ''fgl55090''), '||
				'(select des.des_id from '||V_ESQUEMA||'.des_despacho_externo des where des.borrado = 0 and des.DES_CODIGO = ''D-SUCON-CAN''),0,0 , '''|| V_AUXILIAR ||''', sysdate)'
		;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE (V_MSQL);

	--Asignamos GRUPO A USUARIO
		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES ' ||
				'('||V_ESQUEMA_M||'.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from '||V_ESQUEMA_M||'.usu_usuarios usu where usu.usu_username = ''fgl55090''),'||
				'(SELECT usugrupo.usu_id FROM '||V_ESQUEMA||'.usd_usuarios_despachos usdgrupo INNER JOIN '||V_ESQUEMA_M||'.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id ' ||
				'AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username =''SUPCO-CAN'' AND usugrupo.borrado = 0 ) , '''|| V_AUXILIAR ||''', sysdate)'
		;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE (V_MSQL);
	END IF;

	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN PROCEDIMIENTO]******** Soluciona_CMREC-3289 ********'); 

	EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
	DBMS_OUTPUT.put_line('[ERROR PROCEDIMIENTO]-----------Soluciona_CMREC-3289-----------');
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('[FIN PROCEDIMIENTO]-------------Soluciona_CMREC-3289-----------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
    
END;
/

EXIT;