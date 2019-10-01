package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto para el tab de cargas
 * @author Carlos Feliu
 *
 */
public class DtoActivoCargasTab extends DtoTabActivo {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String numeroActivo;
    private Integer conCargas;
    private Date fechaRevisionCarga;
    private Long idActivo;
    private Boolean unidadAlquilable;
    private String estadoCargas;
    
	public String getNumeroActivo() {
		return numeroActivo;
	}
	public void setNumeroActivo(String numeroActivo) {
		this.numeroActivo = numeroActivo;
	}
	public Integer getConCargas() {
		return conCargas;
	}
	public void setConCargas(Integer conCargas) {
		this.conCargas = conCargas;
	}
	public Date getFechaRevisionCarga() {
		return fechaRevisionCarga;
	}
	public void setFechaRevisionCarga(Date fechaRevisionCarga) {
		this.fechaRevisionCarga = fechaRevisionCarga;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Boolean getUnidadAlquilable() {
		return unidadAlquilable;
	}
	public void setUnidadAlquilable(Boolean unidadAlquilable) {
		this.unidadAlquilable = unidadAlquilable;
	}
	public String getEstadoCargas() {
		return estadoCargas;
	}
	public void setEstadoCargas(String estadoCargas) {
		this.estadoCargas = estadoCargas;
	}
	
    
}