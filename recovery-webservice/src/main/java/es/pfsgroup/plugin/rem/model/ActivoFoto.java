package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.math.BigDecimal;
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
import es.pfsgroup.plugin.rem.model.dd.DDTipoFoto;



/**
 * Modelo que gestiona la información de las fotos.
 * 
 * @author Anahuac de Vicente
 */
@Entity
@Table(name = "ACT_FOT_FOTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoFoto implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/**
     * Constructor
     */
	
    public ActivoFoto() {}

	public ActivoFoto(FileItem fileItem) {
        Adjunto adjunto = new Adjunto(fileItem);
        this.setAdjunto(adjunto);
        this.setNombre(fileItem.getFileName());
        this.setTamanyo(fileItem.getLength());
    }

	@Id
    @Column(name = "FOT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoFotoGenerator")
    @SequenceGenerator(name = "ActivoFotoGenerator", sequenceName = "S_ACT_FOT_FOTO")
    private Long id;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
    
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "AGR_ID")
	private ActivoAgrupacion agrupacion;
	
    @Column(name = "SDV_ID")
    private BigDecimal subdivision;
	
	@OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "ADJ_ID")
    private Adjunto adjunto; 
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TFO_ID")
    private DDTipoFoto tipoFoto;
	
    @Column(name = "FOT_NOMBRE")
    private String nombre;
    
	@Column(name = "FOT_LENGTH")
	private Long tamanyo;
	
	@Column(name = "FOT_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "FOT_FECHA_DOCUMENTO")
	private Date fechaDocumento;
	
	@Column(name = "FOT_PRINCIPAL")
	private Boolean principal;
	
	@Column(name = "FOT_INT_EXT")
	private Boolean interiorExterior;
	
	@Column(name = "FOT_VIDEO")
	private Boolean video;
	
	@Column(name = "FOT_PLANO")
	private Boolean plano;
	
	@Column(name = "FOT_ORDEN")
	private Integer orden;
	
	
	
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

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public ActivoAgrupacion getAgrupacion() {
		return agrupacion;
	}

	public void setAgrupacion(ActivoAgrupacion agrupacion) {
		this.agrupacion = agrupacion;
	}

	public BigDecimal getSubdivision() {
		return subdivision;
	}

	public void setSubdivision(BigDecimal subdivision) {
		this.subdivision = subdivision;
	}

	public Adjunto getAdjunto() {
		return adjunto;
	}

	public void setAdjunto(Adjunto adjunto) {
		this.adjunto = adjunto;
	}

	public DDTipoFoto getTipoFoto() {
		return tipoFoto;
	}

	public void setTipoFoto(DDTipoFoto tipoFoto) {
		this.tipoFoto = tipoFoto;
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

	public Boolean getPrincipal() {
		return principal;
	}

	public void setPrincipal(Boolean principal) {
		this.principal = principal;
	}

	public Boolean getInteriorExterior() {
		return interiorExterior;
	}

	public void setInteriorExterior(Boolean interiorExterior) {
		this.interiorExterior = interiorExterior;
	}

	public Boolean getVideo() {
		return video;
	}

	public void setVideo(Boolean video) {
		this.video = video;
	}

	public Boolean getPlano() {
		return plano;
	}

	public void setPlano(Boolean plano) {
		this.plano = plano;
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
	
	
	
}
