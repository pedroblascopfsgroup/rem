--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=201800530
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-932
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
	V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-932';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_SEQ_GEH NUMBER(16);
	V_TIPO_ID NUMBER(16); --Vle para el id DD_TTR_TIPO_TRABAJO
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--act_num_activo	
		   T_TIPO_DATA(187645)
		 , T_TIPO_DATA(196243)
		 , T_TIPO_DATA(187329)
		 , T_TIPO_DATA(196244)
		 , T_TIPO_DATA(194356)
		 , T_TIPO_DATA(196601)
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


