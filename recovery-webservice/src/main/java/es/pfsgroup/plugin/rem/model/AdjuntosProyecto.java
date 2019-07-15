package es.pfsgroup.plugin.rem.model;

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
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoProyecto;


/**
 * Modelo que gestiona la informacion de los adjuntos de los activos de agrupaciones de tipo proyecto
 * 
 * @author Miguel Ángel Ávila Sánchez
 *
 */
@Entity
@Table(name = "ACT_ADY_ADJUNTO_PROYECTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

public class AdjuntosProyecto implements Serializable, Auditable { 


	/**
	 * 
	 */
	private static final long serialVersionUID = -1948402390502821307L;

	@Id
    @Column(name = "ADY_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AdjuntoProyectoGenerator")
    @SequenceGenerator(name = "AdjuntoProyectoGenerator", sequenceName = "S_ACT_ADY_ADJUNTO_PROYECTO")
    private Long id;
	
	@OneToOne
    @JoinColumn(name = "AGR_ID")
    private ActivoAgrupacion agrupacion;
	
	@ManyToOne
    @JoinColumn(name = "ACT_ID")
    private Activo activo;   	
	
	@ManyToOne
    @JoinColumn(name = "DD_TDY_ID")
    private DDTipoDocumentoProyecto tipoDocumentoProyecto;
	
	@ManyToOne
    @JoinColumn(name = "ADJ_ID")
    private Adjunto adjunto;
	
	@Column(name = "ADY_ID_DOCUMENTO_REST")
	private Long idDocRest;
	
	@Column(name = "ADY_NOMBRE")
	private String nombre;
	
	@Column(name = "ADY_CONTENT_TYPE")
	private String contentType;
	
	@Column(name = "ADY_LENGTH")
	private Long tamanyo;
	
	@Column(name = "ADY_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "ADY_FECHA_DOCUMENTO")
	private Date fechaDocumento;
	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;
	
	
    /**
     * Constructor.
     */
    public AdjuntosProyecto() {}
    
    /**
     * Constructor.
     * @param fileItem FileItem
     */
    public AdjuntosProyecto(FileItem fileItem) {
        Adjunto adjuntoProyecto = new Adjunto(fileItem);
        this.setAdjunto(adjuntoProyecto);
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


	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public DDTipoDocumentoProyecto getTipoDocumentoProyecto() {
		return tipoDocumentoProyecto;
	}

	public void setTipoDocumentoProyecto(DDTipoDocumentoProyecto tipoDocumentoProyecto) {
		this.tipoDocumentoProyecto = tipoDocumentoProyecto;
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

	public Long getIdDocRest() {
		return idDocRest;
	}

	public void setIdDocRest(Long idDocRest) {
		this.idDocRest = idDocRest;
	}

	public ActivoAgrupacion getAgrupacion() {
		return agrupacion;
	}

	public void setAgrupacion(ActivoAgrupacion agrupacion) {
		this.agrupacion = agrupacion;
	}
	
	

}
