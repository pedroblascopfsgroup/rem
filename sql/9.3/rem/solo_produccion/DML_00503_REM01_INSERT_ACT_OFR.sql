--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201028
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8294
--## PRODUCTO=NO
--##
--## Finalidad: Insertar activo a oferta
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Ver1ón inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):= 'REMVIP-8294';
	
    V_OFERTA NUMBER(16):= 90277365;
    V_ACTIVO NUMBER(16):= 7040663;
    V_IMPORTE NUMBER(16):= 1900;
    V_PORCEN NUMBER(16,2):= 11.87;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    --Comprobamos el dato a insertar
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO 
              WHERE ACT_NUM_ACTIVO = '||V_ACTIVO||'
              AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
    IF V_NUM_TABLAS > 0 THEN	

      --Comprobamos el dato a insertar
      V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS 
                WHERE OFR_NUM_OFERTA = '||V_OFERTA||'
                AND BORRADO = 0';
      EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
          
      IF V_NUM_TABLAS > 0 THEN	

        --Comprobamos el dato a insertar
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_OFR 
                  WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO 
                                  WHERE ACT_NUM_ACTIVO = '||V_ACTIVO||'
                                  AND BORRADO = 0)
                  AND OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS 
                                WHERE OFR_NUM_OFERTA = '||V_OFERTA||'
                                AND BORRADO = 0)';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
            
        IF V_NUM_TABLAS > 0 THEN

          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_OFR (ACT_ID, OFR_ID, ACT_OFR_IMPORTE, OFR_ACT_PORCEN_PARTICIPACION) VALUES (
                      '||V_ACTIVO||','||V_OFERTA||', '||V_IMPORTE||','||V_PORCEN||')';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
        ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE EL ACTIVO '||V_ACTIVO||' EN LA OFERTA '||V_OFERTA||'');  

        END IF;

      ELSE
       
        DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE LA OFERTA '||V_OFERTA||'');  

      END IF;

    ELSE
       
      DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL ACTIVO '||V_ACTIVO||'');  

    END IF;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
   

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
