package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_PROVEEDORES", schema = "${entity.schema}")
public class VProveedores implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "PVE_ID")
	private Long idProveedor;
	
	@Column(name = "PVE_NOMBRE")
	private String nombre;
	
	@Column(name = "PVE_NOMBRE_COMERCIAL")
	private String nombreComercial;
	
	@Column(name = "DD_TPR_CODIGO")
	private String codigoTipoProveedor;
	
	@Column(name = "DD_TPR_DESCRIPCION")
	private String descripcionTipoProveedor;
	
	@Column(name = "DD_CRA_ID")
	private Long idCartera ;
	
	@Column(name = "DD_CRA_DESCRIPCION")
	private String cartera ;
	
	@Column(name = "PVC_NOMBRE")
	private String nombreContacto ;
		
	@Column(name = "PVC_TELF1")
	private String telefono1Contacto ;
		
	@Column(name = "PVC_EMAIL")
	private String emailContacto ;
	

	public Long getIdProveedor() {
		return idProveedor;
	}

	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
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

	public String getCodigoTipoProveedor() {
		return codigoTipoProveedor;
	}

	public void setCodigoTipoProveedor(String codigoTipoProveedor) {
		this.codigoTipoProveedor = codigoTipoProveedor;
	}

	public String getDescripcionTipoProveedor() {
		return descripcionTipoProveedor;
	}

	public void setDescripcionTipoProveedor(String descripcionTipoProveedor) {
		this.descripcionTipoProveedor = descripcionTipoProveedor;
	}

	public Long getIdCartera() {
		return idCartera;
	}

	public void setIdCartera(Long idCartera) {
		this.idCartera = idCartera;
	}

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}

	public String getNombreContacto() {
		return nombreContacto;
	}

	public void setNombreContacto(String nombreContacto) {
		this.nombreContacto = nombreContacto;
	}

	public String getTelefono1Contacto() {
		return telefono1Contacto;
	}

	public void setTelefono1Contacto(String telefono1Contacto) {
		this.telefono1Contacto = telefono1Contacto;
	}

	public String getEmailContacto() {
		return emailContacto;
	}

	public void setEmailContacto(String emailContacto) {
		this.emailContacto = emailContacto;
	}
	




}
	
	
	