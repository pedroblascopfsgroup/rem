--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20190514
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4227
--## PRODUCTO=NO
--##
--## Finalidad: --
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
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
   V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
   V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
   ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_ECO_ID NUMBER(16); 
   
   ACT_ID NUMBER(16);
   V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
   
   TYPE T_JBV IS TABLE OF VARCHAR2(32000);
   TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

V_JBV T_ARRAY_JBV := T_ARRAY_JBV( 
-- ="T_JBV("&COLUMNA&"),"
T_JBV('354257'),
T_JBV('220330'),
T_JBV('270569'),
T_JBV('254642'),
T_JBV('237437'),
T_JBV('72174'),
T_JBV('216728'),
T_JBV('208967'),
T_JBV('212450'),
T_JBV('235838'),
T_JBV('264924'),
T_JBV('293942'),
T_JBV('163433'),
T_JBV('181815'),
T_JBV('141445'),
T_JBV('239712'),
T_JBV('224894'),
T_JBV('203765'),
T_JBV('208147'),
T_JBV('197149'),
T_JBV('248350'),
T_JBV('80699'),
T_JBV('307732'),
T_JBV('305881'),
T_JBV('253248'),
T_JBV('253252'),
T_JBV('254647'),
T_JBV('254648'),
T_JBV('317145'),
T_JBV('287432'),
T_JBV('294003'),
T_JBV('319133'),
T_JBV('354059'),
T_JBV('239244'),
T_JBV('122677'),
T_JBV('142782'),
T_JBV('90253'),
T_JBV('90255'),
T_JBV('259520'),
T_JBV('67173')
); 
V_TMP_JBV T_JBV;

BEGIN	

FOR I IN V_JBV.FIRST .. V_JBV.LAST

LOOP

V_TMP_JBV := V_JBV(I);

 	ACT_ID := TRIM(V_TMP_JBV(1));

V_SQL := 'CALL '||V_ESQUEMA||'.SP_CAMBIO_ESTADO_PUBLICACION ('||ACT_ID||',1,''SP_CAMBIO_EST_PUBLI'')';

EXECUTE IMMEDIATE V_SQL;

END LOOP;

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