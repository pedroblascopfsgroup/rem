package es.pfsgroup.plugin.gestorDocumental.model.servicios;

public class GastoMetadatos extends ExpedientesServicios {

	/**
	 * Id gasto
	 */
	private String idGasto;
	
	/**
	 * Id reo
	 */
	private String idReo;
	
	/**
	 * Fecha del gasto
	 */
	private String fechaGasto;
	

	public String getIdGasto() {
		return idGasto;
	}

	public void setIdGasto(String idGasto) {
		this.idGasto = idGasto;
	}

	public String getIdReo() {
		return idReo;
	}

	public void setIdReo(String idReo) {
		this.idReo = idReo;
	}

	public String getFechaGasto() {
		return fechaGasto;
	}

	public void setFechaGasto(String fechaGasto) {
		this.fechaGasto = fechaGasto;
	}
	

	
}