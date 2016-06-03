--##########################################
--## AUTOR=CARLOS LOPEZ
--## FECHA_CREACION=20160526
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=PRODUCTO-1573
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar bienes
--## INSTRUCCIONES:  
--## VERSIONES:
--##            0.1 Versión inicial
--##########################################
--*/
/***************************************/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
set timing ON
set linesize 2000
SET VERIFY OFF
set feedback on

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    USUARIO_BORRAR VARCHAR2(50 CHAR) := 'PRODUCTO-1573';

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INICIO] PRODUCTO-1573');
       
       V_SQL := '
	MERGE INTO '||V_ESQUEMA||'.bie_bien BIE USING
                     (SELECT BIE_ID FROM 
                        (SELECT BIE_ID, BIE_CODIGO_INTERNO, ROW_NUMBER()
                           OVER (PARTITION BY BIE_CODIGO_INTERNO ORDER BY BIE_ID DESC) AS ROWNUMBER 
                        FROM '||V_ESQUEMA||'.bie_bien
                        WHERE BORRADO = 0
                        AND BIE_CODIGO_INTERNO IS NOT NULL
                        
                        ) WHERE ROWNUMBER > 1) aux
	  ON (BIE.BIE_ID=aux.BIE_ID)
	  WHEN MATCHED THEN
	    UPDATE SET
	     BIE.borrado = 1, usuarioborrar = ''PRODUCTO-1573'', fechaborrar = sysdate ';

       
       EXECUTE IMMEDIATE V_SQL;        

       V_SQL := '
	MERGE INTO '||V_ESQUEMA||'.bie_cnt BCNT USING
                        (SELECT BIE_ID
                        FROM '||V_ESQUEMA||'.bie_bien BIE
                        WHERE BIE.borrado = 1
                             AND BIE.usuarioborrar = ''PRODUCTO-1573'')AUX
	  ON (BCNT.BIE_ID=aux.BIE_ID)
	  WHEN MATCHED THEN
	    UPDATE SET
	     BCNT.borrado = 1, BCNT.usuarioborrar = ''PRODUCTO-1573'', BCNT.fechaborrar = sysdate ';

       EXECUTE IMMEDIATE V_SQL;

       V_SQL := '
	MERGE INTO '||V_ESQUEMA||'.bie_bien_entidad bbent USING
                        (SELECT BIE_ID
                        FROM '||V_ESQUEMA||'.bie_bien BIE
                        WHERE BIE.borrado = 1
                             AND BIE.usuarioborrar = ''PRODUCTO-1573'')AUX
	  ON (bbent.BIE_ID=aux.BIE_ID)
	  WHEN MATCHED THEN
	    UPDATE SET
	     bbent.borrado = 1, bbent.usuarioborrar = ''PRODUCTO-1573'', bbent.fechaborrar = sysdate ';

       EXECUTE IMMEDIATE V_SQL;       

       V_SQL := '
	MERGE INTO  '||V_ESQUEMA||'.bie_valoraciones BIE USING
		                             (SELECT DISTINCT BIE_ID FROM 
		                                (SELECT BIEVAL.BIE_ID, ROW_NUMBER()
		                                   OVER (PARTITION BY BIEVAL.BIE_ID ORDER BY BIEVAL.BIE_VAL_ID DESC) AS ROWNUMBER 
		                                FROM '||V_ESQUEMA||'.bie_bien BIE, '||V_ESQUEMA||'.bie_valoraciones BIEVAL 
		                                WHERE BIE.BIE_ID = BIEVAL.BIE_ID 
		                                    AND BIE.usuarioborrar = ''PRODUCTO-1573''
		                                    AND BIE.borrado = 1
		                                
		                                ) WHERE ROWNUMBER > 1) aux
	  ON (BIE.BIE_ID=aux.BIE_ID)
	  WHEN MATCHED THEN
	    UPDATE SET
	     BIE.borrado = 1, usuarioborrar = ''PRODUCTO-1573'', fechaborrar = sysdate ';

       EXECUTE IMMEDIATE V_SQL;

       V_SQL := '
	MERGE INTO  '||V_ESQUEMA||'.bie_localizacion BIE USING
		                             (SELECT DISTINCT BIE_ID FROM 
		                                (SELECT BIELOC.BIE_ID, ROW_NUMBER()
		                                   OVER (PARTITION BY BIELOC.BIE_ID ORDER BY BIELOC.BIE_LOC_ID DESC) AS ROWNUMBER 
		                                FROM '||V_ESQUEMA||'.bie_bien BIE, '||V_ESQUEMA||'.bie_localizacion BIELOC 
		                                WHERE BIE.BIE_ID = BIELOC.BIE_ID 
		                                    AND BIE.usuarioborrar = ''PRODUCTO-1573''
		                                    AND BIE.borrado = 1
		                                
		                                ) WHERE ROWNUMBER > 1) aux
	  ON (BIE.BIE_ID=aux.BIE_ID)
	  WHEN MATCHED THEN
	    UPDATE SET
	     BIE.borrado = 1, usuarioborrar = ''PRODUCTO-1573'', fechaborrar = sysdate ';

       EXECUTE IMMEDIATE V_SQL;

       V_SQL := '
	MERGE INTO  '||V_ESQUEMA||'.bie_adicional BIE USING
		                             (SELECT DISTINCT BIE_ID FROM 
		                                (SELECT BIEADI.BIE_ID, ROW_NUMBER()
		                                   OVER (PARTITION BY BIEADI.BIE_ID ORDER BY BIEADI.BIE_ADI_ID DESC) AS ROWNUMBER 
		                                FROM '||V_ESQUEMA||'.bie_bien BIE, '||V_ESQUEMA||'.bie_adicional BIEADI
		                                WHERE BIE.BIE_ID = BIEADI.BIE_ID 
		                                    AND BIE.usuarioborrar = ''PRODUCTO-1573''
		                                    AND BIE.borrado = 1
		                                
		                                ) WHERE ROWNUMBER > 1) aux
	  ON (BIE.BIE_ID=aux.BIE_ID)
	  WHEN MATCHED THEN
	    UPDATE SET
	     BIE.borrado = 1, usuarioborrar = ''PRODUCTO-1573'', fechaborrar = sysdate ';

       EXECUTE IMMEDIATE V_SQL;

       V_SQL := '
	MERGE INTO  '||V_ESQUEMA||'.bie_datos_registrales BIE USING
		                             (SELECT DISTINCT BIE_ID FROM 
		                                (SELECT BIEDAT.BIE_ID, ROW_NUMBER()
		                                   OVER (PARTITION BY BIEDAT.BIE_ID ORDER BY BIEDAT.BIE_DREG_ID DESC) AS ROWNUMBER 
		                                FROM '||V_ESQUEMA||'.bie_bien BIE, '||V_ESQUEMA||'.bie_datos_registrales BIEDAT
		                                WHERE BIE.BIE_ID = BIEDAT.BIE_ID 
		                                    AND BIE.usuarioborrar = ''PRODUCTO-1573''
		                                    AND BIE.borrado = 1
		                                
		                                ) WHERE ROWNUMBER > 1) aux
	  ON (BIE.BIE_ID=aux.BIE_ID)
	  WHEN MATCHED THEN
	    UPDATE SET
	     BIE.borrado = 1, usuarioborrar = ''PRODUCTO-1573'', fechaborrar = sysdate ';

       EXECUTE IMMEDIATE V_SQL;

  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[FIN] PRODUCTO-1573');        
   
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(V_SQL);
          ROLLBACK;
          RAISE;   
END;
/

EXIT;
