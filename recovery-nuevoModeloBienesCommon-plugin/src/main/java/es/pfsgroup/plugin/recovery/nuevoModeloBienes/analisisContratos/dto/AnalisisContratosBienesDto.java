package es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.dto;

import es.capgemini.devon.dto.WebDto;

/**
 * Clase que transfiere información desde la vista hacia el modelo.
 * 
 * @author Óscar
 * 
 */
public class AnalisisContratosBienesDto extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7764076466686862664L;
	
	private String id;
	private String bieId;
	private String ancId;
	private String solicitarNoAfeccion;
	private String fechaSolicitarNoAfeccion;
	private String fechaResolucion;
	private String resolucion;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getBieId() {
		return bieId;
	}

	public void setBieId(String bieId) {
		this.bieId = bieId;
	}

	public String getSolicitarNoAfeccion() {
		return solicitarNoAfeccion;
	}

	public void setSolicitarNoAfeccion(String solicitarNoAfeccion) {
		this.solicitarNoAfeccion = solicitarNoAfeccion;
	}

	public String getFechaSolicitarNoAfeccion() {
		return fechaSolicitarNoAfeccion;
	}

	public void setFechaSolicitarNoAfeccion(String fechaSolicitarNoAfeccion) {
		this.fechaSolicitarNoAfeccion = fechaSolicitarNoAfeccion;
	}

	public String getFechaResolucion() {
		return fechaResolucion;
	}

	public void setFechaResolucion(String fechaResolucion) {
		this.fechaResolucion = fechaResolucion;
	}

	public String getResolucion() {
		return resolucion;
	}

	public void setResolucion(String resolucion) {
		this.resolucion = resolucion;
	}

	public String getAncId() {
		return ancId;
	}

	public void setAncId(String ancId) {
		this.ancId = ancId;
	}
}