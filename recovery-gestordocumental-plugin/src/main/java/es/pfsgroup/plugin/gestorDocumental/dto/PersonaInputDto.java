package es.pfsgroup.plugin.gestorDocumental.dto;

public class PersonaInputDto {

	public static final String ID_PERSONA_ORIGEN = "ID_PERSONA_ORIGEN";
	public static final String ID_ORIGEN = "ID_ORIGEN";
	public static final String ID_PERSONA_HAYA = "ID_PERSONA_HAYA";
	public static final String FORMATO_STRING = "STRING";
	public static final String EVENTO_IDENTIFICADOR_PERSONA_ORIGEN = "ConsultaIdPersonaPorOrigen";
	
	public static final String ID_ORIGEN_NOS = "NOS";
	
	private String idPersonaOrigen;
	private String idOrigen;
	private String idPersonaHaya;
	private String event;

	public String getIdPersonaOrigen() {
		return idPersonaOrigen;
	}
	
	public void setIdPersonaOrigen(String idPersonaOrigen) {
		this.idPersonaOrigen = idPersonaOrigen;
	}

	public String getIdOrigen() {
		return idOrigen;
	}

	public void setIdOrigen(String idOrigen) {
		this.idOrigen = idOrigen;
	}

	public String getIdPersonaHaya() {
		return idPersonaHaya;
	}
	
	public void setIdPersonaHaya(String idPersonaHaya) {
		this.idPersonaHaya = idPersonaHaya;
	}
	
	public String getEvent() {
		return event;
	}

	public void setEvent(String event) {
		this.event = event;
	}

}
