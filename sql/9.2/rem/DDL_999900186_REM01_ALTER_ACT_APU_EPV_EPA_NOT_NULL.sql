--/*
--##########################################
--## AUTOR=DANIEL ALGABA
--## FECHA_CREACION=20180323
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-3890
--## PRODUCTO=NO
--##
--## Finalidad: Cambiar DD_EPV_ID y DD_EPA_ID a obligatorios
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_APU_ACTIVO_PUBLICACION'; 
    
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] INICIO DEL PROCESO');

    -- Comprobamos si existe ACT_APU_ACTIVO_PUBLICACION
    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER =  '''|| V_ESQUEMA ||''' AND ((TABLE_NAME = '''||V_TEXT_TABLA||''' AND COLUMN_NAME =  ''DD_EPV_ID'' AND NULLABLE = ''N'')
         OR (TABLE_NAME = '''||V_TEXT_TABLA||''' AND COLUMN_NAME =  ''DD_EPA_ID'' AND NULLABLE = ''N''))';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 0 THEN 
        V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' MODIFY (DD_EPV_ID NUMBER(16,0) NOT NULL, DD_EPA_ID NUMBER(16,0) NOT NULL)';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: '|| V_ESQUEMA || '.'||V_TEXT_TABLA||', FILAS MODIFICADAS CON ÉXITO');
    ELSE    
        DBMS_OUTPUT.PUT_LINE('[INFO]: '|| V_ESQUEMA || '.'||V_TEXT_TABLA||', LA TABLA YA TIENE LOS CAMPOS OBLIGATORIOS');
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