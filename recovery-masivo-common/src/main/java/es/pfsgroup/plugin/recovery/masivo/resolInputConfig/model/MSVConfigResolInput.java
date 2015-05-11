package es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model;

import java.io.Serializable;

import es.pfsgroup.commons.utils.Checks;

/**
 * Contiene las diferentes alternativas posibles en una configuración de tipo de resolución.
 * 
 * La información de la alternativa es: tipo de input datos que sirven para discernir si ese input se selecciona
 * 
 * @author pedro
 * 
 */

public class MSVConfigResolInput implements Serializable {

	private static final long serialVersionUID = -7206930149619008983L;

	public static final String TRUE = "true";
	public static final String FALSE = "false";
	public static final String SI = "si";
	public static final String NO = "no";
	public static final String POSITIVO = "positivo";
	public static final String NEGATIVO = "negativo";
	public static final String TOTAL = "total";
	public static final String PARCIAL = "parcial";
	public static final String APROBADA = "aprobada";
	public static final String DENEGADA = "denegada";

	private String codigoInput;
	private String tieneProcurador;
	private String sentido;
	private String completo;
	private String respuesta;
	private String notificacion;
	private String tramiteEmbargo;
	private String conNuevaFecha;

	public String getCodigoInput() {
		return codigoInput;
	}

	public void setCodigoInput(String codigoInput) {
		this.codigoInput = codigoInput;
	}

	public String getTieneProcurador() {
		return tieneProcurador;
	}

	public void setTieneProcurador(String tieneProcurador) {
		this.tieneProcurador = tieneProcurador;
	}

	public String getSentido() {
		return sentido;
	}

	public void setSentido(String sentido) {
		this.sentido = sentido;
	}

	public String getCompleto() {
		return completo;
	}

	public void setCompleto(String completo) {
		this.completo = completo;
	}

	public String getRespuesta() {
		return respuesta;
	}

	public void setRespuesta(String respuesta) {
		this.respuesta = respuesta;
	}

	/**
	 * Este método sirve para ver si diferentes objetos son compatibles 
	 * con valores equivalentes para cada uno de los atributos
	 */
	public boolean compatible(MSVConfigResolInput otro) {
		if (this == otro)
			return true;
		if (otro == null)
			return false;

		boolean igualTieneProc = compruebaIgual(SI, NO, this.tieneProcurador,
				otro.getTieneProcurador());
		boolean igualCompleto = compruebaIgual(TOTAL, PARCIAL, this.completo,
				otro.getCompleto());
		boolean igualRespuesta = compruebaIgual(APROBADA, DENEGADA,
				this.respuesta, otro.getRespuesta());
		boolean igualSentido = compruebaIgual(POSITIVO, NEGATIVO, this.sentido,
				otro.getSentido());
		boolean igualNotificacion = compruebaIgual(TOTAL, PARCIAL, this.notificacion,
				otro.getNotificacion());
		boolean igualTramiteEmbargo = compruebaIgual(TOTAL, PARCIAL, this.tramiteEmbargo,
				otro.getTramiteEmbargo());
		boolean conFechaVista=compruebaIgual(SI, NO, this.conNuevaFecha, otro.getConNuevaFecha());

		return (igualCompleto && igualRespuesta && igualSentido && igualTieneProc && igualNotificacion && igualTramiteEmbargo && conFechaVista);

	}

	private boolean compruebaIgual(String positivo, String negativo,
			String valor, String otroValor) {

		boolean esIgual = false;

		if (Checks.esNulo(otroValor) || Checks.esNulo(valor)) {
			esIgual = true;
		} else if (valor.equalsIgnoreCase(otroValor)) {
			esIgual = true;
		} else if (valor.equalsIgnoreCase(positivo)
				&& (otroValor.equalsIgnoreCase(SI) || otroValor
						.equalsIgnoreCase(TRUE))) {
			esIgual = true;
		} else if (otroValor.equalsIgnoreCase(positivo)
				&& (valor.equalsIgnoreCase(SI) || valor.equalsIgnoreCase(TRUE))) {
			esIgual = true;
		} else if (valor.equalsIgnoreCase(negativo)
				&& (otroValor.equalsIgnoreCase(NO) || otroValor
						.equalsIgnoreCase(FALSE))) {
			esIgual = true;
		} else if (otroValor.equalsIgnoreCase(negativo)
				&& (valor.equalsIgnoreCase(NO) || valor.equalsIgnoreCase(FALSE))) {
			esIgual = true;
		}

		return esIgual;
	}

	public String getNotificacion() {
		return notificacion;
	}

	public void setNotificacion(String notificacion) {
		this.notificacion = notificacion;
	}

	public String getTramiteEmbargo() {
		return tramiteEmbargo;
	}

	public void setTramiteEmbargo(String tramiteEmbargo) {
		this.tramiteEmbargo = tramiteEmbargo;
	}

	public String getConNuevaFecha() {
		return conNuevaFecha;
	}

	public void setConNuevaFecha(String conNuevaFecha) {
		this.conNuevaFecha="NO";
		if (!Checks.esNulo(conNuevaFecha) && !"NO".equals(conNuevaFecha)){
			this.conNuevaFecha="SI";
		}
	}

	

}
