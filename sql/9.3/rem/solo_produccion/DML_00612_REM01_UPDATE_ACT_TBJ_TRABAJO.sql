--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210108
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8638
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar trabajos para que salgan en el buscador del gasto
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
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-8638';    

    V_TABLA_TRABAJO VARCHAR2(100 CHAR):= 'ACT_TBJ_TRABAJO';
    V_TABLA_PROPIETARIO VARCHAR2(100 CHAR):= 'ACT_PAC_PROPIETARIO_ACTIVO';

    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.

    V_COUNT NUMBER(16):=0; --Vble. para contar registros correctos
    V_COUNT_TOTAL NUMBER(16):=0; --Vble para contar registros totales
    
    	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		T_TIPO_DATA('9000251124'),
            T_TIPO_DATA('9000241166')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	    

    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZANDO TRABAJOS');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	    LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_TRABAJO||' WHERE TBJ_NUM_TRABAJO = '||V_TMP_TIPO_DATA(1)||'';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        --Si existe el trabajo
        IF V_NUM_TABLAS = 1 THEN
	
            V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_TRABAJO||' SET 
                        TBJ_FECHA_EMISION_FACTURA = NULL,  
                        PVC_ID = 2945,
                        FECHAMODIFICAR = SYSDATE,
                        USUARIOMODIFICAR = '''||V_USUARIO||'''
                        WHERE TBJ_NUM_TRABAJO = '''||V_TMP_TIPO_DATA(1)||'''';
            EXECUTE IMMEDIATE V_SQL;

            V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_PROPIETARIO||' SET 
                        PRO_ID = 3658,  
                        FECHAMODIFICAR = SYSDATE, 
                        USUARIOMODIFICAR = '''||V_USUARIO||'''
                        WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TRABAJO||' WHERE TBJ_NUM_TRABAJO = '||V_TMP_TIPO_DATA(1)||')';
            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: TRABAJO: '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO');

	    ELSE
            --Si no existe el trabajo
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL TRABAJO:'''||V_TMP_TIPO_DATA(1)||''' ');
        END IF;
    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: TRABAJOS ACTUALIZADOS CORRECTAMENTE');

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


