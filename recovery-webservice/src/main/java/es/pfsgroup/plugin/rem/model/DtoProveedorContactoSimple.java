package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.pfsgroup.commons.utils.Checks;



/**
 * Dto que gestiona la informacion de los contactos de los proveedores
 *  
 * @author Anahuac de Vicente
 */
public class DtoProveedorContactoSimple implements Comparable<DtoProveedorContactoSimple> {


	private Long id;
	private String codTipoDocIdentificativo;
	private String docIdentificativo;
	private String nombre;
	private String apellido1;
	private String apellido2;
	private String codigoPostal;
	private String direccion;
	private String telefono1;
	private String telefono2;
	private String fax;
	private String email;
	private String cargo;
	private Date fechaAlta;
	private Date fechaBaja;
	private String observaciones;
	private Long idUsuario;
	private String loginUsuario;
	private String codProvincia;
	private Boolean usuarioGrupo;
	
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getCodTipoDocIdentificativo() {
		return codTipoDocIdentificativo;
	}
	public void setCodTipoDocIdentificativo(String codTipoDocIdentificativo) {
		this.codTipoDocIdentificativo = codTipoDocIdentificativo;
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
	public String getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(String codigoPostal) {
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
	public Long getIdUsuario() {
		return idUsuario;
	}
	public void setIdUsuario(Long idUsuario) {
		this.idUsuario = idUsuario;
	}
	public String getLoginUsuario() {
		return loginUsuario;
	}
	public void setLoginUsuario(String loginUsuario) {
		this.loginUsuario = loginUsuario;
	}
	public String getCodProvincia() {
		return codProvincia;
	}
	public void setCodProvincia(String codProvincia) {
		this.codProvincia = codProvincia;
	}
	public Boolean getUsuarioGrupo() {
		return usuarioGrupo;
	}
	public void setUsuarioGrupo(Boolean usuarioGrupo) {
		this.usuarioGrupo = usuarioGrupo;
	}
	
	@Override
	public int compareTo(DtoProveedorContactoSimple o) {
		int resultado = 0;
			
		if (!Checks.esNulo(o.getUsuarioGrupo())) {

			if(this.getUsuarioGrupo() && o.getUsuarioGrupo()){
				resultado= this.getNombre().compareTo(o.getNombre());
			}
			else{
				if(this.getUsuarioGrupo() || o.getUsuarioGrupo()){
					resultado= o.getUsuarioGrupo().compareTo(this.getUsuarioGrupo());
				}
				else{
					resultado= this.getNombre().compareTo(o.getNombre());
				}
			}				
		}
		return resultado;
	}
	
	
}