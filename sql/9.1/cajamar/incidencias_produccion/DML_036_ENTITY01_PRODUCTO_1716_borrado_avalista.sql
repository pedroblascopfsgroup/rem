--##########################################
--## AUTOR=Pepe Tamarit
--## FECHA_CREACION=20160617
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=PRODUCTO-1716
--## PRODUCTO=NO
--## 
--## Finalidad: Borrar avalista 
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

  DBMS_OUTPUT.PUT_LINE('[INICIO] PRODUCTO-1716');
    
 -- PRODUCTO-1716
 -- Borrado Avalista
delete from cm01.PRC_PER  
  where per_id = (select per_id from cm01.per_personas where per_cod_cliente_entidad = 31121000320257)
    and prc_id in (
            select distinct prc.prc_id
            from cm01.asu_asuntos asu
            inner join cm01.exp_expedientes exp on asu.EXP_ID = exp.EXP_ID
            inner join cm01.CEX_CONTRATOS_EXPEDIENTE cex on cex.EXP_ID = exp.EXP_ID
            inner join cm01.CNT_CONTRATOS cnt on cnt.CNT_ID = cex.CNT_ID
            inner join cm01.CPE_CONTRATOS_PERSONAS cpe on cpe.CNT_ID = cnt.cnt_id
            inner join cm01.PER_PERSONAS per on per.PER_ID = cpe.per_id
            inner join cm01.PEX_PERSONAS_EXPEDIENTE pex on pex.PER_ID = per.per_id
            inner join cm01.PRC_PER  on PRC_PER.per_id = per.PER_ID
            inner join cm01.PRC_PROCEDIMIENTOS PRC on PRC.PRC_ID = PRC_PER.PRC_ID
            inner join cm01.prc_cex on prc_cex.PRC_ID = PRC.PRC_ID
            inner join cm01.dd_tin_tipo_intervencion tin on cpe.dd_tin_id = tin.dd_tin_id
            where dd_tin_codigo = '20'
            and asu.borrado = 0
            and exp.borrado = 0
            and cex.borrado = 0
            and cnt.borrado = 0
            and cpe.borrado = 0
            and per.borrado = 0
            and cnt.cnt_contrato = 747340420472237
            and asu_nombre like 'B12520896%'
            and per.per_cod_cliente_entidad = 31121000320257);
commit;
  DBMS_OUTPUT.PUT_LINE('[INFO] Avalista borrado');
  DBMS_OUTPUT.PUT_LINE('[FIN] PRODUCTO-1716'); 
   
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
