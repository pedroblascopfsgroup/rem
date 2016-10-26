package es.pfsgroup.plugin.rem.rest.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * 
 * @author rllinares
 *
 */
@Entity
@Table(name = "RST_PETICION", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class PeticionRest implements Serializable, Auditable {

	private static final long serialVersionUID = -6870172731558995942L;

	@Embedded
	private Auditoria auditoria;

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Id
	@Column(name = "RST_PETICION_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "peticionRstGenerator")
	@SequenceGenerator(name = "peticionRstGenerator", sequenceName = "S_RST_PETICION")
	private Long peticionId;

	@Column(name = "RST_PETICION_TOKEN")
	private String token;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "RST_BROKER_ID")
	private Broker broker;
	
	@Column(name = "RST_PETICION_RESULT")
	private String result;
	
	@Column(name = "RST_PETICION_ERROR_DESC")
	private String errorDesc;
	
	@Column(name = "RST_PETICION_METODO")
	private String metodo;
	
	@Column(name = "RST_PETICION_QUERY")
	private String query;
	
	@Column(name = "RST_PETICION_DATA")
	private String data;
	
	@Column(name = "RST_PETICION_IP")
	private String ip;
	
	@Column(name = "RST_PETICION_RESPONSE")
	private String response;
	
	@Column(name = "RST_PETICION_TIME")
	private Long tiempoEjecucion;

	public String getResponse() {
		return response;
	}

	public void setResponse(String response) {
		this.response = response;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;

	}

	public Long getPeticionId() {
		return peticionId;
	}

	public void setPeticionId(Long peticionId) {
		this.peticionId = peticionId;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public Broker getBroker() {
		return broker;
	}

	public void setBroker(Broker broker) {
		this.broker = broker;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public String getErrorDesc() {
		return errorDesc;
	}

	public void setErrorDesc(String errorDesc) {
		if(errorDesc.length()>200){
			errorDesc = errorDesc.substring(0,199);
		}
		this.errorDesc = errorDesc;
	}

	public String getMetodo() {
		return metodo;
	}

	public void setMetodo(String metodo) {
		this.metodo = metodo;
	}

	public String getQuery() {
		return query;
	}

	public void setQuery(String query) {
		this.query = query;
	}

	public String getData() {
		return data;
	}

	public void setData(String data) {
		this.data = data;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public Long getTiempoEjecucion() {
		return tiempoEjecucion;
	}

	public void setTiempoEjecucion(Long tiempoEjecucion) {
		this.tiempoEjecucion = tiempoEjecucion;
	}
	
	

}
