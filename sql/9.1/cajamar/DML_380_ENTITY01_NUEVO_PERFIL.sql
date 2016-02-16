--/*
--##########################################
--## AUTOR=Joaquín Sánchez Valverde
--## FECHA_CREACION=20160211
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=CAJAMAR-0002
--## PRODUCTO=NO
--## Finalidad: DML_380_ENTITY01_NUEVO_PERFIL.sql
--##           
--## INSTRUCCIONES: Cierra procedimientos erroneos por peticion usuario HR-1856 y HR-1911
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
  	V_USUARIO_EJECUTA VARCHAR2(25 CHAR):= 'CAJAMAR-0002'; -- Usuario que EJECUTA el paquete.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
		
    V_TAREA VARCHAR2(1024 CHAR); -- Vble. descripcion de lo que hace el proceso
    V_COD_PERFIL VARCHAR2(50 CHAR); -- Vble. descripcion de lo que hace el proceso
BEGIN
	V_COD_PERFIL := '';
	V_TAREA :='Creamos el nuevo perfil';

	DBMS_OUTPUT.PUT_LINE('[INICIO-PROCEDIMIENTO] -----------' || V_USUARIO_EJECUTA || '---------- - PROCEDIMIENTO');  

	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES pef WHERE pef.USUARIOCREAR = ''' || V_USUARIO_EJECUTA || ''' ';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS < 1 THEN
		V_MSQL := 'SELECT pef.PEF_CODIGO FROM '||V_ESQUEMA||'.PEF_PERFILES pef WHERE pef.PEF_DESCRIPCION = ''D. Zona'' '; -- DIR_ZONA
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_COD_PERFIL;
		IF V_COD_PERFIL is null THEN
			DBMS_OUTPUT.PUT_LINE('--Creamos el nuevo perfil DIR_ZONA');  
			V_COD_PERFIL := 'DIR_ZONA';	
			
			V_MSQL := 'INSERT INTO  '||V_ESQUEMA||'.PEF_PERFILES (PEF_ID,PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION,USUARIOCREAR,FECHACREAR,PEF_CODIGO) VALUES ('
				|| V_ESQUEMA ||'.S_PEF_PERFILES.nextval,''Director de zona'',''Director de zona'',''' || V_USUARIO_EJECUTA || ''',sysdate,'''||V_COD_PERFIL||''' ) '
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Creamos el nuevo perfil DIR_ZONA' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Creamos el nuevo perfil DIR_ZONA ya existe');				
		END IF;

--Asignamos las funciones al perfil
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES pef WHERE pef.PEF_CODIGO = '''||V_COD_PERFIL || '''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS >= 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Asignamos las funciones al perfil');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF ( FUN_ID, PEF_ID, FP_ID, USUARIOCREAR, FECHACREAR)'
			|| ' SELECT FUN.FUN_ID, (SELECT PEF.PEF_ID FROM ' || V_ESQUEMA || '.PEF_PERFILES PEF WHERE PEF_CODIGO = '''||V_COD_PERFIL || ''') , ' || V_ESQUEMA || '.S_FUN_PEF.nextval ,'''
			|| V_USUARIO_EJECUTA || ''',sysdate FROM ' || V_ESQUEMA_M || '.FUN_FUNCIONES FUN WHERE FUN.FUN_DESCRIPCION IN (''ROLE_PUEDE_VER_TAB_EXP_CLIENTES'', ''ROLE_PUEDE_VER_TAB_EXP_TITULOS'','
			|| '''ROLE_PUEDE_VER_TAB_EXP_GESTION'', ''ROLE_PUEDE_VER_TAB_EXP_CUMPLIMIENTO'', ''ROLE_PUEDE_VER_TAB_EXP_CONTRATOS'', ''TAB_ATIPICOS'' )'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Asignadas las funciones al perfil' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Asignamos las funciones, perfil no existe');				
		END IF;    
--Creamos tipo despacho
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO tde WHERE tde.DD_TDE_CODIGO = ''DESDIR_ZONA''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Creamos tipo despacho');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO (DD_TDE_ID,DD_TDE_CODIGO,DD_TDE_DESCRIPCION,DD_TDE_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES ('
				|| V_ESQUEMA_M || '.S_DD_TDE_TIPO_DESPACHO.nextval,''DESDIR_ZONA'',''Director de zona'',''Tipo Despacho Director de zona'' '
				|| ',''' ||  V_USUARIO_EJECUTA || ''',sysdate )'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Creamos tipo despacho' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Creamos tipo despacho ya existe');				
		END IF;    		

--Creamos DESPACHO
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.DES_CODIGO = ''D-DIR_ZONA''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Creamos despacho Despacho Director de zona');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.des_despacho_externo des(des_id,des_despacho,dd_tde_id,DES_CODIGO,zon_id,usuariocrear,fechacrear ) VALUES ('
				|| V_ESQUEMA||'.s_des_despacho_externo.nextval,''Despacho Director de zona'', '
				|| ' (SELECT dd_tde_id FROM '||V_ESQUEMA_M||'.dd_tde_tipo_despacho WHERE dd_tde_codigo = ''DESDIR_ZONA''), ''D-DIR_ZONA'', '
				|| ' (SELECT MAX(zon_id) FROM '||V_ESQUEMA||'.zon_zonificacion WHERE zon_cod = ''01''), ''' || V_USUARIO_EJECUTA || ''',sysdate)'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Despacho GDespacho Director de zona' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Despacho GDespacho Director de zona ya existe');				
		END IF;    
--Creamos GRUPO
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.usu_usuarios usu WHERE usu.usu_username = ''G-DIR_ZONA''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Creamos Grupo - Director de zona');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.usu_usuarios ( usu_id,entidad_id,usu_username,usu_password,usu_nombre,usu_externo,usu_grupo,usuariocrear,fechacrear) VALUES ('
				|| V_ESQUEMA_M||'.s_usu_usuarios.nextval,1,'
				|| ' ''G-DIR_ZONA'', null,''Grupo - Director de zona'','
				|| ' 1,1,''' || V_USUARIO_EJECUTA || ''',sysdate)'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Grupo - Director de zona Creado' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Grupo - Director de zona ya existe');				
		END IF;   		


--Relacionamos DESPACHO y GRUPO
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS usd WHERE '
		  || 'usd.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS grupo WHERE grupo.USU_USERNAME =''G-DIR_ZONA'')'
		  || 'and usd.DES_ID = (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO despa WHERE despa.DES_CODIGO=''D-DIR_ZONA'')'
		;
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Creamos relacion GESTC-MAD con D-GESCON-MAD');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS(USD_ID,USU_ID,DES_ID,USD_GESTOR_DEFECTO,USD_SUPERVISOR,USUARIOCREAR,FECHACREAR) VALUES ('
				|| V_ESQUEMA||'.s_usd_usuarios_despachos.nextval,'
				|| ' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS grupo WHERE grupo.USU_USERNAME =''G-DIR_ZONA''),'
				|| ' (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO despa WHERE despa.DES_CODIGO=''D-DIR_ZONA''),'
				|| ' 1,0,''' || V_USUARIO_EJECUTA || ''',sysdate)'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Relacion Creado G-DIR_ZONA con D-DIR_ZONA' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Relacion G-DIR_ZONA con D-DIR_ZONA ya existe');				
		END IF;
	
	
--Creamos usuario		
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.usu_usuarios usu WHERE usu.usu_username = ''val.dirzona''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Creamos usuario val.dirzona');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.USU_USUARIOS ( USU_ID, ENTIDAD_ID, USU_USERNAME, USU_PASSWORD,USU_NOMBRE, USUARIOCREAR, FECHACREAR,	USU_EXTERNO, USU_GRUPO, USU_FECHA_VIGENCIA_PASS ) VALUES ('
				|| V_ESQUEMA_M||'.S_USU_USUARIOS.NEXTVAL,(SELECT ENT.ID FROM '||V_ESQUEMA_M||'.ENTIDAD ENT WHERE ENT.DESCRIPCION = ''CAJAMAR'') ,'
				|| '''val.dirzona'',''Cajamar1201'',''Director de zona'',''' || V_USUARIO_EJECUTA || ''',sysdate,0,0, sysdate +365)'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Creado val.dirzona' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('val.dirzona ya existe');				
		END IF;		

--Zonificamos al usuario		
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.usu_usuarios usu WHERE usu.usu_username = ''val.dirzona''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS >= 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Zonificamos al usuario val.dirzona');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU ZPU (ZPU.ZPU_ID,ZPU.ZON_ID,ZPU.USU_ID,ZPU.PEF_ID,ZPU.USUARIOCREAR,ZPU.FECHACREAR) VALUES ('
				|| V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL,(SELECT ZON.ZON_ID FROM '|| V_ESQUEMA|| '.ZON_ZONIFICACION ZON WHERE ZON.ZON_NUM_CENTRO = 00000000011 ),'
				|| '(SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = ''val.dirzona'' ),'
				|| '(SELECT PEF.PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES PEF WHERE PEF.PEF_CODIGO = '''||V_COD_PERFIL || ''') ,'
				|| '''' || V_USUARIO_EJECUTA || ''',SYSDATE)'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Zonificamos al usuario val.dirzona' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('val.dirzona no existe');				
		END IF;						
	
--Relacion usuario despacho
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.usu_usuarios usu WHERE usu.usu_username = ''val.dirzona''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS >= 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Relacion usuario despacho');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS(USD_ID,USU_ID,DES_ID,USD_GESTOR_DEFECTO,USD_SUPERVISOR,USUARIOCREAR,FECHACREAR) VALUES ('
				|| V_ESQUEMA||'.s_usd_usuarios_despachos.nextval,(SELECT USU_ID FROM '|| V_ESQUEMA_M|| '.USU_USUARIOS grupo WHERE grupo.USU_USERNAME =''val.dirzona'' ),'
				|| '(SELECT DES_ID FROM  '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO despa WHERE despa.DES_CODIGO=''D-DIR_ZONA''),'
				|| '1,0,''' || V_USUARIO_EJECUTA || ''',SYSDATE)'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Relacion usuario despacho' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('val.dirzona no existe');				
		END IF;	

--Relacionamos usuario con grupo.
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.usu_usuarios usu WHERE usu.usu_username = ''val.dirzona''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS >= 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Relacionamos usuario con grupo.');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS gru ( gru.GRU_ID, gru.USU_ID_USUARIO, gru.USU_ID_GRUPO, gru.USUARIOCREAR, gru.FECHACREAR ) VALUES ('
				|| V_ESQUEMA_M||'.s_GRU_GRUPOS_USUARIOS.nextval, (SELECT usu.usu_id FROM '||V_ESQUEMA_M||'.usu_usuarios usu WHERE usu.usu_username = ''val.dirzona''),'
				|| '(SELECT usugrupo.usu_id FROM  '||V_ESQUEMA||'.usd_usuarios_despachos usdgrupo  INNER JOIN CMmaster.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id '
				|| ' AND usugrupo.usu_grupo = 1  WHERE usugrupo.usu_username =''G-DIR_ZONA'' AND usugrupo.borrado = 0) ,'
				|| '''' || V_USUARIO_EJECUTA || ''',SYSDATE)'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Relacionamos usuario con grupo.' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('val.dirzona no existe');				
		END IF;		

	ELSE 
		DBMS_OUTPUT.PUT_LINE('El  Procedimiento ' || V_USUARIO_EJECUTA || ' ya se ejecuto, NO se ejecutara de nuevo otra vez.');				
	END IF;	 

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN PROCEDIMIENTO]********' || V_USUARIO_EJECUTA || '********'); 
	EXCEPTION
	WHEN OTHERS THEN
	ERR_NUM := SQLCODE;
	ERR_MSG := SQLERRM;
	DBMS_OUTPUT.put_line('[ERROR PROCEDIMIENTO]-----------' || V_USUARIO_EJECUTA || '-----------');
	DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
	DBMS_OUTPUT.put_line('[FIN PROCEDIMIENTO]-------------' || V_USUARIO_EJECUTA || '-----------'); 
	DBMS_OUTPUT.put_line(ERR_MSG);
	ROLLBACK;
	RAISE;   
	END;
	/

	EXIT;
