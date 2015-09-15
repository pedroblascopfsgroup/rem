package es.pfsgroup.plugin.recovery.mejoras.api.registro;

import java.util.Map;

public interface MEJTrazaDto {
	
	public static final String USUARIO = "usuario";
	public static final String TIPO_UNIDAD_GESTION = "tipoUnidadGestion";
	public static final String TIPO_EVENTO = "tipoEvento";
	public static final String ID_UNIDAD_GESTION = "idUnidadGestion";
	public static final String INFORMACION_ADICIONAL = "informacionAdicional";

	/**
	 * C�digo del tipo de evento
	 * @return
	 */
	String getTipoEvento();
	
	/**
	 * C�digo del tipo de Unidad de Gesti�n
	 * @return
	 */
	String getTipoUnidadGestion();
	
	/**
	 * ID de la Unidad de Gesti�n
	 * @return
	 */
	long getIdUnidadGestion();
	
	/**
	 * Id del Usuario que genera el vento
	 * @return
	 */
	long getUsuario();
	
	/**
	 * Informaci�n adicional de la que queremos dejar traza
	 * @return
	 */
	Map<String, Object> getInformacionAdicional();

}
