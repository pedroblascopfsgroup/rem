  --/*
--##########################################
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20190510
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.11.0
--## INCIDENCIA_LINK=HREOS-6184
--## PRODUCTO=NO
--##
--## Finalidad: Borrar duplicados en ACT_ABA_ACTIVO_BANCARIO y crear clave unica en ACT_ID para ACT_ABA_ACTIVO_BANCARIO
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO] Borramos duplicados en ACT_ABA_ACTIVO_BANCARIO');

  EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO ABA WHERE EXISTS ( SELECT 1 FROM (
    WITH DUPLIS AS (
        SELECT ACT_ID
        FROM '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO
        GROUP BY ACT_ID
        HAVING COUNT(1) > 1)
    SELECT aba.act_id,aba.borrado,aba.aba_id
    FROM '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO ABA
    JOIN DUPLIS ON DUPLIS.ACT_ID = ABA.ACT_ID
    WHERE ABA.BORRADO = 1) TMP
    WHERE TMP.ABA_ID = ABA.ABA_ID)';

  DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' registros eliminados fisicamente en ACT_ABA_ACTIVO_BANCARIO');
    
  COMMIT;

  DBMS_OUTPUT.PUT_LINE('[INFO] Crear clave unica en ACT_ID para ACT_ABA_ACTIVO_BANCARIO');

  EXECUTE IMMEDIATE 'select count(1) from ALL_CONSTRAINTS where constraint_name = ''ACT_ID'' and table_name = ''ACT_ABA_ACTIVO_BANCARIO''' INTO TABLE_COUNT;

  IF TABLE_COUNT < 1 THEN 
    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO ADD CONSTRAINT ACT_ID UNIQUE (ACT_ID)'; 
    DBMS_OUTPUT.PUT_LINE('[INFO] Clave creada en ACT_ABA_ACTIVO_BANCARIO');
  ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] Clave ya existente en ACT_ABA_ACTIVO_BANCARIO');
  END IF;

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
