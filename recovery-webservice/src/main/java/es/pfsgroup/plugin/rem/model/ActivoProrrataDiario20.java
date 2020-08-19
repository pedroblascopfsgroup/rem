package es.pfsgroup.plugin.rem.model;

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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;



/**
 * 
 * 
 * @author Jonathan Ovalle
 *
 */
@Entity
@Table(name = "ACT_P20_PRORRATA_DIARIO20", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoProrrataDiario20 implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "P20_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoProrrataDiario20Generator")
    @SequenceGenerator(name = "ActivoProrrataDiario20Generator", sequenceName = "S_ACT_P20_PRORRATA_DIARIO20")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PRO_ID")
	private ActivoPropietario propietarioId;
	
	@Column(name = "P20_PRORRATA")
    private Integer prorrata;   
	 
	@Column(name = "P20_GASTO")
	private Integer ascensorEdificio;
	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;
	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public ActivoPropietario getPropietarioId() {
		return propietarioId;
	}

	public void setPropietarioId(ActivoPropietario propietarioId) {
		this.propietarioId = propietarioId;
	}

	public Integer getProrrata() {
		return prorrata;
	}

	public void setProrrata(Integer prorrata) {
		this.prorrata = prorrata;
	}

	public Integer getAscensorEdificio() {
		return ascensorEdificio;
	}

	public void setAscensorEdificio(Integer ascensorEdificio) {
		this.ascensorEdificio = ascensorEdificio;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	
	

}
