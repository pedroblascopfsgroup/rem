--/*
--##########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180727
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMNIVDOS-1442
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
    V_RESUL_ID NUMBER(20);
    V_ID NUMBER(16);
    V_SEQ_GEH NUMBER(16);
	V_TIPO_ID NUMBER(16); --Vle para el id DD_TTR_TIPO_TRABAJO
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--act_num_activo	
			T_TIPO_DATA(164009),
			T_TIPO_DATA(154108),
			T_TIPO_DATA(164391),
			T_TIPO_DATA(142053),
			T_TIPO_DATA(146019),
			T_TIPO_DATA(146064),
			T_TIPO_DATA(146527),
			T_TIPO_DATA(146528),
			T_TIPO_DATA(164392),
			T_TIPO_DATA(142115),
			T_TIPO_DATA(141895),
			T_TIPO_DATA(141896),
			T_TIPO_DATA(154683),
			T_TIPO_DATA(154500),
			T_TIPO_DATA(142116),
			T_TIPO_DATA(145799),
			T_TIPO_DATA(142117),
			T_TIPO_DATA(141897),
			T_TIPO_DATA(154501),
			T_TIPO_DATA(141945),
			T_TIPO_DATA(154684),
			T_TIPO_DATA(163937),
			T_TIPO_DATA(164393),
			T_TIPO_DATA(154243),
			T_TIPO_DATA(154685),
			T_TIPO_DATA(146065),
			T_TIPO_DATA(163838),
			T_TIPO_DATA(154502),
			T_TIPO_DATA(154109),
			T_TIPO_DATA(142327),
			T_TIPO_DATA(164010),
			T_TIPO_DATA(142436),
			T_TIPO_DATA(145800),
			T_TIPO_DATA(142437),
			T_TIPO_DATA(154111),
			T_TIPO_DATA(154686),
			T_TIPO_DATA(145801),
			T_TIPO_DATA(154244),
			T_TIPO_DATA(154687),
			T_TIPO_DATA(154112),
			T_TIPO_DATA(164011),
			T_TIPO_DATA(142439),
			T_TIPO_DATA(141946),
			T_TIPO_DATA(146020),
			T_TIPO_DATA(146067),
			T_TIPO_DATA(168486),
			T_TIPO_DATA(154245),
			T_TIPO_DATA(163938),
			T_TIPO_DATA(155283),
			T_TIPO_DATA(131992),
			T_TIPO_DATA(155145),
			T_TIPO_DATA(137966),
			T_TIPO_DATA(137967),
			T_TIPO_DATA(155373),
			T_TIPO_DATA(137907)
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	--MODIFICAMOS EL ACT_NUM_ACTIVO AÑADIENDO EL PREFIJO 999 Y EL ACT_RECOVERY_ID SUSTITUYENDO EL PREFIJO 1 POR EL 9
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		V_MSQL := 'update '||V_ESQUEMA||'.act_activo
			  set ACT_RECOVERY_ID = 9||SUBSTR(ACT_RECOVERY_ID, 2)
		where act_num_activo ='||V_TMP_TIPO_DATA(1)|| 'AND ACT_RECOVERY_ID IS NOT NULL';
		EXECUTE IMMEDIATE V_MSQL;
    
   		V_MSQL := 'update '||V_ESQUEMA||'.act_activo
			  set act_num_activo = 999||act_num_activo,
				USUARIOMODIFICAR = ''REMNIVDOS-1442'',
				FECHAMODIFICAR = SYSDATE
		where act_num_activo ='||V_TMP_TIPO_DATA(1);
		EXECUTE IMMEDIATE V_MSQL;
        	V_SQL := 'select act_num_activo from '||V_ESQUEMA||'.act_activo where act_num_activo =999'|| V_TMP_TIPO_DATA(1);
        	EXECUTE IMMEDIATE V_SQL INTO V_RESUL_ID;
		DBMS_OUTPUT.PUT_LINE('Actualizado el activo '||V_TMP_TIPO_DATA(1)||' con el ACT_NUM_ACTIVO: ' || V_RESUL_ID);

		V_SQL := 'select ACT_RECOVERY_ID from '||V_ESQUEMA||'.act_activo where act_num_activo =999'|| V_TMP_TIPO_DATA(1);
        	EXECUTE IMMEDIATE V_SQL INTO V_RESUL_ID;
		DBMS_OUTPUT.PUT_LINE('Actualizado el activo '||V_TMP_TIPO_DATA(1)||' con el ACT_RECOVERY_ID: ' || V_RESUL_ID);
		
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


