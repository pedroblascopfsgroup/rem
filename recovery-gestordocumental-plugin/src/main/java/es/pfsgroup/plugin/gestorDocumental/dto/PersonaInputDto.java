package es.pfsgroup.plugin.gestorDocumental.dto;

public class PersonaInputDto {

	 public static final String ID_CLIENTE = "ID_CLIENTE";
	 public static final String ID_PERSONA_CLIENTE = "ID_PERSONA_CLIENTE";
	 public static final String ID_PERSONA_ORIGEN = "ID_PERSONA_ORIGEN";
	 public static final String ID_ORIGEN = "ID_ORIGEN";
	 public static final String ID_TIPO_PERSONA = "ID_TIPO_PERSONA";
	 public static final String ID_PERSONA_HAYA = "ID_PERSONA_HAYA";
	 public static final String FORMATO_STRING = "STRING";
	 public static final String EVENTO_IDENTIFICADOR_PERSONA_CLIENTE = "ConsultaIdPersonaPorCliente";
	 public static final String EVENTO_IDENTIFICADOR_PERSONA_ORIGEN = "ConsultaIdPersonaPorOrigen";
	 public static final String EVENTO_CONSULTA_TIPO_PERSONA = "ConsultaTiposPersona";

	private String idCliente;
	private String idPersonaCliente;
	private String idPersonaOrigen;
	private String idOrigen;
	private String idTipoPersona;
	private String idPersonaHaya;
	private String event;

	public String getIdCliente() {
		return idCliente;
	}

	public void setIdCliente(String idCliente) {
		this.idCliente = idCliente;
	}

	public String getIdPersonaCliente() {
		return idPersonaCliente;
	}

	public void setIdPersonaCliente(String idPersonaCliente) {
		this.idPersonaCliente = idPersonaCliente;
	}

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

	public String getIdTipoPersona() {
		return idTipoPersona;
	}

	public void setIdTipoPersona(String idTipoPersona) {
		this.idTipoPersona = idTipoPersona;
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
