package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.model.dd.DDFuenteTestigos;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoHabitaculo;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class TestigosOpcionalesDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@NotNull(groups = {Insert.class, Update.class})
	private String id;
	
	private String nombre;

	@Diccionary(clase = DDFuenteTestigos.class, message = "El codigo fuente introducido no existe", groups = { Insert.class,
			Update.class })
	private String fuente;

	private Float superficie;
	
	@Diccionary(clase = DDTipoActivo.class, message = "El codigo tipologia introducido no existe", groups = { Insert.class,
			Update.class })
	private String tipologia;

	private Float precioMercado;

	private Float precio;
	
	private String link;
	
	private String informeMediadores;
	
	private String direccion;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getFuente() {
		return fuente;
	}

	public void setFuente(String fuente) {
		this.fuente = fuente;
	}

	public Float getSuperficie() {
		return superficie;
	}

	public void setSuperficie(Float superficie) {
		this.superficie = superficie;
	}

	public String getTipologia() {
		return tipologia;
	}

	public void setTipologia(String tipologia) {
		this.tipologia = tipologia;
	}

	public Float getPrecioMercado() {
		return precioMercado;
	}

	public void setPrecioMercado(Float precioMercado) {
		this.precioMercado = precioMercado;
	}

	public Float getPrecio() {
		return precio;
	}

	public void setPrecio(Float precio) {
		this.precio = precio;
	}

	public String getLink() {
		return link;
	}

	public void setLink(String link) {
		this.link = link;
	}

	public String getInformeMediadores() {
		return informeMediadores;
	}

	public void setInformeMediadores(String informeMediadores) {
		this.informeMediadores = informeMediadores;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

}
