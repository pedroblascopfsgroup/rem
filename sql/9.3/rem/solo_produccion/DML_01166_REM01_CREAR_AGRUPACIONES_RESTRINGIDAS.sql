--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20220419
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11516
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE


   PL_OUTPUT VARCHAR2(1024 CHAR);
   V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar        
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar       
   V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
   ACT_ID NUMBER(32);
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   DESCRIPCION VARCHAR2(64 CHAR);
   V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
   V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-11516';

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    V_COUNT NUMBER(16);
    V_COUNT2 NUMBER(16);
    V_ACT_ID NUMBER(16);
    V_AGR_ID NUMBER(16);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
T_TIPO_DATA('PROMO 595 - 1','7480084', '7479901', '7479978'),
T_TIPO_DATA('PROMO 595 - 2','7480071', '7480053', '7479903'),
T_TIPO_DATA('PROMO 595 - 3','7480038', '7479862', '7480019'),
T_TIPO_DATA('PROMO 595 - 4','7480011', '7479904', '7479897'),
T_TIPO_DATA('PROMO 595 - 5','7479861', '7480132', '7479863'),
T_TIPO_DATA('PROMO 595 - 6','7480048', '7480063', '7480032'),
T_TIPO_DATA('PROMO 595 - 7','7479943', '7479891', '7480035'),
T_TIPO_DATA('PROMO 595 - 8','7479963', '7480082', '7479977'),
T_TIPO_DATA('PROMO 595 - 9','7479975', '7479987', '7480080'),
T_TIPO_DATA('PROMO 595 - 10','7480072', '7480061', '7479986'),
T_TIPO_DATA('PROMO 595 - 11','7480111', '7480140', '7480014'),
T_TIPO_DATA('PROMO 595 - 12','7480097', '7479906', '7479994'),
T_TIPO_DATA('PROMO 595 - 13','7479981', '7480103', '7480083'),
T_TIPO_DATA('PROMO 595 - 14','7480123', '7480128', '7479950'),
T_TIPO_DATA('PROMO 595 - 15','7480073', '7479990', '7480131'),
T_TIPO_DATA('PROMO 595 - 16','7480001', '', '7480079'),
T_TIPO_DATA('PROMO 595 - 17','7480039', '7480033', '7480044'),
T_TIPO_DATA('PROMO 595 - 18','7479845', '7479919', '7479902'),
T_TIPO_DATA('PROMO 595 - 19','7479983', '7480046', '7480112'),
T_TIPO_DATA('PROMO 595 - 20','7479948', '7480067', '7480120'),
T_TIPO_DATA('PROMO 595 - 21','7479995', '7479879', '7479920'),
T_TIPO_DATA('PROMO 595 - 22','7479934', '7480101', '7480030'),
T_TIPO_DATA('PROMO 595 - 23','7479927', '7480114', '7480116'),
T_TIPO_DATA('PROMO 595 - 24','7479937', '7480066', '7479938'),
T_TIPO_DATA('PROMO 595 - 25','7479921', '7480017', '7480020'),
T_TIPO_DATA('PROMO 595 - 26','7479996', '7480091', '7479946'),
T_TIPO_DATA('PROMO 595 - 27','7479859', '7480127', '7479909'),
T_TIPO_DATA('PROMO 595 - 28','7480008', '7480047', '7480093'),
T_TIPO_DATA('PROMO 595 - 29','7479899', '7480121', '7480130'),
T_TIPO_DATA('PROMO 595 - 30','7479936', '7479923', '7480051'),
T_TIPO_DATA('PROMO 595 - 31','7479883', '7480138', '7479882'),
T_TIPO_DATA('PROMO 595 - 32','7480010', '7480018', '7479954'),
T_TIPO_DATA('PROMO 595 - 33','7479898', '7480005', '7480050'),
T_TIPO_DATA('PROMO 595 - 34','7479952', '7480125', '7480122'),
T_TIPO_DATA('PROMO 595 - 35','7479847', '7480007', '7479985'),
T_TIPO_DATA('PROMO 595 - 36','7479962', '7479856', '7479900'),
T_TIPO_DATA('PROMO 595 - 37','7480089', '7479874', '7480100'),
T_TIPO_DATA('PROMO 595 - 38','7479839', '', '7480041'),
T_TIPO_DATA('PROMO 595 - 39','7479848', '', '7479858'),
T_TIPO_DATA('PROMO 595 - 40','7480040', '7479849', '7480029'),
T_TIPO_DATA('PROMO 595 - 41','7480129', '7480000', '7480022'),
T_TIPO_DATA('PROMO 595 - 42','7479911', '7479959', '7479854'),
T_TIPO_DATA('PROMO 595 - 43','7479926', '7479841', '7479905'),
T_TIPO_DATA('PROMO 595 - 44','7479931', '7479980', '7480043'),
T_TIPO_DATA('PROMO 595 - 45','7479870', '7479944', '7479873'),
T_TIPO_DATA('PROMO 595 - 46','7480113', '7480105', '7479846'),
T_TIPO_DATA('PROMO 595 - 47','7480021', '7480102', '7480104'),
T_TIPO_DATA('PROMO 595 - 48','7479886', '7479973', '7480027'),
T_TIPO_DATA('PROMO 595 - 49','7480006', '7479928', '7480064'),
T_TIPO_DATA('PROMO 595 - 50','7480088', '7479972', '7480002'),
T_TIPO_DATA('PROMO 595 - 51','7479869', '7479892', '7479964'),
T_TIPO_DATA('PROMO 595 - 52','7480117', '7479895', '7479939'),
T_TIPO_DATA('PROMO 595 - 53','7480023', '7479945', '7479878'),
T_TIPO_DATA('PROMO 595 - 54','7479947', '7479917', '7479850'),
T_TIPO_DATA('PROMO 595 - 55','7480096', '7479837', '7480042'),
T_TIPO_DATA('PROMO 595 - 56','7480052', '7480099', '7480086'),
T_TIPO_DATA('PROMO 595 - 57','7480139', '7479871', '7480004'),
T_TIPO_DATA('PROMO 595 - 58','7479857', '7480009', '7479889'),
T_TIPO_DATA('PROMO 595 - 59','7479930', '7479866', '7480081'),
T_TIPO_DATA('PROMO 595 - 60','7479949', '7479974', '7479966'),
T_TIPO_DATA('PROMO 595 - 61','7480028', '7480060', '7480058'),
T_TIPO_DATA('PROMO 595 - 62','7479865', '7479893', '7479884'),
T_TIPO_DATA('PROMO 595 - 63','7479896', '7479907', '7479932'),
T_TIPO_DATA('PROMO 595 - 64','7480074', '7480118', '7479984'),
T_TIPO_DATA('PROMO 595 - 65','7479942', '7479860', '7479929'),
T_TIPO_DATA('PROMO 595 - 66','7480034', '7480092', '7479914'),
T_TIPO_DATA('PROMO 595 - 67','7480049', '', '7480003'),
T_TIPO_DATA('PROMO 595 - 68','7480115', '', '7479840'),
T_TIPO_DATA('PROMO 595 - 69','7479957', '', '7480054'),
T_TIPO_DATA('PROMO 595 - 70','7480107', '', '7480077'),
T_TIPO_DATA('PROMO 595 - 71','7479988', '', '7480036'),
T_TIPO_DATA('PROMO 595 - 72','7480126', '', '7480026'),
T_TIPO_DATA('PROMO 595 - 73','7479958', '7479877', '7480024'),
T_TIPO_DATA('PROMO 595 - 74','7479953', '7479935', '7479969'),
T_TIPO_DATA('PROMO 595 - 75','7480108', '', '7479989'),
T_TIPO_DATA('PROMO 595 - 76','7479991', '', '7479851'),
T_TIPO_DATA('PROMO 595 - 77','7479979', '', '7479922'),
T_TIPO_DATA('PROMO 595 - 78','7480015', '7480013', '7479864'),
T_TIPO_DATA('PROMO 595 - 79','7480078', '7479908', '7480076'),
T_TIPO_DATA('PROMO 595 - 80','7479933', '7479965', '7480062'),
T_TIPO_DATA('PROMO 595 - 81','7480055', '', '7479951'),
T_TIPO_DATA('PROMO 595 - 82','7479876', '', '7479887'),
T_TIPO_DATA('PROMO 595 - 83','7480012', '7479968', '7480069'),
T_TIPO_DATA('PROMO 595 - 84','7480075', '7480109', '7479842'),
T_TIPO_DATA('PROMO 595 - 85','7479913', '7480135', '7479998'),
T_TIPO_DATA('PROMO 595 - 86','7479912', '', '7479956'),
T_TIPO_DATA('PROMO 595 - 87','7480098', '', '7480133'),
T_TIPO_DATA('PROMO 595 - 88','7479924', '', '7480056'),
T_TIPO_DATA('PROMO 595 - 89','7479888', '', '7479855'),
T_TIPO_DATA('PROMO 595 - 90','7479852', '', '7480065'),
T_TIPO_DATA('PROMO 595 - 91','7479880', '7480094', '7479997'),
T_TIPO_DATA('PROMO 595 - 92','7480087', '7480137', '7479838'),
T_TIPO_DATA('PROMO 595 - 93','7480124', '7479982', '7479915'),
T_TIPO_DATA('PROMO 595 - 94','7480106', '', '7479976'),
T_TIPO_DATA('PROMO 595 - 95','7480025', '', '7479925'),
T_TIPO_DATA('PROMO 595 - 96','7480119', '', '7479967'),
T_TIPO_DATA('PROMO 595 - 97','7479960', '', '7479940'),
T_TIPO_DATA('PROMO 595 - 98','7479961', '7479970', '7479867'),
T_TIPO_DATA('PROMO 595 - 99','7480134', '7480068', '7479844'),
T_TIPO_DATA('PROMO 595 - 100','7480136', '7480059', '7479941'),
T_TIPO_DATA('PROMO 595 - 101','7479868', '', '7479955'),
T_TIPO_DATA('PROMO 595 - 102','7479875', '', '7480095'),
T_TIPO_DATA('PROMO 595 - 103','7479890', '', '7480110'),
T_TIPO_DATA('PROMO 595 - 104','7480090', '', '7479894'),
T_TIPO_DATA('PROMO 595 - 105','7479910', '7479993', '7479885'),
T_TIPO_DATA('PROMO 595 - 106','7480057', '7479999', '7479971'),
T_TIPO_DATA('PROMO 595 - 107','7479916', '7479992', '7479918'),
T_TIPO_DATA('PROMO 595 - 108','7480031', '', '7480085'),
T_TIPO_DATA('PROMO 595 - 109','7480016', '', '7480045')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: COMIENZA EL PROCESO');
		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
      
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
				
				DBMS_OUTPUT.PUT_LINE('[INFO]: CREAMOS AGRUPACION '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
				
				V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE agr_nombre = '''||V_TMP_TIPO_DATA(1)||'''';
                               DBMS_OUTPUT.PUT_LINE(V_MSQL);

			       EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
			       
			        IF V_COUNT < 1  THEN
				
				--Comprobamos si el activo y la agrupacion existen
				V_SQL := 'INSERT INTO rem01.act_agr_agrupacion (
					    agr_id,
					    dd_tag_id,
					    agr_nombre,
					    agr_num_agrup_rem,
					    agr_fecha_alta,
					    agr_eliminado,
					    agr_publicado,
					    agr_seg_visitas,
					    version,
					    usuariocrear,
					    fechacrear,
					    borrado,
					    agr_comercializable_cons_plano,
					    agr_existe_piso_piloto,
					    agr_visitable
					) VALUES (
					    '||V_ESQUEMA||'.S_ACT_AGR_AGRUPACION.NEXTVAL,
					    2,
					    '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''',
					    '||V_ESQUEMA||'.S_AGR_NUM_AGRUP_REM.NEXTVAL,
					    SYSDATE,
					    0,
					    0,
					    0,
					    0,
					    '''||V_USUARIO||''',
					    SYSDATE,
					    0,
					    0,
					    0,
					    0
					)'
						;
                        
                				DBMS_OUTPUT.PUT_LINE(V_SQL);
        
				EXECUTE IMMEDIATE V_SQL;
				
				
				
				V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE agr_nombre = '''||V_TMP_TIPO_DATA(1)||'''';
                                				DBMS_OUTPUT.PUT_LINE(V_MSQL);

			       EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
			       
			       IF V_COUNT = 1  THEN
				
					V_MSQL:= 'SELECT AGR_ID FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE agr_nombre = '''||V_TMP_TIPO_DATA(1)||'''';
                                    				DBMS_OUTPUT.PUT_LINE(V_MSQL);

				       EXECUTE IMMEDIATE V_MSQL INTO V_AGR_ID;
				       
				       --Comprobamos si el activo y la agrupacion existen
					V_SQL := 'INSERT INTO rem01.ACT_RES_RESTRINGIDA (
					    agr_id
					) VALUES (
					    '||V_AGR_ID||'
					)'
						;
                        DBMS_OUTPUT.PUT_LINE(V_MSQL);
					EXECUTE IMMEDIATE V_SQL;
					
					DBMS_OUTPUT.PUT_LINE('[INFO]: CREADA AGRUPACION: '||V_TMP_TIPO_DATA(1)||' ');
				
					IF V_TMP_TIPO_DATA(2) IS NOT NULL THEN
                    
                            V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE 
                            ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(2)||''' AND BORRADO = 0';
                                                        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        
                           EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
                           
                           IF V_COUNT = 1  THEN
                               
                            V_MSQL:= 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE 
                            ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(2)||''' AND BORRADO = 0';
                            DBMS_OUTPUT.PUT_LINE(V_MSQL);
                            
                            EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;
                            
                            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO (
                                    AGA_ID, AGR_ID, ACT_ID, AGA_FECHA_INCLUSION, USUARIOCREAR, FECHACREAR, BORRADO
                                    ) VALUES (
                                    '||V_ESQUEMA||'.S_ACT_AGA_AGRUPACION_ACTIVO.NEXTVAL,
                                    '||V_AGR_ID||',
                                    '||V_ACT_ID||',
                                    TO_DATE(SYSDATE,''DD/MM/RRRR''),
                                    '''||V_USUARIO||''',
                                    SYSDATE,
                                    0
                                    )';
                                    DBMS_OUTPUT.PUT_LINE(V_MSQL);
                            EXECUTE IMMEDIATE V_MSQL;  
                            
                            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO ACTIVO: '||V_TMP_TIPO_DATA(2)||' ');
						    
					END IF;
                    
                    END IF;
					
					IF V_TMP_TIPO_DATA(3) IS NOT NULL THEN
                    
                     V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE 
                            ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(3)||''' AND BORRADO = 0';
                                                        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        
                           EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
                           
                           IF V_COUNT = 1  THEN
				       
				        V_MSQL:= 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE 
					ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(3)||''' AND BORRADO = 0';
					
		   			EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;
		   			
		   			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO (
						    AGA_ID, AGR_ID, ACT_ID, AGA_FECHA_INCLUSION, USUARIOCREAR, FECHACREAR, BORRADO
						    ) VALUES (
						    '||V_ESQUEMA||'.S_ACT_AGA_AGRUPACION_ACTIVO.NEXTVAL,
						    '||V_AGR_ID||',
						    '||V_ACT_ID||',
						    TO_DATE(SYSDATE,''DD/MM/RRRR''),
						    '''||V_USUARIO||''',
						    SYSDATE,
						    0
						    )';
					EXECUTE IMMEDIATE V_MSQL;  
					
					DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO ACTIVO: '||V_TMP_TIPO_DATA(3)||' ');
						    
					END IF;
                    
                    END IF;
					
					IF V_TMP_TIPO_DATA(4) IS NOT NULL THEN
                    
                     V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE 
                            ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(2)||''' AND BORRADO = 0';
                                                        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        
                           EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
                           
                           IF V_COUNT = 1  THEN
				       
				        V_MSQL:= 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE 
					ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(4)||''' AND BORRADO = 0';
					
		   			EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;
		   			
		   			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO (
						    AGA_ID, AGR_ID, ACT_ID, AGA_FECHA_INCLUSION, USUARIOCREAR, FECHACREAR, BORRADO
						    ) VALUES (
						    '||V_ESQUEMA||'.S_ACT_AGA_AGRUPACION_ACTIVO.NEXTVAL,
						    '||V_AGR_ID||',
						    '||V_ACT_ID||',
						    TO_DATE(SYSDATE,''DD/MM/RRRR''),
						    '''||V_USUARIO||''',
						    SYSDATE,
						    0
						    )';
					EXECUTE IMMEDIATE V_MSQL;  
					
					DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO ACTIVO: '||V_TMP_TIPO_DATA(4)||' ');
						    
					END IF;
                    
                    END IF;
					
					ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE AGRUPACION: '||V_TMP_TIPO_DATA(1)||' ');

		END IF;	  
		
		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: ya esxiste la AGRUPACION: '||V_TMP_TIPO_DATA(1)||' ');    
			
		END IF;		 	       
			     			
      END LOOP;

COMMIT;
     -- ROLLBACK;
 DBMS_OUTPUT.PUT_LINE('[FIN]: AGRUPACIONES Y ACTIVOS CREADOS');   

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END UPDATE_PAC;
/
EXIT;
