package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.model.dd.DDFuenteTestigos;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class TestigosOfertaDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Diccionary(clase = DDFuenteTestigos.class, message = "El codigo fuente introducido no existe", groups = { Insert.class,
			Update.class })
	private String codFuente;

	private String superficie;
	
	@Diccionary(clase = DDTipoActivo.class, message = "El codigo tipologia introducido no existe", groups = { Insert.class,
			Update.class })
	private String codTipoActivo;

	private String precioMercado;

	private String eurosPorMetro;
	
	private String enlace;
	
	private String direccion;

	public String getCodFuente() {
		return codFuente;
	}

	public void setCodFuente(String codFuente) {
		this.codFuente = codFuente;
	}

	public String getSuperficie() {
		return superficie;
	}

	public void setSuperficie(String superficie) {
		this.superficie = superficie;
	}

	public String getCodTipoActivo() {
		return codTipoActivo;
	}

	public void setCodTipoActivo(String codTipoActivo) {
		this.codTipoActivo = codTipoActivo;
	}

	public String getPrecioMercado() {
		return precioMercado;
	}

	public void setPrecioMercado(String precioMercado) {
		this.precioMercado = precioMercado;
	}

	public String getEurosPorMetro() {
		return eurosPorMetro;
	}

	public void setEurosPorMetro(String eurosPorMetro) {
		this.eurosPorMetro = eurosPorMetro;
	}

	public String getEnlace() {
		return enlace;
	}

	public void setEnlace(String enlace) {
		this.enlace = enlace;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

}