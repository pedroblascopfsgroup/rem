package es.pfsgroup.plugin.rem.model;

import java.util.Date;

/**
 * Dto para el tab de patrimonio contrato
 * @author Luis Adelantado
 *
 */
public class DtoActivoVistaPatrimonioContrato extends DtoTabActivo {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7429602301888781560L;

	private Long idActivo;
	private String descripcion;
	private String localizacion;
	public Long getIdActivo() {
		return idActivo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public String getLocalizacion() {
		return localizacion;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public void setLocalizacion(String localizacion) {
		this.localizacion = localizacion;
	}
}