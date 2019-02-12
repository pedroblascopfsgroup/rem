package es.pfsgroup.plugin.rem.model;

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

	private Long activo;
	private String descripcion;
	private String localizacion;
	private String idContrato;
	private String nombrePrinex;
	private String numeroActivoHaya;
	
	public Long getActivo() {
		return activo;
	}
	public void setActivo(Long activo) {
		this.activo = activo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public String getLocalizacion() {
		return localizacion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public void setLocalizacion(String localizacion) {
		this.localizacion = localizacion;
	}
	public String getIdContrato() {
		return idContrato;
	}
	public void setIdContrato(String idContrato) {
		this.idContrato = idContrato;
	}
	public String getNombrePrinex() {
		return nombrePrinex;
	}
	public void setNombrePrinex(String nombrePrinex) {
		this.nombrePrinex = nombrePrinex;
	}
	public String getNumeroActivoHaya() {
		return numeroActivoHaya;
	}
	public void setNumeroActivoHaya(String numeroActivoHaya) {
		this.numeroActivoHaya = numeroActivoHaya;
	}
}