package es.pfsgroup.plugin.recovery.liquidaciones.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.DtoContabilidadCobros;
import es.pfsgroup.plugin.recovery.liquidaciones.model.ContabilidadCobros;

public interface ContabilidadCobrosDao extends AbstractDao<ContabilidadCobros, Long>{

	public static final String BO_GET_LISTADO_CONTABILIDAD_COBROS = "es.pfsgroup.plugin.recovery.liquidaciones.api.getListadoContabilidadCobrosByASUID";
	public static final String BO_GET_CONTABILIDAD_COBRO_BY_ID = "es.pfsgroup.plugin.recovery.liquidaciones.api.getContabilidadCobroByID";
	public static final String BO_ACTUALIZAR_CONTABILIDAD_COBROS_TAR_ID_BY_ASU_ID = "es.pfsgroup.plugin.recovery.liquidaciones.api.actualizarTARIDByASUID";

	/**
	 * Obtiene un listado de Contabilidad Cobros por el ID de asunto.
	 * 
	 * @param dto : objeto DtoContabilidadCobros para obtener el id de asunto.
	 * @return devuelve un objeto List<ContabilidadCobros> relleno con los
	 * 			cobros del asunto.
	 */
	@BusinessOperationDefinition(BO_GET_LISTADO_CONTABILIDAD_COBROS)
	List<ContabilidadCobros> getListadoContabilidadCobrosByASUID(DtoContabilidadCobros dto);
	
	/**
	 * Obtiene un cobro por su ID.
	 * 
	 * @param dto : objeto DtoContabilidadCobros para obtener el id del cobro.
	 * @return devuelve un objeto ContabilidadCobros relleno con su informacion.
	 */
	@BusinessOperationDefinition(BO_GET_CONTABILIDAD_COBRO_BY_ID)
	ContabilidadCobros getContabilidadCobroByID(DtoContabilidadCobros dto);

	/**
	 * Actualiza el campo de la tarea generada a un cobro dado su ID de asunto.
	 * 
	 * @param asuID : ID del asunto al que hace referencia el cobro que se ha de actualizar.
	 * @param tareaID : ID de la tarea para asignar al cobro.
	 */
	@BusinessOperationDefinition(BO_ACTUALIZAR_CONTABILIDAD_COBROS_TAR_ID_BY_ASU_ID)
	void actualizarTARIDByASUID(Long asuID, Long tareaID);
	
	/**
	 * Obtiene un listado de Contabilidad Cobros por asunto ID donde el campo
	 * de la tarea asociada no esta vacio y no han sido contabilizados.
	 * 
	 * @param dto
	 * @return
	 */
	List<ContabilidadCobros> getListadoContabilidadCobrosParaTareas(DtoContabilidadCobros dto);
}
