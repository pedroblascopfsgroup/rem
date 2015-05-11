package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.asunto;

import java.util.Date;

/**
 * Informacion de anotaciones relacionadas con el asunto
 * 
 * @author bruno
 * 
 */
public class DtoInfoAnotacionAgenda {

	private String usuarioCrear;
	private String asuntoAnotacion;
	private String textoAnotacion;
	private Date fechaAnotacion;

	public DtoInfoAnotacionAgenda(String usuarioCrear, String asuntoAnotacion, String textoAnotacion, Date fechaAnotacion) {
		this.usuarioCrear = usuarioCrear;
		this.asuntoAnotacion = asuntoAnotacion;
		this.textoAnotacion = textoAnotacion;
		this.fechaAnotacion = fechaAnotacion;
	}

	public String getUsuarioCrear() {
		return this.usuarioCrear;
	}

	public String getAsuntoAnotacion() {
		return this.asuntoAnotacion;
	}

	public String getTextoAnotacion() {
		return this.textoAnotacion;
	}

	public Date getFechaAnotacion() {
		return this.fechaAnotacion;
	}

}
