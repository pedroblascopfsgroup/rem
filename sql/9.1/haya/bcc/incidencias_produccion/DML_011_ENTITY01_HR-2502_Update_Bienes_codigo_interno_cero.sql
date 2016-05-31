--##########################################
--## AUTOR=Pepe Tamarit
--## FECHA_CREACION=20160517
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HR-2502
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

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INICIO] HR-2502_0');
    
	UPDATE #ESQUEMA#.bie_bien
	   SET borrado = 1, usuarioborrar = 'HR-2502_0', fechaborrar = sysdate
	 WHERE BIE_CODIGO_INTERNO = 0;

	UPDATE #ESQUEMA#.bie_cnt
	   SET borrado = 1, usuarioborrar = 'HR-2502_0', fechaborrar = sysdate
	 WHERE bie_id IN (SELECT bie_id FROM #ESQUEMA#.bie_bien WHERE borrado = 1 AND usuarioborrar = 'HR-2502_0');
	 
	UPDATE #ESQUEMA#.bie_per
	   SET borrado = 1, usuarioborrar = 'HR-2502_0', fechaborrar = sysdate
	 WHERE bie_id IN (SELECT bie_id FROM #ESQUEMA#.bie_bien WHERE borrado = 1 AND usuarioborrar = 'HR-2502_0');
	 
	UPDATE #ESQUEMA#.prb_prc_bie
	   SET borrado = 1, usuarioborrar = 'HR-2502_0', fechaborrar = sysdate
	 WHERE bie_id IN (SELECT bie_id FROM #ESQUEMA#.bie_bien WHERE borrado = 1 AND usuarioborrar = 'HR-2502_0');
	 
	UPDATE #ESQUEMA#.bie_sui_subasta_instrucciones
	   SET borrado = 1, usuarioborrar = 'HR-2502_0', fechaborrar = sysdate
	 WHERE bie_id IN (SELECT bie_id FROM #ESQUEMA#.bie_bien WHERE borrado = 1 AND usuarioborrar = 'HR-2502_0');
	 
	UPDATE #ESQUEMA#.bie_valoraciones
	   SET borrado = 1, usuarioborrar = 'HR-2502_0', fechaborrar = sysdate
	 WHERE bie_id IN (SELECT bie_id FROM #ESQUEMA#.bie_bien WHERE borrado = 1 AND usuarioborrar = 'HR-2502_0');
	 
	UPDATE #ESQUEMA#.bie_localizacion
	   SET borrado = 1, usuarioborrar = 'HR-2502_0', fechaborrar = sysdate
	 WHERE bie_id IN (SELECT bie_id FROM #ESQUEMA#.bie_bien WHERE borrado = 1 AND usuarioborrar = 'HR-2502_0');
	 
	UPDATE #ESQUEMA#.bie_car_cargas
	   SET borrado = 1, usuarioborrar = 'HR-2502_0', fechaborrar = sysdate
	 WHERE bie_id IN (SELECT bie_id FROM #ESQUEMA#.bie_bien WHERE borrado = 1 AND usuarioborrar = 'HR-2502_0');
	 
	UPDATE #ESQUEMA#.bie_adicional
	   SET borrado = 1, usuarioborrar = 'HR-2502_0', fechaborrar = sysdate
	 WHERE bie_id IN (SELECT bie_id FROM #ESQUEMA#.bie_bien WHERE borrado = 1 AND usuarioborrar = 'HR-2502_0');
	 
	UPDATE #ESQUEMA#.bie_datos_registrales
	   SET borrado = 1, usuarioborrar = 'HR-2502_0', fechaborrar = sysdate
	 WHERE bie_id IN (SELECT bie_id FROM #ESQUEMA#.bie_bien WHERE borrado = 1 AND usuarioborrar = 'HR-2502_0');
 
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[FIN] HR-2502_0');        
   
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
