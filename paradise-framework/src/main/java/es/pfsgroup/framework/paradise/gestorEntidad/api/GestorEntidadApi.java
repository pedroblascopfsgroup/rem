package es.pfsgroup.framework.paradise.gestorEntidad.api;

import java.util.List;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;


/**
 * Mánager de la entidad.
 * 
 * @author Oscar
 * 
 */
public interface GestorEntidadApi {

	List<GestorEntidadHistorico> getListGestoresActivosAdicionalesHistoricoData(GestorEntidadDto dto);
	List<GestorEntidadHistorico> getListGestoresAdicionalesHistoricoData(GestorEntidadDto dto);
	void insertarGestorAdicionalEntidad(GestorEntidadDto dto);
	void borrarGestorAdicionalEntidad(GestorEntidadDto dto);
	List<EXTDDTipoGestor> getListTipoGestorEditables(Long idTipoGestor);
	List<Usuario> getListUsuariosGestoresExpedientePorTipo(Long idTipoGestor);
	String getCodigoGestorPorUsuario(Long idUsuario);
	List<Usuario> getListUsuariosGestoresPorTipoCodigo(String codigoTipoGestor);
}