/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20160210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=CMREC-2054
--## PRODUCTO=NO
--##
--## Finalidad: Asignación de gestores de riesgos a asuntos 
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
	--  insertar usuarios de validacion de riesgos
	
	--Creamos los usuarios
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_MASTER||'.usu_usuarios WHERE usu_username = ''val.dirrietergcc''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;          

    IF V_NUM_TABLAS = 0 THEN

		V_MSQL := 'insert into ' || V_ESQUEMA_MASTER || '.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( ' || V_ESQUEMA_MASTER || '.s_usu_usuarios.nextval, 1,''val.dirrietergcc'',''1234'',''Director riesgos territoriales GCC'','''','''','''' , ''JSV'', sysdate, 0,0)';
		
		EXECUTE IMMEDIATE V_MSQL;
	END IF;
	
	-- Se crean los perfiles
	V_SQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.PEF_PERFILES WHERE PEF_CODIGO = ''DRTGCC''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;          

    IF V_NUM_TABLAS = 0 THEN

		V_MSQL := 'Insert into  ' || V_ESQUEMA || '.PEF_PERFILES (PEF_ID,PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,PEF_CODIGO,PEF_ES_CARTERIZADO,DTYPE) values (' || V_ESQUEMA || '.S_PEF_PERFILES.nextval,''Acceso a las funcionalidades de Director riesgos territoriales GCC'',''Director riesgos territoriales GCC'',''0'',''SAG'',sysdate,null,null,null,null,''0'',''DRTGCC'',''0'',''EXTPerfil'')';
	
		EXECUTE IMMEDIATE V_MSQL;
	END IF;
		
	--Zonificamos los usuarios
	V_SQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.zon_pef_usu zpu WHERE zpu.zon_id = (select max(zon_id) from ' || V_ESQUEMA || '.zon_zonificacion where zon_cod =''01'') AND zpu.pef_id = (SELECT pef_id FROM ' || V_ESQUEMA || '.pef_perfiles WHERE PEF_DESCRIPCION = ''Director riesgos territoriales GCC'' and borrado = 0) AND zpu.usu_id = (SELECT usu_id FROM ' || V_ESQUEMA_MASTER || '.usu_usuarios WHERE usu_username = ''val.dirrietergcc'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;          

    IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'insert into ' || V_ESQUEMA || '.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( ' || V_ESQUEMA || '.s_zon_pef_usu.nextval, (select max(zon_id) from ' || V_ESQUEMA || '.zon_zonificacion where zon_cod =''01''),(SELECT pef_id FROM ' || V_ESQUEMA || '.pef_perfiles WHERE PEF_DESCRIPCION = ''Director riesgos territoriales GCC'' and borrado = 0),(SELECT usu_id FROM ' || V_ESQUEMA_MASTER || '.usu_usuarios WHERE usu_username = ''val.dirrietergcc'') , ''JSV'', sysdate )';
		
		EXECUTE IMMEDIATE V_MSQL;
	END IF;
	
	---Despacho
	V_SQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.usd_usuarios_despachos WHERE usu_id = (select usu.usu_id from ' || V_ESQUEMA_MASTER || '.usu_usuarios usu where usu.usu_username = ''val.gesriesgo'') AND des_id = (select des.des_id from ' || V_ESQUEMA || '.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = ''Despacho Gestor de riesgos'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;          

    IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'insert into ' || V_ESQUEMA || '.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (' || V_ESQUEMA || '.s_usd_usuarios_despachos.nextval,(select usu.usu_id from ' || V_ESQUEMA_MASTER || '.usu_usuarios usu where usu.usu_username = ''val.gesriesgo''), (select des.des_id from ' || V_ESQUEMA || '.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = ''Despacho Gestor de riesgos''),0,0 , ''JSV'', sysdate )';
		
		EXECUTE IMMEDIATE V_MSQL;
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.usd_usuarios_despachos WHERE usu_id = (select usu.usu_id from ' || V_ESQUEMA_MASTER || '.usu_usuarios usu where usu.usu_username = ''val.dirterriegos'') AND des_id = (select des.des_id from ' || V_ESQUEMA || '.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = ''Despacho Director territorial riesgos'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;          

    IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'insert into ' || V_ESQUEMA || '.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (' || V_ESQUEMA || '.s_usd_usuarios_despachos.nextval,(select usu.usu_id from ' || V_ESQUEMA_MASTER || '.usu_usuarios usu where usu.usu_username = ''val.dirterriegos''), (select des.des_id from ' || V_ESQUEMA || '.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = ''Despacho Director territorial riesgos''),0,0 , ''JSV'', sysdate )';
			
		EXECUTE IMMEDIATE V_MSQL;
	END IF;

	V_SQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.usd_usuarios_despachos WHERE usu_id = (select usu.usu_id from ' || V_ESQUEMA_MASTER || '.usu_usuarios usu where usu.usu_username = ''val.dirrietergcc'') AND des_id = (select des.des_id from ' || V_ESQUEMA || '.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = ''Despacho Director riesgos territoriales GCC'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;          

    IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'insert into ' || V_ESQUEMA || '.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (' || V_ESQUEMA || '.s_usd_usuarios_despachos.nextval,(select usu.usu_id from ' || V_ESQUEMA_MASTER || '.usu_usuarios usu where usu.usu_username = ''val.dirrietergcc''), (select des.des_id from ' || V_ESQUEMA || '.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = ''Despacho Director riesgos territoriales GCC''),0,0 , ''JSV'', sysdate )';
		
		EXECUTE IMMEDIATE V_MSQL;
	END IF;
	
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
