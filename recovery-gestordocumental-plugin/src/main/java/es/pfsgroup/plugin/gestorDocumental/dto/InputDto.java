package es.pfsgroup.plugin.gestorDocumental.dto;

public class InputDto {

	public static final String ID_ACTIVO_ORIGEN = "ID_ACTIVO_ORIGEN";
	public static final String ID_ORIGEN = "ID_ORIGEN";
	public static final String ID_ACTIVO_HAYA = "ID_ACTIVO_HAYA";
	public static final String FORMATO_STRING = "STRING";
	public static final String EVENTO_IDENTIFICADOR_ACTIVO_ORIGEN = "MaestroActivos-Consulta-IDHAYA-Origen";
	public static final String EVENTO_IDENTIFICADOR_ACTIVO_CLIENTE = "MaestroActivos-Consulta-IDHAYA-Cliente";
	public static final String EVENTO_IDENTIFICADOR_HAYA_ACTIVO = "MaestroActivos-Consulta-IDCLIENTE";
	
	private String idActivoOrigen;
	private String idOrigen;
	private String idActivoHaya;
	private String event;

	public String getIdActivoOrigen() {
		return idActivoOrigen;
	}

	public void setIdActivoOrigen(String idActivoOrigen) {
		this.idActivoOrigen = idActivoOrigen;
	}

	public String getIdOrigen() {
		return idOrigen;
	}

	public void setIdOrigen(String idOrigen) {
		this.idOrigen = idOrigen;
	}

	public String getIdActivoHaya() {
		return idActivoHaya;
	}

	public void setIdActivoHaya(String idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}
	
	public String getEvent() {
		return event;
	}
	
	public void setEvent(String event) {
		this.event = event;
	}

}
