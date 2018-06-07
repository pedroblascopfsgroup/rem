--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20171127
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3199
--## PRODUCTO=NO
--##
--## Finalidad: Rellenar partidas presupuestarias de ejercicios anteriores
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
    
    CURSOR CARTERA
	IS
	SELECT DD_CRA_DESCRIPCION FROM #ESQUEMA#.DD_CRA_CARTERA
	WHERE DD_CRA_CODIGO NOT IN ('04', '05');
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
				--   GESTOR	ACT EXP AGR CARTERA
		T_TIPO_DATA('GTREE',1,0,0,'Todas'),
		T_TIPO_DATA('PTEC',1,0,0,'Todas'),
		T_TIPO_DATA('SBOINM',1,0,0,'Cajamar'),
		T_TIPO_DATA('SBOFIN',1,0,0,'Cajamar'),
		T_TIPO_DATA('GCBOFIN',1,0,0,'Cajamar'),
		T_TIPO_DATA('SRES',0,1,0,'Cajamar'),
		T_TIPO_DATA('GRES',0,1,0,'Cajamar'),
		T_TIPO_DATA('SMIN',0,1,0,'Cajamar'),
		T_TIPO_DATA('GMIN',0,1,0,'Cajamar'),
		T_TIPO_DATA('GCBOINM',1,0,1,'Cajamar'),
		T_TIPO_DATA('HAYAGBOINM',1,0,1,'Cajamar'),
		T_TIPO_DATA('HAYASBOINM',1,0,1,'Cajamar'),
		T_TIPO_DATA('HAYAGBOFIN',1,0,1,'Cajamar'),
		T_TIPO_DATA('HAYASBOFIN',1,0,1,'Cajamar'),
		T_TIPO_DATA('GESRES',0,1,0,'Cajamar'),
		T_TIPO_DATA('SUPRES',0,1,0,'Cajamar'),
		T_TIPO_DATA('GESMIN',0,1,0,'Cajamar'),
		T_TIPO_DATA('SUPMIN',0,1,0,'Cajamar'),
		T_TIPO_DATA('SUPFVD',1,0,0,'Todas'),
		T_TIPO_DATA('GESTREC',1,0,0,'Todas'),
		T_TIPO_DATA('FVDBACKOFR',1,0,0,'Todas'),
		T_TIPO_DATA('FVDBACKVNT',1,0,0,'Todas'),
		T_TIPO_DATA('FVDNEG',1,0,0,'Todas'),
		T_TIPO_DATA('SADM',1,0,0,'Todas'),
		T_TIPO_DATA('GCAL',1,0,0,'Todas'),
		T_TIPO_DATA('SLLA',1,0,0,'Todas'),
		T_TIPO_DATA('GTOADM',1,0,0,'Todas'),
		T_TIPO_DATA('GTOCED',1,0,0,'Todas'),
		T_TIPO_DATA('GTOPLUS',1,0,0,'Todas'),
		T_TIPO_DATA('GTOPDV',1,0,0,'Todas'),
		T_TIPO_DATA('GLLA',1,0,0,'Todas'),
		T_TIPO_DATA('GFSV',1,0,0,'Todas'),
		T_TIPO_DATA('GADMT',1,0,0,'Todas'),
		T_TIPO_DATA('GIAADMT',1,0,0,'Todas'),
		T_TIPO_DATA('GCCBANKIA',1,0,0,'Bankia'),
		T_TIPO_DATA('GCOMSIN',1,0,0,'Todas'),
		T_TIPO_DATA('SFORM',0,1,0,'Todas'),
		T_TIPO_DATA('SCOM',1,0,1,'Todas'),
		T_TIPO_DATA('GFORM',0,1,0,'Todas'),
		T_TIPO_DATA('GIAFORM',0,1,0,'Todas'),
		T_TIPO_DATA('SPUBL',1,0,0,'Todas'),
		T_TIPO_DATA('SPREC',1,0,0,'Todas'),
		T_TIPO_DATA('SMARK',1,0,0,'Todas'),
		T_TIPO_DATA('GCOM',1,0,1,'Todas'),
		T_TIPO_DATA('GPUBL',1,0,0,'Todas'),
		T_TIPO_DATA('GPREC',1,0,0,'Todas'),
		T_TIPO_DATA('GMARK',1,0,0,'Todas'),
		T_TIPO_DATA('GGADM',1,0,0,'Todas'),
		T_TIPO_DATA('SUPACT',1,0,0,'Todas'),
		T_TIPO_DATA('SUPADM',1,0,0,'Todas'),
		T_TIPO_DATA('CERT',1,0,0,'Todas'),
		T_TIPO_DATA('TECN',1,0,0,'Todas'),
		T_TIPO_DATA('GADM',1,0,0,'Todas'),
		T_TIPO_DATA('GACT',1,0,0,'Todas')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	--Actualizamos las carteras a nulo con la cartera de Bankia
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_GCM_GESTOR_CARGA_MASIVA GCM
				SET
				  GCM.DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''03''),
				  GCM.USUARIOMODIFICAR = ''REMVIP-857'',
				  GCM.FECHAMODIFICAR = SYSDATE
				WHERE GCM.DD_CRA_ID IS NULL
				';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO REGISTROS ACTUALIZADOS '||SQL%ROWCOUNT||'');

	-- LOOP para insertar los valores en DD_GCM_GESTOR_CARGA_MASIVA-----------------------------------------------------------------
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
      
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_GCM_GESTOR_CARGA_MASIVA PARA EL GESTOR '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
	
		--Si es para todas las carteras
		IF TRIM(V_TMP_TIPO_DATA(5)) = 'Todas' THEN
		
			OPEN CARTERA;
			FETCH CARTERA into V_CARTERA;
			WHILE (CARTERA%FOUND) LOOP
			
				--Comprobamos el dato a insertar para registros del tipo de gestor y la cartera
				V_SQL := 'SELECT COUNT(1)
							FROM '||V_ESQUEMA||'.DD_GCM_GESTOR_CARGA_MASIVA GCM
							INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = GCM.DD_GCM_CODIGO
							INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = GCM.DD_CRA_ID
							WHERE TGE.DD_TGE_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
							AND CRA.DD_CRA_DESCRIPCION = '''||V_CARTERA||'''';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

				--Si NO existe lo insertamos
				IF V_NUM_TABLAS = 0 THEN
				
					V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_GCM_GESTOR_CARGA_MASIVA(DD_GCM_ID,DD_GCM_CODIGO,DD_GCM_DESCRIPCION,DD_GCM_DESCRIPCION_LARGA,DD_CRA_ID,DD_GCM_ACTIVO,DD_GCM_EXPEDIENTE,DD_GCM_AGRUPACION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)
					VALUES (
						'||V_ESQUEMA||'.S_DD_GCM_GESTOR_CARGA_MASIVA.NEXTVAL,
						'''|| TRIM(V_TMP_TIPO_DATA(1)) ||''',
						(SELECT DD_TGE_DESCRIPCION FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''),
						(SELECT DD_TGE_DESCRIPCION_LARGA FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''),
						(SELECT CRA.DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_DESCRIPCION = '''||V_CARTERA||'''),
						'''|| TRIM(V_TMP_TIPO_DATA(2)) ||''',
						'''|| TRIM(V_TMP_TIPO_DATA(3)) ||''',
						'''|| TRIM(V_TMP_TIPO_DATA(4)) ||''',
						0,
						''REMVIP-857'',
						SYSDATE,
						0)	
						';
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO REGISTRO PARA EL GESTOR '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y LA CARTERA '''||V_CARTERA||'''');
					
				ELSE
					DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE REGISTRO PARA EL GESTOR '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y LA CARTERA '''||V_CARTERA||''''); 
				END IF;
		
			FETCH CARTERA INTO V_CARTERA;
      
			END LOOP;	
			CLOSE CARTERA;
		
		--Si es solo para una cartera concreta
		ELSE
		
			--Comprobamos el dato a insertar para registros del tipo de gestor y la cartera
			V_SQL := 'SELECT COUNT(1)
						FROM '||V_ESQUEMA||'.DD_GCM_GESTOR_CARGA_MASIVA GCM
						INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = GCM.DD_GCM_CODIGO
						INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = GCM.DD_CRA_ID
						WHERE TGE.DD_TGE_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
						AND CRA.DD_CRA_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			--Si NO existe lo insertamos
			IF V_NUM_TABLAS = 0 THEN
			
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_GCM_GESTOR_CARGA_MASIVA(DD_GCM_ID,DD_GCM_CODIGO,DD_GCM_DESCRIPCION,DD_GCM_DESCRIPCION_LARGA,DD_CRA_ID,DD_GCM_ACTIVO,DD_GCM_EXPEDIENTE,DD_GCM_AGRUPACION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)
				VALUES (
					'||V_ESQUEMA||'.S_DD_GCM_GESTOR_CARGA_MASIVA.NEXTVAL,
					'''|| TRIM(V_TMP_TIPO_DATA(1)) ||''',
					(SELECT DD_TGE_DESCRIPCION FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''),
					(SELECT DD_TGE_DESCRIPCION_LARGA FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''),
					(SELECT CRA.DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''),
					'''|| TRIM(V_TMP_TIPO_DATA(2)) ||''',
					'''|| TRIM(V_TMP_TIPO_DATA(3)) ||''',
					'''|| TRIM(V_TMP_TIPO_DATA(4)) ||''',
					0,
					''REMVIP-857'',
					SYSDATE,
					0)	
					';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO REGISTRO PARA EL GESTOR '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y LA CARTERA '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
				
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE REGISTRO PARA EL GESTOR '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y LA CARTERA '''|| TRIM(V_TMP_TIPO_DATA(5)) ||''''); 
			END IF;
		END IF;
		
	END LOOP;
    
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
