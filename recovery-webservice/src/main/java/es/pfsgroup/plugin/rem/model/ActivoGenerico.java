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
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;



/**
 * Modelo que permita incluir un activo genérico configurable para cada uno de los clientes.
 * 
 * @author Javier Esbrí
 *
 */
@Entity
@Table(name = "ACT_AGS_ACTIVO_GENERICO_STG", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoGenerico implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "AGS_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoGenericoGenerator")
    @SequenceGenerator(name = "ActivoGenericoGenerator", sequenceName = "S_ACT_AGS_ACTIVO_GENERICO_STG")
    private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_STG_ID")
    private DDSubtipoGasto subtipoGasto;
	
	@Column(name = "AGS_ANYO")
    private Integer anyoActivoGenerico;   
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PRO_ID")
    private ActivoPropietario propietario;
	
	@Column(name = "AGS_ACTIVO_GENERICO")
    private Long numActivoGenerico;
	
	
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

	public DDSubtipoGasto getSubtipoGasto() {
		return subtipoGasto;
	}

	public void setSubtipoGasto(DDSubtipoGasto subtipoGasto) {
		this.subtipoGasto = subtipoGasto;
	}

	public Integer getAnyoActivoGenerico() {
		return anyoActivoGenerico;
	}

	public void setAnyoActivoGenerico(Integer anyoActivoGenerico) {
		this.anyoActivoGenerico = anyoActivoGenerico;
	}

	public ActivoPropietario getPropietario() {
		return propietario;
	}

	public void setPropietario(ActivoPropietario propietario) {
		this.propietario = propietario;
	}

	public Long getNumActivoGenerico() {
		return numActivoGenerico;
	}

	public void setNumActivoGenerico(Long numActivoGenerico) {
		this.numActivoGenerico = numActivoGenerico;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
	
	
}
	