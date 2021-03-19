package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;
import java.util.Date;

public class DtoPublicacionGridFilter extends WebDto {
	
	private static final long serialVersionUID = 1L;
	private Long id;
	private String numActivo;
	private Integer admision;
	private Integer gestion;
	private Integer publicacion;
	private Integer precio;
	private Integer publicarSinPrecioVenta;
	private Integer publicarSinPrecioAlquiler;
	private Integer informeComercial;
	private Integer adjuntoActivo;
	private Integer conPrecioAlquiler;
	private Double precioTasacionActivo;
	private Date fechaPublicacionVenta;
	private Date fechaPublicacionAlquiler;
	private String tipoActivoCodigo;
	private String tipoActivoDescripcion;
	private String subtipoActivoCodigo;
	private String subtipoActivoDescripcion;
	private String direccion;
	private String carteraCodigo;
	private String subcarteraCodigo;
	private String estadoPublicacionVentaCodigo;
	private String estadoPublicacionVentaDescripcion;
	private String estadoPublicacionAlquilerCodigo;
	private String estadoPublicacionAlquilerDescripcion;
	private String estadoPublicacionDescripcion;
	private String tipoComercializacionCodigo;
	private String tipoComercializacionDescripcion;
	private String gestorPublicacionUsername;
	private String fasePublicacionCodigo;
	private String fasePublicacionDescripcion;
	private String subfasePublicacionCodigo;
	private String subfasePublicacionDescripcion;
	private String tipoAlquilerDescripcion;
	private String motivosOcultacionVentaCodigo;
	private String motivosOcultacionAlquilerCodigo;
	private String adecuacionAlquilerCodigo;	

	private Boolean checkOkPrecio;
	private Boolean checkOkVenta;
	private Boolean checkOkAlquiler;
	private Boolean checkOkInformeComercial;
	private Boolean checkOkGestion;
	private Boolean checkOkAdmision;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
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
	public Integer getPrecio() {
		return precio;
	}
	public void setPrecio(Integer precio) {
		this.precio = precio;
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
	public Integer getConPrecioAlquiler() {
		return conPrecioAlquiler;
	}
	public void setConPrecioAlquiler(Integer conPrecioAlquiler) {
		this.conPrecioAlquiler = conPrecioAlquiler;
	}
	public Double getPrecioTasacionActivo() {
		return precioTasacionActivo;
	}
	public void setPrecioTasacionActivo(Double precioTasacionActivo) {
		this.precioTasacionActivo = precioTasacionActivo;
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
	public Boolean getCheckOkPrecio() {
		return checkOkPrecio;
	}
	public void setCheckOkPrecio(Boolean checkOkPrecio) {
		this.checkOkPrecio = checkOkPrecio;
	}
	public Boolean getCheckOkVenta() {
		return checkOkVenta;
	}
	public void setCheckOkVenta(Boolean checkOkVenta) {
		this.checkOkVenta = checkOkVenta;
	}
	public Boolean getCheckOkAlquiler() {
		return checkOkAlquiler;
	}
	public void setCheckOkAlquiler(Boolean checkOkAlquiler) {
		this.checkOkAlquiler = checkOkAlquiler;
	}
	public Boolean getCheckOkInformeComercial() {
		return checkOkInformeComercial;
	}
	public void setCheckOkInformeComercial(Boolean checkOkInformeComercial) {
		this.checkOkInformeComercial = checkOkInformeComercial;
	}
	public Boolean getCheckOkGestion() {
		return checkOkGestion;
	}
	public void setCheckOkGestion(Boolean checkOkGestion) {
		this.checkOkGestion = checkOkGestion;
	}
	public Boolean getCheckOkAdmision() {
		return checkOkAdmision;
	}
	public void setCheckOkAdmision(Boolean checkOkAdmision) {
		this.checkOkAdmision = checkOkAdmision;
	}
			
}
