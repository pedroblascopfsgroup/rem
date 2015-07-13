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
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
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
	
	@Column(name = "PCO_DOC_PDD_UG_ID")
	private Long unidadGestionId;	
	
	@Column(name = "PCO_DOC_PDD_UG_DESC")
	private String ugDescripcion;	

	@Column(name = "PCO_DOC_PDD_PROTOCOLO")
	private String protocolo;
	
	@Column(name = "PCO_DOC_PDD_NOTARIO")
	private String notario;

	@Column(name = "PCO_DOC_PDD_FECHA_ESCRIT")
	private Date fechaEscritura;

	@Column(name = "PCO_DOC_PDD_FINCA")
	private String finca;
	
	@Column(name = "PCO_DOC_PDD_ASIENTO")
	private Date asiento;
		
	@Column(name = "PCO_DOC_PDD_TOMO")
	private Date tomo;
		
	@Column(name = "PCO_DOC_PDD_LIBRO")
	private Date libro;
		
	@Column(name = "PCO_DOC_PDD_FOLIO")
	private Date folio;
		
	@Column(name = "PCO_DOC_PDD_NRO_FINCA")
	private Date nroFinca;
		
	@Column(name = "PCO_DOC_PDD_NRO_REGIS")
	private Date nroRegistro;
		
	@Column(name = "PCO_DOC_PDD_PLAZA")
	private Date plaza;
		
	@Column(name = "PCO_DOC_PDD_IDUFIR")
	private Date idufir;
		
	@Column(name = "PCO_DOC_PDD_OBSERVACIONES")
	private String observaciones;
	
	@OneToMany(mappedBy = "documento", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<SolicitudDocumentoPCO> solicitudes;

	@Column(name = "SYS_GUID")
	private String sysGuid;

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

	public Long getUnidadGestionId() {
		return unidadGestionId;
	}

	public void setUnidadGestionId(Long unidadGestionId) {
		this.unidadGestionId = unidadGestionId;
	}

	public String getUgDescripcion() {
		return ugDescripcion;
	}

	public void setUgDescripcion(String ugDescripcion) {
		this.ugDescripcion = ugDescripcion;
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

	public Date getAsiento() {
		return asiento;
	}

	public void setAsiento(Date asiento) {
		this.asiento = asiento;
	}

	public Date getTomo() {
		return tomo;
	}

	public void setTomo(Date tomo) {
		this.tomo = tomo;
	}

	public Date getLibro() {
		return libro;
	}

	public void setLibro(Date libro) {
		this.libro = libro;
	}

	public Date getFolio() {
		return folio;
	}

	public void setFolio(Date folio) {
		this.folio = folio;
	}

	public Date getNroFinca() {
		return nroFinca;
	}

	public void setNroFinca(Date nroFinca) {
		this.nroFinca = nroFinca;
	}

	public Date getNroRegistro() {
		return nroRegistro;
	}

	public void setNroRegistro(Date nroRegistro) {
		this.nroRegistro = nroRegistro;
	}

	public Date getPlaza() {
		return plaza;
	}

	public void setPlaza(Date plaza) {
		this.plaza = plaza;
	}

	public Date getIdufir() {
		return idufir;
	}

	public void setIdufir(Date idufir) {
		this.idufir = idufir;
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

	public String getSysGuid() {
		return sysGuid;
	}

	public void setSysGuid(String sysGuid) {
		this.sysGuid = sysGuid;
	}

}
