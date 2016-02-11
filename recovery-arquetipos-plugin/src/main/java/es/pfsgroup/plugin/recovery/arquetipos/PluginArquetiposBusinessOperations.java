package es.pfsgroup.plugin.recovery.arquetipos;

public class PluginArquetiposBusinessOperations {
	
	/**
	 * @param id del arquetipo que queremos devolver
	 * @return devuelve el objeto ARQListaArquetipo cuyo id coincide con el que le pasamos como parámetro
	 */
	public static final String ARQ_MGR_GET = "plugin.arquetipos.arquetipos.getArquetipo";

	/**
	 * devuelve una lista con todos los arquetipos dados de alta en la base de datos
	 */
	public static final String ARQ_MGR_LISTA = "plugin.arquetipos.arquetipos.listaArquetipos";
	
	/**
	 * @param id del modelo
	 * @return devuelve todos los arquetipos que no están dados de alta
	 * en ese modelo
	 */
	public static final String ARQ_MGR_RESTO_ARQUETIPOS = "plugin.arquetipos.arquetipos.listaRestoArquetipos";
	
	/**
	 * 
	 * @param dto 
	 * @return Devuelve una lista paginada con todos los arquetipos 
	 * que se adaptan a los criterios de búsqueda
	 * Debemos de poder buscar por nombre y por paquete asociado al arquetipo
	 * Si no le metemos ningún criterio de búsqueda deberá devolver la lista de 
	 * todos los arquetipos existentes en la base de datos
	 */
	public static final String ARQ_MGR_FIND = "plugin.arquetipos.arquetipos.findArquetipos";
	
	/**
	 *  Almacena un arquetipo.
	 * 
	 * Este método sirve tanto para dar de alta un nuevo arquetipo como
	 * para modificar uno existente. En el caso que el DTO contenga el id del
	 * arquetipo intentará actualizarlo, si no creará uno nuevo.
	 * 
	 * @param dtoArquetipo
	 */
	public static final String ARQ_MGR_SAVE = "plugin.arquetipos.arquetipos.save";
	
	/**
	 * Elimina de la lista el arquetipo que hemos seleccionado
	 * @return Si el id del arquetipo no existe o se le pasa como entrada
	 *         un null se deberá lanzar una excepción
	 */
	public static final String ARQ_MGR_REMOVE = "plugin.arquetipos.arquetipos.remove";
	
	/**
	 * @return devuelve el objeto RuleDefinition cuyo id coincide con el que se le pasa como parámetro
	 * @param id
	 */
	public static final String RULE_MGR_GET = "plugin.arquetipos.rules.getRule";
	
	/**
	 * devulve la lista de todos los paquetes dados de alta en la base de datos
	 * 
	 */
	public static final String RULE_MGR_LIST = "plugin.arquetipos.rules.lista";
	
	/**
	 * @param id
	 * @return devuelve el modelo cuyo id coincide con el que le pasamos como parámetro
	 */
	public static final String MODELO_MGR_GET = "plugin.arquetipos.modelos.getModelo";
	
	/**
	 * @param dto
	 * @return devuelve la lista de todos los modelos de arquetipos dados de alta en la base de datos
	 */
	public static final String MODELO_MGR_LIST = "plugin.arquetipos.modelos.listaModelos";
	
	/**
	 * Devuelve una lista paginada de modelos de arquetipos con el resultado de la búsqueda
	 * según los criterios de búsqueda del dto
	 */
	public static final String MODELO_MGR_FIND = "plugin.arquetipos.modelos.findModelos";
	
	
	/**
	 *  Almacena un modelo.
	 * 
	 * Este método sirve tanto para dar de alta un nuevo modelo como
	 * para modificar uno existente. En el caso que el DTO contenga el id del
	 * modelo intentará actualizarlo, si no creará uno nuevo.
	 * 
	 * @param dtoModelo 
	 */
	public static final String MODELO_MGR_SAVE = "plugin.arquetipos.modelos.save";
	
	
	/**
	 * Elimina de la lista el modelo que hemos seleccionado
	 * @return Si el id del arquetipo no existe o se le pasa como entrada
	 *         un null se deberá lanzar una excepción
	 */
	public static final String MODELO_MGR_REMOVE = "plugin.arquetipos.modelos.remove";
	
	
	/**
	 * @param id del modelo que desea liberar
	 * Pasa a estado vigente el modelo cuyo id le pasamos como parámetro. Al hacer esto
	 * el modelo que se encontrara en ese momento como vigente pasará a estado HISTÓRICO
	 */
	public static final String MODELO_MGR_LIBERA ="plugin.arquetipos.modelos.libera";
	
	/**
	 * @param id del modelo que se desea copiar
	 * 
	 */
	public static final String MODELO_MGR_COPIA = "plugin.arquetipos.modelos.copiaModelo";
	
	

	/**
	 * @return devuelve la lista de todos los estados posibles de un modelo de arquetipos
	 */
	public static final String ESTADOS_MGR_LIST = "plugin.arquetipos.estadoModelo.listaEstados";
	
	/**
	 * @param el id del estado que queremos recuperar
	 * @return el objeto ARQDDEstadoModelo que coincide con el id que se le pasa
	 */
	public static final String ESTADOS_MGR_GET = "plugin.arquetipos.ddEstado.get";
	
	/**
	 * @param id de la relación entre modelos y arquetipos
	 * @return devuelve el objeto ARQModeloArquetipo cuyo id coincide con el que le pasamos 
	 * como entrada
	 */
	public static final String MODELOARQUETIPO_MGR_GET="plugin.arquetipos.modelosArquetipos.getModeloArquetipo";
	
	/**
	 * @param se le pasa como entrada el id de la relación arquetipos-modelo y el id del modelo al que pertenece ese
	 * arquetipo
	 * Este método marcará como borrado lógico esa relación y les subirá la prioridad a todos los arquetipos que
	 * tengan una prioridad menor
	 */
	public static final String MODELOARQUETIPO_MGR_REMOVE = "plugin.arquetipos.modelosArquetipos.remove";
	
	/**
	 * @param id del modelo
	 * @return devuelve la lista de todos los arquetipos que pertenecen al modelo que coincide con el id
	 * que se le pasa como entrada
	 */
	public static final String MODELOARQUETIPO_MGR_LISTA_ARQUETIPOS = "plugin.arquetipos.modelosArquetipos.listaArquetiposModelo";
	
	/**
	 * @param id del modelo
	 * @return devuelve una lista de objetos dtoEditarArqsMod
	 * Se usa para mapear los cambios en el grid editable
	 */
	public static final String MODELOARQUETIPO_MGR_LISTA_DTOARQUETIPOS="plugin.arquetipos.modelosArquetipos.listaDtoArquetiposModelo";
	
	/**
	 * @param dtoModeloArquetipo
	 * Sirve tanto para insertar relaciones nuevas como para modificar las ya existentes
	 */
	public static final String MODELOARQUETIPO_MGR_SAVE = "plugin.arquetipos.modelosArquetipos.save";
	
	/**
	 * @param dtoEditarArqsMod es un dto que tiene el id, el campo y el valor
	 * Modifica del objeto que coincide con el id el campo que se le pasa y se le da el valor
	 *
	 */
	public static final String MODELOARQUETIPO_MGR_EDITARQS = "plugin.arquetipos.modelosArquetipos.editarArqMod";
	
	/**
	 * @param dtoInsertarArquetiposModelo
	 * Guarda en la tabla MAR_MODELO_ARQUETIPO el arquetipo con los valores que se le pasan en el Dto
	 */
	public static final String MODELOARQUETIPO_MGR_INSERTAR_ARQ ="plugin.arquetipos.modelosArquetipos.insertarArqsMod";
	
	/**
	 * @param id del la entrada ModeloArquetipo
	 * aumenta la prioridad del arquetipo dentro del modelo y le baja la prioridad al que tenga una prioridad superior a la suya
	 * 
	 */
	public static final String MODELOARQUETIPO_MGR_SUBIRPRIORIDAD ="plugin.arquetipos.modelosArquetipos.subirPrioridad";
	
	/**
	 * @param id del la entrada ModeloArquetipo
	 * baja la prioridad del arquetipo dentro del modelo y le sube la prioridad al que tenga una prioridad inferior a la suya
	 * 
	 */
	public static final String MODELOARQUETIPO_MGR_BAJARPRIORIDAD="plugin.arquetipos.modelosArquetipos.bajarPrioridad";
	
	/**
	 * @param id del modelo original y el modelo copiado
	 * Crea tantas instancias como arquetipos asociados tiene el modelo original de la clase
	 * ARQModeloArquetipos, exactamente iguales pero con otro id del modelo
	 */
	public static final String MODELOARQUETIPO_MGR_COPIAARQ = "plugin.arquetipos.modelosArquetipos.copiaArquetipos";
	
	/**
	 * @return devuelve la lista de todos los itinerarios definidos para una entidad
	 * 
	 */
	public static final String ITINERARIO_MGR_LISTA_ITINERARIOS ="plugin.arquetipos.itinerario.listaItinerario";
	
	public static final String ITINERARIO_MGR_GET="plugin.arquetipos.itinerario.getItinerario";
	
	public static final String DDSINO_MGR_LISTA = "plugin.arquetipos.ddSiNo.lista";
	
	
	
	/**
	 * @return devuelve el objeto DDTipoSaltoNivel cuyo id coincide con el parámetro que se le pasa
	 * @param id del objeto
	 */
	public static final String DDTSN_MGR_GET ="plugin.arquetipos.ddTipoSalto.getTipoSalto";
	
	/**
	 * @return delvuelve la lista de todos los tipos de salto dados de alta en la base de datos
	 */
	public static final String DDTSN_MGR_LISTA = "plugin.arquetipos.ddTipoSalto.lista";
	
	/**
	 * Muestra los arquetipos del modelo vigente
	 * @return
	 */
	public static final String SIM_MUESTRA_MODELO_VIGENTE = "plugin.arquetipos.simulacion.muestraModeloVigente";
	
	
	/**
	 * Muestra los arquetipos de un deterrminado modelo
	 * @param idModelo
	 * @return
	 */
	public static final String SIM_MUESTRA_MODELO = "plugin.arquetipos.simulacion.muestraModelo";
	
	/**
	 * Ejecuta una simulación
	 * @return
	 */
	public static final String SIM_SIMULA_MODELO_VIGENTE = "plugin.arquetipos.simulacion.simulaModeloVigente";
	
	
	/**
	 * Ejecuta una simulación de un deterrminado modelo
	 * @param idModelo
	 * @return
	 */
	public static final String SIM_SIMULA_MODELO = "plugin.arquetipos.simulacion.simulaModelo";
	
	/**
	 * Deja pendiente de simulación un determinado modelo preparado para que dejarlo en estado simulación
	 * @param idModelo
	 * @return
	 */
	public static final String SIM_PENDIENTE_SIMULACION = "plugin.arquetipos.simulacion.pendienteSimulacionModelo";
	
	/**
	 * Deja pendiente de simulación un determinado modelo preparado para que dejarlo en estado simulación
	 * @param idModelo
	 * @return
	 */
	public static final String SIM_CANCELAR_PENDIENTE_SIMULACION = "plugin.arquetipos.simulacion.cancelarPendienteSimulacionModelo";

	
}
