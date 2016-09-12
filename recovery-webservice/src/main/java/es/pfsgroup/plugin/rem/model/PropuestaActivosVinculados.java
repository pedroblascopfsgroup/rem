package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
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
 * Modelo que gestiona las propuestas de vinculación entre activos.
 */
@Entity
@Table(name = "ACT_AVI_ACTIVOS_VINCULADOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class PropuestaActivosVinculados implements Serializable, Auditable {
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "AVI_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "PropuestaActivosVinculadosGenerator")
    @SequenceGenerator(name = "PropuestaActivosVinculadosGenerator", sequenceName = "S_ACT_AVI_ACTIVOS_VINCULADOS")
    private Long id;

	@ManyToOne
    @JoinColumn(name = "ACT_ID_ORIGEN")
    private Activo activoOrigen;
	
	@ManyToOne
    @JoinColumn(name = "ACT_ID_VINCULADO")
    private Activo activoVinculado;
	
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

	public Activo getActivoOrigen() {
		return activoOrigen;
	}

	public void setActivoOrigen(Activo activoOrigen) {
		this.activoOrigen = activoOrigen;
	}

	public Activo getActivoVinculado() {
		return activoVinculado;
	}

	public void setActivoVinculado(Activo activoVinculado) {
		this.activoVinculado = activoVinculado;
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
