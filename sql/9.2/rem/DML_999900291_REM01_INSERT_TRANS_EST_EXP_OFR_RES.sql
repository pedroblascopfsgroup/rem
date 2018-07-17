--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20180718
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1076
--## PRODUCTO=NO
--##
--## Finalidad: Insercion inicial TRANS_EST_EXP_OFR_RES
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_AUX NUMBER(16);
    V_TABLA VARCHAR2(27 CHAR) := 'TRANS_EST_EXP_OFR_RES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-1076';

 -- ARRAY PARA LA REACTIVACIÓN DE AGRUPACIONES
    TYPE T_TIPO_DATA_2 IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA_2 IS TABLE OF T_TIPO_DATA_2;
    V_TIPO_DATA_2 T_ARRAY_DATA_2 := T_ARRAY_DATA_2(
    --		DD_OFR_COD	DD_EEC_COD	DD_ERE_COD	 INDICE
		T_TIPO_DATA_2('04','01','01','1'),
		T_TIPO_DATA_2('01','01','01','2'),
		T_TIPO_DATA_2('01','10','01','3'),
		T_TIPO_DATA_2('01','04','01','4'),
		T_TIPO_DATA_2('03','04','01','5'),
		T_TIPO_DATA_2('01','11','01','6'),
		T_TIPO_DATA_2('01','06','02','7'),
		T_TIPO_DATA_2('01','05','02','8'),
		T_TIPO_DATA_2('01','03','02','9'),
		T_TIPO_DATA_2('01','08','02','10'),
		T_TIPO_DATA_2('01','16','05','11'),
		T_TIPO_DATA_2('03','16','05','12'),
		T_TIPO_DATA_2('02','02','06','13'),
		T_TIPO_DATA_2('02','02','07','14'),
		T_TIPO_DATA_2('03','02','07','15'),
		T_TIPO_DATA_2('02','02','08','16'),
		T_TIPO_DATA_2('04','01','NULL','17'),
		T_TIPO_DATA_2('01','01','NULL','18'),
		T_TIPO_DATA_2('01','10','NULL','19'),
		T_TIPO_DATA_2('01','04','NULL','20'),
		T_TIPO_DATA_2('03','04','NULL','21'),
		T_TIPO_DATA_2('01','11','NULL','22'),
		T_TIPO_DATA_2('01','05','NULL','23'),
		T_TIPO_DATA_2('01','03','NULL','24'),
		T_TIPO_DATA_2('01','08','NULL','25')
	); 
    V_TMP_TIPO_DATA_2 T_TIPO_DATA_2;

 BEGIN

  V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME ='''||V_TABLA||'''';
      
  EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
   
  IF V_COUNT > 0 THEN
  
		 -- LOOP-----------------------------------------------------------------
		DBMS_OUTPUT.PUT_LINE('[INFO] Empieza la inserción en la tabla auxiliar '||V_TABLA||'');
		FOR I IN V_TIPO_DATA_2.FIRST .. V_TIPO_DATA_2.LAST
		  LOOP
		  
			V_TMP_TIPO_DATA_2 := V_TIPO_DATA_2(I);
			  
			  IF V_TMP_TIPO_DATA_2(3) != 'NULL' THEN
			  
				  V_SQL := 'SELECT COUNT(1) FROM '||V_TABLA||' WHERE 
									DD_EOF_COD = '''||TRIM(V_TMP_TIPO_DATA_2(1))||'''
								AND DD_EEC_COD = '''||TRIM(V_TMP_TIPO_DATA_2(2))||'''
								AND DD_ERE_COD = '''||TRIM(V_TMP_TIPO_DATA_2(3))||'''';
												                                                
					EXECUTE IMMEDIATE V_SQL INTO V_AUX;			
				  
					IF V_AUX = 0 THEN 
					
					  V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
						  TRANS_EST_EXP_OFR_RES_ID
						, DD_EOF_COD
						, DD_EEC_COD
						, DD_ERE_COD
						, USUARIOCREAR
						, FECHACREAR
						) VALUES (
						  S_'||V_TABLA||'.NEXTVAL
						,'''||TRIM(V_TMP_TIPO_DATA_2(1))||'''
						,'''||TRIM(V_TMP_TIPO_DATA_2(2))||'''
						,'''||TRIM(V_TMP_TIPO_DATA_2(3))||'''
						,'''||V_USUARIO||'''
						,SYSDATE
						)';
								                        
						EXECUTE IMMEDIATE V_SQL;
									
						DBMS_OUTPUT.PUT_LINE('[INFO] Insertado en la tabla de transiciones el registro con indice '||TRIM(V_TMP_TIPO_DATA_2(4))||'');
						
					ELSE 
					
						DBMS_OUTPUT.PUT_LINE('[INFO] El registro con indice '||TRIM(V_TMP_TIPO_DATA_2(4))||' ya existe en la tabla '||V_TABLA );

					END IF;
			
			ELSE 
				
				 V_SQL := 'SELECT COUNT(1) FROM '||V_TABLA||' WHERE  
							    DD_EOF_COD = '''||TRIM(V_TMP_TIPO_DATA_2(1))||'''
							AND DD_EEC_COD = '''||TRIM(V_TMP_TIPO_DATA_2(2))||'''
							AND DD_ERE_COD IS NULL ';
												                    
					EXECUTE IMMEDIATE V_SQL INTO V_AUX;			
				  
					IF V_AUX = 0 THEN 
					
					  V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
						  TRANS_EST_EXP_OFR_RES_ID
						, DD_EOF_COD
						, DD_EEC_COD
						, DD_ERE_COD
						, USUARIOCREAR
						, FECHACREAR
						) VALUES (
						  S_'||V_TABLA||'.NEXTVAL
						,'''||TRIM(V_TMP_TIPO_DATA_2(1))||'''
						,'''||TRIM(V_TMP_TIPO_DATA_2(2))||'''
						,'||TRIM(V_TMP_TIPO_DATA_2(3))||'
						, '''||V_USUARIO||'''
						, SYSDATE
						)';
						                        
						EXECUTE IMMEDIATE V_SQL;
									
						DBMS_OUTPUT.PUT_LINE('[INFO] Insertado en la tabla de transiciones el registro con indice '||TRIM(V_TMP_TIPO_DATA_2(4))||'');
						
					ELSE 
					
						DBMS_OUTPUT.PUT_LINE('[INFO] El registro con indice '||TRIM(V_TMP_TIPO_DATA_2(4))||' ya existe en la tabla '||V_TABLA );

					END IF;
			
			END IF;
				
		END LOOP;
	  
	  DBMS_OUTPUT.PUT_LINE('[INFO] Insertados los registro en la tabla '||V_TABLA);
	  
  ELSE
  	  
  	  DBMS_OUTPUT.PUT_LINE('[INFO] La tabla '||V_TABLA||' no existe');
  	  
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
