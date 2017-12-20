--/*
--##########################################
--## AUTOR=Sergio Belenguer Gadea
--## FECHA_CREACION=20171219
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMNIVDOS-2764
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'PFSREM'; -- Configuracion Esquema
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
    	--		BIE_ENTIDAD_ID	
		T_TIPO_DATA(117292),
		T_TIPO_DATA(117362),
		T_TIPO_DATA(99910),
		T_TIPO_DATA(99782),
		T_TIPO_DATA(100033),
		T_TIPO_DATA(120747),
		T_TIPO_DATA(118590),
		T_TIPO_DATA(100288),
		T_TIPO_DATA(117577),
		T_TIPO_DATA(100289),
		T_TIPO_DATA(117120),
		T_TIPO_DATA(120748),
		T_TIPO_DATA(117363),
		T_TIPO_DATA(120749),
		T_TIPO_DATA(121362),
		T_TIPO_DATA(118440),
		T_TIPO_DATA(117578),
		T_TIPO_DATA(118265),
		T_TIPO_DATA(193277),
		T_TIPO_DATA(200316),
		T_TIPO_DATA(160833),
		T_TIPO_DATA(93084),
		T_TIPO_DATA(79115),
		T_TIPO_DATA(77289),
		T_TIPO_DATA(78694),
		T_TIPO_DATA(122019),
		T_TIPO_DATA(121080),
		T_TIPO_DATA(126175),
		T_TIPO_DATA(122462),
		T_TIPO_DATA(126253),
		T_TIPO_DATA(120907),
		T_TIPO_DATA(126254),
		T_TIPO_DATA(122179),
		T_TIPO_DATA(121509),
		T_TIPO_DATA(120825),
		T_TIPO_DATA(121222),
		T_TIPO_DATA(122334),
		T_TIPO_DATA(104572),
		T_TIPO_DATA(122432),
		T_TIPO_DATA(120826),
		T_TIPO_DATA(122335),
		T_TIPO_DATA(121510),
		T_TIPO_DATA(122336),
		T_TIPO_DATA(104449),
		T_TIPO_DATA(122180),
		T_TIPO_DATA(121223),
		T_TIPO_DATA(126355),
		T_TIPO_DATA(104113),
		T_TIPO_DATA(121224),
		T_TIPO_DATA(121511),
		T_TIPO_DATA(119022),
		T_TIPO_DATA(123980),
		T_TIPO_DATA(152413),
		T_TIPO_DATA(124190),
		T_TIPO_DATA(124421),
		T_TIPO_DATA(125019),
		T_TIPO_DATA(140534),
		T_TIPO_DATA(140535),
		T_TIPO_DATA(140655)
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en TMP_APROV_DACIONES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.TMP_APROV_DACIONES... Empezando a insertar datos en la tabla TMP_APROV_DACIONES');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
   		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_APROV_DACIONES(BIE_ENTIDAD_ID)
			  VALUES('||V_TMP_TIPO_DATA(1)||')';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('INSERTANDO BIE_ENTIDAD_ID: '''||V_TMP_TIPO_DATA(1)||'''');
		
    END LOOP;
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


