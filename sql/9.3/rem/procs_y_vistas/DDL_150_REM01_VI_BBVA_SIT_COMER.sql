--/*
--##########################################
--## AUTOR=Joaquin Arnal
--## FECHA_CREACION=20210129
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11680
--## PRODUCTO=NO
--## Finalidad: Vista para calcular la situacion comercial BBVA de los activos BBVA
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - HREOS-11680 - JAD
--##        0.1 Versión inicial - HREOS-11680 - Quitamos no definido
--##        0.2 REMVIP-8799 - VRO - se cambia calculo para FECHA_DEP_JURIDICA
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_BBVA_SIT_COMER' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_BBVA_SIT_COMER...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VI_BBVA_SIT_COMER';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_BBVA_SIT_COMER... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_BBVA_SIT_COMER' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_BBVA_SIT_COMER...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.VI_BBVA_SIT_COMER';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_BBVA_SIT_COMER... borrada OK');
  END IF;

  
  
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_BBVA_SIT_COMER...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.VI_BBVA_SIT_COMER 
	AS
        with last_oferta as (
            SELECT 
                estado_ofertas.ACT_ID, estado_ofertas.OFR_ID, estado_ofertas.DD_EOF_CODIGO, estado_ofertas.FECHACREAR, estado_ofertas.OFR_FECHA_ALTA
            FROM (
                SELECT DISTINCT ACT2.act_id, EOF.DD_EOF_CODIGO, OFR.OFR_ID, OFR.FECHACREAR, OFR.OFR_FECHA_ALTA,
                    ROW_NUMBER() OVER (PARTITION BY ACT2.act_id ORDER BY OFR.OFR_FECHA_ALTA DESC) AS RN
                FROM '||V_ESQUEMA||'.act_activo ACT2
                    JOIN '||V_ESQUEMA||'.ACT_OFR ACOF ON ACOF.ACT_ID = ACT2.ACT_ID
                    JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ACOF.OFR_ID AND OFR.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID AND EOF.DD_EOF_CODIGO = ''01''
                union
                SELECT DISTINCT ACT2.act_id, EOF.DD_EOF_CODIGO, OFR.OFR_ID, OFR.FECHACREAR, OFR.OFR_FECHA_ALTA,
                    ROW_NUMBER() OVER (PARTITION BY ACT2.act_id ORDER BY OFR.OFR_FECHA_ALTA DESC) AS RN
                FROM '||V_ESQUEMA||'.act_activo ACT2
                    JOIN '||V_ESQUEMA||'.ACT_OFR ACOF ON ACOF.ACT_ID = ACT2.ACT_ID
                    JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ACOF.OFR_ID AND OFR.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID AND EOF.DD_EOF_CODIGO != ''01''
                WHERE NOT EXISTS (
                    SELECT 1
                    FROM '||V_ESQUEMA||'.ACT_OFR ACOF2 
                    JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR2 ON OFR2.OFR_ID = ACOF2.OFR_ID AND OFR2.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF2 ON EOF2.DD_EOF_ID = OFR2.DD_EOF_ID AND EOF2.DD_EOF_CODIGO = ''01''
                    WHERE ACOF2.ACT_ID = ACT2.ACT_ID
                )
            ) estado_ofertas 
            WHERE estado_ofertas.RN = 1
        )
        select 
            ACT.ACT_ID,
            last_oferta.OFR_ID,
            case 
                when 
                        SCM.DD_SCM_CODIGO in (''02'',''09'') -- 09	Disponible condicionado o 02	Disponible para la venta             
                        -- AND ((VCP.COND_PUBL_VENTA = 0 OR VCP.COND_PUBL_ALQUILER = 0) OR (VCP.COND_PUBL_VENTA = 1 and VCP.COND_PUBL_ALQUILER = 1))
                    then ''Libre en venta''
                when 
                        SCM.DD_SCM_CODIGO = ''03'' --	Disponible para la venta con oferta
                        AND last_oferta.DD_EOF_CODIGO in (''01'') AND EEC.DD_EEC_CODIGO in (''01'',''10'')
                    then ''Libre en venta''
                when 
                        SCM.DD_SCM_CODIGO = ''03'' --	Disponible para la venta con oferta
                        AND last_oferta.DD_EOF_CODIGO in (''01'') 
                        AND EEC.DD_EEC_CODIGO in (''11'')  -- Aprobada
                        AND ACT_SPS_SIT_POSESORIA.SPS_OCUPADO in (0,1)
                        AND DD_TPA_TIPO_TITULO_ACT.DD_TPA_CODIGO = ''02''
                        AND COE_CONDICIONANTES_EXPEDIENTE.COE_SOLICITA_RESERVA is null
                        AND ECO.ECO_ESTADO_PBC_R is null
                        AND DD_ERE_ESTADOS_RESERVA.DD_ERE_CODIGO is null
                        AND RES.RES_FECHA_FIRMA is null
                        AND ECO.ECO_ESTADO_PBC is null
                    then ''Apalabrado''
                when SCM.DD_SCM_ID is null
                    then ''No disponible''
                when 
                        SCM.DD_SCM_CODIGO = ''03'' --	Disponible para la venta con oferta
                        AND last_oferta.DD_EOF_CODIGO in (''01'') 
                        AND EEC.DD_EEC_CODIGO in (''11'')  -- Aprobada
                        AND ACT_SPS_SIT_POSESORIA.SPS_OCUPADO in (0,1)
                        AND DD_TPA_TIPO_TITULO_ACT.DD_TPA_CODIGO = ''02''
                        AND COE_CONDICIONANTES_EXPEDIENTE.COE_SOLICITA_RESERVA = 1
                        AND ECO.ECO_ESTADO_PBC_R = 1
                        AND DD_ERE_ESTADOS_RESERVA.DD_ERE_CODIGO = ''01''
                        AND RES.RES_FECHA_FIRMA is null
                        AND ECO.ECO_ESTADO_PBC is null   
                    then ''Reservado''
                when 
                        SCM.DD_SCM_CODIGO = ''03'' --	Disponible para la venta con oferta
                        AND last_oferta.DD_EOF_CODIGO in (''01'') 
                        AND EEC.DD_EEC_CODIGO in (''11'')  -- Aprobada
                        AND ACT_SPS_SIT_POSESORIA.SPS_OCUPADO in (0,1)
                        AND DD_TPA_TIPO_TITULO_ACT.DD_TPA_CODIGO = ''02''
                        AND COE_CONDICIONANTES_EXPEDIENTE.COE_SOLICITA_RESERVA = 0
                        AND ECO.ECO_ESTADO_PBC_R is null
                        AND DD_ERE_ESTADOS_RESERVA.DD_ERE_CODIGO is null
                        AND RES.RES_FECHA_FIRMA is null
                        AND ECO.ECO_ESTADO_PBC = 1
                    then ''Reservado''
                /* when
                        SCM.DD_SCM_CODIGO = ''04'' --	Disponible para la venta con reserva
                        AND last_oferta.DD_EOF_CODIGO in (''01'') 
                        AND EEC.DD_EEC_CODIGO in (''06'')  -- Reservado
                        AND ACT_SPS_SIT_POSESORIA.SPS_OCUPADO in (0,1)
                        AND DD_TPA_TIPO_TITULO_ACT.DD_TPA_CODIGO = ''02''
                        AND COE_CONDICIONANTES_EXPEDIENTE.COE_SOLICITA_RESERVA = 1
                        AND ECO.ECO_ESTADO_PBC_R = 1
                        AND DD_ERE_ESTADOS_RESERVA.DD_ERE_CODIGO = ''02''
                        AND RES.RES_FECHA_FIRMA is not null
                        AND (ECO.ECO_ESTADO_PBC = 1 or ECO.ECO_ESTADO_PBC is null)
                    then ''Contratado'' */
                when
                        SCM.DD_SCM_CODIGO = ''04'' --	Disponible para la venta con reserva
                    then ''Contratado'' 
                when 
                        SCM.DD_SCM_CODIGO = ''05'' --	Vendido
                        -- AND last_oferta.DD_EOF_CODIGO in (''01'') 
                        -- AND EEC.DD_EEC_CODIGO in (''11'')  -- Aprobado
                        -- AND ACT_SPS_SIT_POSESORIA.SPS_OCUPADO in (0,1)
                        -- AND DD_TPA_TIPO_TITULO_ACT.DD_TPA_CODIGO = ''02''
                        -- AND (COE_CONDICIONANTES_EXPEDIENTE.COE_SOLICITA_RESERVA = 1 OR COE_CONDICIONANTES_EXPEDIENTE.COE_SOLICITA_RESERVA is null)
                        -- AND (ECO.ECO_ESTADO_PBC_R = 1 OR ECO.ECO_ESTADO_PBC_R is null)
                        -- AND DD_ERE_ESTADOS_RESERVA.DD_ERE_CODIGO is not null
                        -- AND RES.RES_FECHA_FIRMA is not null
                        -- AND ECO.ECO_ESTADO_PBC = 1 
                        -- AND ECO.ECO_FECHA_VENTA is not null
                    then ''Escriturado''
                when    
                        last_oferta.DD_EOF_CODIGO is null 
                        AND EEC.DD_EEC_CODIGO in (''11'')  -- Aprobado
                        AND ACT_SPS_SIT_POSESORIA.SPS_OCUPADO is null
                        AND DD_TPA_TIPO_TITULO_ACT.DD_TPA_CODIGO is null
                        AND COE_CONDICIONANTES_EXPEDIENTE.COE_SOLICITA_RESERVA is null
                        AND ECO.ECO_ESTADO_PBC_R is null
                        AND DD_ERE_ESTADOS_RESERVA.DD_ERE_CODIGO is null
                        AND RES.RES_FECHA_FIRMA is null
                        AND ECO.ECO_ESTADO_PBC is null 
                        AND ECO.ECO_FECHA_VENTA is null
                    then ''Libre en Alquiler''
                /*when last_oferta.DD_EOF_CODIGO in (''01'')    
                    then ''Uso propio''
                when last_oferta.DD_EOF_CODIGO in (''01'')
                    then ''Reservado para alquiler''
                when last_oferta.DD_EOF_CODIGO in (''01'')
                    then ''En gestión de Ofertas''*/
                when 
                        SCM.DD_SCM_CODIGO = ''03'' --	Disponible para la venta con oferta
                        AND last_oferta.DD_EOF_CODIGO in (''01'')
                        AND EEC.DD_EEC_CODIGO in (''23'')  -- Pendiente de sanción comité
                    then ''Oferta pdte autorización''
                /*when 
                        last_oferta.DD_EOF_CODIGO in (''01'') 
                    then ''Contrato privado''*/
                 WHEN SCM.DD_SCM_CODIGO = ''03'' --	Disponible para la venta con oferta
                        AND ((DIC_TIP_ENT_ACT.DD_TTA_DESCRIPCION = ''Adjudicación judicial'' AND COALESCE(BIEADJ.BIE_ADJ_F_DECRETO_FIRME, NOADJ.ADN_FECHA_TITULO)  IS NULL)
                    	OR (DIC_TIP_ENT_ACT.DD_TTA_DESCRIPCION = ''Adjudicación no judicia'' AND COALESCE(TIT.TIT_FECHA_INSC_REG,BIEADJ.BIE_ADJ_F_INSCRIP_TITULO) IS NULL))
                    THEN ''Contrato privado''
                when 
                        SCM.DD_SCM_CODIGO = ''06'' --	Disponible para la venta con oferta
                        -- AND last_oferta.DD_EOF_CODIGO is null
                        -- AND ACT_PAC_PERIMETRO_ACTIVO.PAC_INCLUIDO = 0
                    then ''Baja contable''
                when
                        SCM.DD_SCM_CODIGO = ''10'' 
                        AND (last_oferta.DD_EOF_CODIGO is null OR last_oferta.DD_EOF_CODIGO in (''02'',''03'',''04''))
                        AND EEC.DD_EEC_CODIGO in (''01'',''10'')  --- 01	En tramitación 10	Pte. Sanción
                        AND ACT_SPS_SIT_POSESORIA.SPS_OCUPADO = 1
                        AND DD_TPA_TIPO_TITULO_ACT.DD_TPA_CODIGO = ''01''
                    then ''Alquilado Libre en Venta''
                /*when 
                        SCM.DD_SCM_CODIGO = ''03'' --	Disponible para la venta con oferta
                        AND last_oferta.DD_EOF_CODIGO in (''01'') 
                        AND EEC.DD_EEC_CODIGO in (''11'')  -- Aprobada
                        AND ACT_SPS_SIT_POSESORIA.SPS_OCUPADO in (0,1)
                        AND DD_TPA_TIPO_TITULO_ACT.DD_TPA_CODIGO in (''01'',''02'')
                        AND COE_CONDICIONANTES_EXPEDIENTE.COE_SOLICITA_RESERVA = 1
                        AND ECO.ECO_ESTADO_PBC_R = 1
                        AND DD_ERE_ESTADOS_RESERVA.DD_ERE_CODIGO = ''01''
                        AND RES.RES_FECHA_FIRMA is null
                        AND ECO.ECO_ESTADO_PBC is null
                    then ''Alquilado Reservado''
                when 
                        SCM.DD_SCM_CODIGO = ''03'' --	Disponible para la venta con oferta
                        AND last_oferta.DD_EOF_CODIGO in (''01'') 
                        AND EEC.DD_EEC_CODIGO in (''11'')  -- Aprobada
                        AND ACT_SPS_SIT_POSESORIA.SPS_OCUPADO in (0,1)
                        AND DD_TPA_TIPO_TITULO_ACT.DD_TPA_CODIGO in (''01'',''02'')
                        AND COE_CONDICIONANTES_EXPEDIENTE.COE_SOLICITA_RESERVA = 0
                        AND ECO.ECO_ESTADO_PBC_R is null
                        AND DD_ERE_ESTADOS_RESERVA.DD_ERE_CODIGO is null
                        AND RES.RES_FECHA_FIRMA is null
                        AND ECO.ECO_ESTADO_PBC = 1
                    then ''Alquilado Reservado''*/
                when 
                        SCM.DD_SCM_CODIGO = ''03'' --	Disponible para la venta con oferta
                    then ''Alquilado Reservado''
                /* when 
                        SCM.DD_SCM_CODIGO = ''04'' --	Disponible para la venta con reserva
                        AND last_oferta.DD_EOF_CODIGO in (''01'') 
                        AND EEC.DD_EEC_CODIGO in (''11'')  -- Aprobada
                        AND ACT_SPS_SIT_POSESORIA.SPS_OCUPADO in (0,1)
                        AND DD_TPA_TIPO_TITULO_ACT.DD_TPA_CODIGO in (''01'')
                        AND COE_CONDICIONANTES_EXPEDIENTE.COE_SOLICITA_RESERVA = 1
                        AND ECO.ECO_ESTADO_PBC_R = 1
                        AND DD_ERE_ESTADOS_RESERVA.DD_ERE_CODIGO = ''02''
                        AND RES.RES_FECHA_FIRMA is not null
                        AND (ECO.ECO_ESTADO_PBC = 1 or ECO.ECO_ESTADO_PBC is null)   
                    then ''Alquilado Contratado'' */
                when 
                        SCM.DD_SCM_CODIGO = ''04'' --	Disponible para la venta con reserva
                    then ''Alquilado Contratado''    
                 when
                        SCM.DD_SCM_CODIGO = ''12'' --	Disponible para venta y alquiler con oferta
                    then ''''
                when
                        SCM.DD_SCM_CODIGO = ''10'' --	Alquilado
                    then ''Alquilado''
                else ''Libre en venta''
            end SITUACION_COMERCIAL_BBVA
        from '||V_ESQUEMA||'.act_activo ACT
            JOIN '||V_ESQUEMA||'.ACT_BBVA_ACTIVOS BBVA ON BBVA.ACT_ID = ACT.ACT_ID
            join '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
            left join last_oferta on last_oferta.ACT_ID = ACT.ACT_ID
            left join '||V_ESQUEMA||'.V_COND_PUBLICACION VCP on VCP.ACT_ID = ACT.ACT_ID
            left join '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = last_oferta.OFR_ID
            left join '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
            left join '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA ON ACT_SPS_SIT_POSESORIA.ACT_ID = ACT.ACT_ID
            left join '||V_ESQUEMA||'.DD_TPA_TIPO_TITULO_ACT ON  DD_TPA_TIPO_TITULO_ACT.DD_TPA_ID = ACT_SPS_SIT_POSESORIA.DD_TPA_ID
            left join '||V_ESQUEMA||'.COE_CONDICIONANTES_EXPEDIENTE ON COE_CONDICIONANTES_EXPEDIENTE.ECO_ID = ECO.ECO_ID   
            left join '||V_ESQUEMA||'.RES_RESERVAS RES ON RES.ECO_ID = ECO.ECO_ID
            left join '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA ON DD_ERE_ESTADOS_RESERVA.DD_ERE_ID = RES.DD_ERE_ID
            left join '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO ON ACT_PAC_PERIMETRO_ACTIVO.ACT_ID = ACT.ACT_ID 
            LEFT JOIN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL AJD ON AJD.ACT_ID = ACT.ACT_ID
            LEFT JOIN '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO DIC_TIP_ENT_ACT ON ACT.DD_TTA_ID = DIC_TIP_ENT_ACT.DD_TTA_ID AND DIC_TIP_ENT_ACT.BORRADO = 0 
            LEFT JOIN '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION BIEADJ ON BIEADJ.BIE_ADJ_ID=AJD.BIE_ADJ_ID AND BIEADJ.BORRADO=0 
            LEFT JOIN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL NOADJ ON NOADJ.ACT_ID = ACT.ACT_ID AND NOADJ.BORRADO=0 
            left JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO TIT ON ACT.ACT_ID = TIT.ACT_ID
                ';
		

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_BBVA_SIT_COMER...Creada OK');
  
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
