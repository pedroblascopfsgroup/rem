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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDFuenteTestigos;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;



/**
 * Modelo que gestiona la informacion de los testigos opcionales de informe comercial
 * 
 * @author Ivan Repiso
 *
 */
@Entity
@Table(name = "ICO_TOP_TESTIGOS_OPCIONALES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class InformeTestigosOpcionales implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6913655175961185833L;

	@Id
    @Column(name = "TOP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "InformeTestigosOpcionalesGenerator")
    @SequenceGenerator(name = "InformeTestigosOpcionalesGenerator", sequenceName = "S_ICO_TOP_TESTIGOS_OPCIONALES")
    private Long id;

	@ManyToOne
    @JoinColumn(name = "ICO_ID")
    private ActivoInfoComercial infoComercial;   
	
	@ManyToOne
    @JoinColumn(name = "DD_FTE_ID")
    private DDFuenteTestigos fuenteTestigos;   

	@Column(name = "TOP_EUROS_METRO")
	private Float eurosPorMetro;
	
	@Column(name = "TOP_PRECIO_MERCADO")
	private Float precioMercado;
	
	@Column(name = "TOP_SUPERCIE")
	private Float superficie;
	
	@ManyToOne
	@JoinColumn(name = "DD_TPA_ID")
	private DDTipoActivo tipoActivo;
	
	@ManyToOne
	@JoinColumn(name = "DD_SAC_ID")
	private DDSubtipoActivo subtipoActivo;
	
	@Column(name = "TOP_ENLACE")
	private String enlace;
	
	@Column(name = "TOP_DIRECCION")
	private String direccion;
	
	@Column(name = "TOP_LATITUD")
	private Float lat;
	
	@Column(name = "TOP_LONGITUD")
	private Float lng;
	
	@Column(name = "TOP_FECHA_TRANSACCION")
	private Date fechaTransaccionPublicacion;
	
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

	public ActivoInfoComercial getInfoComercial() {
		return infoComercial;
	}

	public void setInfoComercial(ActivoInfoComercial infoComercial) {
		this.infoComercial = infoComercial;
	}

	public DDFuenteTestigos getFuenteTestigos() {
		return fuenteTestigos;
	}

	public void setFuenteTestigos(DDFuenteTestigos fuenteTestigos) {
		this.fuenteTestigos = fuenteTestigos;
	}

	public Float getEurosPorMetro() {
		return eurosPorMetro;
	}

	public void setEurosPorMetro(Float eurosPorMetro) {
		this.eurosPorMetro = eurosPorMetro;
	}

	public Float getPrecioMercado() {
		return precioMercado;
	}

	public void setPrecioMercado(Float precioMercado) {
		this.precioMercado = precioMercado;
	}

	public Float getSuperficie() {
		return superficie;
	}

	public void setSuperficie(Float superficie) {
		this.superficie = superficie;
	}

	public DDTipoActivo getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(DDTipoActivo tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public DDSubtipoActivo getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(DDSubtipoActivo subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}

	public String getEnlace() {
		return enlace;
	}

	public void setEnlace(String enlace) {
		this.enlace = enlace;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public Float getLat() {
		return lat;
	}

	public void setLat(Float lat) {
		this.lat = lat;
	}

	public Float getLng() {
		return lng;
	}

	public void setLng(Float lng) {
		this.lng = lng;
	}

	public Date getFechaTransaccionPublicacion() {
		return fechaTransaccionPublicacion;
	}

	public void setFechaTransaccionPublicacion(Date fechaTransaccionPublicacion) {
		this.fechaTransaccionPublicacion = fechaTransaccionPublicacion;
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
