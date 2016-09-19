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
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumentoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoProveedor;



/**
 * Modelo que gestiona la informacion de los adjuntos de los proveedores
 * 
 * @author Daniel Gutiérrez
 *
 */
@Entity
@Table(name = "ACT_APR_ADJUNTO_PROVEEDOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ActivoAdjuntoProveedor implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7785802535778510517L;

	@Id
    @Column(name = "APR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoAdjuntoProveedorGenerator")
    @SequenceGenerator(name = "ActivoAdjuntoProveedorGenerator", sequenceName = "S_ACT_APR_ADJUNTO_PROVEEDOR")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "PVE_ID")
    private ActivoProveedor proveedor;   	
	
	@ManyToOne
    @JoinColumn(name = "DD_TDP_ID")
    private DDTipoDocumentoProveedor tipoDocumentoProveedor;   

    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "ADJ_ID")
    private Adjunto adjunto;  
	
	@Column(name = "APR_NOMBRE")
	private String nombre;
	
	@Column(name = "APR_CONTENT_TYPE")
	private String contentType;
	
	@Column(name = "APR_LENGTH")
	private Long tamanyo;
	
	@Column(name = "APR_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "APR_FECHA_DOCUMENTO")
	private Date fechaDocumento;
	
	@OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
	@JoinColumn(name = "DD_EDP_ID")
	private DDEstadoDocumentoProveedor estadoDocumentoProveedor;
	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

	
    /**
     * Constructor.
     */
    public ActivoAdjuntoProveedor() {}
    
    /**
     * Constructor.
     * @param fileItem FileItem
     */
    public ActivoAdjuntoProveedor(FileItem fileItem) {
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

	public ActivoProveedor getProveedor() {
		return proveedor;
	}

	public void setProveedor(ActivoProveedor proveedor) {
		this.proveedor = proveedor;
	}

	public DDTipoDocumentoProveedor getTipoDocumentoProveedor() {
		return tipoDocumentoProveedor;
	}

	public void setTipoDocumentoProveedor(DDTipoDocumentoProveedor tipoDocumentoProveedor) {
		this.tipoDocumentoProveedor = tipoDocumentoProveedor;
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
