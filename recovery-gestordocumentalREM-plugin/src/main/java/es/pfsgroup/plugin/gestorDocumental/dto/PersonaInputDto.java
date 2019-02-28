package es.pfsgroup.plugin.gestorDocumental.dto;

import java.io.Serializable;

public class PersonaInputDto implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1884005212021894617L;
	public static final String ID_ENTIDAD_CEDENTE = "ID_ENTIDAD_CEDENTE";
	//public static final String ID_PERSONA_CLIENTE = "ID_INTERVINIENTE_CLIENTE";
	public static final String ID_PERSONA_CLIENTE_ALTA = "ID_PERSONA_CLIENTE";
	public static final String ID_INTERVINIENTE_ORIGEN = "ID_INTERVINIENTE_ORIGEN";
	public static final String ID_PERSONA_ORIGEN = "ID_PERSONA_ORIGEN";
	public static final String ID_ORIGEN = "NOS";
	public static final String ID_CLIENTE = "ID_CLIENTE";
	//public static final String ID_TIPO_PERSONA = "ID_TIPO_PERSONA";
	public static final String ID_INTERVINIENTE_HAYA = "ID_INTERVINIENTE_HAYA";
	public static final String ID_PERSONA_HAYA = "ID_PERSONA_HAYA";
	public static final String FORMATO_STRING = "STRING";
	//public static final String EVENTO_IDENTIFICADOR_INTERVINIENTE_CLIENTE = "ConsultaIdIntervinientePorCliente";
	public static final String EVENTO_IDENTIFICADOR_INTERVINIENTE_ORIGEN = "ConsultaIdIntervinientePorOrigen";
	public static final String EVENTO_IDENTIFICADOR_PERSONA_ORIGEN = "ConsultaIdPersonaPorOrigen";
	//public static final String EVENTO_CONSULTA_TIPO_INTERVINIENTE = "ConsultaTiposInterviniente";
	public static final String EVENTO_ALTA_PERSONA = "ALTA_PERSONA_PBC";

	public static final String ID_MOTIVO_OPERACION = "ID_MOTIVO_OPERACION";
	public static final String ID_ORIGEN_PERSONA = "ID_ORIGEN";
	public static final String ID_TIPO_ORIGEN = "ID_TIPO_ORIGEN";
	public static final String FECHA_OPERACION = "FECHA_OPERACION";
	public static final String ID_TIPO_IDENTIFICADOR = "ID_TIPO_IDENTIFICADOR";
	public static final String ID_ROL = "ID_ROL";

	private String idCliente;
	private String idIntervinienteCliente;
	private String idPersonaOrigen;
	private String idOrigen;
	private String idTipoInterviniente;
	private String idIntervinienteHaya;
	private String event;
	
	private String idEntidadCedente;
	private String idPersonaCliente;
	private String idMotivoOperacion;
	private String idTipoOrigen;
	private String fechaOperacion;
	private String idTipoIdentificador;
	private String idPersonaHaya;
	private String idRol;

	public String toString(){
		String result = "";
		
		if(idCliente != null){
			result = result + "idCliente: "+ idCliente + "\\n"; 
		}
		
		if(idIntervinienteCliente != null){
			result = result + "idIntervinienteCliente: "+ idIntervinienteCliente + "\\n"; 
		}
		
		if(idPersonaOrigen != null){
			result = result + "idPersonaOrigen: "+ idPersonaOrigen + "\\n"; 
		}
		
		if(idOrigen != null){
			result = result + "idOrigen: "+ idOrigen + "\\n"; 
		}
		
		if(idTipoInterviniente != null){
			result = result + "idTipoInterviniente: "+ idTipoInterviniente + "\\n"; 
		}
		
		if(idIntervinienteHaya != null){
			result = result + "idIntervinienteHaya: "+ idIntervinienteHaya + "\\n"; 
		}
		
		if(event != null){
			result = result + "event: "+ event + "\\n"; 
		}
		
		return result;
	}

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

	public String getIdMotivoOperacion() {
		return idMotivoOperacion;
	}

	public void setIdMotivoOperacion(String idMotivoOperacion) {
		this.idMotivoOperacion = idMotivoOperacion;
	}

	public String getFechaOperacion() {
		return fechaOperacion;
	}

	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}

	public String getIdTipoIdentificador() {
		return idTipoIdentificador;
	}

	public void setIdTipoIdentificador(String idTipoIdentificador) {
		this.idTipoIdentificador = idTipoIdentificador;
	}

	public String getIdRol() {
		return idRol;
	}

	public void setIdRol(String idRol) {
		this.idRol = idRol;
	}
	
	public String getIdEntidadCedente() {
		return idEntidadCedente;
	}

	public void setIdEntidadCedente(String idEntidadCedente) {
		this.idEntidadCedente = idEntidadCedente;
	}

	public String getIdPersonaCliente() {
		return idPersonaCliente;
	}

	public void setIdPersonaCliente(String idPersonaCliente) {
		this.idPersonaCliente = idPersonaCliente;
	}

	public String getIdTipoOrigen() {
		return idTipoOrigen;
	}

	public void setIdTipoOrigen(String idTipoOrigen) {
		this.idTipoOrigen = idTipoOrigen;
	}

	public String getIdPersonaHaya() {
		return idPersonaHaya;
	}

	public void setIdPersonaHaya(String idPersonaHaya) {
		this.idPersonaHaya = idPersonaHaya;
	}

}
