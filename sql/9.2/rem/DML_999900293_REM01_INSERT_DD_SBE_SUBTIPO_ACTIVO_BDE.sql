--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20180724
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1373
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
    V_TABLA VARCHAR2(27 CHAR) := 'DD_SBE_SUBTIPO_ACTIVO_BDE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-1373';

 -- ARRAY PARA LA REACTIVACIÓN DE AGRUPACIONES
    TYPE T_TIPO_DATA_2 IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA_2 IS TABLE OF T_TIPO_DATA_2;
    V_TIPO_DATA_2 T_ARRAY_DATA_2 := T_ARRAY_DATA_2(
    --		DD_OFR_COD	DD_EEC_COD	DD_ERE_COD	 INDICE
		T_TIPO_DATA_2('02','0-Inversion inmobiliaria'),
		T_TIPO_DATA_2('03','0-No son inmuebles'),
		T_TIPO_DATA_2('04','0-Otros'),
		T_TIPO_DATA_2('05','1. Viv resid. Habitual (d) (e)'),
		T_TIPO_DATA_2('06','2. Vivi NO resid. Hab.(d) (f)'),
		T_TIPO_DATA_2('07','3. Viviendas (resto) (d) (g)'),
		T_TIPO_DATA_2('08','4. Oficinas, locales, naves p.'),
		T_TIPO_DATA_2('09','5. Resto de inmuebles'),
		T_TIPO_DATA_2('10','6.0. Solar'),
		T_TIPO_DATA_2('11','6.1. Suelo Urbano'),
		T_TIPO_DATA_2('12','6.2. Suelo Urbanizable'),
		T_TIPO_DATA_2('13','6.3. Suelo no Urbanizable'),
		T_TIPO_DATA_2('14','6.4 Suelo rústico/ valorado/ c'),
		T_TIPO_DATA_2('15','7. Fincas rústicas en explotac'),
		T_TIPO_DATA_2('16','8. Resto de terrenos'),
		T_TIPO_DATA_2('17','6.5 Suelo Urbano no consolidad'),
		T_TIPO_DATA_2('18','9. No C.6-7')
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
								DD_SBE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA_2(1))||'''';
																							
				EXECUTE IMMEDIATE V_SQL INTO V_AUX;			
			  
				IF V_AUX = 0 THEN 
				
				  V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (		  
					  DD_SBE_ID
					, DD_SBE_CODIGO
					, DD_SBE_DESCRIPCION
					, DD_SBE_DESCRIPCION_LARGA
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
