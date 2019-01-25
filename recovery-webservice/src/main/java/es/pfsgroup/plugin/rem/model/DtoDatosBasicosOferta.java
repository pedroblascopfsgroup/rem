package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de los datos básicos de una oferta.
 *  
 * @author Jose Villel
 *
 */
public class DtoDatosBasicosOferta extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	
    private Long idOferta;
    
    private Long idEco;
    
    private Long numOferta;
    
    private String tipoOfertaDescripcion;
    
    private String tipoOfertaCodigo;
    
    private Date fechaNotificacion;
    
    private Date fechaAlta;
    
    private String estadoDescripcion;
    
    private String estadoCodigo;
    
    private String prescriptor;
        
    private Double importeOferta;
    
    private Double importeContraOferta;
    
    private String comite;
    
    private String numVisita;   
    
    private String estadoVisitaOfertaCodigo;
    
    private String estadoVisitaOfertaDescripcion;
    
    private String canalPrescripcionCodigo;
    
    private String canalPrescripcionDescripcion;
    
    private String comiteSancionadorCodigo;
    
    private String comiteSancionadorCodigoAlquiler;
    
    private String comitePropuestoDescripcion;
    
    private String comitePropuestoCodigo;
   
	private String ofertaExpress;
	
	private String necesitaFinanciacion;
	
	private String observaciones;
	
	private String ventaCartera;
	
	private String tipoAlquilerCodigo;
	
	private String tipoInquilinoCodigo;

	private String numContratoPrinex;
	
	private String refCircuitoCliente;
	
	private Boolean permiteProponer;

	public Long getIdOferta() {
		return idOferta;
	}

	public void setIdOferta(Long idOferta) {
		this.idOferta = idOferta;
	}

	public Long getNumOferta() {
		return numOferta;
	}

	public void setNumOferta(Long numOferta) {
		this.numOferta = numOferta;
	}

	public String getTipoOfertaDescripcion() {
		return tipoOfertaDescripcion;
	}

	public void setTipoOfertaDescripcion(String tipoOfertaDescripcion) {
		this.tipoOfertaDescripcion = tipoOfertaDescripcion;
	}

	public Date getFechaNotificacion() {
		return fechaNotificacion;
	}

	public void setFechaNotificacion(Date fechaNotificacion) {
		this.fechaNotificacion = fechaNotificacion;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public String getEstadoDescripcion() {
		return estadoDescripcion;
	}

	public void setEstadoDescripcion(String estadoDescripcion) {
		this.estadoDescripcion = estadoDescripcion;
	}

	public String getPrescriptor() {
		return prescriptor;
	}

	public void setPrescriptor(String prescriptor) {
		this.prescriptor = prescriptor;
	}

	public Double getImporteOferta() {
		return importeOferta;
	}

	public void setImporteOferta(Double importeOferta) {
		this.importeOferta = importeOferta;
	}

	public Double getImporteContraOferta() {
		return importeContraOferta;
	}

	public void setImporteContraOferta(Double importeContraOferta) {
		this.importeContraOferta = importeContraOferta;
	}

	public String getComite() {
		return comite;
	}

	public void setComite(String comite) {
		this.comite = comite;
	}

	public String getNumVisita() {
		return numVisita;
	}

	public void setNumVisita(String numVisita) {
		this.numVisita = numVisita;
	}

	public String getEstadoVisitaOfertaCodigo() {
		return estadoVisitaOfertaCodigo;
	}

	public void setEstadoVisitaOfertaCodigo(String estadoVisitaOfertaCodigo) {
		this.estadoVisitaOfertaCodigo = estadoVisitaOfertaCodigo;
	}

	public String getEstadoVisitaOfertaDescripcion() {
		return estadoVisitaOfertaDescripcion;
	}

	public void setEstadoVisitaOfertaDescripcion(
			String estadoVisitaOfertaDescripcion) {
		this.estadoVisitaOfertaDescripcion = estadoVisitaOfertaDescripcion;
	}

	public String getTipoOfertaCodigo() {
		return tipoOfertaCodigo;
	}

	public void setTipoOfertaCodigo(String tipoOfertaCodigo) {
		this.tipoOfertaCodigo = tipoOfertaCodigo;
	}

	public String getEstadoCodigo() {
		return estadoCodigo;
	}

	public void setEstadoCodigo(String estadoCodigo) {
		this.estadoCodigo = estadoCodigo;
	}

	public String getCanalPrescripcionCodigo() {
		return canalPrescripcionCodigo;
	}

	public void setCanalPrescripcionCodigo(String canalPrescripcionCodigo) {
		this.canalPrescripcionCodigo = canalPrescripcionCodigo;
	}

	public String getCanalPrescripcionDescripcion() {
		return canalPrescripcionDescripcion;
	}

	public void setCanalPrescripcionDescripcion(String canalPrescripcionDescripcion) {
		this.canalPrescripcionDescripcion = canalPrescripcionDescripcion;
	}

	public String getComiteSancionadorCodigo() {
		return comiteSancionadorCodigo;
	}

	public void setComiteSancionadorCodigo(String comiteSancionadorCodigo) {
		this.comiteSancionadorCodigo = comiteSancionadorCodigo;
	}

	public String getComitePropuestoDescripcion() {
		return comitePropuestoDescripcion;
	}

	public void setComitePropuestoDescripcion(String comitePropuestoDescripcion) {
		this.comitePropuestoDescripcion = comitePropuestoDescripcion;
	}

	public String getComitePropuestoCodigo() {
		return comitePropuestoCodigo;
	}

	public void setComitePropuestoCodigo(String comitePropuestoCodigo) {
		this.comitePropuestoCodigo = comitePropuestoCodigo;
	}

	public String getOfertaExpress() {
		return ofertaExpress;
	}

	public void setOfertaExpress(String ofertaExpress) {
		this.ofertaExpress = ofertaExpress;
	}

	public String getNecesitaFinanciacion() {
		return necesitaFinanciacion;
	}

	public void setNecesitaFinanciacion(String necesitaFinanciacion) {
		this.necesitaFinanciacion = necesitaFinanciacion;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public String getVentaCartera() {
		return ventaCartera;
	}

	public void setVentaCartera(String ventaCartera) {
		this.ventaCartera = ventaCartera;
	}

	public Boolean getPermiteProponer() {
		return permiteProponer;
	}

	public void setPermiteProponer(Boolean permiteProponer) {
		this.permiteProponer = permiteProponer;
	}
	
	public String getTipoAlquilerCodigo() {
		return tipoAlquilerCodigo;
	}

	public void setTipoAlquilerCodigo(String tipoAlquilerDescripcion) {
		this.tipoAlquilerCodigo = tipoAlquilerDescripcion;
	}

	public String getTipoInquilinoCodigo() {
		return tipoInquilinoCodigo;
	}

	public void setTipoInquilinoCodigo(String tipoInquilinoDescripcion) {
		this.tipoInquilinoCodigo = tipoInquilinoDescripcion;
	}

	public String getNumContratoPrinex() {
		return numContratoPrinex;
	}

	public void setNumContratoPrinex(String numContratoPrinex) {
		this.numContratoPrinex = numContratoPrinex;
	}

	public String getRefCircuitoCliente() {
		return refCircuitoCliente;
	}

	public void setRefCircuitoCliente(String refCircuitoCliente) {
		this.refCircuitoCliente = refCircuitoCliente;
	}

	public String getComiteSancionadorCodigoAlquiler() {
		return comiteSancionadorCodigoAlquiler;
	}

	public void setComiteSancionadorCodigoAlquiler(String comiteSancionadorCodigoAlquiler) {
		this.comiteSancionadorCodigoAlquiler = comiteSancionadorCodigoAlquiler;
	}

	public Long getIdEco() {
		return idEco;
	}

	public void setIdEco(Long idEco) {
		this.idEco = idEco;
	}

}
