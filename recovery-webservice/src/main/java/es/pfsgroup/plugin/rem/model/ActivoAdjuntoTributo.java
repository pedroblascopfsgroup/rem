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

import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoTributos;



/**
 * Modelo que gestiona la informacion de los adjuntos de los gastos
 * 
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "ACT_ADT_ADJUNTO_TRIBUTOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ActivoAdjuntoTributo implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7785802535778510517L;

	@Id
    @Column(name = "ADT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoAdjuntoTributoGenerator")
    @SequenceGenerator(name = "ActivoAdjuntoTributoGenerator", sequenceName = "S_ACT_ADT_ADJUNTO_TRIBUTOS")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "ACT_TRI_ID")
    private ActivoTributos activoTributo;   	
	
	@ManyToOne
    @JoinColumn(name = "DD_TDT_ID")
    private DDTipoDocumentoTributos tipoDocumentoTributo;   

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

	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public ActivoTributos getActivoTributo() {
		return activoTributo;
	}

	public void setActivoTributo(ActivoTributos activoTributo) {
		this.activoTributo = activoTributo;
	}

	public DDTipoDocumentoTributos getTipoDocumentoTributo() {
		return tipoDocumentoTributo;
	}

	public void setTipoDocumentoTributo(DDTipoDocumentoTributos tipoDocumentoTributo) {
		this.tipoDocumentoTributo = tipoDocumentoTributo;
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
