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
    
    private Long numVisita;   
    
    private String estadoVisitaOfertaCodigo;
    
    private String estadoVisitaOfertaDescripcion;
    
    private String canalPrescripcionCodigo;
    
    private String canalPrescripcionDescripcion;
   
   	

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

	public Long getNumVisita() {
		return numVisita;
	}

	public void setNumVisita(Long numVisita) {
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
   	
   	
   	
}
