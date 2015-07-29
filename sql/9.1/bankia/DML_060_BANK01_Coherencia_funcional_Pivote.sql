--/*
--##########################################
--## AUTOR=JOSEVI
--## FECHA_CREACION=20150729
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.13
--## INCIDENCIA_LINK=FASE-1470
--## PRODUCTO=NO
--## Finalidad: DML
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');

DBMS_OUTPUT.PUT_LINE('[INFO] Borrado de registros para coherencia con Nuevo Funcional CDD');


--Registros múltiples por ASU_ID y PRC_ID, con bien null
--PRO: 764 (342 unicos) registros
-- Todo igual, cambian fechas. La mayoría duplicidad de grupo por pares.
-- Todos son BANKIA excepto 1 único grupo de 3 componentes q es de SAREB 
--   --ASU_ID: 100022135
--   --PRC_ID: 100640956
--
-- Se opta por ELIMINAR todas las duplicidades por grupo ASU-PRC-BIE(NULL), dejando solo el registro
-- más reciente por grupo
DBMS_OUTPUT.PUT('[INFO] COHERENCIA ASU-PRC (con BIE siempre NULO): Se eliminan los duplicados y se deja 1 solo por grupo, el más reciente...');
execute immediate
'delete '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD dcnv
where exists(
    select 1
    from '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD cnv
    inner join (
      select cnv1.asu_id, cnv1.prc_id
      from '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD cnv1
      where cnv1.bie_id is null
      group by cnv1.asu_id, cnv1.prc_id
      having count(*) >1
      )gcnv on cnv.asu_id = gcnv.asu_id and gcnv.prc_id = cnv.prc_id 
    where cnv.bie_id is null
    and cnv.id_acuerdo_cierre = dcnv.id_acuerdo_cierre
)
and not exists(
    select 1
    from '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD cnv
    inner join (
      select cnv1.asu_id, cnv1.prc_id, max(cnv1.id_acuerdo_cierre) miac
      from '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD cnv1
      where cnv1.bie_id is null
      group by cnv1.asu_id, cnv1.prc_id
      having count(*) >1
      )gcnv on cnv.asu_id = gcnv.asu_id and gcnv.prc_id = cnv.prc_id 
    where cnv.bie_id is null
    and gcnv.miac = dcnv.id_acuerdo_cierre
)' ;
DBMS_OUTPUT.PUT_LINE('OK'); 



--Registros múltiples por ASU_ID y PRC_ID y BIE_ID
--PRO: 9882 registros (3440 unicos)
-- Todo igual, incluso fecha entrega, cambia fecha alta. Duplicidad por pares en la mayoría de casos
-- Todos son SAREB, no hay registros de este tipo con entidad BANKIA
--
-- Se opta por ELIMINAR todas las duplicidades por grupo ASU-PRC-BIE(NULL), dejando solo el registro
-- más reciente por grupo
DBMS_OUTPUT.PUT('[INFO] COHERENCIA ASU-PRC-BIE (con BIE siempre NO NULO): Se eliminan los duplicados y se deja 1 solo por grupo, el más reciente...');
execute immediate
'delete '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD dcnv
where exists(
  select 1
  from '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD cnv
  inner join (
    select cnv1.asu_id, cnv1.prc_id, cnv1.bie_id
    from '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD cnv1
    where cnv1.bie_id is not null
    group by cnv1.asu_id, cnv1.prc_id, cnv1.bie_id
    having count(*) >1
    )gcnv on cnv.asu_id = gcnv.asu_id and gcnv.prc_id = cnv.prc_id and cnv.bie_id = gcnv.bie_id
  where cnv.bie_id is not null
  and cnv.id_acuerdo_cierre = dcnv.id_acuerdo_cierre
)
and not exists(
  select 1
  from '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD cnv
  inner join (
    select cnv1.asu_id, cnv1.prc_id, cnv1.bie_id, max(id_acuerdo_cierre) miac
    from '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD cnv1
    where cnv1.bie_id is not null
    group by cnv1.asu_id, cnv1.prc_id, cnv1.bie_id
    having count(*) >1
    )gcnv on cnv.asu_id = gcnv.asu_id and gcnv.prc_id = cnv.prc_id and cnv.bie_id = gcnv.bie_id
  where cnv.bie_id is not null
  and gcnv.miac = dcnv.id_acuerdo_cierre
)' ;
DBMS_OUTPUT.PUT_LINE('OK'); 


COMMIT;

DBMS_OUTPUT.PUT_LINE('[INFO] OK coherencia funcional definida.');

DBMS_OUTPUT.PUT_LINE('[FIN]');



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO - error');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

