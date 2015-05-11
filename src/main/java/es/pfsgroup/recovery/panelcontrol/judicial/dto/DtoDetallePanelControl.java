package es.pfsgroup.recovery.panelcontrol.judicial.dto;

import es.capgemini.devon.pagination.PaginationParamsImpl;

/***
 *  Dto utilizado para pasar los parámetros de búsqueda para las diferentes operaciones de negocio
 * 
 * 
 * **/
public class DtoDetallePanelControl extends PaginationParamsImpl {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8484644160486011505L;
	
	/**
	 *  Identificador del nivel de jerarquía
	 * **/
	private Long nivel;
	
	/***
	 * Identificador de la zona dentro de una jerarquía
	 * 
	 * */
	private Long idNivel;
	
	/***
	 * Indica el detalle del campo que queremos obtener. usado para los contratos y las tareas
	 * 
	 * */
	private Long detalle;
	
	private String panelTareas;
	
	private String cod;
	
	
	public void setNivel(Long nivel) {
		this.nivel = nivel;
	}
	public Long getNivel() {
		return nivel;
	}
	public void setIdNivel(Long idNivel) {
		this.idNivel = idNivel;
	}
	public Long getIdNivel() {
		return idNivel;
	}
	public void setDetalle(Long detalle) {
		this.detalle = detalle;
	}
	public Long getDetalle() {
		return detalle;
	}
	public void setCod(String cod) {
		this.cod = cod;
	}
	public String getCod() {
		return cod;
	}
	public void setPanelTareas(String panelTareas) {
		this.panelTareas = panelTareas;
	}
	public String getPanelTareas() {
		return panelTareas;
	}
}
