--/*
--##########################################
--## AUTOR=SERGIO SALT
--## FECHA_CREACION=20190225
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5208
--## PRODUCTO=NO
--##
--## Finalidad: Insercion inicial DD_EMN_ESTADO_MOTIVO_CAL_NEGATIVA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_AUX NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR) := 'DD_CAN_CALIFICACION_NEG'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-5208';

 BEGIN

  V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME ='''||V_TABLA||'''';
      
  EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
   
IF V_COUNT > 0 THEN  
    V_SQL := 'SELECT COUNT(1) FROM '||V_TABLA||' WHERE DD_CAN_DESCRIPCION = ''Subsanado''  AND BORRADO = 0';
    EXECUTE IMMEDIATE V_SQL INTO V_AUX;			
    IF V_AUX = 1 THEN
        V_SQL := 'UPDATE '||V_TABLA||' SET BORRADO = 1 WHERE DD_CAN_DESCRIPCION = ''Subsanado''  AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.put_line('[INFO] Se ha borrado el registro correctamente');
    ELSE 
        DBMS_OUTPUT.put_line('[INFO] El registro ya está borrado');
    END IF;
    ELSE 
    DBMS_OUTPUT.put_line('[INFO] La tabla '||V_TABLA||'no existe');
END IF;

 COMMIT;
 
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
