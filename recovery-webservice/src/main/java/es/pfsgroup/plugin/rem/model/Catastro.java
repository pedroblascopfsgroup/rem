package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;



/**
 * Modelo que gestiona la informacion del catastro general
 * 
 * @author Lara Pablo
 *
 */
@Entity
@Table(name = "CAT_CATASTRO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class Catastro implements Serializable, Auditable {


	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "CAT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CatastroGenerator")
    @SequenceGenerator(name = "CatastroGenerator", sequenceName = "S_CAT_CATASTRO")
    private Long id;

	@Column(name = "CAT_REF_CATASTRAL")
	private String refCatastral;
	
	@Column(name = "CAT_SUPERFICIE_PARCELA")
	private Double superficieParcela;
	
	@Column(name = "CAT_SUPERFICIE_CONSTRUIDA")
	private Double superficieConstruida;
	
	@Column(name = "CAT_SUPERFICIE_ZONAS_COMUNES")
	private Double superficieZonasComunes;
	
	@Column(name = "CAT_ANYO_CONSTRUCCION")
	private Integer anyoConstrucción;
	
	@Column(name = "CAT_COD_POSTAL")
	private String codPostal;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TVI_ID")
	private DDTipoVia tipoVia;
	
	@Column(name = "CAT_DESCRIPCION_VIA")
	private String descripcionVia;
	
	@Column(name = "CAT_NUM_VIA")
	private String numeroVia;
	
	@Column(name = "CAT_PISO")
	private String piso;
	
	@Column(name = "CAT_PLANTA")
	private String planta;
	
	@Column(name = "CAT_PUERTA")
	private String puerta;
	
	@Column(name = "CAT_ESCALERA")
	private String escalera;
	
	@Column(name = "CAT_CLASE")
	private String clase;
	
	@Column(name = "CAT_USO_PRINCIPAL")
	private String usoPrincipal;
	
	@Column(name = "CAT_DIV_HORIZONTAL")
	private Boolean divisionHorizontal;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_PRV_ID")
	private DDProvincia provincia;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_LOC_ID")
	private Localidad localidad;
	
	@Column(name = "CAT_LATITUD")
	private BigDecimal latitud;
	
	@Column(name = "CAT_LONGITUD")
	private BigDecimal longitud;
	
	@Column(name = "CAT_GEODISTANCIA")
	private BigDecimal geodistancia;

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

	public String getRefCatastral() {
		return refCatastral;
	}

	public void setRefCatastral(String refCatastral) {
		this.refCatastral = refCatastral;
	}

	public Double getSuperficieParcela() {
		return superficieParcela;
	}

	public void setSuperficieParcela(Double superficieParcela) {
		this.superficieParcela = superficieParcela;
	}

	public Double getSuperficieConstruida() {
		return superficieConstruida;
	}

	public void setSuperficieConstruida(Double superficieConstruida) {
		this.superficieConstruida = superficieConstruida;
	}

	public Double getSuperficieZonasComunes() {
		return superficieZonasComunes;
	}

	public void setSuperficieZonasComunes(Double superficieZonasComunes) {
		this.superficieZonasComunes = superficieZonasComunes;
	}

	public Integer getAnyoConstrucción() {
		return anyoConstrucción;
	}

	public void setAnyoConstrucción(Integer anyoConstrucción) {
		this.anyoConstrucción = anyoConstrucción;
	}

	public String getCodPostal() {
		return codPostal;
	}

	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
	}

	public DDTipoVia getTipoVia() {
		return tipoVia;
	}

	public void setTipoVia(DDTipoVia tipoVia) {
		this.tipoVia = tipoVia;
	}

	public String getDescripcionVia() {
		return descripcionVia;
	}

	public void setDescripcionVia(String descripcionVia) {
		this.descripcionVia = descripcionVia;
	}

	public String getNumeroVia() {
		return numeroVia;
	}

	public void setNumeroVia(String numeroVia) {
		this.numeroVia = numeroVia;
	}

	public String getPiso() {
		return piso;
	}

	public void setPiso(String piso) {
		this.piso = piso;
	}

	public String getPlanta() {
		return planta;
	}

	public void setPlanta(String planta) {
		this.planta = planta;
	}

	public String getPuerta() {
		return puerta;
	}

	public void setPuerta(String puerta) {
		this.puerta = puerta;
	}

	public String getEscalera() {
		return escalera;
	}

	public void setEscalera(String escalera) {
		this.escalera = escalera;
	}

	public String getClase() {
		return clase;
	}

	public void setClase(String clase) {
		this.clase = clase;
	}

	public String getUsoPrincipal() {
		return usoPrincipal;
	}

	public void setUsoPrincipal(String usoPrincipal) {
		this.usoPrincipal = usoPrincipal;
	}

	public Boolean getDivisionHorizontal() {
		return divisionHorizontal;
	}

	public void setDivisionHorizontal(Boolean divisionHorizontal) {
		this.divisionHorizontal = divisionHorizontal;
	}

	public DDProvincia getProvincia() {
		return provincia;
	}

	public void setProvincia(DDProvincia provincia) {
		this.provincia = provincia;
	}

	public Localidad getLocalidad() {
		return localidad;
	}

	public void setLocalidad(Localidad localidad) {
		this.localidad = localidad;
	}

	public BigDecimal getLatitud() {
		return latitud;
	}

	public void setLatitud(BigDecimal latitud) {
		this.latitud = latitud;
	}

	public BigDecimal getLongitud() {
		return longitud;
	}

	public void setLongitud(BigDecimal longitud) {
		this.longitud = longitud;
	}

	public BigDecimal getGeodistancia() {
		return geodistancia;
	}

	public void setGeodistancia(BigDecimal geodistancia) {
		this.geodistancia = geodistancia;
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
