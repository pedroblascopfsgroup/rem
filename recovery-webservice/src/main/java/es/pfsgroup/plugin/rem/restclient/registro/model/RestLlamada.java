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

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "RST_LLAMADA", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class RestLlamada implements Serializable, Auditable {
	
	private static final long serialVersionUID = 8551021750962302260L;
	
	@Id
	@Column(name = "RST_LLAMADA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "llamadaRstGenerator")
	@SequenceGenerator(name = "llamadaRstGenerator", sequenceName = "S_RST_LLAMADA")
	private Long llamadaId;
	
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
	
	
	@Embedded
	private Auditoria auditoria;

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
		this.request = request;
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

	
	
}
