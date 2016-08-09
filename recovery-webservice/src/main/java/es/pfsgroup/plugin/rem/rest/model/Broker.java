package es.pfsgroup.plugin.rem.rest.model;

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

/**
 * 
 * @author rllinares
 *
 */

@Entity
@Table(name = "RST_BROKER", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class Broker implements Serializable, Auditable{

	
	private static final long serialVersionUID = -2174816655546231032L;
	
	@Embedded
	private Auditoria auditoria;
	
	@Id
    @Column(name = "RST_BROKER_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "brokerGenerator")
    @SequenceGenerator(name = "brokerGenerator", sequenceName = "S_RST_BROKER")
	private Long brokerId;
	
	@Column(name = "RST_IP")
	private String ip;
	
	@Column(name = "RST_KEY")
	private String key;
	
	@Column(name = "RST_VALIDAR_FIRMA")
	private Long validarFirma;
	
	public Long getValidarFirma() {
		return validarFirma;
	}

	public void setValidarFirma(Long validarFirma) {
		this.validarFirma = validarFirma;
	}

	public Long getValidarToken() {
		return validarToken;
	}

	public void setValidarToken(Long validarToken) {
		this.validarToken = validarToken;
	}

	@Column(name = "RST_VALIDAR_TOKEN")
	private Long validarToken;

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
		
	}

	public Long getBrokerId() {
		return brokerId;
	}

	public void setBrokerId(Long brokerId) {
		this.brokerId = brokerId;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}
	
	

}
