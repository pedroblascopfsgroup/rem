package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocPlusvalias;


/**
 * Modelo que gestiona los ficheros adjuntos plusvalia.
 *  
 * @author Julian Dolz
 *
 */
@Entity
@Table(name = "ACT_ADP_ADJUNTO_PLUSVALIAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class AdjuntoPlusvalias implements Serializable, Auditable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	
	@Id
    @Column(name = "ADP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AdjuntoPlusvaliasGenerator")
    @SequenceGenerator(name = "AdjuntoPlusvaliasGenerator", sequenceName = "S_ACT_ADP_ADJUNTO_PLUSVALIAS")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "PLS_ID")
    private ActivoPlusvalia plusvalia;
    
	@ManyToOne
	@JoinColumn(name = "DD_TDU_ID")
	private DDTipoDocPlusvalias tipoDocPlusvalias;
    
	@ManyToOne
	@JoinColumn(name = "ADJ_ID")
	private Adjunto adjunto;

	@Column(name = "ADP_NOMBRE")
	private String nombre;
	
    @Column(name = "ADP_CONTENT_TYPE")
	private String contentType;
    
    @Column(name = "ADP_LENGTH")
	private Long tamanyo;
    
    @Column(name = "ADP_DESCRIPCION")
	private String descripcion;
    
    @Column(name = "ADP_FECHA_DOCUMENTO")
	private Date fechaDocumento;
    
    @Column(name = "ADP_ID_DOCUMENTO_REST")
	private Long documentoRest;
	
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

	public ActivoPlusvalia getPlusvalia() {
		return plusvalia;
	}

	public void setPlusvalia(ActivoPlusvalia plusvalia) {
		this.plusvalia = plusvalia;
	}

	public DDTipoDocPlusvalias getTipoDocPlusvalias() {
		return tipoDocPlusvalias;
	}

	public void setTipoDocPlusvalias(DDTipoDocPlusvalias tipoDocPlusvalias) {
		this.tipoDocPlusvalias = tipoDocPlusvalias;
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

	public Long getDocumentoRest() {
		return documentoRest;
	}

	public void setDocumentoRest(Long documentoRest) {
		this.documentoRest = documentoRest;
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
