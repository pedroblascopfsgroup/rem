--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20180727
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1408
--## PRODUCTO=NO
--##
--## Finalidad: Insercion inicial DD_TIPO_SUB_TIPO_ACT_BK
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
    V_TABLA VARCHAR2(27 CHAR) := 'DD_TIPO_SUB_TIPO_ACT_BK'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-1408';

    TYPE T_TIPO_DATA_2 IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA_2 IS TABLE OF T_TIPO_DATA_2;
    V_TIPO_DATA_2 T_ARRAY_DATA_2 := T_ARRAY_DATA_2(
	
	T_TIPO_DATA_2('CO01','COMERCIAL LOCAL'),
	T_TIPO_DATA_2('CO02','COMERCIAL OFICINA'),
	T_TIPO_DATA_2('CO03','COMERCIAL ALMACEN'),
	T_TIPO_DATA_2('ED01','EDIFICIO/COLECTIVO RESIDENCIAL'),
	T_TIPO_DATA_2('ED02','EDIFICIO/COLECTIVO COMERCIAL'),
	T_TIPO_DATA_2('ED03','EDIFICIO/COLECTIVO INDUSTRIAL'),
	T_TIPO_DATA_2('ED04','EDIFICIO/COLECTIVO GARAJE'),
	T_TIPO_DATA_2('ED05','EDIFICIO/COLECTIVO DOTACIONAL'),
	T_TIPO_DATA_2('ED06','EDIFICIO/COLECTIVO HOTELERO'),
	T_TIPO_DATA_2('ED07','EDIFICIO/COLECTIVO OFICINAS'),
	T_TIPO_DATA_2('IN01','INDUSTRIAL NAVE ADOSADA'),
	T_TIPO_DATA_2('IN02','INDUSTRIAL NAVE AISLADA'),
	T_TIPO_DATA_2('IN03','INDUSTRIAL NAVE EN EDIFICIO INDUSTRIAL'),
	T_TIPO_DATA_2('IN04','INDUSTRIAL NAVE EN VARIAS PLANTAS'),
	T_TIPO_DATA_2('OT01','VARIOS APARCAMIENTO'),
	T_TIPO_DATA_2('OT02','VARIOS GARAJE'),
	T_TIPO_DATA_2('OT03','VARIOS TRASTERO'),
	T_TIPO_DATA_2('OT04','VARIOS REGIMEN HOTELERO'),
	T_TIPO_DATA_2('OT05','VARIOS OTROS'),
	T_TIPO_DATA_2('SU01','SUELOS NO URBANIZABLE'),
	T_TIPO_DATA_2('SU02','SUELOS URBANIZABLE NO PROGRAMADO'),
	T_TIPO_DATA_2('SU03','SUELOS URBANIZABLE PROGRAMADO'),
	T_TIPO_DATA_2('SU04','SUELOS URBANO/SOLAR/PARCELA'),
	T_TIPO_DATA_2('VI01','VIVIENDA PISO'),
	T_TIPO_DATA_2('VI02','VIVIENDA PISO DUPLEX'),
	T_TIPO_DATA_2('VI03','VIVIENDA CHALET AISLADO'),
	T_TIPO_DATA_2('VI04','VIVIENDA CHALET ADOSADO'),
	T_TIPO_DATA_2('VI05','VIVIENDA CASA UNIFAMILIAR')
		
	); 
    V_TMP_TIPO_DATA_2 T_TIPO_DATA_2;

 BEGIN

  V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME ='''||V_TABLA||'''';
      
  EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
   
  IF V_COUNT > 0 THEN
  
		 -- LOOP-----------------------------------------------------------------
		DBMS_OUTPUT.PUT_LINE('[INFO] Empieza la inserción en la tabla '||V_TABLA||'');
		FOR I IN V_TIPO_DATA_2.FIRST .. V_TIPO_DATA_2.LAST
		  LOOP
		  
			V_TMP_TIPO_DATA_2 := V_TIPO_DATA_2(I);
			  
			  V_SQL := 'SELECT COUNT(1) FROM '||V_TABLA||' WHERE 
								DD_TST_ACT_CODIGO = '''||TRIM(V_TMP_TIPO_DATA_2(1))||'''';
										                
				EXECUTE IMMEDIATE V_SQL INTO V_AUX;			
			  
				IF V_AUX = 0 THEN 
				
				  V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (		  
					  DD_TST_ACT_ID
					, DD_TST_ACT_CODIGO
					, DD_TST_ACT_DESCRIPCION
					, DD_TST_ACT_DESCRIPCION_LARGA
					, USUARIOCREAR
					, FECHACREAR
					) VALUES (
					  S_'||V_TABLA||'.NEXTVAL
					,'''||TRIM(V_TMP_TIPO_DATA_2(1))||'''
					,'''||V_TMP_TIPO_DATA_2(2)||'''
					,'''||V_TMP_TIPO_DATA_2(2)||'''
					,'''||V_USUARIO||'''
					,SYSDATE
					)';
								                       
					EXECUTE IMMEDIATE V_SQL;
								
					DBMS_OUTPUT.PUT_LINE('[INFO] Insertado en la tabla registro con código '||TRIM(V_TMP_TIPO_DATA_2(1))||'');
					
				ELSE 
				
					DBMS_OUTPUT.PUT_LINE('[INFO] El registro con código '||TRIM(V_TMP_TIPO_DATA_2(1))||' ya existe en la tabla '||V_TABLA );

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
