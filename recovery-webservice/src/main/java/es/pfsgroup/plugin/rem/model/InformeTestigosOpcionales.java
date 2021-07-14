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

	@Column(name = "TOP_ID_INFORME_SF")
	private String informesMediadores;
	
	@ManyToOne
    @JoinColumn(name = "DD_FTE_ID")
    private DDFuenteTestigos fuenteTestigos;   

	@Column(name = "TOP_PRECIO")
	private Float precio;
	
	@Column(name = "TOP_PRECIO_MERCADO")
	private Float precioMercado;
	
	@Column(name = "TOP_SUPERCIE")
	private Float superficie;
	
	@ManyToOne
	@JoinColumn(name = "DD_TPA_ID")
	private DDTipoActivo tipoActivo;
	
	@Column(name = "TOP_LINK")
	private String link;
	
	@Column(name = "TOP_DIRECCION")
	private String direccion;
	
	@Column(name = "TOP_ID_TESTIGO_SF")
	private String idTestigoSF;
	
	@Column(name = "TOP_NOMBRE")
	private String nombre;
	
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

	public String getInformesMediadores() {
		return informesMediadores;
	}

	public void setInformesMediadores(String informesMediadores) {
		this.informesMediadores = informesMediadores;
	}

	public DDFuenteTestigos getFuenteTestigos() {
		return fuenteTestigos;
	}

	public void setFuenteTestigos(DDFuenteTestigos fuenteTestigos) {
		this.fuenteTestigos = fuenteTestigos;
	}

	public Float getPrecio() {
		return precio;
	}

	public void setPrecio(Float precio) {
		this.precio = precio;
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

	public String getLink() {
		return link;
	}

	public void setLink(String link) {
		this.link = link;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getIdTestigoSF() {
		return idTestigoSF;
	}

	public void setIdTestigoSF(String idTestigoSF) {
		this.idTestigoSF = idTestigoSF;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}


}
