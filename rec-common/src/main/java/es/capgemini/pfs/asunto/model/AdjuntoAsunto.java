package es.capgemini.pfs.asunto.model;

import java.io.Serializable;

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
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Clase que representa a un fichero.
 * @author Nicol�s Cornaglia
 */
@Entity
@Table(name = "ADA_ADJUNTOS_ASUNTOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class AdjuntoAsunto implements Serializable, Auditable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "ADA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AdjuntosAsuntosGenerator")
    @SequenceGenerator(name = "AdjuntosAsuntosGenerator", sequenceName = "S_ADA_ADJUNTOS_ASUNTOS")
    private Long id;

    @Column(name = "ADA_NOMBRE")
    private String nombre;

    @Column(name = "ADA_CONTENT_TYPE")
    private String contentType;

    @Column(name = "ADA_LENGTH")
    private Long length;

    @Column(name = "ADA_DESCRIPCION")
    private String descripcion;

    @ManyToOne
    @JoinColumn(name = "ASU_ID", nullable = false)
    private Asunto asunto;

    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "ADJ_ID")
    private Adjunto adjunto;
    
    @ManyToOne
    @JoinColumn(name = "PRC_ID")
    private Procedimiento procedimiento;
    
    @Column(name = "SERVICER_ID")
    private Long servicerId;

	@Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;
    
    @Transient
	private String refCentera;
    
	@Transient
	private String nombreTipoDoc;


    /**
     * Constructor vacio.
     */
    public AdjuntoAsunto() {
    }

    /**
     * Constructor.
     * @param fileItem FileItem
     */
    public AdjuntoAsunto(FileItem fileItem) {
        Adjunto adjunto = new Adjunto(fileItem);
        this.setAdjunto(adjunto);
        this.setContentType(fileItem.getContentType());
        this.setNombre(fileItem.getFileName());
        this.setLength(fileItem.getLength());
    }

    /**
     * @return the adjunto
     */
    public Adjunto getAdjunto() {
        FileItem fileItem = adjunto.getFileItem();
        fileItem.setContentType(contentType);
        fileItem.setFileName(nombre);
        fileItem.setLength(length);
        return adjunto;
    }

    /**
     * @param adjunto the adjunto to set
     */
    public void setAdjunto(Adjunto adjunto) {
        this.adjunto = adjunto;
    }

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the nombre
     */
    public String getNombre() {
        return nombre;
    }

    /**
     * @param nombre the nombre to set
     */
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    /**
     * @return the contentType
     */
    public String getContentType() {
        return contentType;
    }

    /**
     * @param contentType the contentType to set
     */
    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    /**
     * @return the length
     */
    public Long getLength() {
        return length;
    }

    /**
     * @param length the length to set
     */
    public void setLength(Long length) {
        this.length = length;
    }

    /**
     * @return the descripción
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion the descripción to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * @param asunto the asunto to set
     */
    public void setAsunto(Asunto asunto) {
        this.asunto = asunto;
    }

    /**
     * @return the Asunto
     */
    public Asunto getAsunto() {
        return asunto;
    }

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

    public Long getServicerId() {
		return servicerId;
	}

	public void setServicerId(Long servicerId) {
		this.servicerId = servicerId;
	}
	
	public String getRefCentera() {
		return refCentera;
	}
	
	public void setRefCentera(String refCentera) {
		this.refCentera = refCentera;
	}
	
	public String getNombreTipoDoc() {
		return nombreTipoDoc;
	}
	
	public void setNombreTipoDoc(String nombreTipoDoc) {
		this.nombreTipoDoc = nombreTipoDoc;
	}
}
