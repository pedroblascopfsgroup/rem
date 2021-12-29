package es.pfsgroup.plugin.rem.model;

public class DtoOfertaCaixaPbc {
	
	private Oferta oferta;
	private String riesgoOperacion;
	private Boolean ofertaSospechosa;
	private Boolean deteccionIndicio;
	private Boolean ocultaIdentidadTitular;
	private Boolean actitudIncoherente;
	private Boolean titulosPortador;
	private String motivoCompra;
	private String finalidadOperacion;
	private Double fondosPropios;
	private String procedenciaFondosPropios;
	private String otraProcedenciaFondosPropios;
	private String medioPago;
	private Boolean pagoIntermediario;
	private String paisTransferencia;
	private Double fondosBanco;
	
	public Oferta getOferta() {
		return oferta;
	}
	public void setOferta(Oferta oferta) {
		this.oferta = oferta;
	}
	public String getRiesgoOperacion() {
		return riesgoOperacion;
	}
	public void setRiesgoOperacion(String riesgoOperacion) {
		this.riesgoOperacion = riesgoOperacion;
	}
	public Boolean getOfertaSospechosa() {
		return ofertaSospechosa;
	}
	public void setOfertaSospechosa(Boolean ofertaSospechosa) {
		this.ofertaSospechosa = ofertaSospechosa;
	}
	public Boolean getDeteccionIndicio() {
		return deteccionIndicio;
	}
	public void setDeteccionIndicio(Boolean deteccionIndicio) {
		this.deteccionIndicio = deteccionIndicio;
	}
	public Boolean getOcultaIdentidadTitular() {
		return ocultaIdentidadTitular;
	}
	public void setOcultaIdentidadTitular(Boolean ocultaIdentidadTitular) {
		this.ocultaIdentidadTitular = ocultaIdentidadTitular;
	}
	public Boolean getActitudIncoherente() {
		return actitudIncoherente;
	}
	public void setActitudIncoherente(Boolean actitudIncoherente) {
		this.actitudIncoherente = actitudIncoherente;
	}
	public Boolean getTitulosPortador() {
		return titulosPortador;
	}
	public void setTitulosPortador(Boolean titulosPortador) {
		this.titulosPortador = titulosPortador;
	}
	public String getMotivoCompra() {
		return motivoCompra;
	}
	public void setMotivoCompra(String motivoCompra) {
		this.motivoCompra = motivoCompra;
	}
	public String getFinalidadOperacion() {
		return finalidadOperacion;
	}
	public void setFinalidadOperacion(String finalidadOperacion) {
		this.finalidadOperacion = finalidadOperacion;
	}
	public Double getFondosPropios() {
		return fondosPropios;
	}
	public void setFondosPropios(Double fondosPropios) {
		this.fondosPropios = fondosPropios;
	}
	public String getProcedenciaFondosPropios() {
		return procedenciaFondosPropios;
	}
	public void setProcedenciaFondosPropios(String procedenciaFondosPropios) {
		this.procedenciaFondosPropios = procedenciaFondosPropios;
	}
	public String getOtraProcedenciaFondosPropios() {
		return otraProcedenciaFondosPropios;
	}
	public void setOtraProcedenciaFondosPropios(String otraProcedenciaFondosPropios) {
		this.otraProcedenciaFondosPropios = otraProcedenciaFondosPropios;
	}
	public String getMedioPago() {
		return medioPago;
	}
	public void setMedioPago(String medioPago) {
		this.medioPago = medioPago;
	}
	public Boolean getPagoIntermediario() {
		return pagoIntermediario;
	}
	public void setPagoIntermediario(Boolean pagoIntermediario) {
		this.pagoIntermediario = pagoIntermediario;
	}
	public String getPaisTransferencia() {
		return paisTransferencia;
	}
	public void setPaisTransferencia(String paisTransferencia) {
		this.paisTransferencia = paisTransferencia;
	}
	public Double getFondosBanco() {
		return fondosBanco;
	}
	public void setFondosBanco(Double fondosBanco) {
		this.fondosBanco = fondosBanco;
	}

}
