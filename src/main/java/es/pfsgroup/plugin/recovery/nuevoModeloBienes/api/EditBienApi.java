package es.pfsgroup.plugin.recovery.nuevoModeloBienes.api;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdicionalBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBEmbargoProcedimiento;

/**
 * API con las operaciones de negocio para Editar Bienes.
 * @author bruno
 *
 */
public interface EditBienApi {

	String PLUGIN_BIENES_EDIT_BIEN_API_BORRAR_PESONA_BIEN = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.EditBienApi.borrarPersonaBien";
	String PLUGIN_BIENES_EDIT_BIEN_API_GET_EMBARGO_PROCEDIMIENTO = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.EditBienApi.getEmbargoProcedimiento";
	String PLUGIN_BIENES_EDIT_BIEN_API_GET_BIEN = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.EditBienApi.getBien";
	String PLUGIN_BIENES_EDIT_BIEN_API_GET_PROCEDIMIENTO = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.EditBienApi.getProcedimiento";
	String PLUGIN_BIENES_EDIT_BIEN_API_GUARDA_EMBARGO_PROCEDIMIENTO = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.EditBienApi.guardaEmbargoProcedimiento";
	String PLUGIN_BIENES_EDIT_BIEN_API_BORRAR_BIEN_CONTRATO = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.EditBienApi.borrarBienContrato";
	String PLUGIN_BIENES_EDIT_BIEN_API_GUARDAR_ADJUDICACION = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.EditBienApi.guardarAdjudicacion";
	String PLUGIN_BIENES_EDIT_BIEN_API_GUARDAR_ADICIONAL = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.EditBienApi.guardarAdicional";
	String PLUGIN_BIENES_EDIT_BIEN_API_GET_CARGA = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.EditBienApi.getCarga";
	String PLUGIN_BIENES_EDIT_BIEN_API_GUARDAR_CARGA = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.EditBienApi.guardarCarga";	
	String PLUGIN_BIENES_EDIT_BIEN_API_BORRAR_CARGA = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.EditBienApi.borrarCarga";	
	String PLUGIN_BIENES_GET_PROCEDIMEINTO_BIEN = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.EditBienApi.getProcedimientosBien";	
	
	
	/**
	 * Elimina la relaci�n del Bien con la Persona, NMBPersonasBien
	 * @param id ID de la realaci�n Bien Persona
	 */
	@BusinessOperationDefinition(PLUGIN_BIENES_EDIT_BIEN_API_BORRAR_PESONA_BIEN)
	void borrarRelacionPersonaBien(Long id);

	/**
	 * Obtiene una relaci�n {@link NMBEmbargoProcedimiento}
	 * @param idEmbargo
	 * @return
	 */
	@BusinessOperationDefinition(PLUGIN_BIENES_EDIT_BIEN_API_GET_EMBARGO_PROCEDIMIENTO)
	NMBEmbargoProcedimiento getEmbargoProcedimiento(Long idEmbargo);

	/**
	 * Devuelve un Bien.
	 * @param idBien
	 * @return
	 */
	@BusinessOperationDefinition(PLUGIN_BIENES_EDIT_BIEN_API_GET_BIEN)
	NMBBien getBien(long idBien);

	/**
	 * Devuelve un Procedimiento
	 * @param idProcedimiento
	 * @return
	 */
	@BusinessOperationDefinition(PLUGIN_BIENES_EDIT_BIEN_API_GET_PROCEDIMIENTO)
	Procedimiento getProcedimiento(long idProcedimiento);

	/**
	 * Guarda una relaci�n {@link NMBEmbargoProcedimiento}
	 * @param nmbEmbargoProcedimiento
	 */
	@BusinessOperationDefinition(PLUGIN_BIENES_EDIT_BIEN_API_GUARDA_EMBARGO_PROCEDIMIENTO)
	void guardaEmbargoProcedimiento(
			NMBEmbargoProcedimiento nmbEmbargoProcedimiento);

	@BusinessOperationDefinition(PLUGIN_BIENES_EDIT_BIEN_API_BORRAR_BIEN_CONTRATO)
	void borrarRelacionBienContrato(Long id);

	@BusinessOperationDefinition(PLUGIN_BIENES_EDIT_BIEN_API_GUARDAR_ADJUDICACION)
	void guardarAdjudicacion(NMBAdjudicacionBien adjudicacion);
	
	@BusinessOperationDefinition(PLUGIN_BIENES_EDIT_BIEN_API_GUARDAR_ADICIONAL)
	void guardarRevisionCargas(NMBAdicionalBien adicional);
	
	/**
	 * Devuelve una carga.
	 * @param idCarga
	 * @return
	 */
	@BusinessOperationDefinition(PLUGIN_BIENES_EDIT_BIEN_API_GET_CARGA)
	NMBBienCargas getCarga(long idCarga);
	
	@BusinessOperationDefinition(PLUGIN_BIENES_EDIT_BIEN_API_GUARDAR_CARGA)
	void guardarCarga(NMBBienCargas carga);
	
	@BusinessOperationDefinition(PLUGIN_BIENES_EDIT_BIEN_API_BORRAR_CARGA)
	void borrarCarga(Long idCarga);	

}
