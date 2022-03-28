package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;

import javax.validation.constraints.NotNull;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.model.dd.DDFuenteTestigos;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoHabitaculo;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class TestigosOpcionalesDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Diccionary(clase = DDFuenteTestigos.class, message = "El codigo fuente introducido no existe", groups = { Insert.class,
			Update.class })
	private String codFuente;

	private Float superficie;
	
	@Diccionary(clase = DDTipoActivo.class, message = "El codigo codTipoActivo introducido no existe", groups = { Insert.class,
			Update.class })
	private String codTipoActivo;
	
	@Diccionary(clase = DDSubtipoActivo.class, message = "El codigo codSubtipoInmueble introducido no existe", groups = { Insert.class,
			Update.class })
	private String codSubtipoInmueble;
	
	private String direccion;
	
	private Float lat;
	
	private Float lng;
	
	private Float precioMercado;

	private Float eurosPorMetro;
	
	private String enlace;
	
	private Date fechaTransaccionPublicacion;

	public String getCodFuente() {
		return codFuente;
	}

	public void setCodFuente(String codFuente) {
		this.codFuente = codFuente;
	}

	public Float getSuperficie() {
		return superficie;
	}

	public void setSuperficie(Float superficie) {
		this.superficie = superficie;
	}

	public String getCodTipoActivo() {
		return codTipoActivo;
	}

	public void setCodTipoActivo(String codTipoActivo) {
		this.codTipoActivo = codTipoActivo;
	}

	public String getCodSubtipoInmueble() {
		return codSubtipoInmueble;
	}

	public void setCodSubtipoInmueble(String codSubtipoInmueble) {
		this.codSubtipoInmueble = codSubtipoInmueble;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public Float getLat() {
		return lat;
	}

	public void setLat(Float lat) {
		this.lat = lat;
	}

	public Float getLng() {
		return lng;
	}

	public void setLng(Float lng) {
		this.lng = lng;
	}

	public Float getPrecioMercado() {
		return precioMercado;
	}

	public void setPrecioMercado(Float precioMercado) {
		this.precioMercado = precioMercado;
	}

	public Float getEurosPorMetro() {
		return eurosPorMetro;
	}

	public void setEurosPorMetro(Float eurosPorMetro) {
		this.eurosPorMetro = eurosPorMetro;
	}

	public String getEnlace() {
		return enlace;
	}

	public void setEnlace(String enlace) {
		this.enlace = enlace;
	}

	public Date getFechaTransaccionPublicacion() {
		return fechaTransaccionPublicacion;
	}

	public void setFechaTransaccionPublicacion(Date fechaTransaccionPublicacion) {
		this.fechaTransaccionPublicacion = fechaTransaccionPublicacion;
	}

}
