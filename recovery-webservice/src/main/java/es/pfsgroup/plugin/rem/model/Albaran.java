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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDAdecuacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDCesionUso;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAlbaran;
import es.pfsgroup.plugin.rem.model.dd.DDTipoEstadoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoInquilino;

/**
 * Modelo que gestiona el modelo de Albaranes para la gestión, 
 * flujo e información de los trabajos.
 * 
 * @author Alberto Flores
 */
@Entity
@Table(name = "ALB_ALBARAN", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class Albaran implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "ALB_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "AlbaranGenerator")
	@SequenceGenerator(name = "AlbaranGenerator", sequenceName = "S_ALB_ALBARAN")
	private Long id;
	
	@Column(name = "ALB_NUM_ALBARAN")
	private Long numAlbaran;
	
	@Column(name = "ALB_FECHA_ALBARAN")
	private Date fechaAlbaran;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_ESA_ID")
	private DDEstadoAlbaran estadoAlbaran;
	
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

	public Long getNumAlbaran() {
		return numAlbaran;
	}

	public void setNumAlbaran(Long numAlbaran) {
		this.numAlbaran = numAlbaran;
	}

	public Date getFechaAlbaran() {
		return fechaAlbaran;
	}

	public void setFechaAlbaran(Date fechaAlbaran) {
		this.fechaAlbaran = fechaAlbaran;
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

	public DDEstadoAlbaran getEstadoAlbaran() {
		return estadoAlbaran;
	}

	public void setEstadoAlbaran(DDEstadoAlbaran estadoAlbaran) {
		this.estadoAlbaran = estadoAlbaran;
	}
	
}
