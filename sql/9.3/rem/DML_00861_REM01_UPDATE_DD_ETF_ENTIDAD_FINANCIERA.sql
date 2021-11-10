--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20211011
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15566
--## PRODUCTO=NO
--##
--## Finalidad: Insertar nuevas entidades financieras
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
       
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#REMMASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(50 CHAR):= 'DD_ETF_ENTIDAD_FINANCIERA';
    V_MSQL VARCHAR2(4000 CHAR); -- Sentencia a ejecutar
    V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-15566';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.  
    
    V_COUNT NUMBER(16); --Vble para comprobar si existe registro con el codigo

	
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_TIPO_DATA IS TABLE OF T_TIPO_DATA; 
	V_TIPO_DATA T_ARRAY_TIPO_DATA := T_ARRAY_TIPO_DATA(
                 -- COD_REM  COD_SF
		  T_TIPO_DATA('02','3058'),
          T_TIPO_DATA('03','2048'),		
          T_TIPO_DATA('04','49'),
          T_TIPO_DATA('05','182'),
          T_TIPO_DATA('06','1465'),
          T_TIPO_DATA('07','0001'),
          T_TIPO_DATA('08','2100'),
          T_TIPO_DATA('09','81'),
          T_TIPO_DATA('10','128'),
          T_TIPO_DATA('11','19'),
          T_TIPO_DATA('12','61'),
          T_TIPO_DATA('13','235'),
          T_TIPO_DATA('14','2080'),
          T_TIPO_DATA('15','186'),
          T_TIPO_DATA('16','239'),
          T_TIPO_DATA('17','2085'),
          T_TIPO_DATA('19','2103'),
          T_TIPO_DATA('20','0')
	); 
	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
 	LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_ETF_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0 ';        
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBACION CORRECTA');		

		IF V_COUNT = 1 THEN 	

            DBMS_OUTPUT.PUT_LINE('[INFO] INICIANDO PROCESO MODIFICACION');			
                   
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET DD_ETF_CODIGO_SF = '''||V_TMP_TIPO_DATA(2)||''',
                        USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
                        WHERE DD_ETF_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADO CORRECTAMENTE ENTIDAD CON CODIGO '''||V_TMP_TIPO_DATA(1)||''' ');
				
		ELSE
		
        	DBMS_OUTPUT.PUT_LINE('LA ENTIDAD FINANCIERA CON CODIGO '''||V_TMP_TIPO_DATA(1)||''' NO EXISTE');
		
        END IF;
    
    END LOOP;
    
	DBMS_OUTPUT.PUT_LINE('[FIN] ');
    
    COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;