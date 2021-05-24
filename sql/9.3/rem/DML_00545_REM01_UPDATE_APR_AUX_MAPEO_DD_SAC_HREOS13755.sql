--/*
--######################################### 
--## AUTOR=Sergio Gomez
--## FECHA_CREACION=20210419
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13755
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'APR_AUX_MAPEO_DD_SAC'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'HREOS-13755';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                    --DD_CODIGO_SUBTIPO_REC     DD_CODIGO_TUD_REM
                    --(Código Prisma)           (Mapeo existente en REM)
                T_TIPO_DATA('0904', '01'),
                T_TIPO_DATA('0905','01'),
                T_TIPO_DATA('0906','01'),
                T_TIPO_DATA('0907','01'),
                T_TIPO_DATA('0908','02'),
                T_TIPO_DATA('0909','02'),
                T_TIPO_DATA('0910','02'),
                T_TIPO_DATA('0911','07'),
                T_TIPO_DATA('0912','02'),
                T_TIPO_DATA('0913','02'),
                T_TIPO_DATA('0914','02'),
                T_TIPO_DATA('0915','03'),
                T_TIPO_DATA('0916','03'),
                T_TIPO_DATA('0917','03'),
                T_TIPO_DATA('0918','03'),
                T_TIPO_DATA('0919','02'),
                T_TIPO_DATA('0920','02'),
                T_TIPO_DATA('0921','02'),
                T_TIPO_DATA('0922','03'),
                T_TIPO_DATA('0923','02'),
                T_TIPO_DATA('0924','03'),
                T_TIPO_DATA('0925','01'),
                T_TIPO_DATA('0926','02'),
                T_TIPO_DATA('0927','05'),
                T_TIPO_DATA('0928','05'),
                T_TIPO_DATA('0929','05'),
                T_TIPO_DATA('0930','05'),
                T_TIPO_DATA('0931','05'),
                T_TIPO_DATA('0932','06'),
                T_TIPO_DATA('0933','04'),
                T_TIPO_DATA('0934','07'),
                T_TIPO_DATA('0935','05'),
                T_TIPO_DATA('0936','04'),
                T_TIPO_DATA('0937','04'),
                T_TIPO_DATA('0938','02'),
                T_TIPO_DATA('0939','04'),
                T_TIPO_DATA('0940','05'),
                T_TIPO_DATA('0941','04'),
                T_TIPO_DATA('0942','01'),
                T_TIPO_DATA('0943','04'),
                T_TIPO_DATA('0946','03'),
                T_TIPO_DATA('0947','03'),
                T_TIPO_DATA('0948','03'),
                T_TIPO_DATA('0949','02'),
                T_TIPO_DATA('0950','02'),
                T_TIPO_DATA('0951','02'),
                T_TIPO_DATA('SU00','05'),
                T_TIPO_DATA('SU04','05')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
  
    	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_EAC_ESTADO_ACTIVO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACIÓN EN APR_AUX_MAPEO_DD_SAC');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        -- Comprobamos si existe la tabla   
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN 
        
          --Comprobamos el dato a insertar
          V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_CODIGO_SUBTIPO_REC = '''||TRIM(V_TMP_TIPO_DATA(1))||''' 
                    AND DD_CODIGO_TUD_REM = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
          EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

          --Si NO COINCIDEN LOS DOS CAMPOS modificamos los valores
          IF V_NUM_TABLAS = 0 THEN
	        DBMS_OUTPUT.PUT_LINE('SE ACTUALIZA EL CÓDIGO: ' || TRIM(V_TMP_TIPO_DATA(1)));
            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' SET
            DD_CODIGO_TUD_REM = '''||TRIM(V_TMP_TIPO_DATA(2))||''', 
            USUARIOMODIFICAR = '''||V_INCIDENCIA||''', 
            FECHAMODIFICAR = SYSDATE 
            WHERE DD_CODIGO_SUBTIPO_REC = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('SE ACTUALIZA ESTE REGISTRO: DD_CODIGO_SUBTIPO_REC ' || TRIM(V_TMP_TIPO_DATA(1)) 
                                    || 'Y DD_CODIGO_TUD_REM ' || TRIM(V_TMP_TIPO_DATA(2)));              
          ELSE
            DBMS_OUTPUT.PUT_LINE('YA EXISTE ESTE REGISTRO: DD_CODIGO_SUBTIPO_REC ' || TRIM(V_TMP_TIPO_DATA(1)) 
                                    || 'Y DD_CODIGO_TUD_REM ' || TRIM(V_TMP_TIPO_DATA(2)));              
          END IF;

        END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: APR_AUX_MAPEO_DD_SAC MODIFICADO CORRECTAMENTE ');

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
