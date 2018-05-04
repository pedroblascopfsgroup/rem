--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20180504
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=HREOS-3924
--## PRODUCTO=NO
--##
--## Finalidad: 
--##           
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'APR_AUX_UPDATE_BIE_ADJ'; 
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('BIE_ADJ_F_DECRETO_N_FIRME','DATE'),
        T_TIPO_DATA('BIE_ADJ_F_DECRETO_FIRME','DATE'),
        T_TIPO_DATA('BIE_ADJ_IMPORTE_ADJUDICACION','NUMBER(16,2)'),
        T_TIPO_DATA('BIE_ADJ_F_ENTREGA_GESTOR','DATE'),
        T_TIPO_DATA('BIE_ADJ_F_PRESEN_HACIENDA','DATE'),
        T_TIPO_DATA('BIE_ADJ_F_PRESENT_REGISTRO','DATE'),
        T_TIPO_DATA('BIE_ADJ_F_ENVIO_ADICION','DATE'),
        T_TIPO_DATA('BIE_ADJ_F_SEGUNDA_PRESEN','DATE'),
        T_TIPO_DATA('BIE_ADJ_F_INSCRIP_TITULO','DATE'),
        T_TIPO_DATA('BIE_ADJ_F_RECPCION_TITULO','DATE'),
        T_TIPO_DATA('BIE_ADJ_LLAVES_NECESARIAS','NUMBER(1,0)'),
        T_TIPO_DATA('BIE_ADJ_F_RECEP_DEPOSITARIO','DATE')
        
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] INICIO DEL PROCESO');
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);    
		-- Comprobamos si existe la columna en APR_AUX_UPDATE_BIE_DATOS_REG
		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER =  '''|| V_ESQUEMA ||''' AND TABLE_NAME = '''||V_TEXT_TABLA||''' AND COLUMN_NAME =  '''||V_TMP_TIPO_DATA(1)||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
		IF V_NUM_TABLAS = 0 THEN 
			V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' ADD '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||'';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: '|| V_ESQUEMA || '.'||V_TEXT_TABLA||', COLUMNA AÑADIDA CON ÉXITO');
		ELSE    
			DBMS_OUTPUT.PUT_LINE('[INFO]: '|| V_ESQUEMA || '.'||V_TEXT_TABLA||', LA TABLA YA TIENE DICHA COLUMNA');
		END IF;
	END LOOP;
    COMMIT;
    
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] SE HA PRODUCIDO UN ERROR EN LA EJECUCIÓN:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;
