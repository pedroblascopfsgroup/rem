--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210217
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8985
--## PRODUCTO=NO
--##
--## Finalidad: Insertar activos a oferta
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
    V_USUARIO VARCHAR2(100 CHAR):= 'REMVIP-8985';
	
    V_OFERTA NUMBER(16):= 90297940;

    	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('7281409', '54000', '43.32'),
            T_TIPO_DATA('7281352', '6750', '5.42'),
            T_TIPO_DATA('7281388', '1350', '1.08'),
            T_TIPO_DATA('7281411', '52650', '42.24'),
            T_TIPO_DATA('7281378', '7920', '6.35'),
            T_TIPO_DATA('7281382', '1980', '1.59')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

  V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '||V_OFERTA||' AND BORRADO = 0';
  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN	

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

      --Comprobamos el dato a insertar
      V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0';
      EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
                    
      IF V_NUM_TABLAS > 0 THEN	

        --Comprobamos el dato a insertar
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_OFR WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0)
                  AND OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '||V_OFERTA||' AND BORRADO = 0)';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
            
        IF V_NUM_TABLAS = 0 THEN

          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_OFR (ACT_ID, OFR_ID, ACT_OFR_IMPORTE, OFR_ACT_PORCEN_PARTICIPACION) VALUES (
                      (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0),
                      (SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '||V_OFERTA||' AND BORRADO = 0),
                      '||V_TMP_TIPO_DATA(2)||',
                      '||V_TMP_TIPO_DATA(3)||'
                      )';
          EXECUTE IMMEDIATE V_MSQL;

          DBMS_OUTPUT.PUT_LINE('[INFO]: SE HA INSERTADO EL ACTIVO '||V_TMP_TIPO_DATA(1)||' EN LA OFERTA '||V_OFERTA||'');
        
        ELSE
      
          V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_OFR SET
                    ACT_OFR_IMPORTE = '||V_TMP_TIPO_DATA(2)||',
                    VERSION = 1,
                    OFR_ACT_PORCEN_PARTICIPACION = '||V_TMP_TIPO_DATA(3)||'
                    WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0) AND
                    OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '||V_OFERTA||' AND BORRADO = 0)';
          EXECUTE IMMEDIATE V_MSQL;

          DBMS_OUTPUT.PUT_LINE('[INFO]: SE HA MODIFICADO EL ACTIVO '||V_TMP_TIPO_DATA(1)||' DE LA OFERTA '||V_OFERTA||'');

        END IF;

      ELSE
      
        DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL ACTIVO '||V_TMP_TIPO_DATA(1)||'');  

      END IF;

    END LOOP;

  ELSE
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE LA OFERTA '||V_OFERTA||'');  

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
