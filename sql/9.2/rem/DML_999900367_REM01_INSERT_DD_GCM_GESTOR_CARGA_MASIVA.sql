--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20181108
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2318
--## PRODUCTO=NO
--##
--## Finalidad: Añadir GFORM a Otras Carteras
--## INSTRUCCIONES:
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
    
    V_CARTERA VARCHAR2(50 CHAR);
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	-- LOOP para insertar los valores en DD_GCM_GESTOR_CARGA_MASIVA-----------------------------------------------------------------
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_GCM_GESTOR_CARGA_MASIVA PARA EL GESTOR ''GFORM''');
		
		--Comprobamos el dato a insertar para registros del tipo de gestor y la cartera
		V_SQL := 'SELECT COUNT(1)
					FROM '||V_ESQUEMA||'.DD_GCM_GESTOR_CARGA_MASIVA GCM
					INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = GCM.DD_GCM_CODIGO
					INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = GCM.DD_CRA_ID
					WHERE TGE.DD_TGE_CODIGO = ''GFORM''
					AND CRA.DD_CRA_DESCRIPCION = ''Otras carteras''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		--Si NO existe lo insertamos
		IF V_NUM_TABLAS = 0 THEN
		
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_GCM_GESTOR_CARGA_MASIVA(DD_GCM_ID,DD_GCM_CODIGO,DD_GCM_DESCRIPCION,DD_GCM_DESCRIPCION_LARGA,DD_CRA_ID,DD_GCM_ACTIVO,DD_GCM_EXPEDIENTE,DD_GCM_AGRUPACION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)
			VALUES (
				'||V_ESQUEMA||'.S_DD_GCM_GESTOR_CARGA_MASIVA.NEXTVAL,
				''GFORM'',
				(SELECT DD_TGE_DESCRIPCION FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = ''GFORM''),
				(SELECT DD_TGE_DESCRIPCION_LARGA FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = ''GFORM''),
				(SELECT CRA.DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_DESCRIPCION = ''Otras carteras''),
				0,
				1,
				0,
				0,
				''REMVIP-2318'',
				SYSDATE,
				0)	
				';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO REGISTRO PARA EL GESTOR ''GFORM'' Y LA CARTERA ''OTRAS CARTERAS''');
			
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE REGISTRO PARA EL GESTOR ''GFORM'' Y LA CARTERA ''Otras carteras'''); 
	END IF;	
   
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('[FIN]: PARTIDAS PRESUPUESTARIAS ACTUALIZADAS CORRECTAMENTE.');   
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
