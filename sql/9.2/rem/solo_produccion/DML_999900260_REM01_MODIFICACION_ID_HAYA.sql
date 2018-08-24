--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=201800530
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1297
--## PRODUCTO=NO
--##
--## Finalidad: Cambiar ID_HAYA con prefijo de 999
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
	V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-1297';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_SEQ_GEH NUMBER(16);
	V_TIPO_ID NUMBER(16); --Vle para el id DD_TTR_TIPO_TRABAJO
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--act_num_activo	
		  T_TIPO_DATA(62620)
		, T_TIPO_DATA(62621)
		, T_TIPO_DATA(62622)
		, T_TIPO_DATA(62689)
		, T_TIPO_DATA(62690)
		, T_TIPO_DATA(62691)
		, T_TIPO_DATA(62834)
		, T_TIPO_DATA(62835)
		, T_TIPO_DATA(62836)
		, T_TIPO_DATA(62863)
		, T_TIPO_DATA(62864)
		, T_TIPO_DATA(62915)
		, T_TIPO_DATA(62916)
		, T_TIPO_DATA(63010)
		, T_TIPO_DATA(63011)
		, T_TIPO_DATA(63061)
		, T_TIPO_DATA(63062)
		, T_TIPO_DATA(149752)
		, T_TIPO_DATA(158202)
		, T_TIPO_DATA(168929)
		, T_TIPO_DATA(168930)
		, T_TIPO_DATA(168931)
		, T_TIPO_DATA(168932)
		, T_TIPO_DATA(168994)
		, T_TIPO_DATA(168995)
		, T_TIPO_DATA(169191)
		, T_TIPO_DATA(169252)
		, T_TIPO_DATA(169409)
		, T_TIPO_DATA(198558)
		, T_TIPO_DATA(198559)
		, T_TIPO_DATA(198560)
		, T_TIPO_DATA(198561)
		, T_TIPO_DATA(198605)
		, T_TIPO_DATA(198606)
		, T_TIPO_DATA(198607)
		, T_TIPO_DATA(198608)
		, T_TIPO_DATA(198647)
		, T_TIPO_DATA(198648)
		, T_TIPO_DATA(198852)
		, T_TIPO_DATA(6132979)
		, T_TIPO_DATA(6132980)
		, T_TIPO_DATA(6132981)
		, T_TIPO_DATA(6132982)
		, T_TIPO_DATA(6132983)
		, T_TIPO_DATA(6132984)
		, T_TIPO_DATA(6132985)
		, T_TIPO_DATA(6132986)
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	--MODIFICAMOS EL ACT_NUM_ACTIVO AÑADIENDO EL PREFIJO 999 
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
   		V_MSQL := 'update '||V_ESQUEMA||'.act_activo
			  set act_num_activo = 999||act_num_activo,
				USUARIOMODIFICAR = '''||V_USUARIO||''',
				FECHAMODIFICAR = SYSDATE
		where act_num_activo ='||V_TMP_TIPO_DATA(1);
		EXECUTE IMMEDIATE V_MSQL;
        	V_SQL := 'select act_num_activo from '||V_ESQUEMA||'.act_activo where act_num_activo =999'|| V_TMP_TIPO_DATA(1);
        	EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('Actualizado el activo '||V_TMP_TIPO_DATA(1)||' con el ACT_NUM_ACTIVO: ' || V_SQL);
		
    END LOOP;

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


