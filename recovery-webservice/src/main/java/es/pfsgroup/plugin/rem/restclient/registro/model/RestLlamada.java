package es.pfsgroup.plugin.rem.restclient.registro.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "RST_LLAMADA", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class RestLlamada implements Serializable, Auditable {

	private static final long serialVersionUID = 8551021750962302260L;
	private static final int MAX_CHARS_JSON = 5000;

	@Id
	@Column(name = "RST_LLAMADA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "llamadaRstGenerator")
	@SequenceGenerator(name = "llamadaRstGenerator", sequenceName = "S_RST_LLAMADA")
	private Long llamadaId;

	@Column(name = "RST_ITERACION")
	private Long iteracion;

	@Column(name = "RST_LLAMADA_ENDPOINT")
	private String endpoint;

	@Column(name = "RST_LLAMADA_METODO")
	private String metodo;

	@Column(name = "RST_LLAMADA_TOKEN")
	private String token;

	@Column(name = "RST_LLAMADA_IP")
	private String ip;

	@Column(name = "RST_LLAMADA_APIKEY")
	private String apiKey;

	@Column(name = "RST_LLAMADA_SIGNATURE")
	private String signature;

	@Column(name = "RST_LLAMADA_ERROR_DESC")
	private String errorDesc;

	@Column(name = "RST_LLAMADA_REQUEST")
	private String request;

	@Column(name = "RST_LLAMADA_RESPONSE")
	private String response;

	@Column(name = "RST_LLAMADA_EXCEPTION")
	private String exception;

	@Embedded
	private Auditoria auditoria;

	@Column(name = "RST_MS_START_TIME")
	private Long startTime;

	@Column(name = "RST_MS_SELECT_CAMBIOS")
	private Long msSelectCambios;

	@Column(name = "RST_MS_PREP_JSON")
	private Long msPrepararJson;

	@Column(name = "RST_MS_SELECT_TODO")
	private Long msSelectTodo;

	@Column(name = "RST_MS_PETICION_REST")
	private Long msPeticionRest;

	@Column(name = "RST_MS_BORRAR_HIST")
	private Long msBorrarHistorico;

	@Column(name = "RST_MS_INSERTAR_HIST")
	private Long msInsertarHistorico;

	public RestLlamada() {
		this.startTime = System.currentTimeMillis();

	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;

	}

	public Long getLlamadaId() {
		return llamadaId;
	}

	public void setLlamadaId(Long llamadaId) {
		this.llamadaId = llamadaId;
	}

	public String getMetodo() {
		return metodo;
	}

	public void setMetodo(String metodo) {
		this.metodo = metodo;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public String getApiKey() {
		return apiKey;
	}

	public void setApiKey(String apiKey) {
		this.apiKey = apiKey;
	}

	public String getSignature() {
		return signature;
	}

	public void setSignature(String signature) {
		this.signature = signature;
	}

	public String getErrorDesc() {
		return errorDesc;
	}

	public void setErrorDesc(String errorDesc) {
		this.errorDesc = errorDesc;
	}

	public String getRequest() {
		return request;
	}

	public void setRequest(String request) {
		if ((request == null) || (request.length() <= MAX_CHARS_JSON)) {
			this.request = request;
		} else {
			this.request = request.substring(0, MAX_CHARS_JSON) + ".... [too long...]";
		}
	}

	public String getResponse() {
		return response;
	}

	public void setResponse(String response) {
		this.response = response;
	}

	public String getEndpoint() {
		return endpoint;
	}

	public void setEndpoint(String endpoint) {
		this.endpoint = endpoint;
	}

	public String getException() {
		return exception;
	}

	public void setException(String exception) {
		this.exception = exception;
	}

	public void logTiempoSelectCambios() {
		this.msSelectCambios = System.currentTimeMillis() - this.startTime;

	}

	public void logTiempoSelectTodosDatos() {
		this.msSelectTodo = System.currentTimeMillis() - this.startTime;

	}

	public void logTiempPrepararJson() {
		this.msPrepararJson = System.currentTimeMillis() - this.startTime;

	}

	public void logTiempoPeticionRest() {
		this.msPeticionRest = System.currentTimeMillis() - this.startTime;

	}

	public void logTiempoBorrarHistorico() {
		this.msBorrarHistorico = System.currentTimeMillis() - this.startTime;

	}

	public void logTiempoInsertarHistorico() {
		this.msInsertarHistorico = System.currentTimeMillis() - this.startTime;

	}

	public Long getStartTime() {
		return startTime;
	}

	public void setStartTime(Long startTime) {
		this.startTime = startTime;
	}

	public Long getMsSelectCambios() {
		return msSelectCambios;
	}

	public void setMsSelectCambios(Long msSelectCambios) {
		this.msSelectCambios = msSelectCambios;
	}

	public Long getMsSelectTodo() {
		return msSelectTodo;
	}

	public void setMsSelectTodo(Long msSelectTodo) {
		this.msSelectTodo = msSelectTodo;
	}

	public Long getMsBorrarHistorico() {
		return msBorrarHistorico;
	}

	public void setMsBorrarHistorico(Long msBorrarHistorico) {
		this.msBorrarHistorico = msBorrarHistorico;
	}

	public Long getMsInsertarHistorico() {
		return msInsertarHistorico;
	}

	public void setMsInsertarHistorico(Long msInsertarHistorico) {
		this.msInsertarHistorico = msInsertarHistorico;
	}

	public Long getMsPeticionRest() {
		return msPeticionRest;
	}

	public void setMsPeticionRest(Long msPeticionRest) {
		this.msPeticionRest = msPeticionRest;
	}

	public Long getIteracion() {
		return iteracion;
	}

	public void setIteracion(Long iteracion) {
		this.iteracion = iteracion;
	}

	public Long getMsPrepararJson() {
		return msPrepararJson;
	}

	public void setMsPrepararJson(Long msPrepararJson) {
		this.msPrepararJson = msPrepararJson;
	}

}
