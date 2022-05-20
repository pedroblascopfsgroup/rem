--/*
--#########################################
--## AUTOR=Juan Bautista ALfonso
--## FECHA_CREACION=20220502
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11441
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir subfases nuevas y modificar pendiente de precio > en analisis
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(35 CHAR):= 'DD_SFP_SUBFASE_PUBLICACION'; -- Nombre de la tabla
    V_NUM_COLUMNA NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_ID NUMBER(16); -- Vble. para id subfase existe.
    V_SFP_ID NUMBER(16); -- Vble. para id subfase (nextval).
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-11441'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_SUBFASE_EXISTE NUMBER(16);		

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('Fase II', 'Llaves ZZCC Resto', '35'),
	T_TIPO_DATA('Fase II', 'Llaves PAO', '36'),
	T_TIPO_DATA('Fase II', 'Llaves ZZCC Deuda/Contacto', '37')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;


BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	DBMS_OUTPUT.PUT_LINE('[INFO] INSERT SUBFASES');

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      	    LOOP      
        	V_TMP_TIPO_DATA := V_TIPO_DATA(I);
			
		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''DD_SFP_DESCRIPCION'' and TABLE_NAME = '''||V_TABLA||''' and owner 			= '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLUMNA;

		IF V_NUM_COLUMNA = 1 THEN

			DBMS_OUTPUT.PUT_LINE('[INFO] BUSCANDO SUBFASE '''||V_TMP_TIPO_DATA(2)||'''');
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_SFP_DESCRIPCION = '''||V_TMP_TIPO_DATA(2)||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_SUBFASE_EXISTE;
			
			IF V_SUBFASE_EXISTE = 0 THEN

				V_SQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_SFP_SUBFASE_PUBLICACION.NEXTVAL FROM DUAL';
          			EXECUTE IMMEDIATE V_SQL INTO V_SFP_ID;

				V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'(DD_SFP_ID, DD_FSP_ID, DD_SFP_CODIGO, DD_SFP_DESCRIPCION, DD_SFP_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES
		  			('''||V_SFP_ID||''', (SELECT DD_FSP_ID FROM '||V_ESQUEMA||'.DD_FSP_FASE_PUBLICACION WHERE DD_FSP_DESCRIPCION LIKE '''||V_TMP_TIPO_DATA(1)||' %''), '''||V_TMP_TIPO_DATA(3)||''', '''||V_TMP_TIPO_DATA(2)||''', '''||V_TMP_TIPO_DATA(2)||''', '''||V_USUARIO||''', SYSDATE)';
                		EXECUTE IMMEDIATE V_SQL;

				DBMS_OUTPUT.PUT_LINE('[INFO] Se ha añadido correctamente '||SQL%ROWCOUNT||' la subfase '''||V_TMP_TIPO_DATA(2)||''''); 

			ELSE 

				DBMS_OUTPUT.PUT_LINE('[WARN] EXISTE LA SUBFASE: '''||V_TMP_TIPO_DATA(2)||''' ');

			END IF;
		ELSE 
		
			DBMS_OUTPUT.PUT_LINE('[INFO] LA COLUMNA DD_SFP_DESCRIPCION NO EXISTE');

		END IF;
	    END LOOP;	
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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
