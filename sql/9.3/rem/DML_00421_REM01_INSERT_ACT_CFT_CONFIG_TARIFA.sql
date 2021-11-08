--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20211029
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16088
--## PRODUCTO=NO
--##
--## Finalidad: INSERTAR ACT_CFT_CONFIG_TARIFA
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CFT_CONFIG_TARIFA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(250 CHAR) := 'HREOS-16088';

BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');

    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);

    V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (CFT_ID,USUARIOCREAR,FECHACREAR,DD_CRA_ID,DD_TTF_ID,DD_TTR_ID,DD_STR_ID,
                        CFT_PRECIO_UNITARIO,CFT_UNIDAD_MEDIDA,PVE_ID,CFT_FECHA_INI,CFT_FECHA_FIN,CFT_PRECIO_UNITARIO_CLIENTE,CFT_TARIFA_PVE)
                SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,'''||V_USUARIO||''', SYSDATE,
                (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''18''),
                DD_TTF_ID,DD_TTR_ID,DD_STR_ID,CFT_PRECIO_UNITARIO,CFT_UNIDAD_MEDIDA,PVE_ID,CFT_FECHA_INI,CFT_FECHA_FIN,
                CFT_PRECIO_UNITARIO_CLIENTE,CFT_TARIFA_PVE FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
                WHERE DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''03'')
                AND (DD_SCR_ID IS NULL OR DD_SCR_ID = (SELECT DD_sCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''09''))
                AND BORRADO = 0';
    EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('	[INFO] Se han insertado correctamente '||SQL%ROWCOUNT||' registros');    

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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