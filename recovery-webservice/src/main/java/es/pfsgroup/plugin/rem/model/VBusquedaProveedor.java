package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.sql.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_BUSQUEDA_PROVEEDORES", schema = "${entity.schema}")
public class VBusquedaProveedor implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "PVE_ID")
	private Long id;
	
	@Column(name = "PVE_COD_REM")
	private Long codigoProveedorRem;

	@Column(name = "TIPO_PROVEEDOR_CODIGO")
	private String tipoProveedorCodigo;

	@Column(name = "TIPO_PROVEEDOR_DESCRIPCION")
	private String tipoProveedorDescripcion;

	@Column(name = "SUBTIPO_PROVEEDOR_CODIGO")
	private String subtipoProveedorCodigo;

	@Column(name = "SUBTIPO_PROVEEDOR_DESCRIPCION")
	private String subtipoProveedorDescripcion;

	@Column(name = "NIF_PROVEEDOR")
	private String nifProveedor;

	@Column(name = "NOMBRE_PROVEEDOR")
	private String nombreProveedor;

	@Column(name = "NOMBRE_COMERCIAL_PROVEEDOR")
	private String nombreComercialProveedor;

	@Column(name = "ESTADO_PROVEEDOR_CODIGO")
	private String estadoProveedorCodigo;

	@Column(name = "ESTADO_PROVEEDOR_DESCRIPCION")
	private String estadoProveedorDescripcion;

	@Column(name = "OBSERVACIONES_PROVEEDOR")
	private String observaciones;

	@Column(name = "FECHA_ALTA_PROVEEDOR")
	private Date fechaAltaProveedor;

	@Column(name = "FECHA_BAJA_PROVEEDOR")
	private Date fechaBajaProveedor;

	@Column(name = "TIPO_PERSONA_PROVEEDOR_CODIGO")
	private String tipoPersonaProveedorCodigo;

	@Column(name = "CARTERA")
	private String cartera;

	@Column(name = "AMBITO_PROVEEDOR")
	private String ambitoProveedor;

	@Column(name = "PROVINCIA_PROVEEDOR")
	private String provinciaProveedor;

	@Column(name = "MUNICIPIO_PROVEEDOR")
	private String municipioProveedor;

	@Column(name = "CODIGO_POSTAL_PROVEEDOR")
	private Integer codigoPostalProveedor;

	@Column(name = "NIF_PERSONA_CONTACTO")
	private String nifPersonaContacto;

	@Column(name = "NOMBRE_PERSONA_CONTACTO")
	private String nombrePersonaContacto;

	@Column(name = "HOMOLOGADO_PROVEEDOR")
	private Integer homologadoProveedor;

	@Column(name = "CALIFICACION_PROVEEDOR")
	private String calificacionProveedor;

	@Column(name = "TOP_PROVEEDOR")
	private Integer topProveedor;

	@Column(name = "PROPIETARIO_ACTIVO_VINCULADO")
	private String propietarioActivoVinculado;
	
	@Column(name = "USU_ID")
	private Long idUser;
	
	@Column(name = "LINEA_NEGOCIO")
	private String idLineaNegocio;
	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getCodigoProveedorRem() {
		return codigoProveedorRem;
	}

	public void setCodigoProveedorRem(Long codigoProveedorRem) {
		this.codigoProveedorRem = codigoProveedorRem;
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

	public String getSubtipoProveedorCodigo() {
		return subtipoProveedorCodigo;
	}

	public void setSubtipoProveedorCodigo(String subtipoProveedorCodigo) {
		this.subtipoProveedorCodigo = subtipoProveedorCodigo;
	}

	public String getSubtipoProveedorDescripcion() {
		return subtipoProveedorDescripcion;
	}

	public void setSubtipoProveedorDescripcion(String subtipoProveedorDescripcion) {
		this.subtipoProveedorDescripcion = subtipoProveedorDescripcion;
	}

	public String getNifProveedor() {
		return nifProveedor;
	}

	public void setNifProveedor(String nifProveedor) {
		this.nifProveedor = nifProveedor;
	}

	public String getNombreProveedor() {
		return nombreProveedor;
	}

	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}

	public String getNombreComercialProveedor() {
		return nombreComercialProveedor;
	}

	public void setNombreComercialProveedor(String nombreComercialProveedor) {
		this.nombreComercialProveedor = nombreComercialProveedor;
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

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Date getFechaAltaProveedor() {
		return fechaAltaProveedor;
	}

	public void setFechaAltaProveedor(Date fechaAltaProveedor) {
		this.fechaAltaProveedor = fechaAltaProveedor;
	}

	public Date getFechaBajaProveedor() {
		return fechaBajaProveedor;
	}

	public void setFechaBajaProveedor(Date fechaBajaProveedor) {
		this.fechaBajaProveedor = fechaBajaProveedor;
	}

	public String getTipoPersonaProveedorCodigo() {
		return tipoPersonaProveedorCodigo;
	}

	public void setTipoPersonaProveedorCodigo(String tipoPersonaProveedorCodigo) {
		this.tipoPersonaProveedorCodigo = tipoPersonaProveedorCodigo;
	}

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}

	public String getAmbitoProveedor() {
		return ambitoProveedor;
	}

	public void setAmbitoProveedor(String ambitoProveedor) {
		this.ambitoProveedor = ambitoProveedor;
	}

	public String getProvinciaProveedor() {
		return provinciaProveedor;
	}

	public void setProvinciaProveedor(String provinciaProveedor) {
		this.provinciaProveedor = provinciaProveedor;
	}

	public String getMunicipioProveedor() {
		return municipioProveedor;
	}

	public void setMunicipioProveedor(String municipioProveedor) {
		this.municipioProveedor = municipioProveedor;
	}

	public Integer getCodigoPostalProveedor() {
		return codigoPostalProveedor;
	}

	public void setCodigoPostalProveedor(Integer codigoPostalProveedor) {
		this.codigoPostalProveedor = codigoPostalProveedor;
	}

	public String getNifPersonaContacto() {
		return nifPersonaContacto;
	}

	public void setNifPersonaContacto(String nifPersonaContacto) {
		this.nifPersonaContacto = nifPersonaContacto;
	}

	public String getNombrePersonaContacto() {
		return nombrePersonaContacto;
	}

	public void setNombrePersonaContacto(String nombrePersonaContacto) {
		this.nombrePersonaContacto = nombrePersonaContacto;
	}

	public String getPropietarioActivoVinculado() {
		return propietarioActivoVinculado;
	}

	public void setPropietarioActivoVinculado(String propietarioActivoVinculado) {
		this.propietarioActivoVinculado = propietarioActivoVinculado;
	}

	public Integer getHomologadoProveedor() {
		return homologadoProveedor;
	}

	public void setHomologadoProveedor(Integer homologadoProveedor) {
		this.homologadoProveedor = homologadoProveedor;
	}

	public String getCalificacionProveedor() {
		return calificacionProveedor;
	}

	public void setCalificacionProveedor(String calificacionProveedor) {
		this.calificacionProveedor = calificacionProveedor;
	}

	public Integer getTopProveedor() {
		return topProveedor;
	}

	public void setTopProveedor(Integer topProveedor) {
		this.topProveedor = topProveedor;
	}

	public Long getIdUser() {
		return idUser;
	}

	public void setIdUser(Long idUser) {
		this.idUser = idUser;
	}

	public String getIdLineaNegocio() {
		return idLineaNegocio;
	}

	public void setIdLineaNegocio(String idLineaNegocio) {
		this.idLineaNegocio = idLineaNegocio;
	}
	

}