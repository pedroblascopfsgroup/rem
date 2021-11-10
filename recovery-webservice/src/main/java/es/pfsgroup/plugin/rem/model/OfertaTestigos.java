package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;



/**
 * Modelo que gestiona la informacion de los testigos de las ofertas
 * 
 * @author Ivan Repiso
 *
 */
@Entity
@Table(name = "OFR_TES_TESTIGOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class OfertaTestigos implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6913655175961185833L;

	@Id
    @Column(name = "TES_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "OfertaTestigosGenerator")
    @SequenceGenerator(name = "OfertaTestigosGenerator", sequenceName = "S_OFR_TES_TESTIGOS")
    private Long id;

	@ManyToOne
    @JoinColumn(name = "OFR_ID")
    private Oferta oferta;   
	
	@ManyToOne
    @JoinColumn(name = "DD_FTE_ID")
    private DDFuenteTestigos fuenteTestigos;   

	@Column(name = "TES_EUROS_METRO")
	private String eurosMetro;
	
	@Column(name = "TES_PRECIO_MERCADO")
	private Double precioMercado;
	
	@Column(name = "TES_SUPERCIE")
	private Double superficie;
	
	@ManyToOne
	@JoinColumn(name = "DD_TPA_ID")
	private DDTipoActivo tipoActivo;
	
	@Column(name = "TES_ENLACE")
	private String enlace;
	
	@Column(name = "TES_DIRECCION")
	private String direccion;
	
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

	public Oferta getOferta() {
		return oferta;
	}

	public void setOferta(Oferta oferta) {
		this.oferta = oferta;
	}

	public DDFuenteTestigos getFuenteTestigos() {
		return fuenteTestigos;
	}

	public void setFuenteTestigos(DDFuenteTestigos fuenteTestigos) {
		this.fuenteTestigos = fuenteTestigos;
	}

	public String getEurosMetro() {
		return eurosMetro;
	}

	public void setEurosMetro(String eurosMetro) {
		this.eurosMetro = eurosMetro;
	}

	public Double getPrecioMercado() {
		return precioMercado;
	}

	public void setPrecioMercado(Double precioMercado) {
		this.precioMercado = precioMercado;
	}

	public Double getSuperficie() {
		return superficie;
	}

	public void setSuperficie(Double superficie) {
		this.superficie = superficie;
	}

	public DDTipoActivo getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(DDTipoActivo tipoActivo) {
		this.tipoActivo = tipoActivo;
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