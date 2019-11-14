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

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoAgrupacion;



/**
 * Modelo que gestiona la informacion de los adjuntos de los activos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_ADG_ADJUNTO_AGRUPACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ActivoAdjuntoAgrupacion implements Serializable, Auditable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -7785802535778510517L;
	@Id
    @Column(name = "ADG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoAdjuntoAgrupacionGenerator")
    @SequenceGenerator(name = "ActivoAdjuntoAgrupacionGenerator", sequenceName = "S_ACT_ADG_ADJUNTO_AGRUPACION")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "AGR_ID")
    private ActivoAgrupacion agrupacion;   	
	
	@ManyToOne
    @JoinColumn(name = "DD_TDG_ID")
    private DDTipoDocumentoAgrupacion tipoDocumentoAgrupacion;   
	
	@OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "ADJ_ID")
    private Adjunto adjunto;  
	
	@Column(name = "ADG_NOMBRE")
	private String nombre;
	
	@Column(name = "ADG_CONTENT_TYPE")
	private String contentType;
	
	@Column(name = "ADG_LENGTH")
	private Long tamanyo;
	
	@Column(name = "ADG_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "ADG_FECHA_DOCUMENTO")
	private Date fechaDocumento;
	
	@Column(name = "ADG_ID_DOCUMENTO_REST")
	private Long idDocRestClient;
	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

	@Override
	public Auditoria getAuditoria() {
		return this.auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
		
	}
	
	 /**
    * Constructor.
    */
   public ActivoAdjuntoAgrupacion() {}
   
   /**
    * Constructor.
    * @param fileItem FileItem
    */
   public ActivoAdjuntoAgrupacion(FileItem fileItem) {
       Adjunto adjunto = new Adjunto(fileItem);
       this.setAdjunto(adjunto);
       this.setContentType(fileItem.getContentType());
       this.setNombre(fileItem.getFileName());
       this.setTamanyo(fileItem.getLength());
   }	

	public Adjunto getAdjunto() {
		if (adjunto != null ) {
	       FileItem fileItem = adjunto.getFileItem();
	       fileItem.setContentType(contentType);
	       fileItem.setFileName(nombre);
	       fileItem.setLength(tamanyo);	
		}
		return adjunto;
	}

	public void setAdjunto(Adjunto adjunto) {
		this.adjunto = adjunto;
	}

   public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	

	public ActivoAgrupacion getAgrupacion() {
		return agrupacion;
	}

	public void setAgrupacion(ActivoAgrupacion agrupacion) {
		this.agrupacion = agrupacion;
	}

	public DDTipoDocumentoAgrupacion getTipoDocumentoAgrupacion() {
		return tipoDocumentoAgrupacion;
	}

	public void setTipoDocumentoAgrupacion(DDTipoDocumentoAgrupacion tipoDocumentoAgrupacion) {
		this.tipoDocumentoAgrupacion = tipoDocumentoAgrupacion;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
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

	public Long getIdDocRestClient() {
		return idDocRestClient;
	}

	public void setIdDocRestClient(Long idDocRestClient) {
		this.idDocRestClient = idDocRestClient;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	
}
