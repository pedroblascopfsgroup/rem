package es.pfsgroup.plugin.rem.model;

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
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;


/**
 * Modelo que gestiona la informacion de la exclusion bulk de una oferta
 *
 * @author Vicente Martinez
 *
 */
@Entity
@Table(name = "H_OEB_OFR_EXCLUSION_BULK", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class OfertaExclusionBulk implements Serializable, Auditable {

    /**
	 *
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "OEB_ID")
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    private Oferta oferta;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OEB_EXCLUSION_BULK")
    private DDSinSiNo exclusionBulk;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USU_ID")
    private Usuario usuarioAccion;

	@Column(name="OEB_FECHA_INI")
	private Date fechaInicio;

	@Column(name="OEB_FECHA_FIN")
	private Date fechaFin;
	
	@Version
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public Oferta getOferta() {
		return oferta;
	}

	public DDSinSiNo getExclusionBulk() {
		return exclusionBulk;
	}

	public Usuario getUsuarioAccion() {
		return usuarioAccion;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setOferta(Oferta oferta) {
		this.oferta = oferta;
	}

	public void setExclusionBulk(DDSinSiNo exclusionBulk) {
		this.exclusionBulk = exclusionBulk;
	}

	public void setUsuarioAccion(Usuario usuarioAccion) {
		this.usuarioAccion = usuarioAccion;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
