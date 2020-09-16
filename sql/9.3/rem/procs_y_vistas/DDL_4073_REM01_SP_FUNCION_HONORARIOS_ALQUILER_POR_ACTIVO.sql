--/*
--##########################################
--## AUTOR=JOSE LUIS BARBA RIBERA
--## FECHA_CREACION=20180913
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4484
--## PRODUCTO=NO
--## Finalidad: Crear una función para obtener la comisión de honorarios de alquiler en función de una oferta, proveedor y tipo de comisión.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##      	0.2 HREOS-2302_GUILLEM REY
--##        0.3 HREOS-2625 Correcciones honorarios
--##        0.4 (20181129)Juan Ruiz - HREOS-4859 Revisión funcionalidad honorarios alquiler
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
  DBMS_OUTPUT.PUT_LINE('[INFO] Función FUNCTION CALCULAR_HONORARIO_ALQUILER: INICIANDO...');   	 
	EXECUTE IMMEDIATE '
create or replace FUNCTION '||V_ESQUEMA||'.CALCULAR_HONORARIO_ALQUILER (P_OFR_ID IN NUMBER, P_PVE_ID IN NUMBER, TIPO_COMISION IN VARCHAR2) RETURN NUMBER AS 

  es_custodio VARCHAR2(1 CHAR);
  canal VARCHAR2(2 CHAR);
  importe_renta NUMBER(12);
  prc_honorario NUMBER(5,2);


BEGIN

  select
    nvl2(pve.pve_custodio, pve.pve_custodio, 0) as es_custodio, -- Llaves en HRE.
    tpr.dd_tpr_codigo as canal, -- Tipo de mediador.
    ofr.OFR_IMPORTE as importe_renta -- Importe de renta.
  into
    es_custodio,
    canal,
    importe_renta
  from ofr_ofertas ofr
  left outer join act_pve_proveedor pve on pve.pve_id = p_pve_id
  left outer join dd_tpr_tipo_proveedor tpr on pve.dd_tpr_id = tpr.dd_tpr_id
  where ofr.ofr_id = p_ofr_id;

  -- Obtener resultado ------------------------------------------------------

  -- Tipo Proveedor definido. (canal)
  IF canal IN (''04'') THEN
      select
      case
        when TIPO_COMISION = ''C'' then TRF.trf_prc_colab
        when TIPO_COMISION = ''P'' then TRF.trf_prc_presc
      end
      into prc_honorario
      from TRF_HONORARIO_ALQUILER TRF
      where TRF.TRF_LLAVES_HRE  = es_custodio
      and TRF.DD_TPR_CODIGO = canal;
   
  ELSE
    -- Tipo Proveedor no definido o FVD (Fuerza Venta Directa) o Gestión Directa. (canal)
      select
      case
        when TIPO_COMISION = ''C'' then TRF.trf_prc_colab
        when TIPO_COMISION = ''P'' then TRF.trf_prc_presc
      end
      into prc_honorario
      from TRF_HONORARIO_ALQUILER TRF
      where TRF.DD_TPR_CODIGO = canal
      and rownum = 1; --FVD es el mismo para cualquier clase/subclase/llaves

  END IF; 

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