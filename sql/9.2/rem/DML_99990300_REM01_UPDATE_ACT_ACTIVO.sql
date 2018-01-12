--/*
--##########################################
--## AUTOR=JOSE NAVARRO
--## FECHA_CREACION=20180109
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3615
--## PRODUCTO=SI
--##
--## Finalidad: ACTUALIZAR LOS CAMPOS DD_TPA_ID Y DD_SAC_ID DE LOS ACTIVOS QUE NO TENGAN ESTOS CAMPOS RELLENADOS
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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    -- CÓDIGOS DE LOS TIPOS DE ACTIVOS CON EL SUBTIPO DE ACTIVOS MÁS BÁSICO
    TYPE T_TIPO IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY IS TABLE OF T_TIPO;
    V_TIPO T_ARRAY := T_ARRAY(
		    T_TIPO('01','04'),
    		T_TIPO('02','09'),
			T_TIPO('03','13'),
			T_TIPO('04','18'),
			T_TIPO('05','19'),
			T_TIPO('06','23'),
			T_TIPO('07','24')
    ); 
    V_TMP_TIPO T_TIPO;

    V_NUM_MODIFICADAS NUMBER(16);

BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TEXT_TABLA);
		
		-- ACTIVOS SIN DD_TPA_ID NI DD_SAC_ID

		V_SQL := 'SELECT COUNT(1)
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		WHERE ACT.DD_TPA_ID IS NULL AND ACT.DD_SAC_ID IS NULL';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS > 0 THEN
			V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO ACT
						SET ACT.DD_TPA_ID = (SELECT TPA.DD_TPA_ID
												FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA
												WHERE TPA.DD_TPA_CODIGO = ''07''),
							ACT.DD_SAC_ID = (SELECT SAC.DD_SAC_ID
												FROM '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC
												WHERE SAC.DD_SAC_CODIGO = ''26''),
							ACT.USUARIOMODIFICAR = ''HREOS-3615'',
							ACT.FECHAMODIFICAR = SYSDATE
						WHERE ACT.DD_TPA_ID IS NULL AND ACT.DD_SAC_ID IS NULL';
			
			EXECUTE IMMEDIATE V_SQL;
			
			DBMS_OUTPUT.PUT_LINE('[SUCCESS] Actualización de la tabla '||V_TEXT_TABLA||' de los ACTIVOS sin DD_TPA_ID ni DD_SAC_ID. Actualizados '||SQL%ROWCOUNT||' registros.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] No existen ACTIVOS sin DD_TPA_ID ni DD_SAC_ID a la vez en la tabla '||V_TEXT_TABLA||'.');
		END IF;
		
		-- ACTIVOS SIN DD_TPA_ID PERO SI CON DD_SAC_ID

		V_SQL := 'SELECT COUNT(1)
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		WHERE ACT.DD_TPA_ID IS NULL AND ACT.DD_SAC_ID IS NOT NULL';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS > 0 THEN
			V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO ACT
						SET ACT.DD_TPA_ID = (SELECT SAC.DD_TPA_ID
												FROM '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC
												WHERE SAC.DD_SAC_ID = ACT.DD_SAC_ID),
							ACT.USUARIOMODIFICAR = ''HREOS-3615'',
							ACT.FECHAMODIFICAR = SYSDATE
						WHERE ACT.DD_TPA_ID IS NULL AND ACT.DD_SAC_ID IS NOT NULL';
			
			EXECUTE IMMEDIATE V_SQL;
			
			DBMS_OUTPUT.PUT_LINE('[SUCCESS] Actualización de la tabla '||V_TEXT_TABLA||' de los ACTIVOS sin DD_TPA_ID pero si con DD_SAC_ID. Actualizados '||SQL%ROWCOUNT||' registros.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] No existen ACTIVOS sin DD_TPA_ID y con DD_SAC_ID en la tabla '||V_TEXT_TABLA||'.');
		END IF;

		-- ACTIVOS CON DD_TPA_ID PERO SIN DD_SAC_ID

		V_SQL := 'SELECT COUNT(1)
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		WHERE ACT.DD_TPA_ID IS NOT NULL AND ACT.DD_SAC_ID IS NULL';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_MODIFICADAS;
		IF V_NUM_MODIFICADAS > 0 THEN
			FOR I IN V_TIPO.FIRST .. V_TIPO.LAST
			LOOP
				V_TMP_TIPO := V_TIPO(I);

				V_SQL := 'SELECT COUNT(1)
				FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
				WHERE ACT.DD_TPA_ID = (SELECT TPA.DD_TPA_ID
										FROM DD_TPA_TIPO_ACTIVO TPA 
										WHERE TPA.DD_TPA_CODIGO = '''||V_TMP_TIPO(1)||''')
					AND ACT.DD_SAC_ID IS NULL';
				
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
				IF V_NUM_TABLAS > 0 THEN
					V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO ACT
								SET ACT.DD_SAC_ID = (SELECT SAC.DD_SAC_ID
														FROM '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC
														WHERE SAC.DD_SAC_CODIGO = '''||V_TMP_TIPO(2)||'''),
									ACT.USUARIOMODIFICAR = ''HREOS-3615'',
									ACT.FECHAMODIFICAR = SYSDATE
								WHERE ACT.DD_TPA_ID = (SELECT TPA.DD_TPA_ID
										FROM DD_TPA_TIPO_ACTIVO TPA 
										WHERE TPA.DD_TPA_CODIGO = '''||V_TMP_TIPO(1)||''') 
									AND ACT.DD_SAC_ID IS NULL';
					
					EXECUTE IMMEDIATE V_SQL;
				END IF;
			END LOOP;

			DBMS_OUTPUT.PUT_LINE('[SUCCESS] Actualización de la tabla '||V_TEXT_TABLA||' de los ACTIVOS con DD_TPA_ID pero sin DD_SAC_ID. Actualizados '||V_NUM_MODIFICADAS||' registros.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] No existen ACTIVOS con DD_TPA_ID y sin DD_SAC_ID en la tabla '||V_TEXT_TABLA||'.');
		END IF;

    COMMIT;
   

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
