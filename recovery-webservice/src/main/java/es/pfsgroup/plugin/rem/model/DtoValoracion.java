package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;




/**
 * Dto para el listado de propietarios de los activos
 * @author Anahuac de Vicente
 *
 */
public class DtoValoracion extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	
	private Long id;
	private String tipoPrecioCod;
	private String tipoPrecioDescripcion;
	private Double importe;
	private String fechaInicio;
	private String fechaFin;
	
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getTipoPrecioCod() {
		return tipoPrecioCod;
	}
	public void setTipoPrecioCod(String tipoPrecioCod) {
		this.tipoPrecioCod = tipoPrecioCod;
	}
	public String getTipoPrecioDescripcion() {
		return tipoPrecioDescripcion;
	}
	public void setTipoPrecioDescripcion(String tipoPrecioDescripcion) {
		this.tipoPrecioDescripcion = tipoPrecioDescripcion;
	}
	public Double getImporte() {
		return importe;
	}
	public void setImporte(Double importe) {
		this.importe = importe;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	
}