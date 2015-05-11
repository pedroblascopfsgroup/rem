package es.pfsgroup.recovery.ext.api.multigestor;

import java.util.List;

import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.ext.api.asunto.EXTUsuarioRelacionadoInfo;

/**
 * Operaciones de negocio para el paquete de multigestor.
 * 
 * @author bruno
 * 
 */
public interface EXTMultigestorApi {

	public static String COD_UG_CLIENTE = DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE;
	public static String COD_UG_EXPEDIENTE = DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE;
	public static String COD_UG_CONTRATO = DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO;
	public static String COD_UG_ASUNTO = DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO;
	public static String COD_UG_PROCEDIMIENTO = DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO;

	public static final String EXT_BO_MULTIGESTOR_DAME_GESTORES = "es.pfsgroup.recovery.ext.api.multigestor.dameGestores";

	public static final String EXT_BO_MULTIGESTOR_ADD_GESTORES = "es.pfsgroup.recovery.ext.api.multigestor.addGestores";
	public static final String EXT_BO_MULTIGESTOR_ADD_GESTOR = "es.pfsgroup.recovery.ext.api.multigestor.addGestor";
	public static final String EXT_BO_MULTIGESTOR_REMOVE_GESTOR = "es.pfsgroup.recovery.ext.api.multigestor.removeGestor";
	public static final String EXT_BO_MULTIGESTOR_EXISTE_GESTOR = "es.pfsgroup.recovery.ext.api.multigestor.existeGestor";

	/**
	 * Devuelve una lista con los gestores asociados a una Unidad de Gestión
	 * 
	 * @param ugCodigo
	 *            Código que identifica el tipo de Unidad de Gestión que
	 *            queremos buscar. Pueden usarse las constantes COD_UG_*
	 *            definidas en esta interfaz.
	 * 
	 * @param ugId
	 *            ID de la Unidad de Gestión
	 * @return
	 */
	@BusinessOperationDefinition(EXT_BO_MULTIGESTOR_DAME_GESTORES)
	List<EXTGestorInfo> dameGestores(String ugCodigo, Long ugId);

	/**
	 * Esta operación de negocio añade uno o varios Gestores a una Unidad de
	 * Gestión <b>siempre que todos ellos sean el mismo Tipo de Gestor</b>
	 * 
	 * @param ugCodigo
	 *            Código que identifica el tipo de Unidad de Gestión que
	 *            queremos buscar. Pueden usarse las constantes COD_UG_*
	 *            definidas en esta interfaz.
	 * 
	 * @param ugId
	 *            ID de la Unidad de Gestión
	 * 
	 * @param codTipoGestor
	 *            Código del Tipo de Gestor que deben tener los Usuarios para la
	 *            Unidad de Gestión
	 * 
	 * @param idUsuarios
	 *            Lista de ID's de Usuarios que se quieren añadir como gestores
	 *            a la Unidad de Gestión
	 */
	@BusinessOperationDefinition(EXT_BO_MULTIGESTOR_ADD_GESTORES)
	void addGestores(String ugCodigo, Long ugId, String codTipoGestor,
			List<Long> idUsuarios);
	
	@BusinessOperationDefinition(EXT_BO_MULTIGESTOR_ADD_GESTOR)
	void addGestor(String ugCodigo, Long ugId, String codTipoGestor,
			Long idUsuarios);
	
	@BusinessOperationDefinition(EXT_BO_MULTIGESTOR_REMOVE_GESTOR)
	void removeGestor(Long idAsunto, Long idGestor);
	
	@BusinessOperationDefinition(EXT_BO_MULTIGESTOR_EXISTE_GESTOR)
	public boolean existeTipoGestor(String ugCodigo, Long ugId, Long tipoGestor, Long idUsuario);


}
