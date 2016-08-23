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
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoZonaGeografica;
import es.pfsgroup.plugin.rem.model.dd.DDTiposColaborador;



/**
 * Modelo que gestiona la informacion de los proveedores de los activos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_PVE_PROVEEDOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoProveedor implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "PVE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoProveedorGenerator")
    @SequenceGenerator(name = "ActivoProveedorGenerator", sequenceName = "S_ACT_PVE_PROVEEDOR")
    private Long id;	
/*    
    @OneToOne
    @JoinColumn(name = "USU_ID")
    private Usuario usuario;*/
    
    @ManyToOne
    @JoinColumn(name = "DD_TPR_ID")
    private DDTipoProveedor tipoProveedor; 
    
    @ManyToOne
    @JoinColumn(name = "DD_TPC_ID")
    private DDTiposColaborador tipoColaborador; 

    @Column(name = "PVE_COD_UVEM")
	private String codProveedorUvem;
	 
    @Column(name = "PVE_NOMBRE")
	private String nombre;
	 
	@Column(name = "PVE_NOMBRE_COMERCIAL")
	private String nombreComercial;

	@ManyToOne
    @JoinColumn(name = "DD_TDI_ID")
    private DDTipoDocumento tipoDocIdentificativo; 
	
	@Column(name = "PVE_DOCIDENTIF")
	private String docIdentificativo;
	
	@ManyToOne
    @JoinColumn(name = "DD_ZNG_ID")
    private DDTipoZonaGeografica zonaGeografica; 
	
	@ManyToOne
    @JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provincia;
	
	@ManyToOne
	@JoinColumn(name = "DD_LOC_ID")
	private Localidad localidad;

	@Column(name = "PVE_CP")
	private Integer codigoPostal;
	
	@Column(name = "PVE_DIRECCION")
	private String direccion;
	
	@Column(name = "PVE_TELF1")
	private String telefono1;
	
	@Column(name = "PVE_TELF2")
	private String telefono2;
	
	@Column(name = "PVE_FAX")
	private String fax;

	@Column(name = "PVE_EMAIL")
	private String email;
	
	@Column(name = "PVE_PAGINA_WEB")
	private String paginaWeb;
	
	
	@Column(name = "PVE_FRANQUICIA")
	private Float franquicia;

	@Column(name = "PVE_IVA_CAJA")
	private Integer ivaCaja;

	@Column(name = "PVE_NUM_CUENTA")
	private String numCuenta;

	
	
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

/*	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}
*/
	public DDTipoProveedor getTipoProveedor() {
		return tipoProveedor;
	}

	public void setTipoProveedor(DDTipoProveedor tipoProveedor) {
		this.tipoProveedor = tipoProveedor;
	}

	public DDTiposColaborador getTipoColaborador() {
		return tipoColaborador;
	}

	public void setTipoColaborador(DDTiposColaborador tipoColaborador) {
		this.tipoColaborador = tipoColaborador;
	}

	public String getCodProveedorUvem() {
		return codProveedorUvem;
	}

	public void setCodProveedorUvem(String codProveedorUvem) {
		this.codProveedorUvem = codProveedorUvem;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getNombreComercial() {
		return nombreComercial;
	}

	public void setNombreComercial(String nombreComercial) {
		this.nombreComercial = nombreComercial;
	}

	public DDTipoDocumento getTipoDocIdentificativo() {
		return tipoDocIdentificativo;
	}

	public void setTipoDocIdentificativo(
			DDTipoDocumento tipoDocIdentificativo) {
		this.tipoDocIdentificativo = tipoDocIdentificativo;
	}

	public String getDocIdentificativo() {
		return docIdentificativo;
	}

	public void setDocIdentificativo(String docIdentificativo) {
		this.docIdentificativo = docIdentificativo;
	}

	public DDTipoZonaGeografica getZonaGeografica() {
		return zonaGeografica;
	}

	public void setZonaGeografica(DDTipoZonaGeografica zonaGeografica) {
		this.zonaGeografica = zonaGeografica;
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

	public Integer getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(Integer codigoPostal) {
		this.codigoPostal = codigoPostal;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getTelefono1() {
		return telefono1;
	}

	public void setTelefono1(String telefono1) {
		this.telefono1 = telefono1;
	}

	public String getTelefono2() {
		return telefono2;
	}

	public void setTelefono2(String telefono2) {
		this.telefono2 = telefono2;
	}

	public String getFax() {
		return fax;
	}

	public void setFax(String fax) {
		this.fax = fax;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPaginaWeb() {
		return paginaWeb;
	}

	public void setPaginaWeb(String paginaWeb) {
		this.paginaWeb = paginaWeb;
	}

	public Float getFranquicia() {
		return franquicia;
	}

	public void setFranquicia(Float franquicia) {
		this.franquicia = franquicia;
	}

	public Integer getIvaCaja() {
		return ivaCaja;
	}

	public void setIvaCaja(Integer ivaCaja) {
		this.ivaCaja = ivaCaja;
	}

	public String getNumCuenta() {
		return numCuenta;
	}

	public void setNumCuenta(String numCuenta) {
		this.numCuenta = numCuenta;
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
