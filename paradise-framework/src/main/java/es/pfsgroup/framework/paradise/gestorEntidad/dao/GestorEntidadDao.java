package es.pfsgroup.framework.paradise.gestorEntidad.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.gestorEntidad.model.GestorEntidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;

public interface GestorEntidadDao extends AbstractDao<GestorEntidad, Long> {

	List<EXTDDTipoGestor> getListTipoGestorEditables(Long idTipoGestor);
	
	List<Usuario> getListUsuariosGestoresExpedientePorTipo(Long idTipoGestor);
	

	String getCodigoGestorPorUsuario(Long idUsuario);

	List<Usuario> getListUsuariosGestoresPorTipoCodigo(String codigoTipoGestor);

}
