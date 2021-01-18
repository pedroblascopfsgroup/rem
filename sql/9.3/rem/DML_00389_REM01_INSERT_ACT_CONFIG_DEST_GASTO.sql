--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20201222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO= 9.3
--## INCIDENCIA_LINK=HREOS-12525
--## PRODUCTO=NO
--##
--## Finalidad: Insertar en la tabla ACT_CONFIG_DEST_GASTO
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(30 CHAR) := 'ACT_CONFIG_DEST_GASTO';
    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-12525';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
 
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(3200);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('20200909','20991231', '16', ' ', ' ', '01', ' ', ' ', ' ', '02'),
        T_TIPO_DATA('19000101','20200908', '16', ' ', ' ', '01', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '01', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '02', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '03', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '04', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '05', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '06', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '07', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '13', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '14', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '15', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '16', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '17', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '18', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '19', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '20', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '21', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '22', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '23', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '24', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '25', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '26', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '27', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '28', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '29', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '30', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '31', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '32', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '33', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '34', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '35', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '36', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '37', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '38', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '39', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '40', '02', ' ', ' ', ' ', '02'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '41', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '56', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '42', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '43', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '44', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '45', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '46', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '47', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '48', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '49', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '50', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '51', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '52', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '53', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '54', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '55', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '58', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '57', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '59', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '60', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '61', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '62', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '63', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '64', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '65', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '66', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '67', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '68', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '69', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '70', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '71', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '72', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '73', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '100', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '101', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '102', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '103', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '104', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '105', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '106', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '107', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '108', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '109', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '110', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '111', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '112', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '113', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '114', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '115', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '116', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '117', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '118', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '119', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '120', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '121', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '122', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '123', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '124', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '125', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '126', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '127', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '128', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '129', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '130', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '131', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '132', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '133', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '134', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '135', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '136', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '137', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '138', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '139', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '140', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '141', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '142', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '143', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '144', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', '145', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', 'PAQ', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', 'INT', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', 'ACO', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', 'RAN', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', 'VAL', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', 'FOT', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', 'SIN', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('19000101','20200908', '16', ' ', ' ', '02', ' ', ' ', ' ', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', ' ', '03', ' ', ' ', '1', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', ' ', '03', ' ', 'B46001897', '0', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', ' ', '03', ' ', 'F20025318', '0', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', ' ', '03', ' ', 'A28791069', '0', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', ' ', '03', ' ', 'A27178789', '0', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', ' ', '03', ' ', 'A48265169', '0', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', ' ', '03', ' ', 'A86744349', '0', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', ' ', '03', ' ', 'A60470127', '0', '01'),
        T_TIPO_DATA('20200909','20991231', '16', ' ', ' ', '03', ' ', ' ', '0', '02'),
        T_TIPO_DATA('19000101','20200908', '16', ' ', ' ', '03', ' ', ' ', ' ', '01')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
        IF V_TMP_TIPO_DATA(9) = ' ' THEN
            V_MSQL := '
                INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                    DGA_ID
                    , DGA_FECHA_INICIO
                    , DGA_FECHA_FIN
                    , DD_STR_ID
                    , DD_CRA_ID
                    , DD_SCR_ID
                    , DD_IRE_ID
                    , PRO_ID
                    , PVE_ID
                    , DD_DEG_ID
                    , USUARIOCREAR
                )
                SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL DGA_ID
                    , TO_DATE('''||V_TMP_TIPO_DATA(1)||''',''YYYYMMDD'') DGA_FECHA_INICIO
                    , TO_DATE('''||V_TMP_TIPO_DATA(2)||''',''YYYYMMDD'') DGA_FECHA_FIN
                    , STR.DD_STR_ID DD_STR_ID
                    , CRA.DD_CRA_ID DD_CRA_ID
                    , SCR.DD_SCR_ID DD_SCR_ID
                    , IRE.DD_IRE_ID DD_IRE_ID
                    , PRO.PRO_ID PRO_ID
                    , PVE.PVE_ID PVE_ID
                    , DEG.DD_DEG_ID DD_DEG_ID
                    , '''||V_USUARIO||''' USUARIOCREAR
                FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA
                JOIN '||V_ESQUEMA||'.DD_IRE_IDENTIFICADOR_REAM IRE ON IRE.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO DEG ON DEG.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = CRA.DD_CRA_ID
                    AND SCR.BORRADO = 0
                    AND SCR.DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA(4)||'''
                LEFT JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.DD_CRA_ID = CRA.DD_CRA_ID
                    AND PRO.BORRADO = 0
                    AND PRO.PRO_DOCIDENTIF = '''||V_TMP_TIPO_DATA(7)||'''
                LEFT JOIN '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO STR ON STR.BORRADO = 0
                    AND STR.DD_STR_CODIGO = '''||V_TMP_TIPO_DATA(5)||'''
                LEFT JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.BORRADO = 0
                    AND PVE.PVE_DOCIDENTIF = '''||V_TMP_TIPO_DATA(8)||'''
                WHERE CRA.BORRADO = 0
                    AND CRA.DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''
                    AND IRE.DD_IRE_CODIGO = '''||V_TMP_TIPO_DATA(6)||'''
                    AND DEG.DD_DEG_CODIGO = '''||V_TMP_TIPO_DATA(10)||'''
                    AND NOT EXISTS (
                        SELECT 1
                        FROM '||V_ESQUEMA||'.'||V_TABLA||' CNF
                        WHERE CNF.DD_CRA_ID = CRA.DD_CRA_ID
                            AND CNF.DD_IRE_ID = IRE.DD_IRE_ID
                            AND CNF.DD_DEG_ID = DEG.DD_DEG_ID
                            AND NVL(CNF.DD_SCR_ID, 0) = NVL(SCR.DD_SCR_ID, NVL(CNF.DD_SCR_ID, 0))
                            AND NVL(CNF.DD_STR_ID, 0) = NVL(STR.DD_STR_ID, NVL(CNF.DD_STR_ID, 0))
                            AND NVL(CNF.PVE_ID, 0) = NVL(PVE.PVE_ID, NVL(CNF.PVE_ID, 0))
                            AND NVL(CNF.PRO_ID, 0) = NVL(PRO.PRO_ID, NVL(CNF.PRO_ID, 0))
                            AND CNF.DGA_FECHA_INICIO = TO_DATE('''||V_TMP_TIPO_DATA(1)||''',''YYYYMMDD'')
                            AND CNF.DGA_FECHA_FIN = TO_DATE('''||V_TMP_TIPO_DATA(2)||''',''YYYYMMDD'')
                            AND CNF.BORRADO = 0
                    )';
        ELSE
            V_MSQL := '
                INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                    DGA_ID
                    , DGA_FECHA_INICIO
                    , DGA_FECHA_FIN
                    , DD_STR_ID
                    , DD_CRA_ID
                    , DD_SCR_ID
                    , DD_IRE_ID
                    , PRO_ID
                    , PVE_ID
                    , DGA_ARRENDAMIENTO_SOCIAL
                    , DD_DEG_ID
                    , USUARIOCREAR
                )
                SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL DGA_ID
                    , TO_DATE('''||V_TMP_TIPO_DATA(1)||''',''YYYYMMDD'') DGA_FECHA_INICIO
                    , TO_DATE('''||V_TMP_TIPO_DATA(2)||''',''YYYYMMDD'') DGA_FECHA_FIN
                    , STR.DD_STR_ID DD_STR_ID
                    , CRA.DD_CRA_ID DD_CRA_ID
                    , SCR.DD_SCR_ID DD_SCR_ID
                    , IRE.DD_IRE_ID DD_IRE_ID
                    , PRO.PRO_ID PRO_ID
                    , PVE.PVE_ID PVE_ID
                    , '||V_TMP_TIPO_DATA(9)||' DGA_ARRENDAMIENTO_SOCIAL
                    , DEG.DD_DEG_ID DD_DEG_ID
                    , '''||V_USUARIO||''' USUARIOCREAR
                FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA
                JOIN '||V_ESQUEMA||'.DD_IRE_IDENTIFICADOR_REAM IRE ON IRE.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO DEG ON DEG.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = CRA.DD_CRA_ID
                    AND SCR.BORRADO = 0
                    AND SCR.DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA(4)||'''
                LEFT JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.DD_CRA_ID = CRA.DD_CRA_ID
                    AND PRO.BORRADO = 0
                    AND PRO.PRO_DOCIDENTIF = '''||V_TMP_TIPO_DATA(7)||'''
                LEFT JOIN '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO STR ON STR.BORRADO = 0
                    AND STR.DD_STR_CODIGO = '''||V_TMP_TIPO_DATA(5)||'''
                LEFT JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.BORRADO = 0
                    AND PVE.PVE_DOCIDENTIF = '''||V_TMP_TIPO_DATA(8)||'''
                WHERE CRA.BORRADO = 0
                    AND CRA.DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''
                    AND IRE.DD_IRE_CODIGO = '''||V_TMP_TIPO_DATA(6)||'''
                    AND DEG.DD_DEG_CODIGO = '''||V_TMP_TIPO_DATA(10)||'''
                    AND NOT EXISTS (
                        SELECT 1
                        FROM '||V_ESQUEMA||'.'||V_TABLA||' CNF
                        WHERE CNF.DD_CRA_ID = CRA.DD_CRA_ID
                            AND CNF.DD_IRE_ID = IRE.DD_IRE_ID
                            AND CNF.DD_DEG_ID = DEG.DD_DEG_ID
                            AND NVL(CNF.DD_SCR_ID, 0) = NVL(SCR.DD_SCR_ID, NVL(CNF.DD_SCR_ID, 0))
                            AND NVL(CNF.DD_STR_ID, 0) = NVL(STR.DD_STR_ID, NVL(CNF.DD_STR_ID, 0))
                            AND NVL(CNF.PVE_ID, 0) = NVL(PVE.PVE_ID, NVL(CNF.PVE_ID, 0))
                            AND NVL(CNF.PRO_ID, 0) = NVL(PRO.PRO_ID, NVL(CNF.PRO_ID, 0))
                            AND CNF.DGA_FECHA_INICIO = TO_DATE('''||V_TMP_TIPO_DATA(1)||''',''YYYYMMDD'')
                            AND CNF.DGA_FECHA_FIN = TO_DATE('''||V_TMP_TIPO_DATA(2)||''',''YYYYMMDD'')
                            AND CNF.BORRADO = 0
                    )';
        END IF;

        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('  [INFO]: Se ha/n insertado '||SQL%ROWCOUNT||' para la iteración '||I);

        /*IF SQL%ROWCOUNT <> 1 THEN

            DBMS_OUTPUT.PUT_LINE(V_MSQL);

        END IF;*/

      END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla de configuración '||V_TABLA||' rellenada correctamente.');

EXCEPTION
    WHEN OTHERS THEN
        ERR_NUM := SQLCODE;
        ERR_MSG := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
        DBMS_OUTPUT.PUT_LINE(ERR_MSG);
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        ROLLBACK;
        RAISE;          
END;
/
EXIT
