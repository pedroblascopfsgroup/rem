package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.recovery.ext.impl.utils.StringUtils;

public class FiltroBusquedaProcedimientoPcoDTO extends WebDto {

	private static final long serialVersionUID = -1113911238693790533L;

	public static final String BUSQUEDA_DOCUMENTO = "DOCUMENTO";
    public static final String BUSQUEDA_LIQUIDACION = "LIQUIDACION";
    public static final String BUSQUEDA_BUROFAX = "BUROFAX";
    public static final String SALIDA_XLS = "xls";

    private String tipoBusqueda; // Documentos, Liquidaciones, Burofaxes.

	// ProcedimientoPco
	private String proCodigo;
	private String proNombre;
	private String proFechaInicioPreparacionDesde;
	private String proFechaInicioPreparacionHasta;
	private String proFechaPreparadoDesde;
	private String proFechaPreparadoHasta;
	private String proFechaEnviadoLetradoDesde;
	private String proFechaEnviadoLetradoHasta;
	private String proFechaFinalizadoDesde;
	private String proFechaFinalizadoHasta;
	private String proFechaUltimaSubsanacionDesde;
	private String proFechaUltimaSubsanacionHasta;
	private String proFechaCanceladoDesde;
	private String proFechaCanceladoHasta;
	private String proFechaParalizacionDesde;
	private String proFechaParalizacionHasta;
	private String proTipoProcedimiento;
	private String proTipoPreparacion;
	private String proCodigosEstado;
	private String proDisponibleDocumentos;
	private String proDisponibleLiquidaciones;
	private String proDisponibleBurofaxes;
	private String proDiasGestion;
	private String proTipoGestor;
	private String proDespacho;
	private String proGestor;
	private String proJerarquiaContable;
	private String proCentroContable;
	private String importeDesde;
	private String importeHasta;
	

	// Contrato - Persona
	private String conCodigo;
	private String conTiposProducto;
	private String conNif;
	private String conNombre;
	private String conApellidos;

	// Documentos
	private String docTiposDocumento;
	private String docEstados;
	private String docUltimaRespuesta;
	private String docFechaSolicitudDesde;
	private String docFechaSolicitudHasta;
	private String docFechaResultadoDesde;
	private String docFechaResultadoHasta;
	private String docFechaEnvioDesde;
	private String docFechaEnvioHasta;
	private String docFechaRecepcionDesde;
	private String docFechaRecepcionHasta;
	private String docAdjunto;
	private String docSolicitudPrevia;
	private String docDiasGestion;
	private String docTipoGestor;
	private String docDespacho;
	private String docGestor;

	// Liquidacion
	private String liqEstados;
	private String liqFechaSolicitudDesde;
	private String liqFechaSolicitudHasta;
	private String liqFechaRecepcionDesde;
	private String liqFechaRecepcionHasta;
	private String liqFechaConfirmacionDesde;
	private String liqFechaConfirmacionHasta;
	private String liqFechaCierreDesde;
	private String liqFechaCierreHasta;
	private String liqTotalDesde;
	private String liqTotalHasta;
	private String liqDiasGestion;

	// Burofax
	private String burResultadoEnvio;
	private String burFechaSolicitudDesde;
	private String burFechaSolicitudHasta;
	private String burFechaAcuseDesde;
	private String burFechaAcuseHasta;
	private String burFechaEnvioDesde;
	private String burFechaEnvioHasta;
	private String burRefExternaEnvio;
	private String burRegManual;
	private String burAcuseRecibo;

	/**
	 * Comprueba si está informado el filtro de persona
	 */
	public Boolean filtroPersonaInformado() {
		Boolean filtroPersonaInformado = Boolean.valueOf((!StringUtils.emtpyString(getConNombre())
			|| !StringUtils.emtpyString(getConApellidos())
			|| !StringUtils.emtpyString(getConNif())));

		return filtroPersonaInformado;
	}

	/**
	 * Comprueba si está informado el filtro de contrato
	 */
	public Boolean filtroContratoInformado() {
		Boolean filtroContratoInformado = Boolean.valueOf(!StringUtils.emtpyString(getConCodigo())
				|| !StringUtils.emtpyString(getConTiposProducto())
				|| !StringUtils.emtpyString(getProCentroContable()));

		return filtroContratoInformado;
	}

	/**
	 * Comprueba si está informado el filtro de gestor
	 */
	public Boolean filtroGestorInformado() {
		Boolean filtroGestorInformado = Boolean.valueOf(!StringUtils.emtpyString(proTipoGestor)
			&& !StringUtils.emtpyString(proDespacho)
			&& !StringUtils.emtpyString(proGestor));

		return filtroGestorInformado;
	}

	/**
	 * Comprueba si está informado el filtro de documento
	 */
	public Boolean filtroDocumentoInformado() {
		Boolean filtroDocumentoInformado = Boolean.valueOf(
			!StringUtils.emtpyString(getDocTiposDocumento())
			|| !StringUtils.emtpyString(getDocEstados())
			|| !StringUtils.emtpyString(getDocAdjunto())
			|| !StringUtils.emtpyString(getDocSolicitudPrevia()));
		return filtroDocumentoInformado;
	}

	/**
	 * Comprueba si está informado el filtro de solicitud
	 */
	public Boolean filtroSolicitudInformado() {
		Boolean filtroSolicitudInformado = Boolean.valueOf(
			!StringUtils.emtpyString(getDocUltimaRespuesta())
			|| !StringUtils.emtpyString(getDocFechaSolicitudDesde())
			|| !StringUtils.emtpyString(getDocFechaSolicitudHasta())
			|| !StringUtils.emtpyString(getDocFechaResultadoDesde())
			|| !StringUtils.emtpyString(getDocFechaResultadoHasta())
			|| !StringUtils.emtpyString(getDocFechaEnvioDesde())
			|| !StringUtils.emtpyString(getDocFechaEnvioHasta())
			|| !StringUtils.emtpyString(getDocFechaRecepcionDesde())
			|| !StringUtils.emtpyString(getDocFechaRecepcionHasta())
			|| (!StringUtils.emtpyString(docDespacho) && !StringUtils.emtpyString(docGestor))
			|| !StringUtils.emtpyString(getDocDiasGestion()));
		return filtroSolicitudInformado;
	}

	/**
	 * Comprueba si está informado el filtro de liquidacion
	 */
	public Boolean filtroLiquidacionInformado() {
		Boolean filtroLiquidacionInformado = Boolean.valueOf(
			!StringUtils.emtpyString(getLiqEstados())
			|| !StringUtils.emtpyString(getLiqFechaSolicitudDesde())
			|| !StringUtils.emtpyString(getLiqFechaSolicitudHasta())
			|| !StringUtils.emtpyString(getLiqFechaRecepcionDesde())
			|| !StringUtils.emtpyString(getLiqFechaRecepcionHasta())
			|| !StringUtils.emtpyString(getLiqFechaConfirmacionDesde())
			|| !StringUtils.emtpyString(getLiqFechaConfirmacionHasta())
			|| !StringUtils.emtpyString(getLiqFechaCierreDesde())
			|| !StringUtils.emtpyString(getLiqFechaCierreHasta())
			|| !StringUtils.emtpyString(getLiqTotalDesde())
			|| !StringUtils.emtpyString(getLiqTotalHasta())
			|| !StringUtils.emtpyString(getLiqDiasGestion()));
		return filtroLiquidacionInformado;
	}

	/**
	 * Comprueba si está informado el filtro de burofaxes
	 */
	public Boolean filtroBurofaxInformado() {
		Boolean filtroBurofaxInformado = Boolean.valueOf(
			!StringUtils.emtpyString(getBurResultadoEnvio())
			|| !StringUtils.emtpyString(getBurFechaSolicitudDesde())
			|| !StringUtils.emtpyString(getBurFechaSolicitudHasta())
			|| !StringUtils.emtpyString(getBurFechaAcuseDesde())
			|| !StringUtils.emtpyString(getBurFechaAcuseHasta())
			|| !StringUtils.emtpyString(getBurFechaEnvioDesde())
			|| !StringUtils.emtpyString(getBurFechaEnvioHasta())
			|| !StringUtils.emtpyString(getBurAcuseRecibo())
			|| !StringUtils.emtpyString(getBurRefExternaEnvio())
			|| !StringUtils.emtpyString(getBurRegManual()));
		return filtroBurofaxInformado;
	}

	/*
	 * GETTERS & SETTERS
	 */

	public String getProCodigo() {
		return proCodigo;
	}
	public void setProCodigo(String proCodigo) {
		this.proCodigo = proCodigo;
	}
	public String getProNombre() {
		return proNombre;
	}
	public void setProNombre(String proNombre) {
		this.proNombre = proNombre;
	}
	public String getProFechaInicioPreparacionDesde() {
		return proFechaInicioPreparacionDesde;
	}
	public void setProFechaInicioPreparacionDesde(String proFechaInicioPreparacionDesde) {
		this.proFechaInicioPreparacionDesde = proFechaInicioPreparacionDesde;
	}
	public String getProFechaInicioPreparacionHasta() {
		return proFechaInicioPreparacionHasta;
	}
	public void setProFechaInicioPreparacionHasta(String proFechaInicioPreparacionHasta) {
		this.proFechaInicioPreparacionHasta = proFechaInicioPreparacionHasta;
	}
	public String getProFechaPreparadoDesde() {
		return proFechaPreparadoDesde;
	}
	public void setProFechaPreparadoDesde(String proFechaPreparadoDesde) {
		this.proFechaPreparadoDesde = proFechaPreparadoDesde;
	}
	public String getProFechaPreparadoHasta() {
		return proFechaPreparadoHasta;
	}
	public void setProFechaPreparadoHasta(String proFechaPreparadoHasta) {
		this.proFechaPreparadoHasta = proFechaPreparadoHasta;
	}
	public String getProFechaEnviadoLetradoDesde() {
		return proFechaEnviadoLetradoDesde;
	}
	public void setProFechaEnviadoLetradoDesde(String proFechaEnviadoLetradoDesde) {
		this.proFechaEnviadoLetradoDesde = proFechaEnviadoLetradoDesde;
	}
	public String getProFechaEnviadoLetradoHasta() {
		return proFechaEnviadoLetradoHasta;
	}
	public void setProFechaEnviadoLetradoHasta(String proFechaEnviadoLetradoHasta) {
		this.proFechaEnviadoLetradoHasta = proFechaEnviadoLetradoHasta;
	}
	public String getProFechaFinalizadoDesde() {
		return proFechaFinalizadoDesde;
	}
	public void setProFechaFinalizadoDesde(String proFechaFinalizadoDesde) {
		this.proFechaFinalizadoDesde = proFechaFinalizadoDesde;
	}
	public String getProFechaFinalizadoHasta() {
		return proFechaFinalizadoHasta;
	}
	public void setProFechaFinalizadoHasta(String proFechaFinalizadoHasta) {
		this.proFechaFinalizadoHasta = proFechaFinalizadoHasta;
	}
	public String getProFechaUltimaSubsanacionDesde() {
		return proFechaUltimaSubsanacionDesde;
	}
	public void setProFechaUltimaSubsanacionDesde(String proFechaUltimaSubsanacionDesde) {
		this.proFechaUltimaSubsanacionDesde = proFechaUltimaSubsanacionDesde;
	}
	public String getProFechaUltimaSubsanacionHasta() {
		return proFechaUltimaSubsanacionHasta;
	}
	public void setProFechaUltimaSubsanacionHasta(String proFechaUltimaSubsanacionHasta) {
		this.proFechaUltimaSubsanacionHasta = proFechaUltimaSubsanacionHasta;
	}
	public String getProFechaCanceladoDesde() {
		return proFechaCanceladoDesde;
	}
	public void setProFechaCanceladoDesde(String proFechaCanceladoDesde) {
		this.proFechaCanceladoDesde = proFechaCanceladoDesde;
	}
	public String getProFechaCanceladoHasta() {
		return proFechaCanceladoHasta;
	}
	public void setProFechaCanceladoHasta(String proFechaCanceladoHasta) {
		this.proFechaCanceladoHasta = proFechaCanceladoHasta;
	}
	public String getProFechaParalizacionDesde() {
		return proFechaParalizacionDesde;
	}
	public void setProFechaParalizacionDesde(String proFechaParalizacionDesde) {
		this.proFechaParalizacionDesde = proFechaParalizacionDesde;
	}
	public String getProFechaParalizacionHasta() {
		return proFechaParalizacionHasta;
	}
	public void setProFechaParalizacionHasta(String proFechaParalizacionHasta) {
		this.proFechaParalizacionHasta = proFechaParalizacionHasta;
	}
	public String getProTipoProcedimiento() {
		return proTipoProcedimiento;
	}
	public void setProTipoProcedimiento(String proTipoProcedimiento) {
		this.proTipoProcedimiento = proTipoProcedimiento;
	}
	public String getProTipoPreparacion() {
		return proTipoPreparacion;
	}
	public void setProTipoPreparacion(String proTipoPreparacion) {
		this.proTipoPreparacion = proTipoPreparacion;
	}
	public String getProCodigosEstado() {
		return proCodigosEstado;
	}
	public void setProCodigosEstado(String proCodigosEstado) {
		this.proCodigosEstado = proCodigosEstado;
	}
	public String getProDisponibleDocumentos() {
		return proDisponibleDocumentos;
	}
	public void setProDisponibleDocumentos(String proDisponibleDocumentos) {
		this.proDisponibleDocumentos = proDisponibleDocumentos;
	}
	public String getProDisponibleLiquidaciones() {
		return proDisponibleLiquidaciones;
	}
	public void setProDisponibleLiquidaciones(String proDisponibleLiquidaciones) {
		this.proDisponibleLiquidaciones = proDisponibleLiquidaciones;
	}
	public String getProDisponibleBurofaxes() {
		return proDisponibleBurofaxes;
	}
	public void setProDisponibleBurofaxes(String proDisponibleBurofaxes) {
		this.proDisponibleBurofaxes = proDisponibleBurofaxes;
	}
	public String getProDiasGestion() {
		return proDiasGestion;
	}
	public void setProDiasGestion(String proDiasGestion) {
		this.proDiasGestion = proDiasGestion;
	}
	public String getConCodigo() {
		return conCodigo;
	}
	public void setConCodigo(String conCodigo) {
		this.conCodigo = conCodigo;
	}
	public String getConTiposProducto() {
		return conTiposProducto;
	}
	public void setConTiposProducto(String conTiposProducto) {
		this.conTiposProducto = conTiposProducto;
	}
	public String getConNif() {
		return conNif;
	}
	public void setConNif(String conNif) {
		this.conNif = conNif;
	}
	public String getConNombre() {
		return conNombre;
	}
	public void setConNombre(String conNombre) {
		this.conNombre = conNombre;
	}
	public String getConApellidos() {
		return conApellidos;
	}
	public void setConApellidos(String conApellidos) {
		this.conApellidos = conApellidos;
	}
	public String getDocTiposDocumento() {
		return docTiposDocumento;
	}
	public void setDocTiposDocumento(String docTiposDocumento) {
		this.docTiposDocumento = docTiposDocumento;
	}
	public String getDocEstados() {
		return docEstados;
	}
	public void setDocEstados(String docEstados) {
		this.docEstados = docEstados;
	}
	public String getDocUltimaRespuesta() {
		return docUltimaRespuesta;
	}
	public void setDocUltimaRespuesta(String docUltimaRespuesta) {
		this.docUltimaRespuesta = docUltimaRespuesta;
	}
	public String getDocFechaSolicitudDesde() {
		return docFechaSolicitudDesde;
	}
	public void setDocFechaSolicitudDesde(String docFechaSolicitudDesde) {
		this.docFechaSolicitudDesde = docFechaSolicitudDesde;
	}
	public String getDocFechaSolicitudHasta() {
		return docFechaSolicitudHasta;
	}
	public void setDocFechaSolicitudHasta(String docFechaSolicitudHasta) {
		this.docFechaSolicitudHasta = docFechaSolicitudHasta;
	}
	public String getDocFechaResultadoDesde() {
		return docFechaResultadoDesde;
	}
	public void setDocFechaResultadoDesde(String docFechaResultadoDesde) {
		this.docFechaResultadoDesde = docFechaResultadoDesde;
	}
	public String getDocFechaResultadoHasta() {
		return docFechaResultadoHasta;
	}
	public void setDocFechaResultadoHasta(String docFechaResultadoHasta) {
		this.docFechaResultadoHasta = docFechaResultadoHasta;
	}
	public String getDocFechaEnvioDesde() {
		return docFechaEnvioDesde;
	}
	public void setDocFechaEnvioDesde(String docFechaEnvioDesde) {
		this.docFechaEnvioDesde = docFechaEnvioDesde;
	}
	public String getDocFechaEnvioHasta() {
		return docFechaEnvioHasta;
	}
	public void setDocFechaEnvioHasta(String docFechaEnvioHasta) {
		this.docFechaEnvioHasta = docFechaEnvioHasta;
	}
	public String getDocFechaRecepcionDesde() {
		return docFechaRecepcionDesde;
	}
	public void setDocFechaRecepcionDesde(String docFechaRecepcionDesde) {
		this.docFechaRecepcionDesde = docFechaRecepcionDesde;
	}
	public String getDocFechaRecepcionHasta() {
		return docFechaRecepcionHasta;
	}
	public void setDocFechaRecepcionHasta(String docFechaRecepcionHasta) {
		this.docFechaRecepcionHasta = docFechaRecepcionHasta;
	}
	public String getDocAdjunto() {
		return docAdjunto;
	}
	public void setDocAdjunto(String docAdjunto) {
		this.docAdjunto = docAdjunto;
	}
	public String getDocSolicitudPrevia() {
		return docSolicitudPrevia;
	}
	public void setDocSolicitudPrevia(String docSolicitudPrevia) {
		this.docSolicitudPrevia = docSolicitudPrevia;
	}
	public String getDocDiasGestion() {
		return docDiasGestion;
	}
	public void setDocDiasGestion(String docDiasGestion) {
		this.docDiasGestion = docDiasGestion;
	}
	public String getLiqEstados() {
		return liqEstados;
	}
	public void setLiqEstados(String liqEstados) {
		this.liqEstados = liqEstados;
	}
	public String getLiqFechaSolicitudDesde() {
		return liqFechaSolicitudDesde;
	}
	public void setLiqFechaSolicitudDesde(String liqFechaSolicitudDesde) {
		this.liqFechaSolicitudDesde = liqFechaSolicitudDesde;
	}
	public String getLiqFechaSolicitudHasta() {
		return liqFechaSolicitudHasta;
	}
	public void setLiqFechaSolicitudHasta(String liqFechaSolicitudHasta) {
		this.liqFechaSolicitudHasta = liqFechaSolicitudHasta;
	}
	public String getLiqFechaRecepcionDesde() {
		return liqFechaRecepcionDesde;
	}
	public void setLiqFechaRecepcionDesde(String liqFechaRecepcionDesde) {
		this.liqFechaRecepcionDesde = liqFechaRecepcionDesde;
	}
	public String getLiqFechaRecepcionHasta() {
		return liqFechaRecepcionHasta;
	}
	public void setLiqFechaRecepcionHasta(String liqFechaRecepcionHasta) {
		this.liqFechaRecepcionHasta = liqFechaRecepcionHasta;
	}
	public String getLiqFechaConfirmacionDesde() {
		return liqFechaConfirmacionDesde;
	}
	public void setLiqFechaConfirmacionDesde(String liqFechaConfirmacionDesde) {
		this.liqFechaConfirmacionDesde = liqFechaConfirmacionDesde;
	}
	public String getLiqFechaConfirmacionHasta() {
		return liqFechaConfirmacionHasta;
	}
	public void setLiqFechaConfirmacionHasta(String liqFechaConfirmacionHasta) {
		this.liqFechaConfirmacionHasta = liqFechaConfirmacionHasta;
	}
	public String getLiqFechaCierreDesde() {
		return liqFechaCierreDesde;
	}
	public void setLiqFechaCierreDesde(String liqFechaCierreDesde) {
		this.liqFechaCierreDesde = liqFechaCierreDesde;
	}
	public String getLiqFechaCierreHasta() {
		return liqFechaCierreHasta;
	}
	public void setLiqFechaCierreHasta(String liqFechaCierreHasta) {
		this.liqFechaCierreHasta = liqFechaCierreHasta;
	}
	public String getLiqTotalDesde() {
		return liqTotalDesde;
	}
	public void setLiqTotalDesde(String liqTotalDesde) {
		this.liqTotalDesde = liqTotalDesde;
	}
	public String getLiqTotalHasta() {
		return liqTotalHasta;
	}
	public void setLiqTotalHasta(String liqTotalHasta) {
		this.liqTotalHasta = liqTotalHasta;
	}
	public String getLiqDiasGestion() {
		return liqDiasGestion;
	}
	public void setLiqDiasGestion(String liqDiasGestion) {
		this.liqDiasGestion = liqDiasGestion;
	}
	public String getBurResultadoEnvio() {
		return burResultadoEnvio;
	}
	public void setBurResultadoEnvio(String burResultadoEnvio) {
		this.burResultadoEnvio = burResultadoEnvio;
	}
	public String getBurFechaSolicitudDesde() {
		return burFechaSolicitudDesde;
	}
	public void setBurFechaSolicitudDesde(String burFechaSolicitudDesde) {
		this.burFechaSolicitudDesde = burFechaSolicitudDesde;
	}
	public String getBurFechaSolicitudHasta() {
		return burFechaSolicitudHasta;
	}
	public void setBurFechaSolicitudHasta(String burFechaSolicitudHasta) {
		this.burFechaSolicitudHasta = burFechaSolicitudHasta;
	}
	public String getBurFechaAcuseDesde() {
		return burFechaAcuseDesde;
	}
	public void setBurFechaAcuseDesde(String burFechaAcuseDesde) {
		this.burFechaAcuseDesde = burFechaAcuseDesde;
	}
	public String getBurFechaAcuseHasta() {
		return burFechaAcuseHasta;
	}
	public void setBurFechaAcuseHasta(String burFechaAcuseHasta) {
		this.burFechaAcuseHasta = burFechaAcuseHasta;
	}
	public String getBurFechaEnvioDesde() {
		return burFechaEnvioDesde;
	}
	public void setBurFechaEnvioDesde(String burFechaEnvioDesde) {
		this.burFechaEnvioDesde = burFechaEnvioDesde;
	}
	public String getBurFechaEnvioHasta() {
		return burFechaEnvioHasta;
	}
	public void setBurFechaEnvioHasta(String burFechaEnvioHasta) {
		this.burFechaEnvioHasta = burFechaEnvioHasta;
	}
	public String getTipoBusqueda() {
		return tipoBusqueda;
	}
	public void setTipoBusqueda(String tipoBusqueda) {
		this.tipoBusqueda = tipoBusqueda;
	}
	public String getProTipoGestor() {
		return proTipoGestor;
	}
	public void setProTipoGestor(String proTipoGestor) {
		this.proTipoGestor = proTipoGestor;
	}
	public String getProDespacho() {
		return proDespacho;
	}
	public void setProDespacho(String proDespacho) {
		this.proDespacho = proDespacho;
	}
	public String getProGestor() {
		return proGestor;
	}
	public void setProGestor(String proGestor) {
		this.proGestor = proGestor;
	}
	public String getProJerarquiaContable() {
		return proJerarquiaContable;
	}
	public void setProJerarquiaContable(String proJerarquiaContable) {
		this.proJerarquiaContable = proJerarquiaContable;
	}
	public String getProCentroContable() {
		return proCentroContable;
	}
	public void setProCentroContable(String proCentroContable) {
		this.proCentroContable = proCentroContable;
	}
	public String getDocTipoGestor() {
		return docTipoGestor;
	}
	public void setDocTipoGestor(String docTipoGestor) {
		this.docTipoGestor = docTipoGestor;
	}
	public String getDocDespacho() {
		return docDespacho;
	}
	public void setDocDespacho(String docDespacho) {
		this.docDespacho = docDespacho;
	}
	public String getDocGestor() {
		return docGestor;
	}
	public void setDocGestor(String docGestor) {
		this.docGestor = docGestor;
	}

	public String getImporteDesde() {
		return importeDesde;
	}

	public void setImporteDesde(String importeDesde) {
		this.importeDesde = importeDesde;
	}

	public String getImporteHasta() {
		return importeHasta;
	}

	public void setImporteHasta(String importeHasta) {
		this.importeHasta = importeHasta;
	}
	
	public String getBurRefExternaEnvio() {
		return burRefExternaEnvio;
	}
	public void setBurRefExternaEnvio(String burRefExternaEnvio) {
		this.burRefExternaEnvio = burRefExternaEnvio;
	}
	public String getBurRegManual() {
		return burRegManual;
	}
	public void setBurRegManual(String burRegManual) {
		this.burRegManual = burRegManual;
	}
	public String getBurAcuseRecibo() {
		return burAcuseRecibo;
	}
	public void setBurAcuseRecibo(String burAcuseRecibo) {
		this.burAcuseRecibo = burAcuseRecibo;
	}
	
}
