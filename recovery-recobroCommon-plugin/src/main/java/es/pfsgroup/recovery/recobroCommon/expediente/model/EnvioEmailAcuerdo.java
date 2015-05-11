package es.pfsgroup.recovery.recobroCommon.expediente.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.oficina.model.Oficina;

@Entity
@Table(name = "AEM_ACUERDOS_ENV_MAIL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class EnvioEmailAcuerdo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "AEM_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "CicloGenerator")
	@SequenceGenerator(name = "CicloGenerator", sequenceName = "S_AEM_ACUERDOS_ENV_MAIL")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "ACU_ID")
	private Acuerdo acuerdo;

	@ManyToOne
	@JoinColumn(name = "OFI_ID")
	private Oficina oficina;

	@Column(name = "AEM_ENVIADO")
	private Boolean enviado;

	@Column(name = "AEM_FECHA_PROP")
	private Date fechaPropuesta;

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;
	

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Acuerdo getAcuerdo() {
		return acuerdo;
	}

	public void setAcuerdo(Acuerdo acuerdo) {
		this.acuerdo = acuerdo;
	}

	public Oficina getOficina() {
		return oficina;
	}

	public void setOficina(Oficina oficina) {
		this.oficina = oficina;
	}

	public Boolean getEnviado() {
		return enviado;
	}

	public void setEnviado(Boolean enviado) {
		this.enviado = enviado;
	}

	public Date getFechaPropuesta() {
		return fechaPropuesta;
	}

	public void setFechaPropuesta(Date fechaPropuesta) {
		this.fechaPropuesta = fechaPropuesta;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

}
