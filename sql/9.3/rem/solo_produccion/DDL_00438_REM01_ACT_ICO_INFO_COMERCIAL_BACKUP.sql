--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20220321
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17466
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar publicación de activos
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE


    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(50 CHAR):= 'ACT_ICO_INFO_COMERCIAL';
    V_TABLA_BACKUP VARCHAR2(50 CHAR):= 'ACT_ICO_INFO_COMERCIAL_BACKUP';
    V_COUNT NUMBER(16);

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: BACKUP DE LA TABLA ACT_ICO_INFO_COMERCIAL');

    V_MSQL := 'SELECT COUNT(*) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA_BACKUP||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

    IF V_COUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: LA TABLA ACT_ICO_INFO_COMERCIAL_BACKUP YA EXISTE');
    ELSE
        V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA_BACKUP||' AS SELECT * FROM '||V_ESQUEMA||'.'||V_TABLA;
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: TABLA ACT_ICO_INFO_COMERCIAL_BACKUP CREADA CON '||SQL%ROWCOUNT||' REGISTROS');
    END IF;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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