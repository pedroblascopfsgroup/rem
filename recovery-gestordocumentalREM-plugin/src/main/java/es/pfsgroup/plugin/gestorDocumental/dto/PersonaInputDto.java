package es.pfsgroup.plugin.gestorDocumental.dto;

public class PersonaInputDto {

	//public static final String ID_CLIENTE = "ID_CLIENTE";
	//public static final String ID_PERSONA_CLIENTE = "ID_INTERVINIENTE_CLIENTE";
	public static final String ID_INTERVINIENTE_ORIGEN = "ID_INTERVINIENTE_ORIGEN";
	public static final String ID_ORIGEN = "NOS";
	//public static final String ID_TIPO_PERSONA = "ID_TIPO_PERSONA";
	public static final String ID_INTERVINIENTE_HAYA = "ID_INTERVINIENTE_HAYA";
	public static final String ID_PERSONA_HAYA = "ID_PERSONA_HAYA";
	public static final String FORMATO_STRING = "STRING";
	//public static final String EVENTO_IDENTIFICADOR_INTERVINIENTE_CLIENTE = "ConsultaIdIntervinientePorCliente";
	public static final String EVENTO_IDENTIFICADOR_INTERVINIENTE_ORIGEN = "ConsultaIdIntervinientePorOrigen";
	//public static final String EVENTO_CONSULTA_TIPO_INTERVINIENTE = "ConsultaTiposInterviniente";

	private String idCliente;
	private String idIntervinienteCliente;
	private String idIntervinienteOrigen;
	private String idOrigen;
	private String idTipoInterviniente;
	private String idIntervinienteHaya;
	private String event;

	public String getIdCliente() {
		return idCliente;
	}

	public void setIdCliente(String idCliente) {
		this.idCliente = idCliente;
	}

	public String getIdIntervinienteCliente() {
		return idIntervinienteCliente;
	}

	public void setIdIntervinienteCliente(String idIntervinienteCliente) {
		this.idIntervinienteCliente = idIntervinienteCliente;
	}

	public String getIdIntervinienteOrigen() {
		return idIntervinienteOrigen;
	}

	public void setIdIntervinienteOrigen(String idIntervinienteOrigen) {
		this.idIntervinienteOrigen = idIntervinienteOrigen;
	}

	public String getIdOrigen() {
		return idOrigen;
	}

	public void setIdOrigen(String idOrigen) {
		this.idOrigen = idOrigen;
	}

	public String getIdTipoInterviniente() {
		return idTipoInterviniente;
	}

	public void setIdTipoInterviniente(String idTipoInterviniente) {
		this.idTipoInterviniente = idTipoInterviniente;
	}

	public String getIdIntervinienteHaya() {
		return idIntervinienteHaya;
	}

	public void setIdIntervinienteHaya(String idIntervinienteHaya) {
		this.idIntervinienteHaya = idIntervinienteHaya;
	}

	public String getEvent() {
		return event;
	}

	public void setEvent(String event) {
		this.event = event;
	}

}
