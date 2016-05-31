package es.pfsgroup.plugin.recovery.liquidaciones.dto;


import es.pfsgroup.plugin.recovery.liquidaciones.model.DDModalidadCobro;
import es.pfsgroup.plugin.recovery.liquidaciones.model.DDOrigenCobro;

public class LIQDtoCobroPagoEntregas {
	
	private static final long serialVersionUID = 4789880935076648527L;
	
	private Long id;
	private Long idAsunto;
	private Long idCalculo;
   	private String subtipo;
	private String estado;
	private String tipoEntrega;
	private String conceptoEntrega;
	private String fechaEntrega;
	private String fechaValor;
	private Float nominal;
	private Float capital;
	private Float capitalNoVencido;
	private Float interesesOrdinarios;
	private Float interesesMoratorios;
	private Float impuestos;
	private Float gastosProcurador;
	private Float gastosAbogado;
	private Float otrosGastos;
	private	Float gastos;
	private	Float importePago;
	private	String observaciones;
	private	Long procedimiento;
	private	Long contrato;
	private	DDOrigenCobro origenCobro;
	private	DDModalidadCobro modalidadCobro;
	private Float totalEntrega;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdAsunto() {
		return idAsunto;
	}
	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}
	public String getSubtipo() {
		return subtipo;
	}
	public void setSubtipo(String subtipo) {
		this.subtipo = subtipo;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
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
	public Float getNominal() {
		return nominal;
	}
	public void setNominal(Float nominal) {
		this.nominal = nominal;
	}
	public Float getCapital() {
		return capital;
	}
	public void setCapital(Float capital) {
		this.capital = capital;
	}
	public Float getCapitalNoVencido() {
		return capitalNoVencido;
	}
	public void setCapitalNoVencido(Float capitalNoVencido) {
		this.capitalNoVencido = capitalNoVencido;
	}
	public Float getInteresesOrdinarios() {
		return interesesOrdinarios;
	}
	public void setInteresesOrdinarios(Float interesesOrdinarios) {
		this.interesesOrdinarios = interesesOrdinarios;
	}
	public Float getInteresesMoratorios() {
		return interesesMoratorios;
	}
	public void setInteresesMoratorios(Float interesesMoratorios) {
		this.interesesMoratorios = interesesMoratorios;
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
	public Float getGastosAbogado() {
		return gastosAbogado;
	}
	public void setGastosAbogado(Float gastosAbogado) {
		this.gastosAbogado = gastosAbogado;
	}
	public Float getOtrosGastos() {
		return otrosGastos;
	}
	public void setOtrosGastos(Float otrosGastos) {
		this.otrosGastos = otrosGastos;
	}
	public Float getGastos() {
		return gastos;
	}
	public void setGastos(Float gastos) {
		this.gastos = gastos;
	}
	public Float getImportePago() {
		return importePago;
	}
	public void setImportePago(Float importePago) {
		this.importePago = importePago;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public Long getProcedimiento() {
		return procedimiento;
	}
	public void setProcedimiento(Long procedimiento) {
		this.procedimiento = procedimiento;
	}
	public Long getContrato() {
		return contrato;
	}
	public void setContrato(Long contrato) {
		this.contrato = contrato;
	}
	public DDOrigenCobro getOrigenCobro() {
		return origenCobro;
	}
	public void setOrigenCobro(DDOrigenCobro origenCobro) {
		this.origenCobro = origenCobro;
	}
	public DDModalidadCobro getModalidadCobro() {
		return modalidadCobro;
	}
	public void setModalidadCobro(DDModalidadCobro modalidadCobro) {
		this.modalidadCobro = modalidadCobro;
	}
	public Float getTotalEntrega() {
		return totalEntrega;
	}
	public void setTotalEntrega(Float totalEntrega) {
		this.totalEntrega = totalEntrega;
	}
	public Long getIdCalculo() {
		return idCalculo;
	}
	public void setIdCalculo(Long idCalculo) {
		this.idCalculo = idCalculo;
	}
	
	
	
	
	

}
