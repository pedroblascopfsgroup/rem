--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201124
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8412
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar estado presupuesto trabajo
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_COUNT NUMBER(25);
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8412'; -- USUARIOCREAR/USUARIOMODIFICAR

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_TIPO_DATA IS TABLE OF T_TIPO_DATA; 
	V_TIPO_DATA T_ARRAY_TIPO_DATA := T_ARRAY_TIPO_DATA(
                -- NUM TRABAJO    ESTADO COD                                   
		T_TIPO_DATA('916964320805','02')
	); 
	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
 	LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0';        
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN 				
                
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO
                        SET DD_ESP_ID = (SELECT DD_ESP_ID FROM '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESUPUESTO WHERE DD_ESP_CODIGO = '''||V_TMP_TIPO_DATA(2)||''' AND BORRADO = 0)
                        WHERE TBJ_ID = (SELECT TBJ_ID FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0)
                        AND BORRADO = 0';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADO ESTADO PRESUPUESTO DEL TRABAJO '''||V_TMP_TIPO_DATA(1)||'''');
                
        ELSE
        
            DBMS_OUTPUT.PUT_LINE('EL TRABAJO '''||V_TMP_TIPO_DATA(1)||''' ESTA BORRADO O NO EXISTE');
        
        END IF;
    
    END LOOP;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;

END;

/

EXIT
