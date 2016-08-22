package es.pfsgroup.plugin.rem.model;


/**
 * Dto para los datos en general del apartado 'datos publicacion' de la tab 'publicacion' de un activo.
 *
 */
public class DtoDatosPublicacion {
	private Long idActivo;
	private int totalDiasPublicado;
	private String portalesExternos;


	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public int getTotalDiasPublicado() {
		return totalDiasPublicado;
	}
	public void setTotalDiasPublicado(int totalDiasPublicado) {
		this.totalDiasPublicado = totalDiasPublicado;
	}
	public String getPortalesExternos() {
		return portalesExternos;
	}
	public void setPortalesExternos(String portalesExternos) {
		this.portalesExternos = portalesExternos;
	}
	
}