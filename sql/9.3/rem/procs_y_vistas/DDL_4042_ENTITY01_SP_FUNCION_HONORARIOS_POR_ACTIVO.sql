--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20170810
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1325, HREOS-2113, HREOS-2625
--## PRODUCTO=NO
--## Finalidad: Crear una función para obtener la comisión de honorarios en función de una oferta, activo, proveedor y tipo de comisión.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##      	0.2 HREOS-2302_GUILLEM REY
--##        0.3 HREOS-2625 Correcciones honorarios
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.


BEGIN
  DBMS_OUTPUT.PUT_LINE('[INFO] Función FUNCTION CALCULAR_HONORARIO: INICIANDO...');   	 
	EXECUTE IMMEDIATE '
create or replace FUNCTION '||V_ESQUEMA||'.CALCULAR_HONORARIO (P_OFR_ID IN NUMBER, P_ACT_ID IN NUMBER, P_PVE_ID IN NUMBER, TIPO_COMISION IN VARCHAR2) RETURN NUMBER AS 

  clase_activo VARCHAR2(2 CHAR);
  subclase_activo VARCHAR2(2 CHAR);
  tipo_activo VARCHAR2(2 CHAR);
  subtipo_activo VARCHAR2(2 CHAR);
  llaves_en_HRE VARCHAR2(1 CHAR);
  canal VARCHAR2(2 CHAR);
  importe_ultima_tasacion NUMBER(12);
  tipo_persona VARCHAR2(20 CHAR);
  prc_honorario NUMBER(5,2);
  
  chk_agr_obra_nueva NUMBER(1,0) := 0;
  chk_es_visita_oficina NUMBER(1,0) := 0;

BEGIN

  select
    cla.DD_CLA_CODIGO as clase_activo,  -- Clase activo bancario.
    sca.DD_SCA_CODIGO as subclase_activo, -- Subtipo activo bancario.
    tpa.dd_tpa_codigo as tipo_activo,  -- Tipo activo (xa relacion con COTIIM).
    sac.dd_sac_codigo as subtipo_activo,  -- Subtipo activo (xa relacion con COSBIN).
    nvl2(act.ACT_LLAVES_HRE, act.ACT_LLAVES_HRE, 0) as llaves_en_HRE, -- Llaves en HRE.
    tpr.dd_tpr_codigo as canal, -- Tipo de mediador.
    tas.TAS_IMPORTE_TAS_FIN as importe_ultima_tasacion,
    tpe.dd_tpe_codigo as tipo_persona
  into
    clase_activo,
    subclase_activo,
    tipo_activo,
    subtipo_activo,
    llaves_en_HRE,
    canal,
    importe_ultima_tasacion,
    tipo_persona
  from ofr_ofertas ofr
  inner join act_ofr aof on ofr.ofr_id = aof.ofr_id and ofr.ofr_id = p_ofr_id
  inner join act_activo act on aof.act_id = act.act_id and act.act_id = p_act_id
  inner join dd_tpa_tipo_activo tpa on act.dd_tpa_id = tpa.dd_tpa_id
  left outer join dd_sac_subtipo_activo sac on act.dd_sac_id = sac.dd_sac_id
  left outer join act_pve_proveedor pve on pve.pve_id = p_pve_id
  left outer join dd_tpr_tipo_proveedor tpr on pve.dd_tpr_id = tpr.dd_tpr_id
  left outer join (
    select tas1.act_id, max(tas_id) ultima_tasacion_id
    from act_tas_tasacion tas1
    group by tas1.act_id
  ) mtas on act.act_id = mtas.act_id
  left outer join act_tas_tasacion tas on mtas.ultima_tasacion_id = tas.tas_id
  inner join act_aba_activo_bancario aba on act.act_id = aba.act_id
  inner join dd_cla_clase_activo cla on aba.dd_cla_id = cla.dd_cla_id
  left join dd_sca_subclase_activo sca on aba.dd_sca_id = sca.dd_sca_id
  left join REMMASTER.dd_tpe_tipo_persona tpe on tpe.dd_tpe_id = pve.dd_tpe_id;


  -- Obtener resultado primera tabla. --  ------------------------------------------------------

  -- Tipo Proveedor definido. (canal)
  IF canal IN (''04'',''28'',''29'',''30'',''31'') THEN
    -- Clase activo Financiero.
    IF clase_activo = ''01'' THEN
      select
      case
        when TIPO_COMISION = ''C'' then TRF.trf_prc_colab
        when TIPO_COMISION = ''P'' then TRF.trf_prc_presc
      end
      into prc_honorario
      from TRF_TRF_PRC_HONORARIOS TRF
      where TRF.DD_CLA_CODIGO = clase_activo
        and TRF.DD_TPR_CODIGO = canal;
    ELSE
    -- Clase activo Inmobiliario.
      IF subclase_activo = ''01'' THEN
        -- SubClase activo Propio.
        select
        case
          when TIPO_COMISION = ''C'' then TRF.trf_prc_colab
          when TIPO_COMISION = ''P'' then TRF.trf_prc_presc
        end
        into prc_honorario
        from TRF_TRF_PRC_HONORARIOS TRF
        where TRF.DD_CLA_CODIGO = clase_activo
          and TRF.DD_SCA_CODIGO = subclase_activo
          and TRF.DD_TPR_CODIGO = canal;
      ELSE
        -- SubClase activo REO.
        select
        case
          when TIPO_COMISION = ''C'' then TRF.trf_prc_colab
          when TIPO_COMISION = ''P'' then TRF.trf_prc_presc
        end
        into prc_honorario
        from TRF_TRF_PRC_HONORARIOS TRF
        where TRF.DD_CLA_CODIGO = clase_activo
          and TRF.DD_SCA_CODIGO = subclase_activo
          and TRF.TRF_LLAVES_HRE = llaves_en_hre
          and TRF.DD_TPR_CODIGO = canal;
      END IF;
    END IF;
  ELSE
    -- Tipo Proveedor no definido o FVD (Fuerza Venta Directa) o Gestión Directa. (canal)
    IF canal = ''18'' THEN
      select
      case
        when TIPO_COMISION = ''C'' then TRF.trf_prc_colab
        when TIPO_COMISION = ''P'' then TRF.trf_prc_presc
      end
      into prc_honorario
      from TRF_TRF_PRC_HONORARIOS TRF
      where TRF.DD_TPR_CODIGO = canal
        and TRF.DD_TPE_CODIGO = tipo_persona
        and TRF.DD_CLA_CODIGO = clase_activo
        and rownum = 1; --FVD es el mismo para cualquier clase/subclase/llaves
    ELSIF canal = ''37'' THEN
      select
      case
        when TIPO_COMISION = ''C'' then TRF.trf_prc_colab
        when TIPO_COMISION = ''P'' then TRF.trf_prc_presc
      end
      into prc_honorario
      from TRF_TRF_PRC_HONORARIOS TRF
      where TRF.DD_TPR_CODIGO = canal
        and rownum = 1; --FVD es el mismo para cualquier clase/subclase/llaves
    ELSE -- No definido tipo proveedor
      RETURN NULL;
    END IF;
  END IF;


  -- Procesar resultado primera tabla.

  -- Check: La visita la realiza la oficina
  -- (Inmobiliario + REO + Llaves=SI + proveedor Oficinas | Colaboracion)
  IF (TIPO_COMISION = ''C'' AND clase_activo = ''02'' AND subclase_activo = ''02'' 
    AND llaves_en_HRE = 1 AND canal in (''28'',''29'')) THEN
    select decode(count(vis1.vis_id), 0, 0, 1) chk_es_visita_oficina
    into chk_es_visita_oficina
    from vis_visitas vis1
    inner join ofr_ofertas ofr1 on vis1.vis_id = ofr1.vis_id
    where 
      vis1.act_id = p_act_id
      and ofr1.ofr_id = p_ofr_id
      and vis1.PVE_ID_PVE_VISITA = p_pve_id
      and rownum = 1;
      
    IF chk_es_visita_oficina = 1 THEN
      RETURN 0;
    END IF;
  END IF;
    
  IF prc_honorario IS NULL THEN -- Sin honorarios.
    RETURN null;
  ELSE
    IF prc_honorario != 00000 THEN -- Tiene Honorarios.
      RETURN prc_honorario;
    END IF;
  END IF;


  -- Obtener resultado segunda tabla. --  ------------------------------------------------------

  select
  case
    when TIPO_COMISION = ''C'' then TPT.tpt_prc_colab
    when TIPO_COMISION = ''P'' then TPT.tpt_prc_presc
  end
  into prc_honorario
  from TRF_TPT_PRC_HONORAR_TIPOLOG TPT
  where TPT.DD_TPA_CODIGO = tipo_activo
    and TPT.DD_SAC_CODIGO = subtipo_activo;


  -- Procesar resultado segunda tabla.
  
  -- Check: Tipo-Subtipo Activo Comercial-Local pertenece a una agrupacion
  --        de obra nueva (activa)
  -- Si NO pertenece a agrupacion de obra nueva, debe calcular sobre tercera tabla.
  IF (tipo_activo = ''03'' AND subtipo_activo = ''13'') THEN-- Tipo=Comercial y Subtipo=Local
    SELECT decode(count(agr.agr_id), 0 ,0, 1) INTO chk_agr_obra_nueva
    FROM ACT_AGR_AGRUPACION agr 
    INNER JOIN DD_TAG_TIPO_AGRUPACION tag on agr.DD_TAG_ID = tag.DD_TAG_ID 
      and tag.DD_TAG_CODIGO = ''01'' and agr.borrado = 0 and tag.borrado = 0 
    INNER JOIN ACT_AGA_AGRUPACION_ACTIVO aga on agr.agr_id = aga.agr_id 
      and aga.borrado = 0 and aga.act_id = p_act_id;
      
    IF chk_agr_obra_nueva = 1 THEN -- Si es obra nueva => Resultado fijo, y si no es, 3a tabla 
      IF TIPO_COMISION = ''C'' THEN RETURN 0.75; END IF;
      IF TIPO_COMISION = ''P'' THEN RETURN 2.25; END IF;
    END IF;
  END IF;
  
  IF prc_honorario IS NULL THEN -- Sin honorarios.
    RETURN null;
  ELSE
    IF prc_honorario != 00000 THEN -- Tiene Honorarios.
      RETURN prc_honorario;
    END IF;
  END IF;


  -- Obtener resultado tercera tabla. --  ------------------------------------------------------

  SELECT
  case
    when TIPO_COMISION = ''C'' then TTR.ttr_prc_colab
    when TIPO_COMISION = ''P'' then TTR.ttr_prc_presc
  end
  into prc_honorario
  FROM TRF_TTR_PRC_HONORAR_TRAMOS TTR
  WHERE TTR.TTR_IMPORTE_TRAMO =
    (SELECT MIN(TTR_IMPORTE_TRAMO)
      FROM
        (SELECT TTR2.TTR_IMPORTE_TRAMO
          FROM TRF_TTR_PRC_HONORAR_TRAMOS TTR2
          WHERE importe_ultima_tasacion <= TTR2.TTR_IMPORTE_TRAMO
        )
    );

  RETURN PRC_HONORARIO;

EXCEPTION
         WHEN OTHERS THEN
              DBMS_OUTPUT.put_line(''[ERROR] Se ha producido un error en la ejecución: ''||TO_CHAR(SQLCODE));
              DBMS_OUTPUT.put_line(''-----------------------------------------------------------'');
              DBMS_OUTPUT.put_line(SQLERRM);
              RETURN NULL;

END;';
  
DBMS_OUTPUT.PUT_LINE('[INFO] Proceso ejecutado CORRECTAMENTE. Function creada.');
	
COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT