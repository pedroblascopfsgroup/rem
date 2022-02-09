package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Where;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.DDTipoBien;
import es.capgemini.pfs.direccion.model.DDComunidadAutonoma;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBLocalizacionesBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBDDOrigenBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.rem.model.dd.ActivoAdmisionRevisionTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCesionSaneamiento;
import es.pfsgroup.plugin.rem.model.dd.DDClasificacionApple;
import es.pfsgroup.plugin.rem.model.dd.DDDireccionTerritorial;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadOrigen;
import es.pfsgroup.plugin.rem.model.dd.DDEntradaActivoBankia;
import es.pfsgroup.plugin.rem.model.dd.DDEquipoGestion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdmision;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoCargaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoRegistralActivo;
import es.pfsgroup.plugin.rem.model.dd.DDOrganismos;
import es.pfsgroup.plugin.rem.model.dd.DDOrigenAnterior;
import es.pfsgroup.plugin.rem.model.dd.DDProcedenciaProducto;
import es.pfsgroup.plugin.rem.model.dd.DDRatingActivo;
import es.pfsgroup.plugin.rem.model.dd.DDServicerActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSociedadPagoAnterior;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubestadoAdmision;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTAUTipoActuacion;
import es.pfsgroup.plugin.rem.model.dd.DDTerritorio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSegmento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTransmision;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUsoDestino;
import es.pfsgroup.plugin.rem.model.dd.DDValidaEstadoActivo;

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

}
