package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDDescripcionFotoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoFoto;
import es.pfsgroup.plugin.rem.rest.dto.File;

/**
 * Modelo que gestiona la información de las fotos.
 * 
 * @author Anahuac de Vicente
 */
@Entity
@Table(name = "ACT_FOT_FOTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoFoto implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Constructor
	 */

	public ActivoFoto() {
	}

	public ActivoFoto(FileItem fileItem) {
		Adjunto adjunto = new Adjunto(fileItem);
		this.setAdjunto(adjunto);
		this.setNombre(fileItem.getFileName());
		this.setTamanyo(fileItem.getLength());
	}

	public ActivoFoto(File remoteFileItem) {
		this.setRemoteId(remoteFileItem.getId());
		this.setUrl(remoteFileItem.getUrl());
		this.setUrlOptimized(remoteFileItem.getUrl_optimized());
		this.setUrlThumbnail(remoteFileItem.getUrl_thumbnail());
		this.setUrlWatermark(remoteFileItem.getUrl_watermark());

	}

	@Id
	@Column(name = "FOT_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoFotoGenerator")
	@SequenceGenerator(name = "ActivoFotoGenerator", sequenceName = "S_ACT_FOT_FOTO")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_ID")
	private Activo activo;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "AGR_ID")
	private ActivoAgrupacion agrupacion;

	@Column(name = "SDV_ID")
	private Long subdivision;

	@OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
	@JoinColumn(name = "ADJ_ID")
	private Adjunto adjunto;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TFO_ID")
	private DDTipoFoto tipoFoto;

	@Column(name = "FOT_NOMBRE")
	private String nombre;

	@Column(name = "FOT_LENGTH")
	private Long tamanyo;

	@Column(name = "FOT_DESCRIPCION")
	private String descripcion;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_DFA_ID")
	private DDDescripcionFotoActivo descripcionFoto;

	@Column(name = "FOT_FECHA_DOCUMENTO")
	private Date fechaDocumento;

	@Column(name = "FOT_PRINCIPAL")
	private Boolean principal;

	@Column(name = "FOT_INT_EXT")
	private Boolean interiorExterior;

	@Column(name = "FOT_VIDEO")
	private Boolean video;

	@Column(name = "FOT_PLANO")
	private Boolean plano;

	@Column(name = "FOT_ORDEN")
	private Integer orden;

	@Column(name = "FOT_GDF_ID")
	private Long remoteId;

	@Column(name = "FOT_GDF_URL")
	private String url;

	@Column(name = "FOT_GDF_WATERMARK")
	private String urlWatermark;

	@Column(name = "FOT_GDF_OPTIMIZED")
	private String urlOptimized;

	@Column(name = "FOT_GDF_THUMBNAIL")
	private String urlThumbnail;
	
	@Column(name = "FOT_SUELOS")
	private Boolean suelos;

	public Long getRemoteId() {
		return remoteId;
	}

	public void setRemoteId(Long remoteId) {
		this.remoteId = remoteId;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getUrlWatermark() {
		return urlWatermark;
	}

	public void setUrlWatermark(String urlWatermark) {
		this.urlWatermark = urlWatermark;
	}

	public String getUrlOptimized() {
		return urlOptimized;
	}

	public void setUrlOptimized(String urlOptimized) {
		this.urlOptimized = urlOptimized;
	}

	public String getUrlThumbnail() {
		return urlThumbnail;
	}

	public void setUrlThumbnail(String urlThumbnail) {
		this.urlThumbnail = urlThumbnail;
	}

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

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public ActivoAgrupacion getAgrupacion() {
		return agrupacion;
	}

	public void setAgrupacion(ActivoAgrupacion agrupacion) {
		this.agrupacion = agrupacion;
	}

	public Long getSubdivision() {
		return subdivision;
	}

	public void setSubdivision(Long subdivision) {
		this.subdivision = subdivision;
	}

	public Adjunto getAdjunto() {
		return adjunto;
	}

	public void setAdjunto(Adjunto adjunto) {
		this.adjunto = adjunto;
	}

	public DDTipoFoto getTipoFoto() {
		return tipoFoto;
	}

	public void setTipoFoto(DDTipoFoto tipoFoto) {
		this.tipoFoto = tipoFoto;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public Long getTamanyo() {
		return tamanyo;
	}

	public void setTamanyo(Long tamanyo) {
		this.tamanyo = tamanyo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Date getFechaDocumento() {
		return fechaDocumento;
	}

	public void setFechaDocumento(Date fechaDocumento) {
		this.fechaDocumento = fechaDocumento;
	}

	public Boolean getPrincipal() {
		return principal;
	}

	public void setPrincipal(Boolean principal) {
		this.principal = principal;
	}

	public Boolean getInteriorExterior() {
		return interiorExterior;
	}

	public void setInteriorExterior(Boolean interiorExterior) {
		this.interiorExterior = interiorExterior;
	}

	public Boolean getVideo() {
		return video;
	}

	public void setVideo(Boolean video) {
		this.video = video;
	}

	public Boolean getPlano() {
		return plano;
	}

	public void setPlano(Boolean plano) {
		this.plano = plano;
	}

	public Integer getOrden() {
		return orden;
	}

	public void setOrden(Integer orden) {
		this.orden = orden;
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

	public DDDescripcionFotoActivo getDescripcionFoto() {
		return descripcionFoto;
	}

	public void setDescripcionFoto(DDDescripcionFotoActivo descripcionFoto) {
		this.descripcionFoto = descripcionFoto;
	}

	public Boolean getSuelos() {
		return suelos;
	}

	public void setSuelos(Boolean suelos) {
		this.suelos = suelos;
	}

}
