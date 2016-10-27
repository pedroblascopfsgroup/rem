package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
import es.pfsgroup.plugin.rem.model.dd.DDTipoDireccionProveedor;


/**
 * Modelo que gestiona la información de las delegaciones de contacto de los proveedores.
 */
@Entity
@Table(name = "ACT_PRD_PROVEEDOR_DIRECCION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoProveedorDireccion implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "PRD_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoProveedorDireccionGenerator")
    @SequenceGenerator(name = "ActivoProveedorDireccionGenerator", sequenceName = "S_ACT_PRD_PROVEEDOR_DIRECCION")
    private Long id;	

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID")
	private ActivoProveedor proveedor;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TDP_ID")
	private DDTipoDireccionProveedor tipoDireccion;
    
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TVI_ID")
    private DDTipoVia tipoVia; 
	
	@Column(name = "PRD_NOMBRE")
	private String nombreVia;

	@Column(name = "PRD_NUM")
	private Integer numeroVia;
	 
	@Column(name = "PRD_PTA")
	private Integer puerta;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_LOC_ID")
	private Localidad localidad;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provincia;
	
	@Column(name = "PRD_CP")
	private Integer codigoPostal;
	
	@Column(name = "PRD_TELEFONO")
	private String telefono;
	
	@Column(name = "PRD_EMAIL")
	private String email;
	
	@Column(name = "PRD_REFERENCIA")
	private Integer referencia;
	
	@Column(name = "PRD_LOCAL_ABIERTO_PUBLICO")
	private Integer localAbiertoPublico;

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

	public ActivoProveedor getProveedor() {
		return proveedor;
	}

	public void setProveedor(ActivoProveedor proveedor) {
		this.proveedor = proveedor;
	}

	public DDTipoDireccionProveedor  getTipoDireccion() {
		return tipoDireccion;
	}

	public void setTipoDireccion(DDTipoDireccionProveedor tipoDireccion) {
		this.tipoDireccion = tipoDireccion;
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

	public Integer getNumeroVia() {
		return numeroVia;
	}

	public void setNumeroVia(Integer numeroVia) {
		this.numeroVia = numeroVia;
	}

	public Integer getPuerta() {
		return puerta;
	}

	public void setPuerta(Integer puerta) {
		this.puerta = puerta;
	}

	public DDProvincia getProvincia() {
		return provincia;
	}

	public void setProvincia(DDProvincia provincia) {
		this.provincia = provincia;
	}

	public Integer getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(Integer codigoPostal) {
		this.codigoPostal = codigoPostal;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Integer getReferencia() {
		return referencia;
	}

	public void setReferencia(Integer referencia) {
		this.referencia = referencia;
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

	public Integer getLocalAbiertoPublico() {
		return localAbiertoPublico;
	}

	public void setLocalAbiertoPublico(Integer localAbiertoPublico) {
		this.localAbiertoPublico = localAbiertoPublico;
	}

	public Localidad getLocalidad() {
		return localidad;
	}

	public void setLocalidad(Localidad localidad) {
		this.localidad = localidad;
	}


	
	
}
