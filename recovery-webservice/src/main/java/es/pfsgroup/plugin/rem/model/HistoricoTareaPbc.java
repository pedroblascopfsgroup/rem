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
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
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
import es.pfsgroup.plugin.rem.model.dd.DDTipoTareaPbc;


/**
 * Modelo que gestiona la informacion de una oferta
 *
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "HTP_HISTORICO_TAREAS_PBC", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class HistoricoTareaPbc implements Serializable, Auditable {

    /**
	 *
	 */
	private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "HTP_ID", updatable = false, nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "HistoricoTareaPbcGenerator")
    @SequenceGenerator(name = "HistoricoTareaPbcGenerator", sequenceName = "S_HTP_HISTORICO_TAREAS_PBC", allocationSize = 1)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    private Oferta oferta;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPB_ID")
	private DDTipoTareaPbc tipoTareaPbc;

    @Column(name = "HTP_ACTIVA")
    private Boolean activa = true;

	@Column(name="HTP_APROBACION")
	private Boolean aprobacion;

	@Column(name="HTP_FECHA_SANCION")
	private Date fechaSancion;

	@Column(name="HTP_INFORME")
	private String informe;

	@Column(name = "HTP_FECHA_SOLICITUD_CALCULO_RIESGO")
	private Date fechaSolicitudCalculoRiesgo;

	@Column(name = "HTP_FECHA_COMUNICACION_RIESGO")
   	private Date fechaComunicacionRiesgo;

	@Column(name = "HTP_FECHA_ENVIO_DOCUMENTACION_BC")
   	private Date fechaEnvioDocumentacionBc;

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

	public Oferta getOferta() {
		return oferta;
	}

	public void setOferta(Oferta oferta) {
		this.oferta = oferta;
	}

	public DDTipoTareaPbc getTipoTareaPbc() {
		return tipoTareaPbc;
	}

	public void setTipoTareaPbc(DDTipoTareaPbc tipoTareaPbc) {
		this.tipoTareaPbc = tipoTareaPbc;
	}

	public Boolean getActiva() {
		return activa;
	}

	public void setActiva(Boolean activa) {
		this.activa = activa;
	}

	public Boolean getAprobacion() {
		return aprobacion;
	}

	public void setAprobacion(Boolean aprobacion) {
		this.aprobacion = aprobacion;
	}

	public Date getFechaSancion() {
		return fechaSancion;
	}

	public void setFechaSancion(Date fechaSancion) {
		this.fechaSancion = fechaSancion;
	}

	public String getInforme() {
		return informe;
	}

	public void setInforme(String informe) {
		this.informe = informe;
	}

	public Date getFechaSolicitudCalculoRiesgo() {
		return fechaSolicitudCalculoRiesgo;
	}

	public void setFechaSolicitudCalculoRiesgo(Date fechaSolicitudCalculoRiesgo) {
		this.fechaSolicitudCalculoRiesgo = fechaSolicitudCalculoRiesgo;
	}

	public Date getFechaComunicacionRiesgo() {
		return fechaComunicacionRiesgo;
	}

	public void setFechaComunicacionRiesgo(Date fechaComunicacionRiesgo) {
		this.fechaComunicacionRiesgo = fechaComunicacionRiesgo;
	}

	public Date getFechaEnvioDocumentacionBc() {
		return fechaEnvioDocumentacionBc;
	}

	public void setFechaEnvioDocumentacionBc(Date fechaEnvioDocumentacionBc) {
		this.fechaEnvioDocumentacionBc = fechaEnvioDocumentacionBc;
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
