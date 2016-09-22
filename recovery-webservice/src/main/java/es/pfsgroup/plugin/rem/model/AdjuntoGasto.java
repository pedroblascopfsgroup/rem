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
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoGasto;



/**
 * Modelo que gestiona la informacion de los adjuntos de los gastos
 * 
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "ADG_ADJUNTOS_GASTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class AdjuntoGasto implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7785802535778510517L;

	@Id
    @Column(name = "ADG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AdjuntoGastoGenerator")
    @SequenceGenerator(name = "AdjuntoGastoGenerator", sequenceName = "S_ADG_ADJUNTOS_GASTO")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "GPV_ID")
    private GastoProveedor gastoProveedor;   	
	
	@ManyToOne
    @JoinColumn(name = "DD_TPD_ID")
    private DDTipoDocumentoGasto tipoDocumentoGasto;   

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

	
    /**
     * Constructor.
     */
    public AdjuntoGasto() {}
    
    /**
     * Constructor.
     * @param fileItem FileItem
     */
    public AdjuntoGasto(FileItem fileItem) {
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


	public GastoProveedor getGastoProveedor() {
		return gastoProveedor;
	}

	public void setGastoProveedor(GastoProveedor gastoProveedor) {
		this.gastoProveedor = gastoProveedor;
	}

	public DDTipoDocumentoGasto getTipoDocumentoGasto() {
		return tipoDocumentoGasto;
	}

	public void setTipoDocumentoGasto(DDTipoDocumentoGasto tipoDocumentoGasto) {
		this.tipoDocumentoGasto = tipoDocumentoGasto;
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

	public Long getIdDocRestClient() {
		return idDocRestClient;
	}

	public void setIdDocRestClient(Long idDocRestClient) {
		this.idDocRestClient = idDocRestClient;
	}

}
