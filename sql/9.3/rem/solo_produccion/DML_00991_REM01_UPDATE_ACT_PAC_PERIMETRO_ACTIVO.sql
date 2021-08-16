--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210805
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10248
--## PRODUCTO=NO
--##
--## Finalidad: Script para marcar checks
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
    V_NUM NUMBER(16); -- Vble. auxiliar para almacenar el número de registros
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_PAC_PERIMETRO_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10248'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_ACT_ID NUMBER(16);
	V_COUNT NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(1024);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --	ACTIVO
            T_TIPO_DATA(' 7434050 '),
            T_TIPO_DATA(' 7434052 '),
            T_TIPO_DATA(' 7434053 '),
            T_TIPO_DATA(' 7434054 '),
            T_TIPO_DATA(' 7434055 '),
            T_TIPO_DATA(' 7434057 '),
            T_TIPO_DATA(' 7434058 '),
            T_TIPO_DATA(' 7434059 '),
            T_TIPO_DATA(' 7434060 '),
            T_TIPO_DATA(' 7434061 '),
            T_TIPO_DATA(' 7434062 '),
            T_TIPO_DATA(' 7434063 '),
            T_TIPO_DATA(' 7434064 '),
            T_TIPO_DATA(' 7434065 '),
            T_TIPO_DATA(' 7434066 '),
            T_TIPO_DATA(' 7434067 '),
            T_TIPO_DATA(' 7434068 '),
            T_TIPO_DATA(' 7434069 '),
            T_TIPO_DATA(' 7434070 '),
            T_TIPO_DATA(' 7434071 '),
            T_TIPO_DATA(' 7434073 '),
            T_TIPO_DATA(' 7434074 '),
            T_TIPO_DATA(' 7434075 '),
            T_TIPO_DATA(' 7434076 '),
            T_TIPO_DATA(' 7434077 '),
            T_TIPO_DATA(' 7434078 '),
            T_TIPO_DATA(' 7434079 '),
            T_TIPO_DATA(' 7434080 '),
            T_TIPO_DATA(' 7434081 '),
            T_TIPO_DATA(' 7434082 '),
            T_TIPO_DATA(' 7434083 '),
            T_TIPO_DATA(' 7434084 '),
            T_TIPO_DATA(' 7434085 '),
            T_TIPO_DATA(' 7434086 '),
            T_TIPO_DATA(' 7434087 '),
            T_TIPO_DATA(' 7434089 '),
            T_TIPO_DATA(' 7434090 '),
            T_TIPO_DATA(' 7434091 '),
            T_TIPO_DATA(' 7434092 '),
            T_TIPO_DATA(' 7434093 '),
            T_TIPO_DATA(' 7434094 '),
            T_TIPO_DATA(' 7434095 '),
            T_TIPO_DATA(' 7434097 '),
            T_TIPO_DATA(' 7434098 '),
            T_TIPO_DATA(' 7434099 '),
            T_TIPO_DATA(' 7434100 '),
            T_TIPO_DATA(' 7434101 '),
            T_TIPO_DATA(' 7434102 '),
            T_TIPO_DATA(' 7434104 '),
            T_TIPO_DATA(' 7434105 '),
            T_TIPO_DATA(' 7434106 '),
            T_TIPO_DATA(' 7434107 '),
            T_TIPO_DATA(' 7434108 '),
            T_TIPO_DATA(' 7434109 '),
            T_TIPO_DATA(' 7434113 '),
            T_TIPO_DATA(' 7434114 '),
            T_TIPO_DATA(' 7434116 '),
            T_TIPO_DATA(' 7434117 '),
            T_TIPO_DATA(' 7434118 '),
            T_TIPO_DATA(' 7434119 '),
            T_TIPO_DATA(' 7434120 '),
            T_TIPO_DATA(' 7434121 '),
            T_TIPO_DATA(' 7434122 '),
            T_TIPO_DATA(' 7434123 '),
            T_TIPO_DATA(' 7434124 '),
            T_TIPO_DATA(' 7434125 '),
            T_TIPO_DATA(' 7434126 '),
            T_TIPO_DATA(' 7434127 '),
            T_TIPO_DATA(' 7434128 '),
            T_TIPO_DATA(' 7434129 '),
            T_TIPO_DATA(' 7434130 '),
            T_TIPO_DATA(' 7434131 '),
            T_TIPO_DATA(' 7434132 '),
            T_TIPO_DATA(' 7434133 '),
            T_TIPO_DATA(' 7434134 '),
            T_TIPO_DATA(' 7434136 '),
            T_TIPO_DATA(' 7434137 '),
            T_TIPO_DATA(' 7434138 '),
            T_TIPO_DATA(' 7434139 '),
            T_TIPO_DATA(' 7434140 '),
            T_TIPO_DATA(' 7434141 '),
            T_TIPO_DATA(' 7434142 '),
            T_TIPO_DATA(' 7434143 '),
            T_TIPO_DATA(' 7434144 '),
            T_TIPO_DATA(' 7434145 '),
            T_TIPO_DATA(' 7434146 '),
            T_TIPO_DATA(' 7434147 '),
            T_TIPO_DATA(' 7434148 '),
            T_TIPO_DATA(' 7434151 '),
            T_TIPO_DATA(' 7434153 '),
            T_TIPO_DATA(' 7434154 '),
            T_TIPO_DATA(' 7434155 '),
            T_TIPO_DATA(' 7434156 '),
            T_TIPO_DATA(' 7434157 '),
            T_TIPO_DATA(' 7434158 '),
            T_TIPO_DATA(' 7434160 '),
            T_TIPO_DATA(' 7434161 '),
            T_TIPO_DATA(' 7434162 '),
            T_TIPO_DATA(' 7434163 '),
            T_TIPO_DATA(' 7434164 '),
            T_TIPO_DATA(' 7434165 '),
            T_TIPO_DATA(' 7434166 '),
            T_TIPO_DATA(' 7434167 '),
            T_TIPO_DATA(' 7434169 '),
            T_TIPO_DATA(' 7434170 '),
            T_TIPO_DATA(' 7434171 '),
            T_TIPO_DATA(' 7434172 '),
            T_TIPO_DATA(' 7434173 '),
            T_TIPO_DATA(' 7434175 '),
            T_TIPO_DATA(' 7434176 '),
            T_TIPO_DATA(' 7434177 '),
            T_TIPO_DATA(' 7434178 '),
            T_TIPO_DATA(' 7434179 '),
            T_TIPO_DATA(' 7434180 '),
            T_TIPO_DATA(' 7434181 '),
            T_TIPO_DATA(' 7434182 '),
            T_TIPO_DATA(' 7434183 '),
            T_TIPO_DATA(' 7434184 '),
            T_TIPO_DATA(' 7434185 '),
            T_TIPO_DATA(' 7434186 '),
            T_TIPO_DATA(' 7434187 '),
            T_TIPO_DATA(' 7434188 '),
            T_TIPO_DATA(' 7434189 '),
            T_TIPO_DATA(' 7434190 '),
            T_TIPO_DATA(' 7434191 '),
            T_TIPO_DATA(' 7434192 '),
            T_TIPO_DATA(' 7434193 '),
            T_TIPO_DATA(' 7434194 '),
            T_TIPO_DATA(' 7434195 '),
            T_TIPO_DATA(' 7434196 '),
            T_TIPO_DATA(' 7434197 '),
            T_TIPO_DATA(' 7434198 '),
            T_TIPO_DATA(' 7434199 '),
            T_TIPO_DATA(' 7434200 '),
            T_TIPO_DATA(' 7434201 '),
            T_TIPO_DATA(' 7434202 '),
            T_TIPO_DATA(' 7434203 '),
            T_TIPO_DATA(' 7434204 '),
            T_TIPO_DATA(' 7434206 '),
            T_TIPO_DATA(' 7434207 '),
            T_TIPO_DATA(' 7434208 '),
            T_TIPO_DATA(' 7434209 '),
            T_TIPO_DATA(' 7434210 '),
            T_TIPO_DATA(' 7434211 '),
            T_TIPO_DATA(' 7434213 '),
            T_TIPO_DATA(' 7434215 '),
            T_TIPO_DATA(' 7434216 '),
            T_TIPO_DATA(' 7434217 '),
            T_TIPO_DATA(' 7434218 '),
            T_TIPO_DATA(' 7434219 '),
            T_TIPO_DATA(' 7434220 '),
            T_TIPO_DATA(' 7434221 '),
            T_TIPO_DATA(' 7434222 '),
            T_TIPO_DATA(' 7434223 ')



    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	DBMS_OUTPUT.PUT_LINE('[INFO]: MARCAR CHECKS EN '||V_TEXT_TABLA);
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT > 0 THEN

			V_MSQL:='SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
			EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET
			PAC_CHECK_ADMISION = 1,
			PAC_FECHA_ADMISION = SYSDATE,
			USUARIOMODIFICAR = '''||V_USU||''',
			FECHAMODIFICAR = SYSDATE
			WHERE ACT_ID = '||V_ACT_ID||'';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO]: CHECKS MARCADOS PARA EL ACTIVO: '||V_TMP_TIPO_DATA(1)||'');
		
		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: EL ACTIVO: '||V_TMP_TIPO_DATA(1)||' NO EXISTE');

		END IF;

	END LOOP;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');


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