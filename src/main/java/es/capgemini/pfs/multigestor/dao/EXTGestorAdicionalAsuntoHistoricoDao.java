package es.capgemini.pfs.multigestor.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsuntoHistorico;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;


/**
 * Dao de la entidad  {@link EXTGestorAdicionalAsuntoHistorico}
 * 
 * @author manuel
 *
 */
public interface EXTGestorAdicionalAsuntoHistoricoDao extends AbstractDao<EXTGestorAdicionalAsuntoHistorico, Long>{

	/**
	 * Acutaliza el valor del campo fechaHasta para todos los objetos del histórico que cumple con las condiciones de filtrado.
	 * Filtrado por idAsunto e idTipoGestor.
	 *
	 * @param idAsunto
	 * @param idTipoGestor
	 */
	void actualizaFechaHasta(Long idAsunto, Long idTipoGestor);

	/**
	 * Dao que devuelve una lista de {@link EXTGestorAdicionalAsuntoHistorico} ordenada por 
	 * 'tipoGestor.descripcion asc,fechaDesde desc' (campos de EXTGestorAdicionalAsuntoHistorico)
	 * Filtrado por idAsunto
	 * 
	 * @param idAsunto id del asunto
	 * @return Lista de {@link EXTGestorAdicionalAsuntoHistorico}
	 */
	List<EXTGestorAdicionalAsuntoHistorico> getListOrderedByAsunto(Long idAsunto);

}
