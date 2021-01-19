--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210118
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8713
--## PRODUCTO=NO
--##
--## Finalidad: 
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
    
    V_TABLA VARCHAR2(30 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL';  -- Tabla a modificar
    V_TABLA_OFERTA VARCHAR2(100 CHAR):='OFR_OFERTAS';
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-8713'; -- USUARIOCREAR/USUARIOMODIFICAR
    V_NUM_OFERTA VARCHAR2(100 CHAR):='90290997';
    V_COMITE_CODIGO VARCHAR2(100 CHAR):='34';
    
BEGIN	

		DBMS_OUTPUT.PUT_LINE('[INFO] Actualizacion en '||V_TABLA||'');

        V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_OFERTA||' WHERE OFR_NUM_OFERTA='||V_NUM_OFERTA||' AND BORRADO=0';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS=1 THEN

            V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COS_COMITES_SANCION WHERE DD_COS_CODIGO='||V_COMITE_CODIGO||' AND BORRADO=0';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS=1 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO] Se realiza la modificacion.');

                V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
                            SET DD_COS_ID = (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_COMITES_SANCION WHERE DD_COS_CODIGO='||V_COMITE_CODIGO||'),
                            SET DD_COS_ID_PROPUESTO = (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_COMITES_SANCION WHERE DD_COS_CODIGO='||V_COMITE_CODIGO||'),
                            USUARIOMODIFICAR = '''|| V_USR ||''',
                            FECHAMODIFICAR = SYSDATE
                            WHERE OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_OFERTA||' WHERE OFR_NUM_OFERTA='||V_NUM_OFERTA||')';

                EXECUTE IMMEDIATE V_MSQL;

            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] No existe el comite indicado '||V_COMITE_CODIGO||'');
            END IF;

        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] No existe la oferta indicada '||V_NUM_OFERTA||'');
        END IF;

        DBMS_OUTPUT.PUT_LINE('[FIN] Comité modificado correctamente.');
        
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