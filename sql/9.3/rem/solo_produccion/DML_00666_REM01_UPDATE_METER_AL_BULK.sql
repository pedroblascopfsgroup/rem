--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210217
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8907
--## PRODUCTO=NO
--## 
--## Finalidad: Meter ofertas a bulk
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= '';
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-8907';

    OFR_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('90292243'),
			T_TIPO_DATA('90291783'),
			T_TIPO_DATA('90292215'),
			T_TIPO_DATA('90291570'),
			T_TIPO_DATA('90286294'),
			T_TIPO_DATA('90292166'),
			T_TIPO_DATA('90292638'),
			T_TIPO_DATA('90289835'),
			T_TIPO_DATA('90291151'),
			T_TIPO_DATA('90292218'),
			T_TIPO_DATA('90282679'),
			T_TIPO_DATA('90291265'),
			T_TIPO_DATA('90286895'),
			T_TIPO_DATA('90291758'),
			T_TIPO_DATA('90291233'),
			T_TIPO_DATA('90290919'),
			T_TIPO_DATA('90291222'),
			T_TIPO_DATA('90291373'),
			T_TIPO_DATA('90292448'),
			T_TIPO_DATA('90291530'),
			T_TIPO_DATA('90292082'),
			T_TIPO_DATA('90292031'),
			T_TIPO_DATA('90291484'),
			T_TIPO_DATA('90284203'),
			T_TIPO_DATA('90292053'),
			T_TIPO_DATA('90291239')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

		DBMS_OUTPUT.PUT_LINE('[INICIO] SACAR OFERTAS DEL BULK S000113/2021');

		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

			--Comprobamos que existe la oferta
			V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

			IF V_COUNT = 1 THEN

				V_MSQL := 'SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '''||V_TMP_TIPO_DATA(1)||'''';
				EXECUTE IMMEDIATE V_MSQL INTO OFR_ID;
			
				V_MSQL := ' UPDATE '||V_ESQUEMA||'.BLK_OFR SET 
							USUARIOBORRAR = null,
							FECHABORRAR = null,
							BORRADO = 0
							WHERE OFR_ID = '''||OFR_ID||''' AND BORRADO = 0';
				EXECUTE IMMEDIATE V_MSQL;

				V_MSQL := ' UPDATE '||V_ESQUEMA||'.H_OEB_OFR_EXCLUSION_BULK SET 
							OEB_EXCLUSION_BULK = 2,
							USUARIOMODIFICAR = '''||V_USUARIO||''',
							FECHAMODIFICAR = SYSDATE
							WHERE OFR_ID = '''||OFR_ID||''' AND OEB_FECHA_FIN IS NULL';
				EXECUTE IMMEDIATE V_MSQL;
				
				DBMS_OUTPUT.PUT_LINE('[INFO] LA OFERTA '''||V_TMP_TIPO_DATA(1)||''' SE HA SACADO DEL BULK CORRECTAMENTE.');

			ELSE 

				DBMS_OUTPUT.PUT_LINE('[INFO] LA OFERTA '''||V_TMP_TIPO_DATA(1)||''' NO EXISTE.');
			
			END IF;

		END LOOP;

		COMMIT;

		DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
