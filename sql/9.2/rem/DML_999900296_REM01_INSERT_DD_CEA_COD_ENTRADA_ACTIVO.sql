--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20180727
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1408
--## PRODUCTO=NO
--##
--## Finalidad: Insercion inicial DD_CEA_COD_ENTRADA_ACTIVO
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
    V_TABLA VARCHAR2(27 CHAR) := 'DD_CEA_COD_ENTRADA_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-1408';

    TYPE T_TIPO_DATA_2 IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA_2 IS TABLE OF T_TIPO_DATA_2;
    V_TIPO_DATA_2 T_ARRAY_DATA_2 := T_ARRAY_DATA_2(
	
	T_TIPO_DATA_2('01','ADJUDICACION'),
	T_TIPO_DATA_2('02','DACION'),
	T_TIPO_DATA_2('03','COMPRA VENTA'),
	T_TIPO_DATA_2('04','DISOLUCION PROINDIVISO'),
	T_TIPO_DATA_2('05','ABSORCION'),
	T_TIPO_DATA_2('06','CESION EN PAGO'),
	T_TIPO_DATA_2('07','COMPRA VENTA JUDICIAL'),
	T_TIPO_DATA_2('08','OTROS'),
	T_TIPO_DATA_2('09','INTERMEDIACION'),
	T_TIPO_DATA_2('10','TRASPASO'),
	T_TIPO_DATA_2('14','INMOVILIZADO DESAFECTADO A LA ACTIVIDAD'),
	T_TIPO_DATA_2('13','INMOVILIZADO DE USO PROPIO'),
	T_TIPO_DATA_2('21','PROMOCIONES EXTERNAS'),
	T_TIPO_DATA_2('12','ACTIVOS PROPIOS DE NEGOCIO'),
	T_TIPO_DATA_2('16','LEASING'),
	T_TIPO_DATA_2('22','SALE & LEASE BACK'),
	T_TIPO_DATA_2('23','CARTERA DE TERCEROS')
		
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
								DD_CEA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA_2(1))||'''';
										                
				EXECUTE IMMEDIATE V_SQL INTO V_AUX;			
			  
				IF V_AUX = 0 THEN 
				
				  V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (		  
					  DD_CEA_ID
					, DD_CEA_CODIGO
					, DD_CEA_DESCRIPCION
					, DD_CEA_DESCRIPCION_LARGA
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
