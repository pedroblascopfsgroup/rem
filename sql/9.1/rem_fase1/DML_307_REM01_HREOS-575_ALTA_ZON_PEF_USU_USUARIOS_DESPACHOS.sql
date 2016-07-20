	--/*
	--###########################################
	--## AUTOR=Pablo Meseguer
	--## FECHA_CREACION=20160623
	--## ARTEFACTO=batch
	--## VERSION_ARTEFACTO=0.1
	--## INCIDENCIA_LINK=HREOS-575
	--## PRODUCTO=NO
	--## 
	--## Finalidad: Adición de perfil y despacho para un usuario
	--##			
	--## INSTRUCCIONES:  
	--## VERSIONES:
	--##        0.1 Versión inicial
	--###########################################
	----*/


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

		DBMS_OUTPUT.PUT_LINE('[INICIO] ');

		-------------------------------------------------
		--Comprobamos el dato a insertar en zon_pef_usu--
		-------------------------------------------------
			
		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ZON_PEF_USU '); 
				
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ZON_PEF_USU 
					WHERE USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''lfabe'')';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
				
		-- Si existe se inserta el nuevo perfil
		IF V_NUM_TABLAS > 0 THEN	  
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL NUEVO PERFIL PARA lfabe EN ZON_PEF_USU');
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU' ||
						' (ZPU_ID, ZON_ID, PEF_ID, USU_ID, USUARIOCREAR, FECHACREAR, BORRADO)' || 
						' SELECT '||V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL,' ||
						' (SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''REM''),' ||
						' (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYASUPACT''),' ||
						' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''lfabe''),' ||
						' ''HREOS-575'',
						SYSDATE,
						0 
						FROM DUAL';
				
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO DE NUEVO PERFIL PARA lfabe INSERTADO CORRECTAMENTE EN ZON_PEF_USU');
						
		ELSE
			
			DBMS_OUTPUT.PUT_LINE('[INFO] EL USUARIO NO EXISTE Y NO SE PUEDE CREAR EL NUEVO PERFIL.');
							
		END IF;
			
		------------------------------------------------------------
		--Comprobamos el dato a insertar en usd_usuarios_despachos--
		------------------------------------------------------------
		   
		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN USD_USUARIOS_DESPACHOS ');
       
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS 
			WHERE USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''lfabe'')';
			
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
		-- Si existe se inserta el nuevo despacho
		IF V_NUM_TABLAS > 0 THEN	
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL NUEVO DESPACHO PARA lfabe EN USD_USUARIOS_DESPACHOS');
		
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS' ||
					' (USD_ID, DES_ID, USU_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT '||V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL,' ||
					' (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = ''REMSUPACT''),' ||							
					' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''lfabe''),' ||
					' 1,1,''HREOS-575'',SYSDATE,0 FROM DUAL';
		  	
			EXECUTE IMMEDIATE V_MSQL;
		
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO DE NUEVO DESPACHO PARA lfabe INSERTADO CORRECTAMENTE EN USD_USUARIOS_DESPACHOS');			
			
		ELSE
		
			DBMS_OUTPUT.PUT_LINE('[INFO] EL USUARIO NO EXISTE Y NO SE PUEDE ASOCIAR AL NUEVO DESPACHO.');
			
		END IF;	
		
			
	   COMMIT;
	   
	   DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO ACTUALIZADO CORRECTAMENTE ');
	 

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
