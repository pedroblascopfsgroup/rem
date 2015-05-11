package es.pfsgroup.plugin.recovery.mejoras.api.registro;

import java.util.Map;

public interface MEJTrazaDto {
	
	public static final String USUARIO = "usuario";
	public static final String TIPO_UNIDAD_GESTION = "tipoUnidadGestion";
	public static final String TIPO_EVENTO = "tipoEvento";
	public static final String ID_UNIDAD_GESTION = "idUnidadGestion";
	public static final String INFORMACION_ADICIONAL = "informacionAdicional";

	/**
	 * Código del tipo de evento
	 * @return
	 */
	String getTipoEvento();
	
	/**
	 * Código del tipo de Unidad de Gestión
	 * @return
	 */
	String getTipoUnidadGestion();
	
	/**
	 * ID de la Unidad de Gestión
	 * @return
	 */
	long getIdUnidadGestion();
	
	/**
	 * Id del Usuario que genera el vento
	 * @return
	 */
	long getUsuario();
	
	/**
	 * Información adicional de la que queremos dejar traza
	 * @return
	 */
	Map<String, Object> getInformacionAdicional();

}
