package es.capgemini.pfs.multigestor.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.multigestor.model.EXTTipoGestorPropiedad;
import es.capgemini.pfs.users.domain.Usuario;

public interface EXTGestorAdicionalAsuntoDao extends
		AbstractDao<EXTGestorAdicionalAsunto, Long> {

	List<Usuario> findGestoresByAsunto(Long idAsunto, String tipoGestor);
	
	List<DespachoExterno> getTipoDespachoExternoList(long idUsuario);
	List<EXTTipoGestorPropiedad> getTipoGestorPropiedadList(String codSta);

	List<EXTGestorAdicionalAsunto> findGestorAdicionalesByAsunto(Long idAsunto);

}
