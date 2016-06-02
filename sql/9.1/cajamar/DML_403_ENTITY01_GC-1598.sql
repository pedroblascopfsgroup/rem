--/*
--##########################################
--## AUTOR=Joaquín Sánchez Valverde
--## FECHA_CREACION=20160203
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=GC-1598
--## PRODUCTO=NO
--## Finalidad: DML inserta despacho usuario gestoria
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'CM01';  -- Configuracion Esquema este caso haya01
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
	DBMS_OUTPUT.PUT_LINE('[INICIO PROCEDIMIENTO]******** inserta despacho usuario gestoria ********'); 
	
	V_AUXILIAR := 'GC-1598'; --identificador del item que soluciona o nombre del sql.
	
	V_TABLA := 'usu_usuarios';
	V_CAMPO := 'usu_username';
	V_VALOR := 'Gestoria';
	
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.' || V_TABLA || ' WHERE ' || V_Campo || '= '''||V_Valor||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
	IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro con valor:'''||V_Valor||''' en la tabla '||V_ESQUEMA||'.' ||V_TABLA);
	ELSE
	--Alta del despacho
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.des_despacho_externo des (des_id,des_despacho,dd_tde_id,zon_id,usuariocrear,fechacrear)  VALUES' ||
				'('|| V_ESQUEMA|| '.s_des_despacho_externo.nextval,''Despacho Gestoría Preparación Documental'',' ||
				'(SELECT dd_tde_id FROM '||V_ESQUEMA_M|| '.dd_tde_tipo_despacho WHERE dd_tde_codigo = ''GESTORIA_PREDOC''),' ||
				'(SELECT MAX(zon_id) FROM  '||V_ESQUEMA|| '.zon_zonificacion WHERE zon_cod = ''01''),''' || V_AUXILIAR || ''',sysdate)'
		;
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;	
	
	--Alta del usuario
		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ' ||
				'('|| V_ESQUEMA_M || '.s_usu_usuarios.nextval, (select ID from '||V_ESQUEMA_M||'.ENTIDAD where DESCRIPCION = ''CAJAMAR'') ,' ||
				'''Gestoria'',null,''Gestoría Preparación Documental'',''Gestoría Preparación Documental'',null,null , ''' || V_AUXILIAR || ''', sysdate, 0,0)'
		;
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		
	--alta zona		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ' ||
				'('|| V_ESQUEMA || '.s_zon_pef_usu.nextval, (select max(zon_id) from '|| V_ESQUEMA || '.zon_zonificacion where zon_cod =''01''),' ||
				'(SELECT pef_id FROM '||V_ESQUEMA||'.pef_perfiles WHERE pef_codigo = ''GEST_EXTERNO''),(SELECT usu_id FROM '||V_ESQUEMA_M||'.usu_usuarios WHERE usu_username = ''Gestoria'') , ''' || 
				V_AUXILIAR || ''', sysdate )' 
		;
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;		
	--Rel usuario despacho 
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values ' ||
				'('|| V_ESQUEMA || '.s_usd_usuarios_despachos.nextval,(select usu.usu_id from '||V_ESQUEMA_M||'.usu_usuarios usu where usu.usu_username = ''Gestoria''), ' ||
				'(select des.des_id from '||V_ESQUEMA||'.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = ''Despacho Gestoría Preparación Documental''),0,0 , ''' || V_AUXILIAR || ''', sysdate )'
		;
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;		

	END IF;

	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN PROCEDIMIENTO]******** inserta despacho usuario gestoria ********'); 

	EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
	DBMS_OUTPUT.put_line('[ERROR PROCEDIMIENTO]-----------inserta despacho usuario gestoria-----------');
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('[FIN PROCEDIMIENTO]-------------inserta despacho usuario gestoria-----------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
    
END;
/

EXIT;