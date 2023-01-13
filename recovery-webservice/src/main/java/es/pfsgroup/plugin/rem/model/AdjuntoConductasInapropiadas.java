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
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoConductasInapropiadas;


/**
 * Modelo que gestiona la informacion de los adjuntos de los proveedores
 * 
 * @author Daniel Gutiérrez
 *
 */
@Entity
@Table(name = "ACI_ADJUNTO_CONDUCTAS_INAPROPIADAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class AdjuntoConductasInapropiadas implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7785802535778510517L;

	@Id
    @Column(name = "ACI_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AdjuntoConductasInapropiadasGenerator")
    @SequenceGenerator(name = "AdjuntoConductasInapropiadasGenerator", sequenceName = "S_ACI_ADJUNTO_CONDUCTAS_INAPROPIADAS")
    private Long id; 	
	
	@ManyToOne
    @JoinColumn(name = "DD_TDC_ID")
    private DDTipoDocumentoConductasInapropiadas tipoDocumentoConductasInapropiadas;   

    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "ADJ_ID")
    private Adjunto adjunto;  
	
	@Column(name = "ACI_NOMBRE")
	private String nombre;
	
	@Column(name = "ACI_CONTENT_TYPE")
	private String contentType;
	
	@Column(name = "ACI_LENGTH")
	private Long tamanyo;
	
	@Column(name = "ACI_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "ACI_FECHA_DOCUMENTO")
	private Date fechaDocumento;
	
	@Column(name = "ACI_ID_DOCUMENTO_REST")
	private Long idDocRestClient;

	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

    /**
     * Constructor.
     */
    public AdjuntoConductasInapropiadas() {}
    
    /**
     * Constructor.
     * @param fileItem FileItem
     */
    public AdjuntoConductasInapropiadas(FileItem fileItem) {
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

	public DDTipoDocumentoConductasInapropiadas getTipoDocumentoConductasInapropiadas() {
		return tipoDocumentoConductasInapropiadas;
	}

	public void setTipoDocumentoConductasInapropiadas(DDTipoDocumentoConductasInapropiadas tipoDocumentoConductasInapropiadas) {
		this.tipoDocumentoConductasInapropiadas = tipoDocumentoConductasInapropiadas;
	}

	public Adjunto getAdjunto() {
        FileItem fileItem = adjunto.getFileItem();
        fileItem.setContentType(contentType);
        fileItem.setFileName(nombre);
        fileItem.setLength(tamanyo);		
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

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
