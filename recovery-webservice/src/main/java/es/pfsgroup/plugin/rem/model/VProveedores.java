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
	
	@Column(name = "DD_CRA_CODIGO")
	private String codigoCartera ;
	
	@Column(name = "DD_CRA_DESCRIPCION")
	private String cartera ;
	
	@Column(name = "DD_PRV_CODIGO")
	private String codigoProvincia ;
	
	@Column(name = "DD_PRV_DESCRIPCION")
	private String provinciaDescripcion ;
	

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

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}

	public String getCodigoCartera() {
		return codigoCartera;
	}

	public void setCodigoCartera(String codigoCartera) {
		this.codigoCartera = codigoCartera;
	}

	public String getCodigoProvincia() {
		return codigoProvincia;
	}

	public void setCodigoProvincia(String codigoProvincia) {
		this.codigoProvincia = codigoProvincia;
	}

	public String getProvinciaDescripcion() {
		return provinciaDescripcion;
	}

	public void setProvinciaDescripcion(String provinciaDescripcion) {
		this.provinciaDescripcion = provinciaDescripcion;
	}

}
	
	
	