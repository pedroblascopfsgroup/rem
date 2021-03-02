package es.pfsgroup.plugin.rem.trabajo.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


public class DtoHistorificadorCampos extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long idTrabajo;
	private Long idHistorico;
	private String campo;
	private String usuarioModificacion;
	private Date fechaModificacion;
	private String valorAnterior;
	private String valorNuevo;
	private String tabla;
	private String columna;
	private String pestana;
	private Integer totalCount;
	



	public String getCampo() {
		return campo;
	}
	public void setCampo(String campo) {
		this.campo = campo;
	}
	public String getUsuarioModificacion() {
		return usuarioModificacion;
	}
	public void setUsuarioModificacion(String usuarioModificacion) {
		this.usuarioModificacion = usuarioModificacion;
	}
	public Date getFechaModificacion() {
		return fechaModificacion;
	}
	public void setFechaModificacion(Date fechaModificacion) {
		this.fechaModificacion = fechaModificacion;
	}
	public String getValorAnterior() {
		return valorAnterior;
	}
	public void setValorAnterior(String valorAnterior) {
		this.valorAnterior = valorAnterior;
	}
	public String getValorNuevo() {
		return valorNuevo;
	}
	public void setValorNuevo(String valorNuevo) {
		this.valorNuevo = valorNuevo;
	}
	public Long getIdTrabajo() {
		return idTrabajo;
	}
	public void setIdTrabajo(Long idTrabajo) {
		this.idTrabajo = idTrabajo;
	}
	public Long getIdHistorico() {
		return idHistorico;
	}
	public void setIdHistorico(Long idHistorico) {
		this.idHistorico = idHistorico;
	}
	public String getTabla() {
		return tabla;
	}
	public void setTabla(String tabla) {
		this.tabla = tabla;
	}
	public String getColumna() {
		return columna;
	}
	public void setColumna(String columna) {
		this.columna = columna;
	}
	public String getPestana() {
		return pestana;
	}
	public void setPestana(String pestana) {
		this.pestana = pestana;
	}
	public Integer getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(Integer totalCount) {
		this.totalCount = totalCount;
	}

	
	
	
	
	
	
}