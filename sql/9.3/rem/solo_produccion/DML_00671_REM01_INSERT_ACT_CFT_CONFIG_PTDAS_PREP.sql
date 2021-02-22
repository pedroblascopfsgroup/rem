--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210218
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8816
--## PRODUCTO=NO
--##
--## Finalidad: Insertar configuraciones
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONFIG_PTDAS_PREP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8816';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		--T_TIPO_DATA('SUBTIPO GASTO'1,'SUBCARTERA'2,'PROPIETARIO'3,'AÑO'4,'ARRENDAMIENTO'5,'VENDIDO'6)
		T_TIPO_DATA('27','56','593','2017','0','0'),
		T_TIPO_DATA('27','57','593','2017','0','0'),
		T_TIPO_DATA('27','56','593','2017','1','0'),
		T_TIPO_DATA('27','57','593','2017','1','0'),
		T_TIPO_DATA('27','56','593','2018','0','0'),
		T_TIPO_DATA('27','57','593','2018','0','0'),
		T_TIPO_DATA('27','56','593','2018','1','0'),
		T_TIPO_DATA('27','57','593','2018','1','0'),
		T_TIPO_DATA('27','56','593','2019','0','0'),
		T_TIPO_DATA('27','57','593','2019','0','0'),
		T_TIPO_DATA('27','56','593','2019','1','0'),
		T_TIPO_DATA('27','57','593','2019','1','0'),
		T_TIPO_DATA('27','56','593','2020','0','0'),
		T_TIPO_DATA('27','57','593','2020','0','0'),
		T_TIPO_DATA('27','56','593','2020','1','0'),
		T_TIPO_DATA('27','57','593','2020','1','0'),
		T_TIPO_DATA('27','56','593','2021','0','0'),
		T_TIPO_DATA('27','57','593','2021','0','0'),
		T_TIPO_DATA('27','56','593','2021','1','0'),
		T_TIPO_DATA('27','57','593','2021','1','0'),
		T_TIPO_DATA('27','56','589','2017','0','0'),
		T_TIPO_DATA('27','57','589','2017','0','0'),
		T_TIPO_DATA('27','56','589','2017','1','0'),
		T_TIPO_DATA('27','57','589','2017','1','0'),
		T_TIPO_DATA('27','56','589','2018','0','0'),
		T_TIPO_DATA('27','57','589','2018','0','0'),
		T_TIPO_DATA('27','56','589','2018','1','0'),
		T_TIPO_DATA('27','57','589','2018','1','0'),
		T_TIPO_DATA('27','56','589','2019','0','0'),
		T_TIPO_DATA('27','57','589','2019','0','0'),
		T_TIPO_DATA('27','56','589','2019','1','0'),
		T_TIPO_DATA('27','57','589','2019','1','0'),
		T_TIPO_DATA('27','56','589','2020','0','0'),
		T_TIPO_DATA('27','57','589','2020','0','0'),
		T_TIPO_DATA('27','56','589','2020','1','0'),
		T_TIPO_DATA('27','57','589','2020','1','0'),
		T_TIPO_DATA('27','56','589','2021','0','0'),
		T_TIPO_DATA('27','57','589','2021','0','0'),
		T_TIPO_DATA('27','56','589','2021','1','0'),
		T_TIPO_DATA('27','57','589','2021','1','0'),
		T_TIPO_DATA('26','56','593','2018','0','0'),
		T_TIPO_DATA('26','57','593','2018','0','0'),
		T_TIPO_DATA('26','56','593','2018','1','0'),
		T_TIPO_DATA('26','57','593','2018','1','0'),
		T_TIPO_DATA('26','56','593','2019','0','0'),
		T_TIPO_DATA('26','57','593','2019','0','0'),
		T_TIPO_DATA('26','56','593','2019','1','0'),
		T_TIPO_DATA('26','57','593','2019','1','0'),
		T_TIPO_DATA('26','56','593','2020','0','0'),
		T_TIPO_DATA('26','57','593','2020','0','0'),
		T_TIPO_DATA('26','56','593','2020','1','0'),
		T_TIPO_DATA('26','57','593','2020','1','0'),
		T_TIPO_DATA('26','56','593','2021','0','0'),
		T_TIPO_DATA('26','57','593','2021','0','0'),
		T_TIPO_DATA('26','56','593','2021','1','0'),
		T_TIPO_DATA('26','57','593','2021','1','0'),
		T_TIPO_DATA('26','56','593','2017','0','0'),
		T_TIPO_DATA('26','57','593','2017','0','0'),
		T_TIPO_DATA('26','56','593','2017','1','0'),
		T_TIPO_DATA('26','57','593','2017','1','0'),
		T_TIPO_DATA('26','56','589','2017','0','0'),
		T_TIPO_DATA('26','57','589','2017','0','0'),
		T_TIPO_DATA('26','56','589','2017','1','0'),
		T_TIPO_DATA('26','57','589','2017','1','0'),
		T_TIPO_DATA('26','56','589','2018','0','0'),
		T_TIPO_DATA('26','57','589','2018','0','0'),
		T_TIPO_DATA('26','56','589','2018','1','0'),
		T_TIPO_DATA('26','57','589','2018','1','0'),
		T_TIPO_DATA('26','56','589','2019','0','0'),
		T_TIPO_DATA('26','57','589','2019','0','0'),
		T_TIPO_DATA('26','56','589','2019','1','0'),
		T_TIPO_DATA('26','57','589','2019','1','0'),
		T_TIPO_DATA('26','56','589','2020','0','0'),
		T_TIPO_DATA('26','57','589','2020','0','0'),
		T_TIPO_DATA('26','56','589','2020','1','0'),
		T_TIPO_DATA('26','57','589','2020','1','0'),
		T_TIPO_DATA('26','56','589','2021','0','0'),
		T_TIPO_DATA('26','57','589','2021','0','0'),
		T_TIPO_DATA('26','56','589','2021','1','0'),
		T_TIPO_DATA('26','57','589','2021','1','0'),
		T_TIPO_DATA('26','56','589','2018','0','1'),
		T_TIPO_DATA('26','57','589','2018','0','1'),
		T_TIPO_DATA('26','56','589','2018','1','1'),
		T_TIPO_DATA('26','57','589','2018','1','1'),
		T_TIPO_DATA('26','56','589','2019','0','1'),
		T_TIPO_DATA('26','57','589','2019','0','1'),
		T_TIPO_DATA('26','56','589','2019','1','1'),
		T_TIPO_DATA('26','57','589','2019','1','1'),
		T_TIPO_DATA('26','56','589','2020','0','1'),
		T_TIPO_DATA('26','57','589','2020','0','1'),
		T_TIPO_DATA('26','56','589','2020','1','1'),
		T_TIPO_DATA('26','57','589','2020','1','1'),
		T_TIPO_DATA('26','56','589','2021','0','1'),
		T_TIPO_DATA('26','57','589','2021','0','1'),
		T_TIPO_DATA('26','56','589','2021','1','1'),
		T_TIPO_DATA('26','57','589','2021','1','1'),
		T_TIPO_DATA('26','56','589','2017','0','1'),
		T_TIPO_DATA('26','57','589','2017','0','1'),
		T_TIPO_DATA('26','56','589','2017','1','1'),
		T_TIPO_DATA('26','57','589','2017','1','1'),
		T_TIPO_DATA('27','56','589','2018','0','1'),
		T_TIPO_DATA('27','57','589','2018','0','1'),
		T_TIPO_DATA('27','56','589','2018','1','1'),
		T_TIPO_DATA('27','57','589','2018','1','1'),
		T_TIPO_DATA('27','56','589','2019','0','1'),
		T_TIPO_DATA('27','57','589','2019','0','1'),
		T_TIPO_DATA('27','56','589','2019','1','1'),
		T_TIPO_DATA('27','57','589','2019','1','1'),
		T_TIPO_DATA('27','56','589','2020','0','1'),
		T_TIPO_DATA('27','57','589','2020','0','1'),
		T_TIPO_DATA('27','56','589','2017','0','1'),
		T_TIPO_DATA('27','56','589','2020','1','1'),
		T_TIPO_DATA('27','57','589','2020','1','1'),
		T_TIPO_DATA('27','56','589','2021','0','1'),
		T_TIPO_DATA('27','57','589','2021','0','1'),
		T_TIPO_DATA('27','56','589','2021','1','1'),
		T_TIPO_DATA('27','57','589','2021','1','1'),
		T_TIPO_DATA('27','57','589','2017','0','1'),
		T_TIPO_DATA('27','56','589','2017','1','1'),
		T_TIPO_DATA('27','57','589','2017','1','1'),
		T_TIPO_DATA('26','56','593','2017','0','1'),
		T_TIPO_DATA('26','57','593','2017','0','1'),
		T_TIPO_DATA('26','56','593','2017','1','1'),
		T_TIPO_DATA('26','57','593','2017','1','1'),
		T_TIPO_DATA('26','56','593','2018','0','1'),
		T_TIPO_DATA('26','57','593','2018','0','1'),
		T_TIPO_DATA('26','56','593','2018','1','1'),
		T_TIPO_DATA('26','57','593','2018','1','1'),
		T_TIPO_DATA('26','56','593','2019','0','1'),
		T_TIPO_DATA('26','57','593','2019','0','1'),
		T_TIPO_DATA('26','56','593','2019','1','1'),
		T_TIPO_DATA('26','57','593','2019','1','1'),
		T_TIPO_DATA('26','56','593','2020','0','1'),
		T_TIPO_DATA('26','57','593','2020','0','1'),
		T_TIPO_DATA('26','56','593','2020','1','1'),
		T_TIPO_DATA('26','57','593','2020','1','1'),
		T_TIPO_DATA('26','56','593','2021','0','1'),
		T_TIPO_DATA('26','57','593','2021','0','1'),
		T_TIPO_DATA('26','56','593','2021','1','1'),
		T_TIPO_DATA('26','57','593','2021','1','1'),
		T_TIPO_DATA('27','56','593','2018','0','1'),
		T_TIPO_DATA('27','57','593','2018','0','1'),
		T_TIPO_DATA('27','56','593','2018','1','1'),
		T_TIPO_DATA('27','57','593','2018','1','1'),
		T_TIPO_DATA('27','56','593','2019','0','1'),
		T_TIPO_DATA('27','57','593','2019','0','1'),
		T_TIPO_DATA('27','56','593','2019','1','1'),
		T_TIPO_DATA('27','57','593','2019','1','1'),
		T_TIPO_DATA('27','56','593','2020','0','1'),
		T_TIPO_DATA('27','57','593','2020','0','1'),
		T_TIPO_DATA('27','56','593','2020','1','1'),
		T_TIPO_DATA('27','57','593','2020','1','1'),
		T_TIPO_DATA('27','56','593','2021','0','1'),
		T_TIPO_DATA('27','57','593','2021','0','1'),
		T_TIPO_DATA('27','56','593','2021','1','1'),
		T_TIPO_DATA('27','57','593','2021','1','1'),
		T_TIPO_DATA('27','56','593','2017','0','1'),
		T_TIPO_DATA('27','57','593','2017','0','1'),
		T_TIPO_DATA('27','56','593','2017','1','1'),
		T_TIPO_DATA('27','57','593','2017','1','1')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
    
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);
			
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
					CPP_PTDAS_ID,
					CPP_PARTIDA_PRESUPUESTARIA,
					DD_TGA_ID,
					DD_STG_ID,
					DD_TIM_ID,
					DD_CRA_ID,
					DD_SCR_ID,
					PRO_ID,
					EJE_ID,
					CPP_ARRENDAMIENTO,
					USUARIOCREAR,
					FECHACREAR,
					CPP_PRINCIPAL,
					DD_TBE_ID,
					CPP_APARTADO,
					CPP_CAPITULO,
					CPP_VENDIDO
					) VALUES
					(
					'||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,
					''004'',
					(SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = ''05''),
					(SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''),
					1,
					(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''08''),
					(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
					'||V_TMP_TIPO_DATA(3)||',
					(SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||V_TMP_TIPO_DATA(4)||'''),
					'||V_TMP_TIPO_DATA(5)||',
					'''||V_USUARIO||''',
					SYSDATE,
					1,
					(SELECT DD_TBE_ID FROM '||V_ESQUEMA||'.DD_TBE_TIPO_ACTIVO_BDE WHERE DD_TBE_CODIGO = ''01''),
					''05'',
					''15'',
					'||V_TMP_TIPO_DATA(6)||')';                          
		EXECUTE IMMEDIATE V_MSQL;
		
		IF SQL%ROWCOUNT = 1 THEN 
			DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado 1 registro.');
		ELSIF SQL%ROWCOUNT > 1 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO]: Se han insertado '||SQL%ROWCOUNT||' registros .');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO]: No se insertó ningún registro');
		END IF;
			
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

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
