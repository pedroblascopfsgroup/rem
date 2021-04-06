--/*
--##########################################
--## AUTOR=Sergio Gomez
--## FECHA_CREACION=20210325
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13460
--## PRODUCTO=NO
--## Finalidad: Creación índices para V_COND_DISPONIBILIDAD
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_INDEX NUMBER(3); -- Vble. auxiliar para la numeración de índices
    V_TABLA VARCHAR2(50 CHAR); -- Vble. auxiliar para almacenar el nombres de tablas
    V_INDICE VARCHAR2(50 CHAR); -- Vble. auxiliar para almacenar el nombre del índice
    V_NUM_COLS_INDEX NUMBER(2);--  Vble. auxiliar que indica el numero de columnas a los que apunta el ínidce
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 

    --ARRAY PARA CREAR INDEX
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                -- Nombre INDEX                     TABLA                   COLUMNAS
        T_TIPO_DATA('IDX_TAG_DD_TAG_CODIGO', 'DD_TAG_TIPO_AGRUPACION', 'BORRADO,DD_TAG_CODIGO'),
        T_TIPO_DATA('IDX_HOR_INSC_ACT_ID_BORR', 'ACT_REG_INFO_REGISTRAL', 'BORRADO,ACT_ID,REG_DIV_HOR_INSCRITO'),
        T_TIPO_DATA('IDX_AGA_PPAL_ACT_ID', 'ACT_AGA_AGRUPACION_ACTIVO', 'BORRADO,AGA_PRINCIPAL,ACT_ID'),
        T_TIPO_DATA('IDX_SPS_OCUPADO_BORR', 'ACT_SPS_SIT_POSESORIA', 'BORRADO,SPS_OCUPADO'),
        T_TIPO_DATA('IDX_TPA_COD_BORR', 'DD_TPA_TIPO_TITULO_ACT', 'BORRADO,DD_TPA_CODIGO'),
        T_TIPO_DATA('IDX_EON_COD_BORR', 'DD_EON_ESTADO_OBRA_NUEVA', 'BORRADO,DD_EON_CODIGO'),
        T_TIPO_DATA('IDX_EAC_COD_BORR', 'DD_EAC_ESTADO_ACTIVO', 'BORRADO,DD_EAC_CODIGO'),
        T_TIPO_DATA('IDX_CRA_COD_BORR', 'DD_CRA_CARTERA', 'BORRADO,DD_CRA_CODIGO'),
        T_TIPO_DATA('IDX_ICO_POSIBLE_ACT_ID_ICO_ID_BORR', 'ACT_ICO_INFO_COMERCIAL', 'BORRADO,ICO_POSIBLE_HACER_INF,ICO_ID,ACT_ID')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    BEGIN

        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);    	

            V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = '''||V_TMP_TIPO_DATA(1)||'''';        
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 0 THEN
                V_MSQL := 'CREATE INDEX '||V_ESQUEMA||'.'||V_TMP_TIPO_DATA(1)||' ON '||V_ESQUEMA||'.'||V_TMP_TIPO_DATA(2)||' ('||V_TMP_TIPO_DATA(3)||') TABLESPACE '||V_TABLESPACE_IDX;		
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO] Indice '||V_TMP_TIPO_DATA(1)||' - creado.');
            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el índice '||V_TMP_TIPO_DATA(1)||'');
            END IF;
        END LOOP;
	COMMIT;



EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
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