package es.pfsgroup.plugin.precontencioso.documento.model;

import java.io.Serializable;
import java.util.Date;

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
import org.hibernate.annotations.Formula;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;

@Entity
@Table(name = "PCO_DOC_SOLICITUDES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class SolicitudDocumentoPCO implements Serializable, Auditable {

	private static final long serialVersionUID = -6530223234442269689L;

	@Id
	@Column(name = "PCO_DOC_DSO_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SolicitudDocumentoPCOGenerator")
	@SequenceGenerator(name = "SolicitudDocumentoPCOGenerator", sequenceName = "S_PCO_DOC_SOLICITUDES")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "PCO_DOC_PDD_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DocumentoPCO documento;

	@ManyToOne
	@JoinColumn(name = "DD_PCO_DSR_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDResultadoSolicitudPCO resultadoSolicitud;

	@ManyToOne
	@JoinColumn(name = "DD_PCO_DSA_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDTipoActorPCO tipoActor;

	@ManyToOne
	@JoinColumn(name = "USD_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private GestorDespacho actor;

	@Column(name = "PCO_DOC_DSO_FECHA_SOLICITUD")
	private Date fechaSolicitud;

	@Column(name = "PCO_DOC_DSO_FECHA_ENVIO")
	private Date fechaEnvio;

	@Column(name = "PCO_DOC_DSO_FECHA_RESULTADO")
	private Date fechaResultado;

	@Column(name = "PCO_DOC_DSO_FECHA_RECEPCION")
	private Date fechaRecepcion;
	
	@ManyToOne
	@JoinColumn(name = "PCO_DOC_SOLICITANTE")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private GestorDespacho solicitante;

	@Column(name = "SYS_GUID")
	private String sysGuid;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	/*
	 * Formulas para el buscador de precontencioso
	 */

	@Formula(value = 
		" (SELECT TRUNC(SYSDATE) - TRUNC(pco_doc_solicitudes.pco_doc_dso_fecha_solicitud)" +
		" FROM   pco_doc_documentos " +
		"        INNER JOIN dd_pco_doc_estado " +
		"                ON dd_pco_doc_estado.dd_pco_ded_id = pco_doc_documentos.dd_pco_ded_id " +
		"        INNER JOIN pco_doc_solicitudes " +
		"                ON pco_doc_documentos.pco_doc_pdd_id = pco_doc_solicitudes.pco_doc_pdd_id " +
		" WHERE  pco_doc_solicitudes.PCO_DOC_DSO_ID = PCO_DOC_DSO_ID " +
		"        AND dd_pco_doc_estado.dd_pco_ded_codigo != '" + DDEstadoDocumentoPCO.DESCARTADO + "' " +
		"        AND dd_pco_doc_estado.dd_pco_ded_codigo != '" + DDEstadoDocumentoPCO.DISPONIBLE + "' )" )
	private Integer diasEnGestion;

	/*
	 * GETTERS & SETTERS
	 */

	public DocumentoPCO getDocumento() {
		return documento;
	}

	public void setDocumento(DocumentoPCO documento) {
		this.documento = documento;
	}

	public DDResultadoSolicitudPCO getResultadoSolicitud() {
		return resultadoSolicitud;
	}

	public void setResultadoSolicitud(DDResultadoSolicitudPCO resultadoSolicitud) {
		this.resultadoSolicitud = resultadoSolicitud;
	}

	public DDTipoActorPCO getTipoActor() {
		return tipoActor;
	}

	public void setTipoActor(DDTipoActorPCO tipoActor) {
		this.tipoActor = tipoActor;
	}

	public GestorDespacho getActor() {
		return actor;
	}

	public void setActor(GestorDespacho actor) {
		this.actor = actor;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public Date getFechaEnvio() {
		return fechaEnvio;
	}

	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}

	public Date getFechaResultado() {
		return fechaResultado;
	}

	public void setFechaResultado(Date fechaResultado) {
		this.fechaResultado = fechaResultado;
	}

	public Date getFechaRecepcion() {
		return fechaRecepcion;
	}

	public void setFechaRecepcion(Date fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
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

	public Long getId() {
		return id;
	}

	public String getSysGuid() {
		return sysGuid;
	}

	public void setSysGuid(String sysGuid) {
		this.sysGuid = sysGuid;
	}

	public GestorDespacho getSolicitante() {
		return solicitante;
	}

	public void setSolicitante(GestorDespacho solicitante) {
		this.solicitante = solicitante;
	}
}
