package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto para el tab de cargas
 * @author Carlos Feliu
 *
 */
public class DtoActivoCargasTab extends WebDto {

	private String numeroActivo;
    private Integer conCargas;
    private Date fechaRevisionCarga;
    
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
    
}