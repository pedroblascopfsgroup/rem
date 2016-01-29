package es.pfsgroup.plugin.recovery.expediente.gestorEntidad.api;

import java.util.List;

import es.capgemini.pfs.gestorEntidad.model.GestorEntidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.expediente.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.plugin.recovery.expediente.gestorEntidad.model.GestorEntidadHistorico;

/**
 * Mánager de la entidad.
 * 
 * @author Oscar
 * 
 */
public interface GestorEntidadApi {

	public static final String BO_BORRAR_GESTOR_ADICIONAL_ENTIDAD = "es.pfsgroup.recovery.gestorEntidad.api.borrarGestorAdicionalEntidad";
	public static final String BO_INSERTAR_GESTOR_ADICIONAL_ENTIDAD = "es.pfsgroup.recovery.gestorEntidad.api.insertarGestorAdicionalEntidad";
	public static final String BO_GET_LIST_GESTORES_ADICIONALES_HISTORICO = "es.pfsgroup.recovery.gestorEntidad.api.getListGestoresAdicionalesHistorico";
	public static final String GET_LISTADO_TIPO_GESTOR_EDITABLE = "es.pfsgroup.recovery.gestorEntidad.api.getListTipoGestorEditableoData";
	public static final String GET_LISTADO_GESTOREXPEDIENTE_POR_TIPO = "es.pfsgroup.recovery.gestorEntidad.api.getListGestorExpedientePorTipo";

	@BusinessOperationDefinition(BO_GET_LIST_GESTORES_ADICIONALES_HISTORICO)
	List<GestorEntidadHistorico> getListGestoresAdicionalesHistoricoData(GestorEntidadDto dto);

	@BusinessOperationDefinition(BO_INSERTAR_GESTOR_ADICIONAL_ENTIDAD)
	void insertarGestorAdicionalEntidad(GestorEntidadDto dto);

	@BusinessOperationDefinition(BO_BORRAR_GESTOR_ADICIONAL_ENTIDAD)
	void borrarGestorAdicionalEntidad(GestorEntidadDto dto);

	@BusinessOperationDefinition(GET_LISTADO_TIPO_GESTOR_EDITABLE)
	List<EXTDDTipoGestor> getListTipoGestorEditables(Long idTipoGestor);
	
	@BusinessOperationDefinition(GET_LISTADO_GESTOREXPEDIENTE_POR_TIPO)
	List<Usuario> getListUsuariosGestoresExpedientePorTipo(Long idTipoGestor);

}