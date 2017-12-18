--/*
--##########################################
--## AUTOR=Sergio Belenguer Gadea
--## FECHA_CREACION=20171205
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HRNIVDOS-7154
--## PRODUCTO=NO
--##
--## Finalidad: Insercion en la TMP_APROV_DACIONES
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_SEQ_GEH NUMBER(16);
	V_TIPO_ID NUMBER(16); --Vle para el id DD_TTR_TIPO_TRABAJO
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--		act_num_activo	
		T_TIPO_DATA(174671),
		T_TIPO_DATA(69408),
		T_TIPO_DATA(69086),
		T_TIPO_DATA(160988),
		T_TIPO_DATA(152798),
		T_TIPO_DATA(174553),
		T_TIPO_DATA(179822),
		T_TIPO_DATA(160989),
		T_TIPO_DATA(174028),
		T_TIPO_DATA(160802),
		T_TIPO_DATA(160755),
		T_TIPO_DATA(160756),
		T_TIPO_DATA(174108),
		T_TIPO_DATA(174109),
		T_TIPO_DATA(174209),
		T_TIPO_DATA(174580),
		T_TIPO_DATA(174110),
		T_TIPO_DATA(171396),
		T_TIPO_DATA(160913),
		T_TIPO_DATA(65516),
		T_TIPO_DATA(174212),
		T_TIPO_DATA(65517),
		T_TIPO_DATA(65186),
		T_TIPO_DATA(65187),
		T_TIPO_DATA(171331),
		T_TIPO_DATA(171332),
		T_TIPO_DATA(65423),
		T_TIPO_DATA(65188),
		T_TIPO_DATA(171036),
		T_TIPO_DATA(171632),
		T_TIPO_DATA(161187),
		T_TIPO_DATA(179440),
		T_TIPO_DATA(179719),
		T_TIPO_DATA(79864),
		T_TIPO_DATA(81640),
		T_TIPO_DATA(69849),
		T_TIPO_DATA(80367),
		T_TIPO_DATA(69798),
		T_TIPO_DATA(70001),
		T_TIPO_DATA(79865),
		T_TIPO_DATA(75851),
		T_TIPO_DATA(75777),
		T_TIPO_DATA(70002),
		T_TIPO_DATA(79866),
		T_TIPO_DATA(80208),
		T_TIPO_DATA(81444),
		T_TIPO_DATA(80209),
		T_TIPO_DATA(69616),
		T_TIPO_DATA(81877),
		T_TIPO_DATA(75454),
		T_TIPO_DATA(69617),
		T_TIPO_DATA(69799),
		T_TIPO_DATA(81878),
		T_TIPO_DATA(76160),
		T_TIPO_DATA(75852),
		T_TIPO_DATA(75853),
		T_TIPO_DATA(75324),
		T_TIPO_DATA(81879),
		T_TIPO_DATA(75854),
		T_TIPO_DATA(81641),
		T_TIPO_DATA(76161),
		T_TIPO_DATA(79867),
		T_TIPO_DATA(75855),
		T_TIPO_DATA(69800),
		T_TIPO_DATA(75325),
		T_TIPO_DATA(75326),
		T_TIPO_DATA(75778),
		T_TIPO_DATA(76162),
		T_TIPO_DATA(69801),
		T_TIPO_DATA(80119),
		T_TIPO_DATA(80210),
		T_TIPO_DATA(75327),
		T_TIPO_DATA(69802),
		T_TIPO_DATA(69803),
		T_TIPO_DATA(75779),
		T_TIPO_DATA(70003),
		T_TIPO_DATA(75780),
		T_TIPO_DATA(75328),
		T_TIPO_DATA(70004),
		T_TIPO_DATA(81722),
		T_TIPO_DATA(80120),
		T_TIPO_DATA(75781),
		T_TIPO_DATA(70005),
		T_TIPO_DATA(75329),
		T_TIPO_DATA(76163),
		T_TIPO_DATA(69618),
		T_TIPO_DATA(80121),
		T_TIPO_DATA(75782),
		T_TIPO_DATA(69850),
		T_TIPO_DATA(76164)
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en TMP_APROV_DACIONES -----------------------------------------------------------------
    --DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.TMP_APROV_DACIONES... Empezando a insertar datos en la tabla TMP_APROV_DACIONES');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
   		V_MSQL := 'update '||V_ESQUEMA||'.act_activo
			  set act_num_activo = 999||act_num_activo
		where act_num_activo ='||V_TMP_TIPO_DATA(1);
		EXECUTE IMMEDIATE V_MSQL;
        V_SQL := 'select act_num_activo from '||V_ESQUEMA||'.act_activo where act_num_activo ='|| V_TMP_TIPO_DATA(1);
        EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('act_num_activo actualizado: ' || V_SQL);
		
    END LOOP;
    --ROLLBACK;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.TMP_APROV_DACIONES... Datos de la tabla insertados');
   

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


