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

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDComunidadAutonoma;
import es.pfsgroup.plugin.rem.model.dd.DDOrganismos;
import es.pfsgroup.plugin.rem.model.dd.DDTAUTipoActuacion;

/**
 * Modelo que gestiona los activos.
 */
@Entity
@Table(name = "ORG_ORGANISMOS", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class Organismos implements Serializable, Auditable {

	private static final long serialVersionUID = 4477763412715784465L;

	@Id
	@Column(name = "ORG_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "OrganismosGenerator")
	@SequenceGenerator(name = "OrganismosGenerator", sequenceName = "S_ORG_ORGANISMOS")
	private Long id;

	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_ORG_ID")
	private DDOrganismos organismo;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TAU_ID")
	private DDTAUTipoActuacion tipoActuacion;	

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_CCA_ID")
	private DDComunidadAutonoma comunidad;

	@Column(name = "FECHA_ORGANISMO")
	private Date fechaOrganismo;
	
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

	public DDOrganismos getOrganismo() {
		return organismo;
	}

	public void setOrganismo(DDOrganismos organismo) {
		this.organismo = organismo;
	}

	public DDTAUTipoActuacion getTipoActuacion() {
		return tipoActuacion;
	}

	public void setTipoActuacion(DDTAUTipoActuacion tipoActuacion) {
		this.tipoActuacion = tipoActuacion;
	}

	public Date getFechaOrganismo() {
		return fechaOrganismo;
	}

	public void setFechaOrganismo(Date fechaOrganismo) {
		this.fechaOrganismo = fechaOrganismo;
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

	public DDComunidadAutonoma getComunidad() {
		return comunidad;
	}

	public void setComunidad(DDComunidadAutonoma comunidad) {
		this.comunidad = comunidad;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}


}
