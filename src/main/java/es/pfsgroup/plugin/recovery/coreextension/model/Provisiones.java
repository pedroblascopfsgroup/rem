package es.pfsgroup.plugin.recovery.coreextension.model;


import java.io.Serializable;
import java.util.Date;

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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
/**
 * Clase que representa la entidad Provisiones.
 * 
 * @author
 * 
 */
@Entity
@Table(name = "PRO_PROVISIONES_ASUNTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
// @Inheritance(strategy = InheritanceType.JOINED)
public class Provisiones implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3449617310961554948L;

	@Id
	@Column(name = "PRO_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ProvisionesGenerator")
	@SequenceGenerator(name = "ProvisionesGenerator", sequenceName = "S_PRO_PROVISIONES_ASUNTO")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ASU_ID")
	private Asunto asunto;

	@Column(name = "PRO_FECHA_ALTA")
	private Date fechaAlta;

	@Column(name = "PRO_FECHA_BAJA")
	private Date fechaBaja;

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

	public Asunto getAsunto() {
		return asunto;
	}

	public void setAsunto(Asunto asunto) {
		this.asunto = asunto;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Date getFechaBaja() {
		return fechaBaja;
	}

	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
	
	/**
     * Retorna el atributo version.
     * @return version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * Setea el atributo version.
     * @param version Integer
     */
    public void setVersion(Integer version) {
        this.version = version;
    }
}
