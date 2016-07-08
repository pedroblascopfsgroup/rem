package es.pfsgroup.plugin.rem.trabajo.dto;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de Trabajos
 * @author Jose Villel
 *
 */
public class DtoActivosTrabajoFilter extends WebDto {
	
	private String idTrabajo;
	private String idActivo;
	private String estadoCodigo;
	private String estadoContable;

	public String getIdTrabajo() {
		return idTrabajo;
	}

	public void setIdTrabajo(String idTrabajo) {
		this.idTrabajo = idTrabajo;
	}

	public String getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}

	public String getEstadoCodigo() {
		return estadoCodigo;
	}

	public void setEstadoCodigo(String estadoCodigo) {
		this.estadoCodigo = estadoCodigo;
	}

	public String getEstadoContable() {
		return estadoContable;
	}

	public void setEstadoContable(String estadoContable) {
		this.estadoContable = estadoContable;
	}
	
	
	
}