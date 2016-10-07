package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de provisiones de gastos
 * @author Jose Villel
 *
 */
public class DtoProvisionGastosFilter extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long id;
	private Long numProvision;
	private String gestoria;
	private String estadoProvisionCodigo;
	private Date fechaAlta;
	private Date fechaEnvio;
	private Date fechaRespuesta;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getNumProvision() {
		return numProvision;
	}
	public void setNumProvision(Long numProvision) {
		this.numProvision = numProvision;
	}
	public String getGestoria() {
		return gestoria;
	}
	public void setGestoria(String gestoria) {
		this.gestoria = gestoria;
	}

	public String getEstadoProvisionCodigo() {
		return estadoProvisionCodigo;
	}
	public void setEstadoProvisionCodigo(String estadoProvisionCodigo) {
		this.estadoProvisionCodigo = estadoProvisionCodigo;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public Date getFechaEnvio() {
		return fechaEnvio;
	}
	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}
	public Date getFechaRespuesta() {
		return fechaRespuesta;
	}
	public void setFechaRespuesta(Date fechaRespuesta) {
		this.fechaRespuesta = fechaRespuesta;
	}
	
	
	
}