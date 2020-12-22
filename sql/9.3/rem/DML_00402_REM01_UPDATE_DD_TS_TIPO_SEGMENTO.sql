--/*
--######################################### 
--## AUTOR=KEVIN HONORATO
--## FECHA_CREACION=20201210
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-12376
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); --Vble .aux para almacenar el valor de la sequencia
    V_NUM_MAXID NUMBER(16); --Vble .aux para almacenar el valor maximo de 
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_TS_TIPO_SEGMENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'HREOS-12376';
    V_ID_TIPO_SEGMENTO NUMBER(16); --Vble para extraer el ID del registro a modificar, si procede.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'TS'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.




    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('00200','BC NO R'),
            T_TIPO_DATA('00201','SLA (R)'),
            T_TIPO_DATA('00202','BC POST'),
            T_TIPO_DATA('00203','NEW REO'),
            T_TIPO_DATA('00205','SLA (RECOMPRAS)'),
            T_TIPO_DATA('00206','SLA (T)'),
            T_TIPO_DATA('00210','SLA 4.1'),
            T_TIPO_DATA('00211','SLA 4.1 (n)'),
            T_TIPO_DATA('00212','SLA 4.1 (b)'),
            T_TIPO_DATA('00213','SLA 4.1 (b) (n)'),
            T_TIPO_DATA('00214','118 4.1'),
            T_TIPO_DATA('00215','118 4.1 (n)'),
            T_TIPO_DATA('00216','118 3.1.3'),
            T_TIPO_DATA('00217','SLA (ex118)'),
            T_TIPO_DATA('00218','NEW REO PF:ANFR'),
            T_TIPO_DATA('00219','NEW REO PF:ANFR'),
            T_TIPO_DATA('00220','NEW REO PF:ANFR'),
            T_TIPO_DATA('00221','NEW REO PF:ANFR-SUB'),
            T_TIPO_DATA('00222','NEW REO PF:HERC'),
            T_TIPO_DATA('00223','SLA 4.1 PF:HERC'),
            T_TIPO_DATA('00224','NEW REO PF:SNTR'),
            T_TIPO_DATA('00225','SLA 4.1 (b) PF:SNTR'),
            T_TIPO_DATA('00226','SLA (ex118) PF:SNTR'),
            T_TIPO_DATA('00227','SLA 4.1 (b) PF:JAIP'),
            T_TIPO_DATA('00228','SLA 4.1 PF:JAIP'),
            T_TIPO_DATA('00229','SLA (ex118) PF:JAIP'),
            T_TIPO_DATA('00230','SLA 4.1 PF:SARB'),
            T_TIPO_DATA('00231','SLA 4.3 PF:HERC'),
            T_TIPO_DATA('00232','SLA 4.3 PF:SNTR'),
            T_TIPO_DATA('00233','SLA 4.3 PF:SARB'),
            T_TIPO_DATA('00234','SLA 4.3'),           
            T_TIPO_DATA('00235','118 4.1 (a)'),
            T_TIPO_DATA('00236','118 3.1.3 (a)'),
            T_TIPO_DATA('00237','SLA (P)'),
            T_TIPO_DATA('00238','APORTADOS'),
            T_TIPO_DATA('00239','ESC NO R')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
  
    	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_TS_TIPO_SEGMENTO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TS_TIPO_SEGMENTO ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        -- Comprobamos si existe la tabla   
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN 
        
          --Comprobamos el dato a insertar
          V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

          --Si existe modificamos los valores
          IF V_NUM_TABLAS > 0 THEN
          
            V_MSQL := 'SELECT DD_TS_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID_TIPO_SEGMENTO;

            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
            'SET DD_TS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''''||
            ', DD_'||V_TEXT_CHARS||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
            ', DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
            ', USUARIOMODIFICAR = '''||V_INCIDENCIA||''' , FECHAMODIFICAR = SYSDATE '||
            'WHERE DD_'||V_TEXT_CHARS||'_ID = '''||V_ID_TIPO_SEGMENTO||'''';
            EXECUTE IMMEDIATE V_MSQL;            
          END IF;       
        END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TS_TIPO_SEGMENTO MODIFICADO CORRECTAMENTE ');

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

EXIT;
