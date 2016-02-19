--/*
--##########################################
--## AUTOR=Joaquín Sánchez Valverde
--## FECHA_CREACION=20160211
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=CAJAMAR-0001
--## PRODUCTO=NO
--## Finalidad: DML ......
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
  	V_USUARIO_EJECUTA VARCHAR2(25 CHAR):= 'CAJAMAR-0001'; -- Usuario que EJECUTA el paquete.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
		
    V_TAREA VARCHAR2(1024 CHAR); -- Vble. descripcion de lo que hace el proceso
    
BEGIN

	V_TAREA :='Cambiamos nombre a despacho existente';

	DBMS_OUTPUT.PUT_LINE('[INICIO-PROCEDIMIENTO] -----------' || V_USUARIO_EJECUTA || '---------- - PROCEDIMIENTO');  

	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO DES WHERE des.USUARIOMODIFICAR = ''' || V_USUARIO_EJECUTA || ''' ';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS < 1 THEN

		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.DES_CODIGO = ''D-GESCON''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Modificamos los existente (cambio Nombre) Despacho Gestor concursal Servicios Centrales');  

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des SET des.DES_DESPACHO = ''Despacho Gestor concursal Servicios Centrales'','
			|| ' des.USUARIOMODIFICAR = ''' || V_USUARIO_EJECUTA || ''',des.FECHAMODIFICAR  = sysdate WHERE DES_CODIGO = ''D-GESCON'' '
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Despacho Despacho Gestor concursal Servicios Centrales modificado' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Despacho Despacho Gestor concursal Servicios Centrales no existe');				
		END IF;

		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.DES_CODIGO = ''D-SUCON''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Modificamos los existente (cambio Nombre) Despacho Supervisor concursal Servicios Centrales');  

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des SET des.DES_DESPACHO = ''Despacho Supervisor concursal Servicios Centrales'','
			|| ' des.USUARIOMODIFICAR = ''' || V_USUARIO_EJECUTA || ''',des.FECHAMODIFICAR  = sysdate WHERE DES_CODIGO = ''D-SUCON'' '
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Despacho Despacho Supervisor concursal Servicios Centrales modificado' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Despacho Despacho Supervisor concursal Servicios Centrales no existe');				
		END IF;


		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.DES_CODIGO = ''GESTC''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Modificamos los existente (cambio Nombre) Grupo - Gestor concursal Servicios Centrales');  

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des SET des.DES_DESPACHO = ''Grupo - Gestor concursal Servicios Centrales'','
			|| ' des.USUARIOMODIFICAR = ''' || V_USUARIO_EJECUTA || ''',des.FECHAMODIFICAR  = sysdate WHERE DES_CODIGO = ''GESTC'' '
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Despacho Grupo - Gestor concursal Servicios Centrales modificado' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Despacho Grupo - Gestor concursal Servicios Centrales no existe');				
		END IF;

		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.DES_CODIGO = ''SUPCO''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Modificamos los existente (cambio Nombre) Grupo - Supervisor concursal Servicios Centrales');  

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des SET des.DES_DESPACHO = ''Grupo - Supervisor concursal Servicios Centrales'','
			|| ' des.USUARIOMODIFICAR = ''' || V_USUARIO_EJECUTA || ''',des.FECHAMODIFICAR  = sysdate WHERE DES_CODIGO = ''SUPCO'' '
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Despacho Grupo - Supervisor concursal Servicios Centrales modificado' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Despacho Grupo - Supervisor concursal Servicios Centrales no existe');				
		END IF;    

--Creamos DESPACHO
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.DES_CODIGO = ''D-GESCON-MAD''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Creamos despacho Despacho Gestor concursal Madrid');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.des_despacho_externo des(des_id,des_despacho,dd_tde_id,DES_CODIGO,zon_id,usuariocrear,fechacrear ) VALUES ('
				|| V_ESQUEMA||'.s_des_despacho_externo.nextval,''Despacho Gestor concursal Madrid'', '
				|| ' (SELECT dd_tde_id FROM '||V_ESQUEMA_M||'.dd_tde_tipo_despacho WHERE dd_tde_codigo = ''D-GESCON''), ''D-GESCON-MAD'', '
				|| ' (SELECT MAX(zon_id) FROM '||V_ESQUEMA||'.zon_zonificacion WHERE zon_cod = ''01''), ''' || V_USUARIO_EJECUTA || ''',sysdate)'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Despacho Gestor concursal Madrid Creado' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Despacho Gestor concursal Madrid ya existe');				
		END IF;    


		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.DES_CODIGO = ''D-GESCON-CAN''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Creamos Despacho Gestor concursal Canarias');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.des_despacho_externo des(des_id,des_despacho,dd_tde_id,DES_CODIGO,zon_id,usuariocrear,fechacrear ) VALUES ('
				|| V_ESQUEMA||'.s_des_despacho_externo.nextval,''Despacho Gestor concursal Canarias'', '
				|| ' (SELECT dd_tde_id FROM '||V_ESQUEMA_M||'.dd_tde_tipo_despacho WHERE dd_tde_codigo = ''D-GESCON''), ''D-GESCON-CAN'', '
				|| ' (SELECT MAX(zon_id) FROM '||V_ESQUEMA||'.zon_zonificacion WHERE zon_cod = ''01''), ''' || V_USUARIO_EJECUTA || ''',sysdate)'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Despacho Gestor concursal Canarias Creado' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Despacho Gestor concursal Canarias ya existe');				
		END IF;  


		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.DES_CODIGO = ''D-SUCON-MAD''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Creamos Despacho Supervisor concursal Madrid');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.des_despacho_externo des(des_id,des_despacho,dd_tde_id,DES_CODIGO,zon_id,usuariocrear,fechacrear ) VALUES ('
				|| V_ESQUEMA||'.s_des_despacho_externo.nextval,''Despacho Supervisor concursal Madrid'', '
				|| ' (SELECT dd_tde_id FROM '||V_ESQUEMA_M||'.dd_tde_tipo_despacho WHERE dd_tde_codigo = ''D-SUCON''), ''D-SUCON-MAD'', '
				|| ' (SELECT MAX(zon_id) FROM '||V_ESQUEMA||'.zon_zonificacion WHERE zon_cod = ''01''), ''' || V_USUARIO_EJECUTA || ''',sysdate)'
			;	
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Despacho Supervisor concursal Madrid Creado' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Despacho Supervisor concursal Madrid ya existe');				
		END IF;    


		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.DES_CODIGO = ''D-SUCON-CAN''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Creamos Despacho Supervisor concursal Canarias');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.des_despacho_externo des (des_id,des_despacho,dd_tde_id,DES_CODIGO,zon_id,usuariocrear,fechacrear ) VALUES ('
				|| V_ESQUEMA||'.s_des_despacho_externo.nextval,''Despacho Supervisor concursal Canarias'', '
				|| ' (SELECT dd_tde_id FROM '||V_ESQUEMA_M||'.dd_tde_tipo_despacho WHERE dd_tde_codigo = ''D-SUCON''), ''D-SUCON-CAN'', '
				|| ' (SELECT MAX(zon_id) FROM '||V_ESQUEMA||'.zon_zonificacion WHERE zon_cod = ''01''), ''' || V_USUARIO_EJECUTA || ''',sysdate)'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Despacho Supervisor concursal Canarias Creado' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Despacho Supervisor concursal Canarias ya existe');				
		END IF;    

--Creamos GRUPO
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.usu_usuarios usu WHERE usu.usu_username = ''GESTC-MAD''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Creamos Grupo - Gestor concursal Madrid');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.usu_usuarios ( usu_id,entidad_id,usu_username,usu_password,usu_nombre,usu_externo,usu_grupo,usuariocrear,fechacrear) VALUES ('
				|| V_ESQUEMA_M||'.s_usu_usuarios.nextval,1,'
				|| ' ''GESTC-MAD'', null,''Grupo - Gestor concursal Madrid'','
				|| ' 1,1,''' || V_USUARIO_EJECUTA || ''',sysdate)'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Grupo - Gestor concursal Madrid Creado' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Grupo - Gestor concursal Madrid ya existe');				
		END IF;   
    
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.usu_usuarios usu WHERE usu.usu_username = ''GESTC-CAN''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Creamos Grupo - Gestor concursal Canarias');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.usu_usuarios ( usu_id,entidad_id,usu_username,usu_password,usu_nombre,usu_externo,usu_grupo,usuariocrear,fechacrear) VALUES ('
				|| V_ESQUEMA_M||'.s_usu_usuarios.nextval,1,'
				|| ' ''GESTC-CAN'', null,''Grupo - Gestor concursal Canarias'','
				|| ' 1,1,''' || V_USUARIO_EJECUTA || ''',sysdate)'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Grupo - Gestor concursal Canarias Creado' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Grupo - Gestor concursal Canarias ya existe');				
		END IF;  
  
  
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.usu_usuarios usu WHERE usu.usu_username = ''SUPCO-MAD''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Creamos Grupo - Supervisor concursal Madrid');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.usu_usuarios ( usu_id,entidad_id,usu_username,usu_password,usu_nombre,usu_externo,usu_grupo,usuariocrear,fechacrear) VALUES ('
				|| V_ESQUEMA_M||'.s_usu_usuarios.nextval,1,'
				|| ' ''SUPCO-MAD'', null,''Grupo - Supervisor concursal Madrid'','
				|| ' 1,1,''' || V_USUARIO_EJECUTA || ''',sysdate)'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Grupo - Supervisor concursal Madrid Creado' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Grupo - Supervisor concursal Madrid ya existe');				
		END IF;      
    
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.usu_usuarios usu WHERE usu.usu_username = ''SUPCO-CAN''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Creamos Grupo - Supervisor concursal Canarias');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.usu_usuarios ( usu_id,entidad_id,usu_username,usu_password,usu_nombre,usu_externo,usu_grupo,usuariocrear,fechacrear) VALUES ('
				|| V_ESQUEMA_M||'.s_usu_usuarios.nextval,1,'
				|| ' ''SUPCO-CAN'', null,''Grupo - Supervisor concursal Canarias'','
				|| ' 1,1,''' || V_USUARIO_EJECUTA || ''',sysdate)'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Grupo - Supervisor concursal Canarias Creado' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Grupo - Supervisor concursal Canarias ya existe');				
		END IF;

--Relacionamos DESPACHO y GRUPO
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS usd WHERE '
		  || 'usd.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS grupo WHERE grupo.USU_USERNAME =''GESTC-MAD'')'
		  || 'and usd.DES_ID = (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO despa WHERE despa.DES_CODIGO=''D-GESCON-MAD'')'
		;
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Creamos relacion GESTC-MAD con D-GESCON-MAD');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS(USD_ID,USU_ID,DES_ID,USD_GESTOR_DEFECTO,USD_SUPERVISOR,USUARIOCREAR,FECHACREAR) VALUES ('
				|| V_ESQUEMA ||'.s_usd_usuarios_despachos.nextval,'
				|| ' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS grupo WHERE grupo.USU_USERNAME =''GESTC-MAD''),'
				|| ' (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO despa WHERE despa.DES_CODIGO=''D-GESCON-MAD''),'
				|| ' 1,0,''' || V_USUARIO_EJECUTA || ''',sysdate)'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Relacion Creado GESTC-MAD con D-GESCON-MAD' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Relacion GESTC-MAD con D-GESCON-MAD ya existe');				
		END IF;

		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS usd WHERE '
			|| 'usd.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS grupo WHERE grupo.USU_USERNAME =''GESTC-CAN'')'
			|| 'and usd.DES_ID = (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO despa WHERE despa.DES_CODIGO=''D-GESCON-CAN'')'
		;
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Creamos relacion GESTC-CAN con D-GESCON-CAN');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS(USD_ID,USU_ID,DES_ID,USD_GESTOR_DEFECTO,USD_SUPERVISOR,USUARIOCREAR,FECHACREAR) VALUES ('
				|| V_ESQUEMA ||'.s_usd_usuarios_despachos.nextval,'
				|| ' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS grupo WHERE grupo.USU_USERNAME =''GESTC-CAN''),'
				|| ' (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO despa WHERE despa.DES_CODIGO=''D-GESCON-CAN''),'
				|| ' 1,0,''' || V_USUARIO_EJECUTA || ''',sysdate)'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Relacion Creado GESTC-CAN con D-GESCON-CAN' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Relacion GESTC-CAN con D-GESCON-CAN ya existe');				
		END IF;


		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS usd WHERE '
			|| 'usd.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS grupo WHERE grupo.USU_USERNAME =''SUPCO-MAD'')'
			|| 'and usd.DES_ID = (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO despa WHERE despa.DES_CODIGO=''D-SUCON-MAD'')'
		;
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Creamos relacion SUPCO-MAD con D-SUCON-MAD');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS(USD_ID,USU_ID,DES_ID,USD_GESTOR_DEFECTO,USD_SUPERVISOR,USUARIOCREAR,FECHACREAR) VALUES ('
				|| V_ESQUEMA ||'.s_usd_usuarios_despachos.nextval,'
				|| ' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS grupo WHERE grupo.USU_USERNAME =''SUPCO-MAD''),'
				|| ' (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO despa WHERE despa.DES_CODIGO=''D-SUCON-MAD''),'
				|| ' 1,0,''' || V_USUARIO_EJECUTA || ''',sysdate)'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Relacion Creado SUPCO-MAD con D-SUCON-MAD' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Relacion SUPCO-MAD con D-SUCON-MAD ya existe');				
		END IF;   

		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS usd WHERE '
		  || 'usd.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS grupo WHERE grupo.USU_USERNAME =''SUPCO-CAN'')'
		  || 'and usd.DES_ID = (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO despa WHERE despa.DES_CODIGO=''D-SUCON-CAN'')'
		;
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('--Creamos relacion SUPCO-CAN con D-SUCON-CAN');  
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS(USD_ID,USU_ID,DES_ID,USD_GESTOR_DEFECTO,USD_SUPERVISOR,USUARIOCREAR,FECHACREAR) VALUES ('
				|| V_ESQUEMA ||'.s_usd_usuarios_despachos.nextval,'
				|| ' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS grupo WHERE grupo.USU_USERNAME =''SUPCO-CAN''),'
				|| ' (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO despa WHERE despa.DES_CODIGO=''D-SUCON-CAN''),'
				|| ' 1,0,''' || V_USUARIO_EJECUTA || ''',sysdate)'
			;
			DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Relacion Creado SUPCO-CAN con D-SUCON-CAN' );
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Relacion SUPCO-CAN con D-SUCON-CAN ya existe');				
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
