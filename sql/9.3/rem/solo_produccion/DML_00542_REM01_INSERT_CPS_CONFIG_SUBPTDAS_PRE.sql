--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8400
--## PRODUCTO=NO
--##
--## Finalidad: Insertar config subpartidas
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'CPS_CONFIG_SUBPTDAS_PRE';
    V_MSQL VARCHAR2(4000 CHAR); -- Sentencia a ejecutar
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-8400';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.  
    V_COUNT NUMBER(16); --Vble para comprobar si existe registro con el codigo
	
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_TIPO_DATA IS TABLE OF T_TIPO_DATA; 
	V_TIPO_DATA T_ARRAY_TIPO_DATA := T_ARRAY_TIPO_DATA(
                    -- CCC          CPP     DESCRIPCION                             
		  T_TIPO_DATA('6222000002','PP007', 'REPARACIÓN Y CONSERVACIÓN'),
          T_TIPO_DATA('6222000002','PP008', 'HE MANTENIMIENTO REQUERIDO'),		
          T_TIPO_DATA('6222000002','PP009', 'HE MANTENIMIENTO NO REQUERIDO OBLIG.')
	); 
	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
 	LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE CPS_CUENTA_CONTABLE = '''||V_TMP_TIPO_DATA(1)||''' AND CPS_PARTIDA_PRESUPUESTARIA = '''||V_TMP_TIPO_DATA(2)||'''';        
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        --Si no existe el codigo se inserta			
		IF V_COUNT = 0 THEN 				
                   
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (CPS_CUENTA_CONTABLE, CPS_DESCRIPCION, CPS_PARTIDA_PRESUPUESTARIA, USUARIOCREAR, FECHACREAR) 
                        VALUES ('''||V_TMP_TIPO_DATA(1)||''','''||V_TMP_TIPO_DATA(3)||''','''||V_TMP_TIPO_DATA(2)||''',
                        '''||V_USUARIO||''', SYSDATE)';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADO CORRECTAMENTE CONFIGURACION DE CUENTA '''||V_TMP_TIPO_DATA(1)||''' Y PARTIDA '''||V_TMP_TIPO_DATA(2)||'''');
				
		ELSE
		
        	DBMS_OUTPUT.PUT_LINE('LA CONFIGURACION DE CUENTA '''||V_TMP_TIPO_DATA(1)||''' Y PARTIDA '''||V_TMP_TIPO_DATA(2)||''' YA EXISTE');
		
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