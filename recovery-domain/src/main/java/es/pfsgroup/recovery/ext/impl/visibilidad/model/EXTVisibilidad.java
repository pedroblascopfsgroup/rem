package es.pfsgroup.recovery.ext.impl.visibilidad.model;

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

@Entity
@Table(name = "VSB_VISIBILIDAD", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class EXTVisibilidad implements Serializable, Auditable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 5127738214554399424L;


	@Id
    @Column(name = "VSB_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "VisibilidadGenerator")
    @SequenceGenerator(name = "VisibilidadGenerator", sequenceName = "S_VSB_VISIBILIDAD")
    private Long id;
	
	
	@Column(name = "VSB_IDENTIDAD")
	private Long idEntidad;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TVB_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
	private EXTDDTipoVisibilidad tipoVisibilidad;
	
	@Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdEntidad() {
		return idEntidad;
	}

	public void setIdEntidad(Long idEntidad) {
		this.idEntidad = idEntidad;
	}

	public EXTDDTipoVisibilidad getTipoVisibilidad() {
		return tipoVisibilidad;
	}

	public void setTipoVisibilidad(EXTDDTipoVisibilidad tipoVisibilidad) {
		this.tipoVisibilidad = tipoVisibilidad;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
