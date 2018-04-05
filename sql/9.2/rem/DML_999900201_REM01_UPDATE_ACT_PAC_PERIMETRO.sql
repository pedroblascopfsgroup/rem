--/*
--##########################################
--## AUTOR=DANIEL ALGABA
--## FECHA_CREACION=20180405
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-3927
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar los campos PAC_CHECK_PUBLICAR y PAC_FECHA_PUBLICAR
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_PAC_PERIMETRO_ACTIVO'; 
    
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] INICIO DEL PROCESO');

    -- Comprobamos si existe ACT_APU_ACTIVO_PUBLICACION
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN 
        V_MSQL := 'UPDATE '|| V_ESQUEMA || '.'||V_TEXT_TABLA|| '
					SET PAC_CHECK_PUBLICAR = 1
                    ,USUARIOMODIFICAR = ''HREOS-3927''
                    ,FECHAMODIFICAR = SYSDATE
					WHERE PAC_CHECK_PUBLICAR IS NULL';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CORRECTAMENTE');
        DBMS_OUTPUT.PUT_LINE('[INFO]: '|| V_ESQUEMA || '.'||V_TEXT_TABLA||', FILAS ACTUALIZADAS CON ÉXITO');

        V_MSQL := 'UPDATE '|| V_ESQUEMA || '.'||V_TEXT_TABLA|| '
                    SET PAC_FECHA_PUBLICAR = SYSDATE
                    ,USUARIOMODIFICAR = ''HREOS-3927''
                    ,FECHAMODIFICAR = SYSDATE
                    WHERE PAC_FECHA_PUBLICAR IS NULL';
        EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CORRECTAMENTE');
        DBMS_OUTPUT.PUT_LINE('[INFO]: '|| V_ESQUEMA || '.'||V_TEXT_TABLA||', FILAS ACTUALIZADAS CON ÉXITO');
    ELSE    
        DBMS_OUTPUT.PUT_LINE('[INFO]: LA TABLA '|| V_ESQUEMA || '.'||V_TEXT_TABLA||' NO EXISTE');
    END IF;
    COMMIT;
    
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] SE HA PRODUCIDO UN ERROR EN LA EJECUCIÓN:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;