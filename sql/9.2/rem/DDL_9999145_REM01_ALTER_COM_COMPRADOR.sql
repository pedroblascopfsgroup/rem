--/*
--##########################################
--## AUTOR=SIMEON SHOPOV 
--## FECHA_CREACION=20180326
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-???
--## PRODUCTO=NO
--##
--## Finalidad: Añadir el nuevo campo COM_COMPRADORES.ID_COMPRADOR_URSUS_BH
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
    V_TABLA VARCHAR2(25 CHAR):= 'COM_COMPRADOR';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-???';
     BEGIN

   

 V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD
 			  ID_COMPRADOR_URSUS_BH NUMBER(16,0) ';

 EXECUTE IMMEDIATE V_SQL;



 V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ID_COMPRADOR_URSUS_BH 
   IS ''Id del comprador de Bankia Habitat devuelto por el WebService de Bankia.'''

  EXECUTE IMMEDIATE V_SQL;

 V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ID_COMPRADOR_URSUS 
   IS ''Id del comprador de Bankia devuelto por el WebService de Bankia.''';

  EXECUTE IMMEDIATE V_SQL;

 
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
