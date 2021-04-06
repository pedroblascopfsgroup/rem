--/*
--######################################### 
--## AUTOR=Ivan Repiso
--## FECHA_CREACION=20210326
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9118
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
	V_USU VARCHAR2(30 CHAR) := 'REMVIP-9118';
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'CFG_PVE_PREDETERMINADO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_NUM_TABLAS NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
				--CRA	SCR		TTR		PVE		PRV
		T_TIPO_DATA(43,	23,		3,	   140849,	8),
		T_TIPO_DATA(43,	163,	3,	   140849,	8),
		T_TIPO_DATA(43,	164,	3,	   140849,	8),
		T_TIPO_DATA(43,	165,	3,	   140849,	8),
		T_TIPO_DATA(43,	166,	3,	   140849,	8),
		T_TIPO_DATA(43,	167,	3,	   140849,	8),
		T_TIPO_DATA(43,	263,	3,	   140849,	8),
		T_TIPO_DATA(43,	283,	3,	   140849,	8)
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

	V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_CRA_ID = '||V_TMP_TIPO_DATA(1)||' AND DD_SCR_ID = '||V_TMP_TIPO_DATA(2)||'
				AND DD_TTR_ID = '||V_TMP_TIPO_DATA(3)||' AND PVE_ID = '||V_TMP_TIPO_DATA(4)||' AND DD_PRV_ID = '||V_TMP_TIPO_DATA(5)||' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 0 THEN

		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (CPP_ID,DD_CRA_ID,DD_SCR_ID,DD_TTR_ID,PVE_ID,USUARIOCREAR,FECHACREAR,DD_PRV_ID) VALUES (
					'||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL, '||V_TMP_TIPO_DATA(1)||','||V_TMP_TIPO_DATA(2)||','||V_TMP_TIPO_DATA(3)||','||V_TMP_TIPO_DATA(4)||',
					'''||V_USU||''',SYSDATE,'||V_TMP_TIPO_DATA(5)||')';
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADO REGISTRO EN '||V_TEXT_TABLA||': DD_CRA_ID -> '||V_TMP_TIPO_DATA(1)||' / DD_SCR_ID -> '||V_TMP_TIPO_DATA(2)||'
				/ DD_TTR_ID -> '||V_TMP_TIPO_DATA(3)||' / PVE_ID -> '||V_TMP_TIPO_DATA(4)||' / DD_PRV_ID -> '||V_TMP_TIPO_DATA(5)||'');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE REGISTRO: DD_CRA_ID -> '||V_TMP_TIPO_DATA(1)||' / DD_SCR_ID -> '||V_TMP_TIPO_DATA(2)||'
				/ DD_TTR_ID -> '||V_TMP_TIPO_DATA(3)||' / PVE_ID -> '||V_TMP_TIPO_DATA(4)||' / DD_PRV_ID -> '||V_TMP_TIPO_DATA(5)||'');

	END IF;
        
	END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN 
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejECVción:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT;