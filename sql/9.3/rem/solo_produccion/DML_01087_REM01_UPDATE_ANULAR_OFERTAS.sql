--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20211117
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10780
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Insertar config proveedores
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejECVtar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USU VARCHAR2(30 CHAR) := 'REMVIP-10780';
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'CFG_PVE_PREDETERMINADO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_NUM_TABLAS NUMBER(16);


	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
				--CRA	SCR	
				T_TIPO_DATA('90351704'),
                T_TIPO_DATA('90346102'),
                T_TIPO_DATA('90352372'),
                T_TIPO_DATA('90346624'),
                T_TIPO_DATA('90353283')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

	V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR 
                JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID=OFR.OFR_ID AND ECO.BORRADO = 0
                WHERE OFR.OFR_NUM_OFERTA = '''||V_TMP_TIPO_DATA(1)||''' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 1 THEN

            --Actualizamos configuracion para BFA
        V_MSQL:= 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS SET
        DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE BORRADO = 0 AND DD_EOF_CODIGO= ''02'' ),
        USUARIOMODIFICAR = '''|| V_USU ||''',
        FECHAMODIFICAR = SYSDATE
        WHERE OFR_NUM_OFERTA = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] actualizados en oferta '||SQL%ROWCOUNT||' registros');

        V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET
        DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE BORRADO = 0 AND DD_EEC_CODIGO= ''02'' ),
        USUARIOMODIFICAR = '''|| V_USU ||''',
        FECHAMODIFICAR = SYSDATE
        WHERE OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0 )';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] actualizados en expediente '||SQL%ROWCOUNT||' registros');
        
        
        
        DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADO CORRECTAMENTE ESTADOS OFERTA '''||V_TMP_TIPO_DATA(1)||''' ');
        

	ELSE

		DBMS_OUTPUT.PUT_LINE('[ERROR]: NO EXISTE OFERTA '''||V_TMP_TIPO_DATA(1)||'''');

	END IF;
        
	END LOOP;

    COMMIT;

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

EXIT;