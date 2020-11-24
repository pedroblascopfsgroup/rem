--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201124
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8391
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar fecha rec advisory y autorizacion propiedad
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8391'; -- USUARIOCREAR/USUARIOMODIFICAR

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_TIPO_DATA IS TABLE OF T_TIPO_DATA; 
	V_TIPO_DATA T_ARRAY_TIPO_DATA := T_ARRAY_TIPO_DATA(
                -- NUM OFERTA    FECHA     CAMPO                              
		T_TIPO_DATA('6012983','07/04/2020', 'fechaRecomendacionCes'),
        T_TIPO_DATA('6012527','07/04/2020', 'fechaAprobacionProManzana'),		
        T_TIPO_DATA('90273414','16/10/2020', 'fechaRecomendacionCes'),
        T_TIPO_DATA('90273414','22/10/2020', 'fechaAprobacionProManzana')
	); 
	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
 	LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        IF V_TMP_TIPO_DATA(3) = 'fechaAprobacionProManzana' THEN

            V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0';        
            EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

            IF V_COUNT = 1 THEN 				
                    
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS SET OFR_FECHA_RESOLUCION_CES = TO_DATE('''||V_TMP_TIPO_DATA(2)||''',''DD/MM/YYYY'')
                            WHERE OFR_NUM_OFERTA = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADA FECHA APROBACIÓN PROPIEDAD DE LA OFERTA '''||V_TMP_TIPO_DATA(1)||'''');
                    
            ELSE
            
                DBMS_OUTPUT.PUT_LINE('LA OFERTA '''||V_TMP_TIPO_DATA(1)||''' ESTA BORRADA O NO EXISTE');
            
            END IF;

        ELSE 

            V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0';        
            EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

            IF V_COUNT = 1 THEN 				
                    
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET ECO_FECHA_RECOMENDACION_CES = TO_DATE('''||V_TMP_TIPO_DATA(2)||''',''DD/MM/YYYY'')
                            WHERE OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0)
                            AND BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADA FECHA RESPUESTA RECOMENDACION ADVISORY EN EL EXPEDIENTE DE LA OFERTA '''||V_TMP_TIPO_DATA(1)||'''');
                    
            ELSE
            
                DBMS_OUTPUT.PUT_LINE('LA OFERTA '''||V_TMP_TIPO_DATA(1)||''' ESTA BORRADA O NO EXISTE');    

            END IF;

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
