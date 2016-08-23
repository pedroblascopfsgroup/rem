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
    
    private Date fechaNotificacion;
    
    private Date fechaAlta;
    
    private String estadoDescripcion;
    
    private String prescriptorDescripcion;
    
    private Double importeOferta;
    
    private Double importeContraoferta;
    
    private String comite;
    
    private Long numVisita;   
   
   	

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

	public String getPrescriptorDescripcion() {
		return prescriptorDescripcion;
	}

	public void setPrescriptorDescripcion(String prescriptorDescripcion) {
		this.prescriptorDescripcion = prescriptorDescripcion;
	}

	public Double getImporteOferta() {
		return importeOferta;
	}

	public void setImporteOferta(Double importeOferta) {
		this.importeOferta = importeOferta;
	}

	public Double getImporteContraoferta() {
		return importeContraoferta;
	}

	public void setImporteContraoferta(Double importeContraoferta) {
		this.importeContraoferta = importeContraoferta;
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
   	
   	
   	
}
