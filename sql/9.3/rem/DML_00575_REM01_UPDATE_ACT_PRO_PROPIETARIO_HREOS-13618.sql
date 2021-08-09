--/*
--######################################### 
--## AUTOR=Daniel Gallego
--## FECHA_CREACION=20210407
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13618
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_PRO_PROPIETARIO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.



    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('1','BBVA ADJUDICADOS'),
            T_TIPO_DATA('2','BBVA CONSUMO 3 Fondo de Tit. de Activos'),
            T_TIPO_DATA('2','BBVA EMPRESAS 3 FTA'),
            T_TIPO_DATA('2','BBVA EMPRESAS 4 FTA'),
            T_TIPO_DATA('2','BBVA EMPRESAS 5 Fondo de Tit. de Activos'),
            T_TIPO_DATA('2','BBVA EMPRESAS 6 Fondo de Tit. de Activos'),
            T_TIPO_DATA('2','BBVA LEASING 1 Fondo de Tit. de Activos'),
            T_TIPO_DATA('2','BBVA RMBS 1 Fondo de Tit. de Activos'),
            T_TIPO_DATA('2','BBVA RMBS 10 Fondo de Tit. de Activos'),
            T_TIPO_DATA('2','BBVA RMBS 11FTA'),
            T_TIPO_DATA('2','BBVA RMBS 12 FONDO DE TITULIZACION DE ACTIVOS'),
            T_TIPO_DATA('2','BBVA RMBS 2 Fondo de Tit. de Activos'),
            T_TIPO_DATA('2','BBVA RMBS 3 Fondo de Tit. de Activos'),
            T_TIPO_DATA('2','BBVA RMBS 4 Fondo de Tit. de Activos'),
            T_TIPO_DATA('2','BBVA RMBS 5 Fondo de Tit. de Activos'),
            T_TIPO_DATA('2','BBVA RMBS 7 Fondo de Tit. de Activos'),
            T_TIPO_DATA('2','BBVA RMBS 9 Fondo de Tit. de Activos'),
            T_TIPO_DATA('2','BBVA-5 FTPYME Fondo de Tit. de Activos'),
            T_TIPO_DATA('2','BBVA-6 FTPYME Fondo de Tit. de Activos'),
            T_TIPO_DATA('2','GAT FTGENCAT 2006 FTA'),
            T_TIPO_DATA('2','GAT FTGENCAT 2007'),
            T_TIPO_DATA('2','GAT FTGENCAT 2008 FTA'),
            T_TIPO_DATA('2','GAT FTGENCAT 2009 FTA'),
            T_TIPO_DATA('2','GAT ICO FTVPO, FTH BBVA-9 PYME Fondo de Titulización de ActivosHIPOCAT 10 FTA'),
            T_TIPO_DATA('2','HIPOCAT 11 FTA'),
            T_TIPO_DATA('2','HIPOCAT 17 FTA'),
            T_TIPO_DATA('2','HIPOCAT 19 FTA'),
            T_TIPO_DATA('2','HIPOCAT 20 FTA'),
            T_TIPO_DATA('2','HIPOCAT 6 FTA'),
            T_TIPO_DATA('2','HIPOCAT 7 FTA'),
            T_TIPO_DATA('2','HIPOCAT 8 FTA'),
            T_TIPO_DATA('2','HIPOCAT 9 FTA'),
            T_TIPO_DATA('2','MBSCAT 1 FTA'),
            T_TIPO_DATA('2','MBSCAT 2 FTA'),
            T_TIPO_DATA('3','ACTIVOS MACORP, S.L.'),
            T_TIPO_DATA('3','ALCALÁ 120 PROMOS. Y G.IM. SL'),
            T_TIPO_DATA('3','ANIDA GRUPO INMOBILIARIO, S.L.'),
            T_TIPO_DATA('3','ANIDA OPERACIONES SINGULARES, SAU'),
            T_TIPO_DATA('3','ARRAHONA IMMO SLU'),
            T_TIPO_DATA('3','ARRAHONA NEXUS SLU'),
            T_TIPO_DATA('3','ARRELS CT FINSOL SAU'),
            T_TIPO_DATA('3','ARRELS CT PATRIMONI I PROJECTES SAU'),
            T_TIPO_DATA('3','CAIXA MANRESA ONCASA INMOBILIARIA S.L.'),
            T_TIPO_DATA('3','CAMARATE GOLF, S.A.'),
            T_TIPO_DATA('3','CATALONIA PROMODIS 4 SAU'),
            T_TIPO_DATA('3','CATALUNYACAIXA IMMOBILIARIA SAU'),
            T_TIPO_DATA('3','ECOARENYS S.L.'),
            T_TIPO_DATA('3','GESCAT GESTIÓ DE SÒL, S.L.'),
            T_TIPO_DATA('3','GESCAT LLOGUERS, S.L.'),
            T_TIPO_DATA('3','GESCAT VIVENDES EN COMERCIALITZACIÓ '),
            T_TIPO_DATA('3','JALE PROCAM SL F'),
            T_TIPO_DATA('3','FUNDACIÓ HABITATGE LLOGUER'),
            T_TIPO_DATA('3','PARCSUD PLANNER SLU'),
            T_TIPO_DATA('3','PORTICO PROCAM SL'),
            T_TIPO_DATA('3','PROMOCIONES MIES DEL VALLE, SL'),
            T_TIPO_DATA('3','PROMOTORA DEL VALLES SLU'),
            T_TIPO_DATA('3','PROMOU CT OPEN SEGRE SLU'),
            T_TIPO_DATA('3','PROMOU GLOBAL SLU'),
            T_TIPO_DATA('3','SATICEM HOLDING S.L.'),
            T_TIPO_DATA('3','SATICEM IMMOBLES EN ARRENDAMENT S.L.'),
            T_TIPO_DATA('3','UNNIM SDAD PARA LA GESTION DE ACTIVOS SA')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
  
    	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_EAC_ESTADO_ACTIVO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACIÓN EN ACT_PRO_PROPIETARIO ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        -- Comprobamos si existe la tabla   
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN 
        
          --Comprobamos el dato a insertar
          V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE PRO_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
          EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

          --Si existe modificamos los valores
          IF V_NUM_TABLAS > 0 THEN
	    DBMS_OUTPUT.PUT_LINE('SE ACTUALIZA EL CÓDIGO: ' || TRIM(V_TMP_TIPO_DATA(1)));
            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' SET
             DD_TSP_ID = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
            ,FECHAMODIFICAR = SYSDATE 
            WHERE PRO_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
            EXECUTE IMMEDIATE V_MSQL;            
          END IF;       
        END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ACT_PRO_PROPIETARIO MODIFICADA CORRECTAMENTE ');

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
