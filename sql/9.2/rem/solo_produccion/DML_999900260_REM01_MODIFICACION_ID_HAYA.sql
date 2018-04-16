--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180416
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-505
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_SEQ_GEH NUMBER(16);
	V_TIPO_ID NUMBER(16); --Vle para el id DD_TTR_TIPO_TRABAJO
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--act_num_activo	
		  T_TIPO_DATA(77086)
		, T_TIPO_DATA(112341)
		, T_TIPO_DATA(115314)
		, T_TIPO_DATA(132254)
		, T_TIPO_DATA(132255)
		, T_TIPO_DATA(136807)
		, T_TIPO_DATA(137819)
		, T_TIPO_DATA(137917)
		, T_TIPO_DATA(138093)
		, T_TIPO_DATA(140751)
		, T_TIPO_DATA(140757)
		, T_TIPO_DATA(140760)
		, T_TIPO_DATA(140762)
		, T_TIPO_DATA(141060)
		, T_TIPO_DATA(141061)
		, T_TIPO_DATA(145181)
		, T_TIPO_DATA(145390)
		, T_TIPO_DATA(153108)
		, T_TIPO_DATA(153109)
		, T_TIPO_DATA(153472)
		, T_TIPO_DATA(153475)
		, T_TIPO_DATA(153568)
		, T_TIPO_DATA(153720)
		, T_TIPO_DATA(153722)
		, T_TIPO_DATA(153723)
		, T_TIPO_DATA(155613)
		, T_TIPO_DATA(162624)
		, T_TIPO_DATA(162625)
		, T_TIPO_DATA(162867)
		, T_TIPO_DATA(162871)
		, T_TIPO_DATA(162873)
		, T_TIPO_DATA(162946)
		, T_TIPO_DATA(163156)
		, T_TIPO_DATA(163234)
		, T_TIPO_DATA(173932)
		, T_TIPO_DATA(175918)
		, T_TIPO_DATA(176276)
		, T_TIPO_DATA(183428)
		, T_TIPO_DATA(184036)
		, T_TIPO_DATA(188551)
		, T_TIPO_DATA(188552)
		, T_TIPO_DATA(194834)
		, T_TIPO_DATA(195003)
		, T_TIPO_DATA(195113)
		, T_TIPO_DATA(195114)
		, T_TIPO_DATA(195145)
		, T_TIPO_DATA(195146)
		, T_TIPO_DATA(195311)
		, T_TIPO_DATA(196897)
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
				USUARIOMODIFICAR = ''REMVIP-132'',
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


