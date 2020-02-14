package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;
import java.util.Date;

public class DtoActivosPublicacion extends WebDto {
	private static final long serialVersionUID = 1L;

	private String numActivo;
	private String tipoActivo;
	private String subtipoActivo;
	private String cartera;
	private String subCartera;
	private String estadoPublicacionCodigo;
	private String estadoPublicacionAlquilerCodigo;
	private String tipoComercializacionCodigo[];
	private Boolean admision;
	private Boolean gestion;
	private Boolean publicacion;
	private Boolean precio;
	private Boolean informeComercial;
	private Boolean okventa;
	private Boolean okalquiler;
	private String motivosOcultacionCodigo;
	private String motivosOcultacionAlquilerCodigo;
	private String gestorPublicacionUsername;
	private String fasePublicacionCodigo;
	private String fasePublicacionDescripcion;
	private String subFasePublicacionCodigo;
	private String subFasePublicacionDescripcion;
	private Long precioTasacionActivo;
	private String tipoAlquilerDescripcion;
	private Date fechaPublicacionVenta;
	private Date fechaPublicacionAlquiler;

	public String getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}

	public String getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(String tipo) {
		this.tipoActivo = tipo;
	}

	public String getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(String subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}

	public Boolean getAdmision() {
		return admision;
	}

	public void setAdmision(Boolean admision) {
		this.admision = admision;
	}

	public Boolean getGestion() {
		return gestion;
	}

	public void setGestion(Boolean gestion) {
		this.gestion = gestion;
	}

	public Boolean getPublicacion() {
		return publicacion;
	}

	public void setPublicacion(Boolean publicacion) {
		this.publicacion = publicacion;
	}

	public Boolean getPrecio() {
		return precio;
	}

	public void setPrecio(Boolean precio) {
		this.precio = precio;
	}

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}

	public String getEstadoPublicacionCodigo() {
		return estadoPublicacionCodigo;
	}

	public void setEstadoPublicacionCodigo(String estadoPublicacionCodigo) {
		this.estadoPublicacionCodigo = estadoPublicacionCodigo;
	}

	public String getEstadoPublicacionAlquilerCodigo() {
		return estadoPublicacionAlquilerCodigo;
	}

	public void setEstadoPublicacionAlquilerCodigo(String estadoPublicacionAlquilerCodigo) {
		this.estadoPublicacionAlquilerCodigo = estadoPublicacionAlquilerCodigo;
	}
	
	public Boolean getInformeComercial() {
		return informeComercial;
	}

	public void setInformeComercial(Boolean informeComercial) {
		this.informeComercial = informeComercial;
	}

	public String[] getTipoComercializacionCodigo() {
		return tipoComercializacionCodigo;
	}

	public void setTipoComercializacionCodigo(String[] tipoComercializacionCodigo) {
		this.tipoComercializacionCodigo = tipoComercializacionCodigo;
	}

	public Boolean getOkventa() {
		return okventa;
	}

	public void setOkventa(Boolean okventa) {
		this.okventa = okventa;
	}

	public Boolean getOkalquiler() {
		return okalquiler;
	}

	public void setOkalquiler(Boolean okalquiler) {
		this.okalquiler = okalquiler;
	}

	public String getMotivosOcultacionCodigo() {
		return motivosOcultacionCodigo;
	}

	public void setMotivosOcultacionCodigo(String motivosOcultacionCodigo) {
		this.motivosOcultacionCodigo = motivosOcultacionCodigo;
	}

	public String getMotivosOcultacionAlquilerCodigo() {
		return motivosOcultacionAlquilerCodigo;
	}

	public void setMotivosOcultacionAlquilerCodigo(String motivosOcultacionAlquilerCodigo) {
		this.motivosOcultacionAlquilerCodigo = motivosOcultacionAlquilerCodigo;
	}

	public String getSubCartera() {
		return subCartera;
	}

	public void setSubCartera(String subCartera) {
		this.subCartera = subCartera;
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

	public String getSubFasePublicacionCodigo() {
		return subFasePublicacionCodigo;
	}

	public void setSubFasePublicacionCodigo(String subFasePublicacionCodigo) {
		this.subFasePublicacionCodigo = subFasePublicacionCodigo;
	}

	public String getSubFasePublicacionDescripcion() {
		return subFasePublicacionDescripcion;
	}

	public void setSubFasePublicacionDescripcion(String subFasePublicacionDescripcion) {
		this.subFasePublicacionDescripcion = subFasePublicacionDescripcion;
	}

	public Long getPrecioTasacionActivo() {
		return precioTasacionActivo;
	}

	public void setPrecioTasacionActivo(Long precioTasacionActivo) {
		this.precioTasacionActivo = precioTasacionActivo;
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
	
}
