package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "VI_BUSQUEDA_PROVEEDORES_ACTIVO", schema = "${entity.schema}")
public class VBusquedaProveedoresActivo implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "PVE_ID")
	private String id;
	
	@Column(name="ACT_ID")
	private String idActivo;
	
	@Column(name="ACT_NUM_ACTIVO")
	private String numActivo;
	
	@Column(name="DD_TPR_CODIGO")
	private String tipoProveedorCodigo;
	
	@Column(name="DD_TPR_DESCRIPCION")
	private String tipoProveedorDescripcion;
	
	@Column(name="PVE_DOCIDENTIF")
	private String numDocumentoProveedor;
	
	@Column(name="PVE_NOMBRE")
	private String nombreProveedor;
	
	@Column(name="DD_EPR_CODIGO")
	private String estadoProveedorCodigo;
	
	@Column(name="DD_EPR_DESCRIPCION")
	private String estadoProveedorDescripcion;
	
	@Column(name="PVE_COD_UVEM")
	private String codigoProveedor;

	@Column(name="AIN_FECHA_EXCLUSION")
	private Date fechaExclusion;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}

	public String getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}

	public String getTipoProveedorCodigo() {
		return tipoProveedorCodigo;
	}

	public void setTipoProveedorCodigo(String tipoProveedorCodigo) {
		this.tipoProveedorCodigo = tipoProveedorCodigo;
	}

	public String getTipoProveedorDescripcion() {
		return tipoProveedorDescripcion;
	}

	public void setTipoProveedorDescripcion(String tipoProveedorDescripcion) {
		this.tipoProveedorDescripcion = tipoProveedorDescripcion;
	}

	public String getNumDocumentoProveedor() {
		return numDocumentoProveedor;
	}

	public void setNumDocumentoProveedor(String numDocumentoProveedor) {
		this.numDocumentoProveedor = numDocumentoProveedor;
	}

	public String getNombreProveedor() {
		return nombreProveedor;
	}

	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}

	public String getEstadoProveedorCodigo() {
		return estadoProveedorCodigo;
	}

	public void setEstadoProveedorCodigo(String estadoProveedorCodigo) {
		this.estadoProveedorCodigo = estadoProveedorCodigo;
	}

	public String getEstadoProveedorDescripcion() {
		return estadoProveedorDescripcion;
	}

	public void setEstadoProveedorDescripcion(String estadoProveedorDescripcion) {
		this.estadoProveedorDescripcion = estadoProveedorDescripcion;
	}

	public String getCodigoProveedor() {
		return codigoProveedor;
	}

	public void setCodigoProveedor(String codigoProveedor) {
		this.codigoProveedor = codigoProveedor;
	}

	public Date getFechaExclusion() {
		return fechaExclusion;
	}

	public void setFechaExclusion(Date fechaExclusion) {
		this.fechaExclusion = fechaExclusion;
	}
		

}
