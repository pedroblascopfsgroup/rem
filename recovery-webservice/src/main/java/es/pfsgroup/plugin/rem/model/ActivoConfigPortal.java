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
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;

/**
 * Modelo que gestiona la información de la documentación exigida de los
 * activos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_CNP_CONFIG_PORTAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoConfigPortal implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "CNP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoConfigPortalGenerator")
	@SequenceGenerator(name = "ActivoConfigPortalGenerator", sequenceName = "S_ACT_CNP_CONFIG_PORTAL")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "DD_CRA_ID")
	private DDCartera cartera;

	@ManyToOne
	@JoinColumn(name = "DD_SCR_ID")
	private DDSubcartera subcartera;

	@Column(name = "CNP_PENDIENTE_INSCRIPCION")
	private Boolean pendienteInscripcion;

	@Column(name = "CNP_CON_CARGAS")
	private Boolean conCargas;

	@Column(name = "CFD_APLICA_F_ETIQUETA")
	private Boolean ocupadoSinTitulo;

	@Column(name = "CNP_OCUPADO_CON_TITULO")
	private Boolean ocupadoConTitulo;

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

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

	public DDSubcartera getSubcartera() {
		return subcartera;
	}

	public void setSubcartera(DDSubcartera subcartera) {
		this.subcartera = subcartera;
	}

	public Boolean getPendienteInscripcion() {
		return pendienteInscripcion;
	}

	public void setPendienteInscripcion(Boolean pendienteInscripcion) {
		this.pendienteInscripcion = pendienteInscripcion;
	}

	public Boolean getConCargas() {
		return conCargas;
	}

	public void setConCargas(Boolean conCargas) {
		this.conCargas = conCargas;
	}

	public Boolean getOcupadoSinTitulo() {
		return ocupadoSinTitulo;
	}

	public void setOcupadoSinTitulo(Boolean ocupadoSinTitulo) {
		this.ocupadoSinTitulo = ocupadoSinTitulo;
	}

	public Boolean getOcupadoConTitulo() {
		return ocupadoConTitulo;
	}

	public void setOcupadoConTitulo(Boolean ocupadoConTitulo) {
		this.ocupadoConTitulo = ocupadoConTitulo;
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
