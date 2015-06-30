package es.pfsgroup.plugin.precontencioso.documento.model;

import java.io.Serializable;
import java.util.Date;
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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.precontencioso.procedimientoJudicial.model.ProcedimientoPCO;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

@Entity
@Table(name = "PCO_DOC_DOCUMENTOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class DocumentoPCO implements Serializable, Auditable {

	private static final long serialVersionUID = 3368840686161416274L;

	@Id
	@Column(name = "PCO_DOC_PDD_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DocumentoPCOGenerator")
	@SequenceGenerator(name = "DocumentoPCOGenerator", sequenceName = "S_PCO_DOC_DOCUMENTOS")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "PCO_PRC_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private ProcedimientoPCO procedimientoPCO;

	@ManyToOne
	@JoinColumn(name = "DD_PCO_DED_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDEstadoDocumentoPCO estadoDocumento;

	@ManyToOne
	@JoinColumn(name = "DD_PCO_DTD_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDUnidadGestionPCO unidadGestion;

	@ManyToOne
	@JoinColumn(name = "DD_TFA_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDTipoFicheroAdjunto tipoDocumento;

	@Column(name = "PCO_DOC_PDD_ADJUNTO")
	private Boolean adjuntado;
	
	@Column(name = "PCO_DOC_PDD_PROTOCOLO")
	private String protocolo;
	
	@Column(name = "PCO_DOC_PDD_NOTARIO")
	private String notario;

	@Column(name = "PCO_DOC_PDD_FINCA")
	private String finca;
	
	@Column(name = "PCO_DOC_PDD_FECHA_ESCRIT")
	private Date fechaEscritura;
		
	@Column(name = "PCO_DOC_PDD_OBSERVACIONES")
	private String observaciones;

	
	@OneToMany(mappedBy = "documento", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<SolicitudDocumentoPCO> solicitudes;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	/*
	 * GETTERS & SETTERS
	 */

	public ProcedimientoPCO getProcedimientoPCO() {
		return procedimientoPCO;
	}

	public void setProcedimientoPCO(ProcedimientoPCO procedimientoPCO) {
		this.procedimientoPCO = procedimientoPCO;
	}

	public DDEstadoDocumentoPCO getEstadoDocumento() {
		return estadoDocumento;
	}

	public void setEstadoDocumento(DDEstadoDocumentoPCO estadoDocumento) {
		this.estadoDocumento = estadoDocumento;
	}

	public DDUnidadGestionPCO getUnidadGestion() {
		return unidadGestion;
	}

	public void setUnidadGestion(DDUnidadGestionPCO unidadGestion) {
		this.unidadGestion = unidadGestion;
	}

	public DDTipoFicheroAdjunto getTipoDocumento() {
		return tipoDocumento;
	}

	public void setTipoDocumento(DDTipoFicheroAdjunto tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}

	public Boolean getAdjuntado() {
		return adjuntado;
	}

	public void setAdjuntado(Boolean adjuntado) {
		this.adjuntado = adjuntado;
	}

	public String getProtocolo() {
		return protocolo;
	}

	public void setProtocolo(String protocolo) {
		this.protocolo = protocolo;
	}

	public String getNotario() {
		return notario;
	}

	public void setNotario(String notario) {
		this.notario = notario;
	}

	public String getFinca() {
		return finca;
	}

	public void setFinca(String finca) {
		this.finca = finca;
	}

	public Date getFechaEscritura() {
		return fechaEscritura;
	}

	public void setFechaEscritura(Date fechaEscritura) {
		this.fechaEscritura = fechaEscritura;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
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

	public List<SolicitudDocumentoPCO> getSolicitudes() {
		return solicitudes;
	}

	public void setSolicitudes(List<SolicitudDocumentoPCO> solicitudes) {
		this.solicitudes = solicitudes;
	}

}
