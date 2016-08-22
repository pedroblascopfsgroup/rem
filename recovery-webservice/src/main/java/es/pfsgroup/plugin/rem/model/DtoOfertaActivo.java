package es.pfsgroup.plugin.rem.model;

import java.util.Date;

/**
 * Dto para el grid de ofertas de la pestaña activos
 * @author Carlos Feliu
 *
 */
public class DtoOfertaActivo {

	private static final long serialVersionUID = 0L;


	private Long idOferta;
	private Long idActivo;
	private Long idAgrupacion;
	private String estadoOferta;
	
	
	public Long getIdOferta() {
		return idOferta;
	}
	public void setIdOferta(Long idOferta) {
		this.idOferta = idOferta;
	}
	
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Long getIdAgrupacion() {
		return idAgrupacion;
	}
	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}
	public String getEstadoOferta() {
		return estadoOferta;
	}
	public void setEstadoOferta(String estadoOferta) {
		this.estadoOferta = estadoOferta;
	}

	
	
	
}