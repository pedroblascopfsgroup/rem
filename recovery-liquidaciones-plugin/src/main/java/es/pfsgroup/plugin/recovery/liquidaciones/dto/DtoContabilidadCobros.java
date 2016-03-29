package es.pfsgroup.plugin.recovery.liquidaciones.dto;

import es.capgemini.devon.dto.WebDto;

/*
 * DTO de Contabilidad Cobros.
 */
public class DtoContabilidadCobros extends WebDto {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1643924123392046504L;

	private Long id;
	private String fechaEntrega;
	private String fechaValor;
	private Float valor;
	private Float importe;
	private String tipoEntrega;
	private String conceptoEntrega;
	private Float nominal;
	private Float intereses;
	private Float demoras;
	private Float impuestos;
	private Float gastosProcurador;
	private Float gastosLetrado;
	private Float otrosGastos;
	private Float quitaNominal;
	private Float quitaIntereses;
	private Float quitaDemoras;
	private Float quitaImpuestos;
	private Float quitaGastosProcurador;
	private Float quitaGastosLetrado;
	private Float quitaOtrosGastos;
	private Float totalEntrega;
	private String numEnlace;
	private String numMandamiento;
	private String numCheque;
	private String observaciones;
	private Long asunto;
	private Boolean operacionesTramite;

	public DtoContabilidadCobros() {
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getFechaEntrega() {
		return fechaEntrega;
	}

	public void setFechaEntrega(String fechaEntrega) {

		this.fechaEntrega = fechaEntrega;

	}

	public String getFechaValor() {
		return fechaValor;
	}

	public void setFechaValor(String fechaValor) {

		this.fechaValor = fechaValor;
	}

	public Float getValor() {
		return valor;
	}

	public void setValor(Float valor) {
		this.valor = valor;
	}

	public String getTipoEntrega() {
		return tipoEntrega;
	}

	public void setTipoEntrega(String tipoEntrega) {
		this.tipoEntrega = tipoEntrega;
	}

	public String getConceptoEntrega() {
		return conceptoEntrega;
	}

	public void setConceptoEntrega(String conceptoEntrega) {
		this.conceptoEntrega = conceptoEntrega;
	}

	public Float getNominal() {
		return nominal;
	}

	public void setNominal(Float nominal) {
		this.nominal = nominal;
	}

	public Float getIntereses() {
		return intereses;
	}

	public void setIntereses(Float intereses) {
		this.intereses = intereses;
	}

	public Float getDemoras() {
		return demoras;
	}

	public void setDemoras(Float demoras) {
		this.demoras = demoras;
	}

	public Float getImpuestos() {
		return impuestos;
	}

	public void setImpuestos(Float impuestos) {
		this.impuestos = impuestos;
	}

	public Float getGastosProcurador() {
		return gastosProcurador;
	}

	public void setGastosProcurador(Float gastosProcurador) {
		this.gastosProcurador = gastosProcurador;
	}

	public Float getGastosLetrado() {
		return gastosLetrado;
	}

	public void setGastosLetrado(Float gastosLetrado) {
		this.gastosLetrado = gastosLetrado;
	}

	public Float getOtrosGastos() {
		return otrosGastos;
	}

	public void setOtrosGastos(Float otrosGastos) {
		this.otrosGastos = otrosGastos;
	}

	public Float getQuitaNominal() {
		return quitaNominal;
	}

	public void setQuitaNominal(Float quitaNominal) {
		this.quitaNominal = quitaNominal;
	}

	public Float getQuitaIntereses() {
		return quitaIntereses;
	}

	public void setQuitaIntereses(Float quitaIntereses) {
		this.quitaIntereses = quitaIntereses;
	}

	public Float getQuitaDemoras() {
		return quitaDemoras;
	}

	public void setQuitaDemoras(Float quitaDemoras) {
		this.quitaDemoras = quitaDemoras;
	}

	public Float getQuitaImpuestos() {
		return quitaImpuestos;
	}

	public void setQuitaImpuestos(Float quitaImpuestos) {
		this.quitaImpuestos = quitaImpuestos;
	}

	public Float getQuitaGastosProcurador() {
		return quitaGastosProcurador;
	}

	public void setQuitaGastosProcurador(Float quitaGastosProcurador) {
		this.quitaGastosProcurador = quitaGastosProcurador;
	}

	public Float getQuitaGastosLetrado() {
		return quitaGastosLetrado;
	}

	public void setQuitaGastosLetrado(Float quitaGastosLetrado) {
		this.quitaGastosLetrado = quitaGastosLetrado;
	}

	public Float getQuitaOtrosGastos() {
		return quitaOtrosGastos;
	}

	public void setQuitaOtrosGastos(Float quitaOtrosGastos) {
		this.quitaOtrosGastos = quitaOtrosGastos;
	}

	public Float getTotalEntrega() {
		return totalEntrega;
	}

	public void setTotalEntrega(Float totalEntrega) {
		this.totalEntrega = totalEntrega;
	}

	public String getNumEnlace() {
		return numEnlace;
	}

	public void setNumEnlace(String numEnlace) {
		this.numEnlace = numEnlace;
	}

	public String getNumMandamiento() {
		return numMandamiento;
	}

	public void setNumMandamiento(String numMandamiento) {
		this.numMandamiento = numMandamiento;
	}

	public String getNumCheque() {
		return numCheque;
	}

	public void setNumCheque(String numCheque) {
		this.numCheque = numCheque;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Float getImporte() {
		return importe;
	}

	public void setImporte(Float importe) {
		this.importe = importe;
	}

	public Long getAsunto() {
		return asunto;
	}

	public void setAsunto(Long asunto) {
		this.asunto = asunto;
	}

	public Boolean getOperacionesTramite() {
		return operacionesTramite;
	}

	public void setOperacionesTramite(Boolean operacionesTramite) {
		this.operacionesTramite = operacionesTramite;
	}

}
