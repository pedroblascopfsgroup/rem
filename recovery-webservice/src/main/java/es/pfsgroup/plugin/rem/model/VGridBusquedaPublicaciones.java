package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_GRID_BUSQUEDA_PUBLICACIONES", schema = "${entity.schema}")
public class VGridBusquedaPublicaciones implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "ACT_ID")
	private Long id;

	@Column(name = "ACT_NUM_ACTIVO")
	private Long numActivo;

	@Column(name = "TIPO_ACTIVO_CODIGO")
	private String tipoActivoCodigo;

	@Column(name = "TIPO_ACTIVO_DESCRIPCION")
	private String tipoActivoDescripcion;

	@Column(name = "SUBTIPO_ACTIVO_CODIGO")
	private String subtipoActivoCodigo;

	@Column(name = "SUBTIPO_ACTIVO_DESCRIPCION")
	private String subtipoActivoDescripcion;

	@Column(name = "DIRECCION")
	private String direccion;

	@Column(name = "CARTERA_CODIGO")
	private String carteraCodigo;	
	
	@Column(name = "SUBCARTERA_CODIGO")
	private String subcarteraCodigo;

	@Column(name = "ESTADO_PUBLICACION_VENTA_CODIGO")
	private String estadoPublicacionVentaCodigo;

	@Column(name = "ESTADO_PUBLICACION_VENTA_DESCRIPCION")
	private String estadoPublicacionVentaDescripcion;

	@Column(name = "ESTADO_PUBLICACION_ALQUILER_CODIGO")
	private String estadoPublicacionAlquilerCodigo;

	@Column(name = "ESTADO_PUBLICACION_ALQUILER_DESCRIPCION")
	private String estadoPublicacionAlquilerDescripcion;

	@Column(name = "ESTADO_PUBLICACION_DESCRIPCION")
	private String estadoPublicacionDescripcion;

	@Column(name = "TIPO_COMERCIALIZACION_CODIGO")
	private String tipoComercializacionCodigo;

	@Column(name = "TIPO_COMERCIALIZACION_DESCRIPCION")
	private String tipoComercializacionDescripcion;

	@Column(name = "ADMISION")
	private Integer admision;

	@Column(name = "GESTION")
	private Integer gestion;

	@Column(name = "PUBLICACION")
	private Integer publicacion;

	@Column(name = "TAS_IMPORTE_TAS_FIN")
	private Double precioTasacionActivo;

	@Column(name = "PRECIO")
	private Integer precio;

	@Column(name = "GPUBL_USU_USERNAME")
	private String gestorPublicacionUsername;

	@Column(name = "FASE_PUBLICACION_CODIGO")
	private String fasePublicacionCodigo;

	@Column(name = "FASE_PUBLICACION_DESCRIPCION")
	private String fasePublicacionDescripcion;

	@Column(name = "SUBFASE_PUBLICACION_CODIGO")
	private String subfasePublicacionCodigo;

	@Column(name = "SUBFASE_PUBLICACION_DESCRIPCION")
	private String subfasePublicacionDescripcion;

	@Column(name = "TAL_DESCRIPCION")
	private String tipoAlquilerDescripcion;

	@Column(name = "FECHA_VENTA")
	private Date fechaPublicacionVenta;

	@Column(name = "FECHA_ALQUILER")
	private Date fechaPublicacionAlquiler;

	@Column(name = "PUBLICAR_SIN_PRECIO_VENTA")
	private Integer publicarSinPrecioVenta;

	@Column(name = "PUBLICAR_SIN_PRECIO_ALQUILER")
	private Integer publicarSinPrecioAlquiler;

	@Column(name = "INFORME_COMERCIAL")
	private Integer informeComercial;

	@Column(name = "ADJUNTO_ACTIVO")
	private Integer adjuntoActivo;
	
	@Column(name = "MOTIVO_OCULTACION_VENTA_CODIGO")
	private String motivosOcultacionVentaCodigo;
	
	@Column(name = "MOTIVO_OCULTACION_ALQUILER_CODIGO")
	private String motivosOcultacionAlquilerCodigo;
	
	@Column(name = "ADECUACION_ALQUILER_CODIGO")
	private String adecuacionAlquilerCodigo;

	@Column(name = "CON_PRECIO_ALQUILER")
	private Integer conPrecioAlquiler;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public String getTipoActivoCodigo() {
		return tipoActivoCodigo;
	}

	public void setTipoActivoCodigo(String tipoActivoCodigo) {
		this.tipoActivoCodigo = tipoActivoCodigo;
	}

	public String getTipoActivoDescripcion() {
		return tipoActivoDescripcion;
	}

	public void setTipoActivoDescripcion(String tipoActivoDescripcion) {
		this.tipoActivoDescripcion = tipoActivoDescripcion;
	}

	public String getSubtipoActivoCodigo() {
		return subtipoActivoCodigo;
	}

	public void setSubtipoActivoCodigo(String subtipoActivoCodigo) {
		this.subtipoActivoCodigo = subtipoActivoCodigo;
	}

	public String getSubtipoActivoDescripcion() {
		return subtipoActivoDescripcion;
	}

	public void setSubtipoActivoDescripcion(String subtipoActivoDescripcion) {
		this.subtipoActivoDescripcion = subtipoActivoDescripcion;
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

	public String getSubcarteraCodigo() {
		return subcarteraCodigo;
	}

	public void setSubcarteraCodigo(String subcarteraCodigo) {
		this.subcarteraCodigo = subcarteraCodigo;
	}

	public String getEstadoPublicacionVentaCodigo() {
		return estadoPublicacionVentaCodigo;
	}

	public void setEstadoPublicacionVentaCodigo(String estadoPublicacionVentaCodigo) {
		this.estadoPublicacionVentaCodigo = estadoPublicacionVentaCodigo;
	}

	public String getEstadoPublicacionVentaDescripcion() {
		return estadoPublicacionVentaDescripcion;
	}

	public void setEstadoPublicacionVentaDescripcion(String estadoPublicacionVentaDescripcion) {
		this.estadoPublicacionVentaDescripcion = estadoPublicacionVentaDescripcion;
	}

	public String getEstadoPublicacionAlquilerCodigo() {
		return estadoPublicacionAlquilerCodigo;
	}

	public void setEstadoPublicacionAlquilerCodigo(String estadoPublicacionAlquilerCodigo) {
		this.estadoPublicacionAlquilerCodigo = estadoPublicacionAlquilerCodigo;
	}

	public String getEstadoPublicacionAlquilerDescripcion() {
		return estadoPublicacionAlquilerDescripcion;
	}

	public void setEstadoPublicacionAlquilerDescripcion(String estadoPublicacionAlquilerDescripcion) {
		this.estadoPublicacionAlquilerDescripcion = estadoPublicacionAlquilerDescripcion;
	}

	public String getEstadoPublicacionDescripcion() {
		return estadoPublicacionDescripcion;
	}

	public void setEstadoPublicacionDescripcion(String estadoPublicacionDescripcion) {
		this.estadoPublicacionDescripcion = estadoPublicacionDescripcion;
	}

	public String getTipoComercializacionCodigo() {
		return tipoComercializacionCodigo;
	}

	public void setTipoComercializacionCodigo(String tipoComercializacionCodigo) {
		this.tipoComercializacionCodigo = tipoComercializacionCodigo;
	}

	public String getTipoComercializacionDescripcion() {
		return tipoComercializacionDescripcion;
	}

	public void setTipoComercializacionDescripcion(String tipoComercializacionDescripcion) {
		this.tipoComercializacionDescripcion = tipoComercializacionDescripcion;
	}

	public Integer getAdmision() {
		return admision;
	}

	public void setAdmision(Integer admision) {
		this.admision = admision;
	}

	public Integer getGestion() {
		return gestion;
	}

	public void setGestion(Integer gestion) {
		this.gestion = gestion;
	}

	public Integer getPublicacion() {
		return publicacion;
	}

	public void setPublicacion(Integer publicacion) {
		this.publicacion = publicacion;
	}

	public Double getPrecioTasacionActivo() {
		return precioTasacionActivo;
	}

	public void setPrecioTasacionActivo(Double precioTasacionActivo) {
		this.precioTasacionActivo = precioTasacionActivo;
	}

	public Integer getPrecio() {
		return precio;
	}

	public void setPrecio(Integer precio) {
		this.precio = precio;
	}

	public String getGestorPublicacionUsername() {
		return gestorPublicacionUsername;
	}

	public void setGestorPublicacionUsername(String gestorPublicacionUsername) {
		this.gestorPublicacionUsername = gestorPublicacionUsername;
	}

	public String getFasePublicacionCodigo() {
		return fasePublicacionCodigo;
	}

	public void setFasePublicacionCodigo(String fasePublicacionCodigo) {
		this.fasePublicacionCodigo = fasePublicacionCodigo;
	}

	public String getFasePublicacionDescripcion() {
		return fasePublicacionDescripcion;
	}

	public void setFasePublicacionDescripcion(String fasePublicacionDescripcion) {
		this.fasePublicacionDescripcion = fasePublicacionDescripcion;
	}

	public String getSubfasePublicacionCodigo() {
		return subfasePublicacionCodigo;
	}

	public void setSubfasePublicacionCodigo(String subfasePublicacionCodigo) {
		this.subfasePublicacionCodigo = subfasePublicacionCodigo;
	}

	public String getSubfasePublicacionDescripcion() {
		return subfasePublicacionDescripcion;
	}

	public void setSubfasePublicacionDescripcion(String subfasePublicacionDescripcion) {
		this.subfasePublicacionDescripcion = subfasePublicacionDescripcion;
	}

	public String getTipoAlquilerDescripcion() {
		return tipoAlquilerDescripcion;
	}

	public void setTipoAlquilerDescripcion(String tipoAlquilerDescripcion) {
		this.tipoAlquilerDescripcion = tipoAlquilerDescripcion;
	}

	public Date getFechaPublicacionVenta() {
		return fechaPublicacionVenta;
	}

	public void setFechaPublicacionVenta(Date fechaPublicacionVenta) {
		this.fechaPublicacionVenta = fechaPublicacionVenta;
	}

	public Date getFechaPublicacionAlquiler() {
		return fechaPublicacionAlquiler;
	}

	public void setFechaPublicacionAlquiler(Date fechaPublicacionAlquiler) {
		this.fechaPublicacionAlquiler = fechaPublicacionAlquiler;
	}

	public Integer getPublicarSinPrecioVenta() {
		return publicarSinPrecioVenta;
	}

	public void setPublicarSinPrecioVenta(Integer publicarSinPrecioVenta) {
		this.publicarSinPrecioVenta = publicarSinPrecioVenta;
	}

	public Integer getPublicarSinPrecioAlquiler() {
		return publicarSinPrecioAlquiler;
	}

	public void setPublicarSinPrecioAlquiler(Integer publicarSinPrecioAlquiler) {
		this.publicarSinPrecioAlquiler = publicarSinPrecioAlquiler;
	}

	public Integer getInformeComercial() {
		return informeComercial;
	}

	public void setInformeComercial(Integer informeComercial) {
		this.informeComercial = informeComercial;
	}

	public Integer getAdjuntoActivo() {
		return adjuntoActivo;
	}

	public void setAdjuntoActivo(Integer adjuntoActivo) {
		this.adjuntoActivo = adjuntoActivo;
	}

	public String getMotivosOcultacionVentaCodigo() {
		return motivosOcultacionVentaCodigo;
	}

	public void setMotivosOcultacionVentaCodigo(String motivosOcultacionVentaCodigo) {
		this.motivosOcultacionVentaCodigo = motivosOcultacionVentaCodigo;
	}

	public String getMotivosOcultacionAlquilerCodigo() {
		return motivosOcultacionAlquilerCodigo;
	}

	public void setMotivosOcultacionAlquilerCodigo(String motivosOcultacionAlquilerCodigo) {
		this.motivosOcultacionAlquilerCodigo = motivosOcultacionAlquilerCodigo;
	}

	public String getAdecuacionAlquilerCodigo() {
		return adecuacionAlquilerCodigo;
	}

	public void setAdecuacionAlquilerCodigo(String adecuacionAlquilerCodigo) {
		this.adecuacionAlquilerCodigo = adecuacionAlquilerCodigo;
	}

	public Integer getConPrecioAlquiler() {
		return conPrecioAlquiler;
	}

	public void setConPrecioAlquiler(Integer conPrecioAlquiler) {
		this.conPrecioAlquiler = conPrecioAlquiler;
	}	
	
}