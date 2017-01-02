--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20161229
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1325
--## PRODUCTO=NO
--## Finalidad: Crear una función para obtener el porcentaje de honorarios.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
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
create or replace FUNCTION '||V_ESQUEMA||'.CALCULAR_HONORARIO (OFR_ID IN NUMBER, TIPO_COMISION IN VARCHAR2) RETURN NUMBER AS 

  clase_activo VARCHAR2(2 CHAR);
  subclase_activo VARCHAR2(2 CHAR);
  tipo_activo VARCHAR2(2 CHAR);
  subtipo_activo VARCHAR2(2 CHAR);
  llaves_en_HRE VARCHAR2(1 CHAR);
  canal VARCHAR2(2 CHAR);
  importe_ultima_tasacion NUMBER(12);
  prc_honorario NUMBER(5,2);

BEGIN

  -- Obtener datos para filtrar el porcentaje obtenido en base a la oferta y el tipo de honorario (Colaboración / Prescripción).
  IF TIPO_COMISION = ''C'' THEN -- Consulta para calculos de honorarios de tipo "Colaboracion".
    select
      cla.DD_CLA_CODIGO as clase_activo,  -- Clase activo bancario.
      sca.DD_SCA_CODIGO as subclase_activo, -- Subtipo activo bancario.
      tpa.dd_tpa_codigo as tipo_activo,  -- Tipo activo (xa relacion con COTIIM).
      sac.dd_sac_codigo as subtipo_activo,  -- Subtipo activo (xa relacion con COSBIN).
      act.ACT_LLAVES_HRE as llaves_en_HRE, -- Llaves en HRE.
      tpr.dd_tpr_codigo as canal, -- Tipo de mediador.
      tas.TAS_IMPORTE_TAS_FIN as importe_ultima_tasacion
    into
      clase_activo,
      subclase_activo,
      tipo_activo,
      subtipo_activo,
      llaves_en_HRE,
      canal,
      importe_ultima_tasacion
    from ofr_ofertas ofr
    inner join act_ofr aof on ofr.ofr_id = aof.ofr_id
    inner join act_activo act on aof.act_id = act.act_id
    inner join dd_tpa_tipo_activo tpa on act.dd_tpa_id = tpa.dd_tpa_id
    inner join dd_sac_subtipo_activo sac on act.dd_sac_id = sac.dd_sac_id
    inner join act_pve_proveedor pve on pve.pve_id =  
      case 
        when ofr.PVE_ID_FDV is not null then ofr.PVE_ID_FDV
        when ofr.PVE_ID_CUSTODIO is not null then ofr.PVE_ID_CUSTODIO
      end -- Join primero con FDV porque tiene prioridad y si no hay FDV, join con custodio -- Como colaborador
    inner join dd_tpr_tipo_proveedor tpr on pve.dd_tpr_id = tpr.dd_tpr_id
    inner join (
      select tas1.act_id, max(tas_id) ultima_tasacion_id 
      from act_tas_tasacion tas1
      group by tas1.act_id
    ) mtas on act.act_id = mtas.act_id
    inner join act_tas_tasacion tas on mtas.ultima_tasacion_id = tas.tas_id
    inner join act_aba_activo_bancario aba on act.act_id = aba.act_id
    inner join dd_cla_clase_activo cla on aba.dd_cla_id = cla.dd_cla_id
    left join dd_sca_subclase_activo sca on aba.dd_sca_id = sca.dd_sca_id;

  ELSIF TIPO_COMISION = ''P'' THEN -- Consulta para calculos de honorarios de tipo "Colaboracion".
      select 
        cla.DD_CLA_CODIGO as clase_activo,  -- Clase activo bancario.
        sca.DD_SCA_CODIGO as subclase_activo, -- Subtipo activo bancario.
        tpa.dd_tpa_codigo as tipo_activo,  -- Tipo activo (xa relacion con COTIIM).
        sac.dd_sac_codigo as subtipo_activo,  -- Subtipo activo (xa relacion con COSBIN).
        act.ACT_LLAVES_HRE as llaves_en_HRE, -- Llaves en HRE
        tpr.dd_tpr_codigo as canal, -- Tipo de mediador.
        tas.TAS_IMPORTE_TAS_FIN as importe_ultima_tasacion
      into
        clase_activo,
        subclase_activo,
        tipo_activo,
        subtipo_activo,
        llaves_en_HRE,
        canal,
        importe_ultima_tasacion
      from ofr_ofertas ofr
      inner join act_ofr aof on ofr.ofr_id = aof.ofr_id
      inner join act_activo act on aof.act_id = act.act_id
      inner join dd_tpa_tipo_activo tpa on act.dd_tpa_id = tpa.dd_tpa_id
      inner join dd_sac_subtipo_activo sac on act.dd_sac_id = sac.dd_sac_id
      inner join act_pve_proveedor pve on pve.pve_id = ofr.PVE_ID_PRESCRIPTOR -- Join solo con prescriptor -- Como prescriptor
      inner join dd_tpr_tipo_proveedor tpr on pve.dd_tpr_id = tpr.dd_tpr_id
      inner join (
        select tas1.act_id, max(tas_id) ultima_tasacion_id 
        from act_tas_tasacion tas1
        group by tas1.act_id
      ) mtas on act.act_id = mtas.act_id
      inner join act_tas_tasacion tas on mtas.ultima_tasacion_id = tas.tas_id
      inner join act_aba_activo_bancario aba on act.act_id = aba.act_id
      inner join dd_cla_clase_activo cla on aba.dd_cla_id = cla.dd_cla_id
      left join dd_sca_subclase_activo sca on aba.dd_sca_id = sca.dd_sca_id;

  ELSE -- Si es otro tipo no definido devolver null.
    RETURN NULL;
  END IF;


-- Obtener resultado primera tabla.
  IF canal IN (''04'',''28'',''29'',''30'',''31'') THEN -- Tipo Proveedor definido.
      IF clase_activo = ''01'' THEN -- Clase activo Financiero.
          select 
              case
                  when TIPO_COMISION = ''C'' then TRF.trf_prc_colab
                  when TIPO_COMISION = ''P'' then TRF.trf_prc_presc
              end
          into prc_honorario 
          from TRF_TRF_PRC_HONORARIOS TRF
          where TRF.DD_CLA_CODIGO = clase_activo
          and TRF.DD_TPR_CODIGO = canal;
       ELSE -- Clase activo Inmobiliario.
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
  ELSE -- Tipo Proveedor no definido.
      RETURN NULL;
  END IF;


-- Procesar resultado primera tabla.
  IF prc_honorario IS NULL THEN -- Sin honorarios.
    RETURN null;
  ELSIF prc_honorario != 00000 THEN -- Tiene Honorarios.
   RETURN prc_honorario;
  END IF;


-- Obtener resultado segunda tabla.
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
  IF prc_honorario IS NULL THEN -- Sin honorarios.
    RETURN null;
  ELSIF prc_honorario != 00000 THEN -- Tiene Honorarios.
   RETURN prc_honorario;
  END IF;


-- Obtener resultado tercera tabla.
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

END;
	';
  
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