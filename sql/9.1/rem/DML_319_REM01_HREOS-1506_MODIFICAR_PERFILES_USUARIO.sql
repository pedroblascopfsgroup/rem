--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20172802
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-1506
--## PRODUCTO=NO
--##
--## Finalidad: Actualiza los perfiles del usuario Maria del Carmen Morandeira, 
--## 			DE ADMISIÓN A GESTOR Y SUPERVISOR DE ACTIVOS
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
			
		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION Y MODIFICACION EN ZON_PEF_USU ');

		
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION Y MODIFICACION EN ZON_PEF_USU ');
	
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ZON_PEF_USU WHERE USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''morandeira'') ' ||
			       		' AND ZON_ID = (SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''REM'')' ||
						' AND PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYASUPACT'')';
       	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       
       --Si existe no se modifica
       IF V_NUM_TABLAS > 0 THEN				         
			
	   		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.ZON_PEF_USU...no se modifica nada.');
			
       ELSE
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL NUEVO PERFIL  EN ZON_PEF_USU');
		
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU' ||
					' (ZPU_ID, ZON_ID, PEF_ID, USU_ID, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT '||V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL,' ||
					' (SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''REM''),' ||
					' (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYASUPACT''),' ||
					' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''morandeira''),' ||
					' ''HREOS-1506'',
					SYSDATE,
					0 
					FROM DUAL';
			
			EXECUTE IMMEDIATE V_MSQL;
			
		END IF;
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL PERFIL EXISTENTE EN ZON_PEF_USU');
		
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ZON_PEF_USU ' ||
					'SET PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYAGESACT''),'||
					'USUARIOMODIFICAR = ''HREOS-1506'','||
					'FECHAMODIFICAR = SYSDATE ' ||
					'WHERE USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''morandeira'') '||
					'AND PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYAGESTADM'')';
			
		EXECUTE IMMEDIATE V_MSQL;
		
	DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO DE PERFIL MODIFICADO CORRECTAMENTE EN ZON_PEF_USU');

	---------------------------------------------------------------------------------------------------------------------------------------------------------		
	DBMS_OUTPUT.PUT_LINE('[INFO -------------------------------------------------------]');
	DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICACION EN USD_USUARIOS_DESPACHOS');
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL DESPACHO REMADM POR REMSUPACT EN USD_USUARIOS_DESPACHOS');
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS ' ||
			'SET DES_ID = (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = ''REMSUPACT''),' ||
			'USUARIOMODIFICAR = ''HREOS-1506'', FECHAMODIFICAR = SYSDATE '||
			'WHERE DES_ID = (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = ''REMADM'') ' || 	
			'AND USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''morandeira'')';
  	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE EN USD_USUARIOS_DESPACHOS');

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
	EXIT;
