--/*
--##########################################
--## AUTOR=Luis Antonio Prato Paredes
--## FECHA_CREACION=20160307
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=BKREC-1715
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar el campo 
--## INSTRUCCIONES:  Actualizar el campo PRO_FECHA_BAJA, USUARIO_MODIFICAR, FECHA_MODIFICAR de la tabla: PRO_PROVISIONES_ASUNTOS debido a un error en el ETL
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);

 

 BEGIN

        V_MSQL := 'Update ' || V_ESQUEMA || '.PRO_PROVISIONES_ASUNTO set PRO_FECHA_BAJA=SYSDATE, USUARIOMODIFICAR=''BKREC-1715'', FECHAMODIFICAR = SYSDATE WHERE ASU_ID In (select asu.ASU_ID  from 
	' || V_ESQUEMA || '.ASU_ASUNTOS asu
  join  ' || V_ESQUEMA || '.PRO_PROVISIONES_ASUNTO pro on asu.asu_id = pro.asu_id
  left join ' || V_ESQUEMA || '.CNV_AUX_PRC_PRO aux on aux.CODIGO_PROCEDIMIENTO = asu.ASU_ID_EXTERNO
  where aux.codigo_procedimiento  is null
    and trunc(pro.pro_fecha_baja) is null)';

EXECUTE IMMEDIATE V_MSQL;
 EXCEPTION

    
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;

END;
/

EXIT;
