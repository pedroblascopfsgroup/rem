package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_GRID_BUSQUEDA_AGRUPACIONES", schema = "${entity.schema}")
public class VGridBusquedaAgrupaciones implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "AGR_ID")
	private Long id;

	@Column(name = "TIPO_AGRUPACION_CODIGO")
	private String tipoAgrupacionCodigo;

	@Column(name = "TIPO_AGRUPACION_DESCRIPCION")
	private String tipoAgrupacionDescripcion;

	@Column(name = "NUM_AGRUP_REM")
	private Long numAgrupacionRem;

	@Column(name = "NUM_AGRUP_UVEM")
	private Long numAgrupacionUvem;

	@Column(name = "AGR_NOMBRE")
	private String nombre;

	@Column(name = "AGR_DESCRIPCION")
	private String descripcion;

	@Column(name = "AGR_FECHA_ALTA")
	private Date fechaAlta;

	@Column(name = "AGR_FECHA_BAJA")
	private Date fechaBaja;

	@Column(name = "AGR_INI_VIGENCIA")
	private Date fechaInicioVigencia;

	@Column(name = "AGR_FIN_VIGENCIA")
	private Date fechaFinVigencia;

	@Column(name = "AGR_PUBLICADO")
	private Integer publicado;

	@Column(name = "ACTIVOS")
	private Integer numActivos;

	@Column(name = "PUBLICADOS")
	private Integer numPublicados;

	@Column(name = "DIRECCION")
	private String direccion;

	@Column(name = "CARTERA_CODIGO")
	private String carteraCodigo;

	@Column(name = "CARTERA_DESCRIPCION")
	private String carteraDescripcion;

	@Column(name = "SUBCARTERA_CODIGO")
	private String subcarteraCodigo;

	@Column(name = "SUBCARTERA_DESCRIPCION")
	private String subcarteraDescripcion;

	@Column(name = "FORMALIZACION")
	private Integer formalizacion;

	@Column(name = "TIPO_ALQUILER_CODIGO")
	private String tipoAlquilerCodigo;

	@Column(name = "TIPO_ALQUILER_DESCRIPCION")
	private String tipoAlquilerDescripcion;

	@Column(name = "LOCALIDAD_CODIGO")
	private String localidadCodigo;

	@Column(name = "LOCALIDAD_DESCRIPCION")
	private String localidadDescripcion;

	@Column(name = "PROVINCIA_CODIGO")
	private String provinciaCodigo;

	@Column(name = "PROVINCIA_DESCRIPCION")
	private String provinciaDescripcion;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getTipoAgrupacionCodigo() {
		return tipoAgrupacionCodigo;
	}

	public void setTipoAgrupacionCodigo(String tipoAgrupacionCodigo) {
		this.tipoAgrupacionCodigo = tipoAgrupacionCodigo;
	}

	public String getTipoAgrupacionDescripcion() {
		return tipoAgrupacionDescripcion;
	}

	public void setTipoAgrupacionDescripcion(String tipoAgrupacionDescripcion) {
		this.tipoAgrupacionDescripcion = tipoAgrupacionDescripcion;
	}

	public Long getNumAgrupacionRem() {
		return numAgrupacionRem;
	}

	public void setNumAgrupacionRem(Long numAgrupacionRem) {
		this.numAgrupacionRem = numAgrupacionRem;
	}

	public Long getNumAgrupacionUvem() {
		return numAgrupacionUvem;
	}

	public void setNumAgrupacionUvem(Long numAgrupacionUvem) {
		this.numAgrupacionUvem = numAgrupacionUvem;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
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

	public Date getFechaInicioVigencia() {
		return fechaInicioVigencia;
	}

	public void setFechaInicioVigencia(Date fechaInicioVigencia) {
		this.fechaInicioVigencia = fechaInicioVigencia;
	}

	public Date getFechaFinVigencia() {
		return fechaFinVigencia;
	}

	public void setFechaFinVigencia(Date fechaFinVigencia) {
		this.fechaFinVigencia = fechaFinVigencia;
	}

	public Integer getPublicado() {
		return publicado;
	}

	public void setPublicado(Integer publicado) {
		this.publicado = publicado;
	}

	public Integer getNumActivos() {
		return numActivos;
	}

	public void setNumActivos(Integer numActivos) {
		this.numActivos = numActivos;
	}

	public Integer getNumPublicados() {
		return numPublicados;
	}

	public void setNumPublicados(Integer numPublicados) {
		this.numPublicados = numPublicados;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getCarteraCodigo() {
		return carteraCodigo;
	}

	public void setCarteraCodigo(String carteraCodigo) {
		this.carteraCodigo = carteraCodigo;
	}

	public String getCarteraDescripcion() {
		return carteraDescripcion;
	}

	public void setCarteraDescripcion(String carteraDescripcion) {
		this.carteraDescripcion = carteraDescripcion;
	}

	public String getSubcarteraCodigo() {
		return subcarteraCodigo;
	}

	public void setSubcarteraCodigo(String subcarteraCodigo) {
		this.subcarteraCodigo = subcarteraCodigo;
	}

	public String getSubcarteraDescripcion() {
		return subcarteraDescripcion;
	}

	public void setSubcarteraDescripcion(String subcarteraDescripcion) {
		this.subcarteraDescripcion = subcarteraDescripcion;
	}

	public Integer getFormalizacion() {
		return formalizacion;
	}

	public void setFormalizacion(Integer formalizacion) {
		this.formalizacion = formalizacion;
	}

	public String getTipoAlquilerCodigo() {
		return tipoAlquilerCodigo;
	}

	public void setTipoAlquilerCodigo(String tipoAlquilerCodigo) {
		this.tipoAlquilerCodigo = tipoAlquilerCodigo;
	}

	public String getTipoAlquilerDescripcion() {
		return tipoAlquilerDescripcion;
	}

	public void setTipoAlquilerDescripcion(String tipoAlquilerDescripcion) {
		this.tipoAlquilerDescripcion = tipoAlquilerDescripcion;
	}

	public String getLocalidadCodigo() {
		return localidadCodigo;
	}

	public void setLocalidadCodigo(String localidadCodigo) {
		this.localidadCodigo = localidadCodigo;
	}

	public String getLocalidadDescripcion() {
		return localidadDescripcion;
	}

	public void setLocalidadDescripcion(String localidadDescripcion) {
		this.localidadDescripcion = localidadDescripcion;
	}

	public String getProvinciaCodigo() {
		return provinciaCodigo;
	}

	public void setProvinciaCodigo(String provinciaCodigo) {
		this.provinciaCodigo = provinciaCodigo;
	}

	public String getProvinciaDescripcion() {
		return provinciaDescripcion;
	}

	public void setProvinciaDescripcion(String provinciaDescripcion) {
		this.provinciaDescripcion = provinciaDescripcion;
	}

}