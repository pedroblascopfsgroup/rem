package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

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
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDCargoProveedorContacto;



/**
 * Modelo que gestiona la información de las personas de contacto de los proveedores.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_PVC_PROVEEDOR_CONTACTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoProveedorContacto implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "PVC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoProveedorContactoGenerator")
    @SequenceGenerator(name = "ActivoProveedorContactoGenerator", sequenceName = "S_ACT_PVC_PROVEEDOR_CONTACTO")
    private Long id;	

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID")
	private ActivoProveedor proveedor;
	
	@ManyToOne
	@JoinColumn(name = "USU_ID")
	private Usuario usuario;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provincia;
    
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TDI_ID")
    private DDTipoDocumento tipoDocIdentificativo; 
	
	@Column(name = "PVC_DOCIDENTIF")
	private String docIdentificativo;

	@Column(name = "PVC_NOMBRE")
	private String nombre;
	 
	@Column(name = "PVC_APELLID01")
	private String apellido1;

	@Column(name = "PVC_APELLID02")
	private String apellido2;

	@Column(name = "PVC_CP")
	private Integer codigoPostal;
	
	@Column(name = "PVC_DIRECCION")
	private String direccion;
	
	@Column(name = "PVC_TELF1")
	private String telefono1;
	
	@Column(name = "PVC_TELF2")
	private String telefono2;
	
	@Column(name = "PVC_FAX")
	private String fax;

	@Column(name = "PVC_EMAIL")
	private String email;
	
	@Column(name = "PVC_PRINCIPAL")
	private Integer principal;
	
	@ManyToOne
	@JoinColumn(name = "DD_CPC_ID")
	private DDCargoProveedorContacto cargoProveedorContacto;
    
	@Column(name = "PVC_CARGO")
	private String cargo;
	
	@Column(name = "PVC_FECHA_ALTA")
	private Date fechaAlta;
	
	@Column(name = "PVC_FECHA_BAJA")
	private Date fechaBaja;
	
	@Column(name = "PVC_OBSERVACIONES")
	private String observaciones;

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
	public DDProvincia getProvincia() {
		return provincia;
	}
	public void setProvincia(DDProvincia provincia) {
		this.provincia = provincia;
	}
	public DDTipoDocumento getTipoDocIdentificativo() {
		return tipoDocIdentificativo;
	}
	public void setTipoDocIdentificativo(DDTipoDocumento tipoDocIdentificativo) {
		this.tipoDocIdentificativo = tipoDocIdentificativo;
	}
	public String getDocIdentificativo() {
		return docIdentificativo;
	}
	public void setDocIdentificativo(String docIdentificativo) {
		this.docIdentificativo = docIdentificativo;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getApellido1() {
		return apellido1;
	}
	public void setApellido1(String apellido1) {
		this.apellido1 = apellido1;
	}
	public String getApellido2() {
		return apellido2;
	}
	public void setApellido2(String apellido2) {
		this.apellido2 = apellido2;
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
	
	public Usuario getUsuario(){
		return usuario;
	}
	
	public void setUsuario(Usuario usuario){
		this.usuario = usuario;
	}
	
    /**
     * getApellidoNombre.
     * @return getApellidoNombre
     */
    public String getApellidoNombre() {
        
        return usuario.getApellidoNombre();
    }
    
    public Integer getPrincipal() {
		return principal;
	}

	public void setPrincipal(Integer principal) {
		this.principal = principal;
	}

	public DDCargoProveedorContacto getCargoProveedorContacto() {
		return cargoProveedorContacto;
	}

	public void setCargoProveedorContacto(
			DDCargoProveedorContacto cargoProveedorContacto) {
		this.cargoProveedorContacto = cargoProveedorContacto;
	}

	public String getCargo() {
		return cargo;
	}

	public void setCargo(String cargo) {
		this.cargo = cargo;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Date getFechaBaja() {
		return fechaBaja;
	}

	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
	
}
