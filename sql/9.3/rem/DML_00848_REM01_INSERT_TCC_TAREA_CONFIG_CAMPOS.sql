--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210726
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14701
--## PRODUCTO=NO
--##
--## Finalidad: INSERTAR TCC_TAREA_CONFIG_CAMPOS
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TCC_TAREA_CONFIG_CAMPOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(250 CHAR) := 'HREOS-14701';
    
    V_TAP VARCHAR2(250 CHAR) := 'T013_DocumentosPostVenta';
    V_TAP_ID NUMBER(25) := 0;
    V_TFI VARCHAR2(250 CHAR) := 'fechaIngreso';
    V_TFI_ID NUMBER(25) := 0;
    TCC_ACCION VARCHAR2(250 CHAR) := 'IS NOT NULL';

BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');

    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);

    V_SQL := 'SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
					WHERE TAP_CODIGO = '''||V_TAP||''' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_SQL INTO V_TAP_ID;

    IF V_TAP_ID != 0 THEN

        V_SQL := 'SELECT TFI_ID FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
					WHERE TFI_NOMBRE = '''||V_TFI||''' AND TAP_ID = '||V_TAP_ID||' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_TFI_ID;

        IF V_TFI_ID != 0 THEN

            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                        WHERE TFI_ID = '||V_TFI_ID||' AND TAP_ID = '||V_TAP_ID||' AND BORRADO = 0';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 0 THEN

                V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (TCC_ID,TAP_ID,TFI_ID,TCC_INSTANCIA,TCC_ACCION,USUARIOCREAR,FECHACREAR)
                            VALUES ('||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,'||V_TAP_ID||','||V_TFI_ID||',1,'''||TCC_ACCION||''', '''||V_USUARIO||''', SYSDATE)';
                EXECUTE IMMEDIATE V_SQL;

            ELSE 

                DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE UNA INSTANCIA PARA ESTE PROCEDIMIENTO. REVISA EL DML');

            END IF;

        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO]: PROBLEMA CON CAMPO '||V_TFI||'');

        END IF;

    ELSE 

        DBMS_OUTPUT.PUT_LINE('[INFO]: PROBLEMA CON TAREA '||V_TAP||'');

    END IF;

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