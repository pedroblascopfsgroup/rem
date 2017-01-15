package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;



/**
 * Dto para el grid de distribución por plantas de la info comercial del activo
 * @author Carlos Feliu
 *
 */
public class DtoDistribucion extends WebDto {

	private static final long serialVersionUID = 0L;

	private String numPlanta;
	private String tipoHabitaculoCodigo;
	private String tipoHabitaculoDescripcion;
	private String cantidad;
	private String superficie;
	private String idDistribucion;
	
	public String getNumPlanta() {
		return numPlanta;
	}
	public void setNumPlanta(String numPlanta) {
		this.numPlanta = numPlanta;
	}
	public String getTipoHabitaculoCodigo() {
		return tipoHabitaculoCodigo;
	}
	public void setTipoHabitaculoCodigo(String tipoHabitaculoCodigo) {
		this.tipoHabitaculoCodigo = tipoHabitaculoCodigo;
	}
	public String getTipoHabitaculoDescripcion() {
		return tipoHabitaculoDescripcion;
	}
	public void setTipoHabitaculoDescripcion(String tipoHabitaculoDescripcion) {
		this.tipoHabitaculoDescripcion = tipoHabitaculoDescripcion;
	}
	public String getCantidad() {
		return cantidad;
	}
	public void setCantidad(String cantidad) {
		this.cantidad = cantidad;
	}
	public String getSuperficie() {
		return superficie;
	}
	public void setSuperficie(String superficie) {
		this.superficie = superficie;
	}
	public String getIdDistribucion() {
		return idDistribucion;
	}
	public void setIdDistribucion(String idDistribucion) {
		this.idDistribucion = idDistribucion;
	}
	
}