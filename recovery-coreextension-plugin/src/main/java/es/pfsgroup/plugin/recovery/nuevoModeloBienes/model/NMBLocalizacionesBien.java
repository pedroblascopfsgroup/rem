package es.pfsgroup.plugin.recovery.nuevoModeloBienes.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBLocalizacionesBienInfo;

@Entity
@Table(name = "BIE_LOCALIZACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class NMBLocalizacionesBien implements Serializable, Auditable, NMBLocalizacionesBienInfo{

	private static final long serialVersionUID = -3290771629640906608L;

	@Id
    @Column(name = "BIE_LOC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "NMBLocalizacionesBienGenerator")
    @SequenceGenerator(name = "NMBLocalizacionesBienGenerator", sequenceName = "S_BIE_LOCALIZACION")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "BIE_ID")
	private NMBBien bien;
	
	@Column(name = "BIE_LOC_POBLACION")
    private String poblacion;
	
	@Column(name = "BIE_LOC_DIRECCION")
    private String direccion;
	
	@Column(name = "BIE_LOC_COD_POST")
    private String codPostal;
	
	@OneToOne
    @JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provincia;
	
	@Embedded
    private Auditoria auditoria;
	
	@OneToOne
	@JoinColumn(name = "DD_TVI_ID")
	private DDTipoVia tipoVia;
	
	@Column(name = "BIE_LOC_NOMBRE_VIA")
	private String nombreVia;
	
	@Column(name = "BIE_LOC_NUMERO_DOMICILIO")
	private String numeroDomicilio;
	
	@Column(name = "BIE_LOC_PORTAL")
	private String portal;
	
	@Column(name = "BIE_LOC_BLOQUE")
	private String bloque;
	
	@Column(name = "BIE_LOC_ESCALERA")
	private String escalera;
	
	@Column(name = "BIE_LOC_PISO")
	private String piso;

	@Column(name = "BIE_LOC_PUERTA")
	private String puerta;
	
	@Column(name = "BIE_LOC_BARRIO")
	private String barrio;
	
	@OneToOne
	@JoinColumn(name = "DD_CIC_ID")
	private DDCicCodigoIsoCirbeBKP pais;
	
	@OneToOne
	@JoinColumn(name = "DD_LOC_ID")
	private Localidad localidad;
	
	@OneToOne
	@JoinColumn(name = "DD_UPO_ID")
	private DDUnidadPoblacional unidadPoblacional;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public NMBBien getBien() {
		return bien;
	}

	public void setBien(NMBBien bien) {
		this.bien = bien;
	}

	public String getPoblacion() {
		return poblacion;
	}

	public void setPoblacion(String poblacion) {
		this.poblacion = poblacion;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getCodPostal() {
		return codPostal;
	}

	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public DDProvincia getProvincia() {
		return provincia;
	}

	public void setProvincia(DDProvincia provincia) {
		this.provincia = provincia;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public DDTipoVia getTipoVia() {
		return tipoVia;
	}

	public void setTipoVia(DDTipoVia tipoVia) {
		this.tipoVia = tipoVia;
	}

	public String getNombreVia() {
		return nombreVia;
	}

	public void setNombreVia(String nombreVia) {
		this.nombreVia = nombreVia;
	}

	public String getNumeroDomicilio() {
		return numeroDomicilio;
	}

	public void setNumeroDomicilio(String numeroDomicilio) {
		this.numeroDomicilio = numeroDomicilio;
	}

	public String getPortal() {
		return portal;
	}

	public void setPortal(String portal) {
		this.portal = portal;
	}

	public String getBloque() {
		return bloque;
	}

	public void setBloque(String bloque) {
		this.bloque = bloque;
	}

	public String getEscalera() {
		return escalera;
	}

	public void setEscalera(String escalera) {
		this.escalera = escalera;
	}

	public String getPiso() {
		return piso;
	}

	public void setPiso(String piso) {
		this.piso = piso;
	}

	public String getPuerta() {
		return puerta;
	}

	public void setPuerta(String puerta) {
		this.puerta = puerta;
	}

	public String getBarrio() {
		return barrio;
	}

	public void setBarrio(String barrio) {
		this.barrio = barrio;
	}

	public DDCicCodigoIsoCirbeBKP getPais() {
		return pais;
	}

	public void setPais(DDCicCodigoIsoCirbeBKP pais) {
		this.pais = pais;
	}

	public Localidad getLocalidad() {
		return localidad;
	}

	public void setLocalidad(Localidad localidad) {
		this.localidad = localidad;
	}
	
	public DDUnidadPoblacional getUnidadPoblacional() {
		return unidadPoblacional;
	}

	public void setUnidadPoblacional(DDUnidadPoblacional unidadPoblacional) {
		this.unidadPoblacional = unidadPoblacional;
	}
	
}
