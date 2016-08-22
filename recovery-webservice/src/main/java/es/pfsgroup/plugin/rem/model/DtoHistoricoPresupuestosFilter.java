package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de Activos
 * @author Benjamín Guerrero
 *
 */
public class DtoHistoricoPresupuestosFilter extends WebDto {

	private static final long serialVersionUID = 0L;

	private String idActivo;
	private String idPresupuesto;

	public String getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}

	public String getIdPresupuesto() {
		return idPresupuesto;
	}

	public void setIdPresupuesto(String idPresupuesto) {
		this.idPresupuesto = idPresupuesto;
	}


	
	
}