package es.pfsgroup.plugin.controlcalidad.constantes;

/**
 * Interfaz de constantes para el plugin de Control de Calidad
 * @author Guillem
 *
 */
public interface ControlCalidadConstants {

	/**
	 * Clase de constantes genéricas para el plugin de Control de Calidad
	 * @author Guillem
	 *
	 */
	public static class Genericas{
		
		public final static String VACIO = "";		
		public final static String ID = "id";
		public final static String CODIGO = "codigo";
		public final static String TIPO_CONTROL_CALIDAD = "tipoControlCalidad";
		public final static String ID_ENTIDAD = "idEntidad";
		public final static String TIPO_ENTIDAD = "tipoEntidad";
		
	}	
	
	/**
	 * Clase de constantes para el Manager del Control de Calidad
	 * @author Guillem
	 *
	 */
	public static class ControlCalidadConstantes{
		
		public final static String BO_CONTROL_CALIDAD_REGISTRAR_INCIDENCIA_PROCEDIMIENTO_RECOBRO = "plugin.controlcalidad.controlCalidadManager.registrarIncidenciaProcedimientoRecobro";
		public final static String EXCEPCION_REGISTRAR_INCIDENCIA_PROCEDIMIENTO_RECOBRO = "Se ha producido una excepción en el método registrarIncidenciaProcedimientoRecobro: ";		
		public final static String EXCEPCION_REGISTRAR_INCIDENCIA = "Se ha producido una excepción en el método registrarIncidencia: ";
		public final static String DESCRIPCION_CONTROL_CALIDAD_EXPEDIENTE_RECOBRO = "";
		
	}	
	
}
