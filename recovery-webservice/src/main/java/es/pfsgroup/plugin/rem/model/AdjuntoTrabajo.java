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
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;



/**
 * Modelo que gestiona la informacion de los adjuntos de los trabajos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_ADT_ADJUNTO_TRABAJO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class AdjuntoTrabajo implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "ADT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AdjuntoTrabajoGenerator")
    @SequenceGenerator(name = "AdjuntoTrabajoGenerator", sequenceName = "S_ACT_ADT_ADJUNTO_TRABAJO")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "TBJ_ID")
    private Trabajo trabajo;   	
	
	@ManyToOne
    @JoinColumn(name = "DD_TPD_ID")
    private DDTipoDocumentoActivo tipoDocumentoActivo;   

    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "ADJ_ID")
    private Adjunto adjunto;   
	
	@Column(name = "ADT_NOMBRE")
	private String nombre;
	
	@Column(name = "ADT_CONTENT_TYPE")
	private String contentType;
	
	@Column(name = "ADT_LENGTH")
	private Long tamanyo;
	
	@Column(name = "ADT_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "ADT_FECHA_DOCUMENTO")
	private Date fechaDocumento;
	
	@Column(name = "ADT_ID_DOCUMENTO_REST")
	private Long idDocRestClient;

	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

	
    /**
     * Constructor.
     */
    public AdjuntoTrabajo() {}
    
    /**
     * Constructor.
     * @param fileItem FileItem
     */
    public AdjuntoTrabajo(FileItem fileItem) {
        Adjunto adjunto = new Adjunto(fileItem);
        this.setAdjunto(adjunto);
        this.setContentType(fileItem.getContentType());
        this.setNombre(fileItem.getFileName());
        this.setTamanyo(fileItem.getLength());
    }
	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Trabajo getTrabajo() {
		return trabajo;
	}

	public void setTrabajo(Trabajo trabajo) {
		this.trabajo = trabajo;
	}

	public DDTipoDocumentoActivo getTipoDocumentoActivo() {
		return tipoDocumentoActivo;
	}

	public void setTipoDocumentoActivo(DDTipoDocumentoActivo tipoDocumentoActivo) {
		this.tipoDocumentoActivo = tipoDocumentoActivo;
	}

	public Adjunto getAdjunto() {
		return adjunto;
	}

	public void setAdjunto(Adjunto adjunto) {
		this.adjunto = adjunto;
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
	
	public Long getIdDocRestClient() {
		return idDocRestClient;
	}

	public void setIdDocRestClient(Long idDocRestClient) {
		this.idDocRestClient = idDocRestClient;
	}
}
