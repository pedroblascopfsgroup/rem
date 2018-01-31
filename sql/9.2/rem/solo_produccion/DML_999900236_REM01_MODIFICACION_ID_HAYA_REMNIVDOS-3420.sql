--/*
--##########################################
--## AUTOR=Sergio Belenguer Gadea
--## FECHA_CREACION=20180131
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMNIVDOS-3420
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
    V_RESUL_ID NUMBER(16);
    V_ID NUMBER(16);
    V_SEQ_GEH NUMBER(16);
	V_TIPO_ID NUMBER(16); --Vle para el id DD_TTR_TIPO_TRABAJO
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--act_num_activo	
	T_TIPO_DATA(187191),
	T_TIPO_DATA(196311),
	T_TIPO_DATA(189369),
	T_TIPO_DATA(187569),
	T_TIPO_DATA(189644),
	T_TIPO_DATA(186371),
	T_TIPO_DATA(186185),
	T_TIPO_DATA(189370),
	T_TIPO_DATA(189989),
	T_TIPO_DATA(187192),
	T_TIPO_DATA(189371),
	T_TIPO_DATA(196921),
	T_TIPO_DATA(187067),
	T_TIPO_DATA(187193),
	T_TIPO_DATA(187194),
	T_TIPO_DATA(186968),
	T_TIPO_DATA(190449),
	T_TIPO_DATA(187068),
	T_TIPO_DATA(197176),
	T_TIPO_DATA(189372),
	T_TIPO_DATA(190450),
	T_TIPO_DATA(187195),
	T_TIPO_DATA(187069),
	T_TIPO_DATA(190451),
	T_TIPO_DATA(189373),
	T_TIPO_DATA(187070),
	T_TIPO_DATA(187570),
	T_TIPO_DATA(187071),
	T_TIPO_DATA(189990),
	T_TIPO_DATA(191029),
	T_TIPO_DATA(189339),
	T_TIPO_DATA(190624),
	T_TIPO_DATA(187072),
	T_TIPO_DATA(189390),
	T_TIPO_DATA(187196),
	T_TIPO_DATA(189645),
	T_TIPO_DATA(196782),
	T_TIPO_DATA(190452),
	T_TIPO_DATA(190625),
	T_TIPO_DATA(196922),
	T_TIPO_DATA(187073),
	T_TIPO_DATA(189420),
	T_TIPO_DATA(196923),
	T_TIPO_DATA(196312),
	T_TIPO_DATA(187571),
	T_TIPO_DATA(196783),
	T_TIPO_DATA(190453),
	T_TIPO_DATA(189646),
	T_TIPO_DATA(189647)
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	--MODIFICAMOS EL ACT_NUM_ACTIVO AÑADIENDO EL PREFIJO 999 Y EL BIE_NUMERO_ACTIVO AÑADIENDO EL PREFIJO 9
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		V_MSQL := 'update '||V_ESQUEMA||'.act_activo
			  set BIE_NUMERO_ACTIVO = 9||BIE_NUMERO_ACTIVO,
				USUARIOMODIFICAR = ''REMNIVDOS-3420'',
				FECHAMODIFICAR = SYSDATE
		where act_num_activo ='||V_TMP_TIPO_DATA(1)|| 'AND BIE_NUMERO_ACTIVO IS NOT NULL';
		EXECUTE IMMEDIATE V_MSQL;
    
   		V_MSQL := 'update '||V_ESQUEMA||'.act_activo
			  set act_num_activo = 999||act_num_activo,
				USUARIOMODIFICAR = ''REMNIVDOS-3420'',
				FECHAMODIFICAR = SYSDATE
		where act_num_activo ='||V_TMP_TIPO_DATA(1);
		EXECUTE IMMEDIATE V_MSQL;
        	V_SQL := 'select act_num_activo from '||V_ESQUEMA||'.act_activo where act_num_activo =999'|| V_TMP_TIPO_DATA(1);
        	EXECUTE IMMEDIATE V_SQL INTO V_RESUL_ID;
		DBMS_OUTPUT.PUT_LINE('Actualizado el activo '||V_TMP_TIPO_DATA(1)||' con el ACT_NUM_ACTIVO: ' || V_RESUL_ID);

		V_SQL := 'select BIE_NUMERO_ACTIVO from '||V_ESQUEMA||'.act_activo where act_num_activo =999'|| V_TMP_TIPO_DATA(1);
        	EXECUTE IMMEDIATE V_SQL INTO V_RESUL_ID;
		DBMS_OUTPUT.PUT_LINE('Actualizado el activo '||V_TMP_TIPO_DATA(1)||' con el ACT_NUM_ACTIVO: ' || V_RESUL_ID);
		
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


