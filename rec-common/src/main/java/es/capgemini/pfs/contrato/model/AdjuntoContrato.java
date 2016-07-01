package es.capgemini.pfs.contrato.model;

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
import es.capgemini.pfs.tipoFicheroAdjuntoEntidad.DDTipoAdjuntoEntidad;
import es.pfsgroup.commons.utils.Checks;

/**
 * Clase que representa a un fichero.
 * @author pamuller
 */
@Entity
@Table(name = "ADC_ADJUNTOS_CONTRATOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class AdjuntoContrato implements Serializable, Auditable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "ADC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AdjuntosContratosGenerator")
    @SequenceGenerator(name = "AdjuntosContratosGenerator", sequenceName = "S_ADC_ADJUNTOS_CONTRATOS")
    private Long id;

    @Column(name = "ADC_NOMBRE")
    private String nombre;

    @Column(name = "ADC_CONTENT_TYPE")
    private String contentType;

    @Column(name = "ADC_LENGTH")
    private Long length;

    @Column(name = "ADC_DESCRIPCION")
    private String descripcion;

    @ManyToOne
    @JoinColumn(name = "CNT_ID", nullable = false)
    private Contrato contrato;

    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "ADJ_ID")
    private Adjunto adjunto;
    
    @ManyToOne
    @JoinColumn(name = "DD_TAE_ID")
    private DDTipoAdjuntoEntidad tipoAdjuntoEntidad;
    
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
	
	@Transient
	private Long idAdjuntoBlob;
    
    /**
     * Constructor vacio.
     */
    public AdjuntoContrato() {
    }

    /**
     * Constructor.
     * @param fileItem FileItem
     */
    public AdjuntoContrato(FileItem fileItem) {
        Adjunto adjunto = new Adjunto(fileItem);
        this.setAdjunto(adjunto);
        this.setContentType(fileItem.getContentType());
        this.setNombre(fileItem.getFileName());
        this.setLength(fileItem.getLength());
    }

    /**
     * Constructor.
     * @param fileItem FileItem
     * @param DDTipoAdjuntoEntidad
     */
    public AdjuntoContrato(FileItem fileItem, DDTipoAdjuntoEntidad tipoAdjunto) {
        Adjunto adjunto = new Adjunto(fileItem);
        this.setAdjunto(adjunto);
        this.setContentType(fileItem.getContentType());
        this.setNombre(fileItem.getFileName());
        this.setLength(fileItem.getLength());
        this.setTipoAdjuntoEntidad(tipoAdjunto);
    }
    
    /**
     * @return the adjunto
     */
    public Adjunto getAdjunto() {
    	if(Checks.esNulo(adjunto)) {
    		return null;
    	}
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
     * @return the contrato
     */
    public Contrato getContrato() {
        return contrato;
    }

    /**
     * @param contrato the contrato to set
     */
    public void setContrato(Contrato contrato) {
        this.contrato = contrato;
    }
    
    public DDTipoAdjuntoEntidad getTipoAdjuntoEntidad() {
		return tipoAdjuntoEntidad;
	}

	public void setTipoAdjuntoEntidad(DDTipoAdjuntoEntidad tipoAdjuntoEntidad) {
		this.tipoAdjuntoEntidad = tipoAdjuntoEntidad;
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
	
	public Long getServicerId() {
		return servicerId;
	}
	
	public void setServicerId(Long servicerId) {
		this.servicerId = servicerId;
	}
	
	public Long getIdAdjuntoBlob() {
		return idAdjuntoBlob;
	}
	public void setIdAdjuntoBlob(Long idAdjuntoBlob) {
		this.idAdjuntoBlob = idAdjuntoBlob;
	}
}
