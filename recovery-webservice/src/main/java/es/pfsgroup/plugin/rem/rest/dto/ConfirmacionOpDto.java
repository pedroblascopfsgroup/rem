package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class ConfirmacionOpDto implements Serializable{


	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	

	@Diccionary(clase = Activo.class, message = "El activo no existe", foreingField = "numActivoUvem", groups = {
			Insert.class, Update.class })
	Long activo;
	
	@Diccionary(clase = Oferta.class, message = "La oferta no existe", foreingField = "numOferta", groups = {
		Insert.class, Update.class })
	Long ofertaHRE;
	
	@NotNull(groups = { Insert.class, Update.class })
	String accion;
	
	@NotNull(groups = { Insert.class, Update.class })
	Integer resultado;
	
	String mensaje;

	
	
	public Long getActivo() {
		return activo;
	}

	public void setActivo(Long activo) {
		this.activo = activo;
	}

	public Long getOfertaHRE() {
		return ofertaHRE;
	}

	public void setOfertaHRE(Long ofertaHRE) {
		this.ofertaHRE = ofertaHRE;
	}

	public String getAccion() {
		return accion;
	}

	public void setAccion(String accion) {
		this.accion = accion;
	}

	public Integer getResultado() {
		return resultado;
	}

	public void setResultado(Integer resultado) {
		this.resultado = resultado;
	}

	public String getMensaje() {
		return mensaje;
	}

	public void setMensaje(String mensaje) {
		this.mensaje = mensaje;
	}
	
	

	
}
