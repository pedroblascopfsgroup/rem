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



/**
 * Modelo que gestiona la información de las fotos.
 * 
 * @author Anahuac de Vicente
 */
@Entity
@Table(name = "ACT_FTR_FOTO_TRABAJO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class TrabajoFoto implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/**
     * Constructor
     */
	
    public TrabajoFoto() {}

	public TrabajoFoto(FileItem fileItem) {
        Adjunto adjunto = new Adjunto(fileItem);
        this.setAdjunto(adjunto);
        this.setNombre(fileItem.getFileName());
        this.setTamanyo(fileItem.getLength());
    }

	@Id
    @Column(name = "FTR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TrabajoFotoGenerator")
    @SequenceGenerator(name = "TrabajoFotoGenerator", sequenceName = "S_ACT_FTR_FOTO_TRABAJO")
    private Long id;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TBJ_ID")
    private Trabajo trabajo;
	
	@OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "ADJ_ID")
    private Adjunto adjunto; 
	
    @Column(name = "FTR_NOMBRE")
    private String nombre;
    
	@Column(name = "FTR_LENGTH")
	private Long tamanyo;
	
	@Column(name = "FTR_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "FTR_FECHA_DOCUMENTO")
	private Date fechaDocumento;
	
	@Column(name="FTR_ORDEN")
	private Integer orden;
	
	@Column(name = "FTR_SOLICITANTE_PROVEEDOR")
	private Boolean solicitanteProveedor;
	
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

	public Trabajo getTrabajo() {
		return trabajo;
	}

	public void setTrabajo(Trabajo trabajo) {
		this.trabajo = trabajo;
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

	public Boolean getSolicitanteProveedor() {
		return solicitanteProveedor;
	}

	public void setSolicitanteProveedor(Boolean solicitanteProveedor) {
		this.solicitanteProveedor = solicitanteProveedor;
	}
	
	
	
}
