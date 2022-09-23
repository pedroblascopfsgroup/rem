--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220901
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12355
--## PRODUCTO=NO
--##
--## Finalidad: Se añaden datos a la tabla ACT_TIT_TITULO y ACT_AHT_HIST_TRAM_TITULO
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_WHERE VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_WHERE_TIT VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
	V_USUARIO VARCHAR2(150 CHAR):='REMVIP-12355';
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
        T_FUNCION(7519335),
        T_FUNCION(7519338),
        T_FUNCION(7519347),
        T_FUNCION(7519352),
        T_FUNCION(7519353),
        T_FUNCION(7519354),
        T_FUNCION(7519357),
        T_FUNCION(7519358),
        T_FUNCION(7519361),
        T_FUNCION(7519362),
        T_FUNCION(7519365),
        T_FUNCION(7519366),
        T_FUNCION(7519367),
        T_FUNCION(7519371),
        T_FUNCION(7519372),
        T_FUNCION(7519373),
        T_FUNCION(7519374),
        T_FUNCION(7519375),
        T_FUNCION(7519376),
        T_FUNCION(7519382),
        T_FUNCION(7519383),
        T_FUNCION(7519384),
        T_FUNCION(7519386),
        T_FUNCION(7519387),
        T_FUNCION(7519388),
        T_FUNCION(7519390),
        T_FUNCION(7519391),
        T_FUNCION(7519392),
        T_FUNCION(7519393),
        T_FUNCION(7519400),
        T_FUNCION(7519401),
        T_FUNCION(7519402),
        T_FUNCION(7519403),
        T_FUNCION(7519404),
        T_FUNCION(7519405),
        T_FUNCION(7519413),
        T_FUNCION(7519414),
        T_FUNCION(7519416),
        T_FUNCION(7519417),
        T_FUNCION(7519421),
        T_FUNCION(7519422),
        T_FUNCION(7519427),
        T_FUNCION(7519428),
        T_FUNCION(7519442),
        T_FUNCION(7519443),
        T_FUNCION(7519449),
        T_FUNCION(7519450),
        T_FUNCION(7519455),
        T_FUNCION(7519456),
        T_FUNCION(7519458),
        T_FUNCION(7519459),
        T_FUNCION(7519479),
        T_FUNCION(7519480),
        T_FUNCION(7519481),
        T_FUNCION(7519482),
        T_FUNCION(7519483),
        T_FUNCION(7519486),
        T_FUNCION(7519487),
        T_FUNCION(7519490),
        T_FUNCION(7519491),
        T_FUNCION(7519492),
        T_FUNCION(7519493),
        T_FUNCION(7519494),
        T_FUNCION(7519497),
        T_FUNCION(7519498),
        T_FUNCION(7519513),
        T_FUNCION(7519514),
        T_FUNCION(7519518),
        T_FUNCION(7519519),
        T_FUNCION(7519520),
        T_FUNCION(7519528),
        T_FUNCION(7519529),
        T_FUNCION(7519434),
        T_FUNCION(7519368),
        T_FUNCION(7519326),
        T_FUNCION(7519331),
        T_FUNCION(7519439),
        T_FUNCION(7519410),
        T_FUNCION(7519441),
        T_FUNCION(7519415),
        T_FUNCION(7519418),
        T_FUNCION(7519552),
        T_FUNCION(7519551),
        T_FUNCION(7519445),
        T_FUNCION(7519321),
        T_FUNCION(7519369),
        T_FUNCION(7519370),
        T_FUNCION(7519446),
        T_FUNCION(7519420),
        T_FUNCION(7519424),
        T_FUNCION(7519336),
        T_FUNCION(7519426),
        T_FUNCION(7519337),
        T_FUNCION(7519547),
        T_FUNCION(7519340),
        T_FUNCION(7519377),
        T_FUNCION(7519378),
        T_FUNCION(7519341),
        T_FUNCION(7519342),
        T_FUNCION(7519379),
        T_FUNCION(7519380),
        T_FUNCION(7519381),
        T_FUNCION(7519385),
        T_FUNCION(7519389),
        T_FUNCION(7519550),
        T_FUNCION(7519448),
        T_FUNCION(7519343),
        T_FUNCION(7519394),
        T_FUNCION(7519348),
        T_FUNCION(7519395),
        T_FUNCION(7519429),
        T_FUNCION(7519451),
        T_FUNCION(7519396),
        T_FUNCION(7519397),
        T_FUNCION(7519349),
        T_FUNCION(7519350),
        T_FUNCION(7519351),
        T_FUNCION(7519398),
        T_FUNCION(7519399),
        T_FUNCION(7519406),
        T_FUNCION(7519355),
        T_FUNCION(7519356),
        T_FUNCION(7519324),
        T_FUNCION(7519431),
        T_FUNCION(7519407),
        T_FUNCION(7519432),
        T_FUNCION(7519433),
        T_FUNCION(7519359),
        T_FUNCION(7519408),
        T_FUNCION(7519545),
        T_FUNCION(7519543),
        T_FUNCION(7519409),
        T_FUNCION(7519544),
        T_FUNCION(7519360),
        T_FUNCION(7519325),
        T_FUNCION(7519363),
        T_FUNCION(7519464),
        T_FUNCION(7519472),
        T_FUNCION(7519477),
        T_FUNCION(7519478),
        T_FUNCION(7519364),
        T_FUNCION(7519488),
        T_FUNCION(7519540),
        T_FUNCION(7519489),
        T_FUNCION(7519495),
        T_FUNCION(7519496),
        T_FUNCION(7519509),
        T_FUNCION(7519548)
    );          
    V_TMP_FUNCION T_FUNCION;
                
BEGIN	        
	            
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	            
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
        V_TMP_FUNCION := V_FUNCION(I);

            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT  WHERE ACT.ACT_NUM_ACTIVO = '''||(V_TMP_FUNCION(1))||''' AND ACT.BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;			

			IF V_NUM_TABLAS = 1 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Existe el activo se procede a actualizar.'''||(V_TMP_FUNCION(1))||'''');
                
                V_WHERE := '(SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||(V_TMP_FUNCION(1))||''' AND BORRADO = 0)';
                V_WHERE_TIT := '(SELECT TIT_ID FROM '||V_ESQUEMA||'.ACT_TIT_TITULO WHERE ACT_ID = '||V_WHERE||' AND BORRADO = 0)';

                V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO SET
                        PAC_CHECK_ADMISION = 1,
                        PAC_FECHA_ADMISION = SYSDATE,
                        USUARIOMODIFICAR = '''||V_USUARIO||''',
                        FECHAMODIFICAR = SYSDATE
                        WHERE ACT_ID = '||V_WHERE||' AND BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL;

			    DBMS_OUTPUT.PUT_LINE('[INFO]: CHECK ADMISION MARCADO');
                
                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO (
                            AHT_ID, TIT_ID, AHT_FECHA_PRES_REGISTRO, AHT_FECHA_INSCRIPCION, DD_ESP_ID, USUARIOCREAR, FECHACREAR
                            ) VALUES (
                            '||V_ESQUEMA||'.S_ACT_AHT_HIST_TRAM_TITULO.NEXTVAL,
                            '||V_WHERE_TIT||',
                            TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
                            TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
                            (SELECT DD_ESP_ID FROM '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION WHERE DD_ESP_CODIGO = ''03'' AND BORRADO = 0),
                            '''||V_USUARIO||''',SYSDATE)';
                EXECUTE IMMEDIATE V_MSQL;    

                DBMS_OUTPUT.PUT_LINE('[INFO]: HISTORICO REGISTRO INSERTADO');

                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_TIT_TITULO SET
                            TIT_FECHA_INSC_REG = TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
                            DD_ETI_ID = (SELECT DD_ETI_ID FROM '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO WHERE BORRADO = 0 AND DD_ETI_CODIGO=''02''),
                            USUARIOMODIFICAR = '''||V_USUARIO||''',FECHAMODIFICAR = SYSDATE
                            WHERE ACT_ID = '||V_WHERE||' AND BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL;    

                DBMS_OUTPUT.PUT_LINE('[INFO]: TITULO ACTIVO ACTUALIZADO');

                DBMS_OUTPUT.PUT_LINE('[INFO] Datos actualizados correctamente.'''||(V_TMP_FUNCION(1))||'''');
			ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] No existe el activo indicado: '''||(V_TMP_FUNCION(1))||'''');
		    END IF;	
      END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: Historico presentaciones ACTUALIZADO CORRECTAMENTE ');

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