package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dao.impl;

import java.text.ParseException;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dao.CambioMasivoGestoresAsuntoDao;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.model.PeticionCambioMasivoGestoresAsunto;

/**
 * Implementación de  los DAO's del cambio de gestores
 * @author bruno
 *
 */
@Repository
public class CambioMasivoGestoresAsuntoDaoImpl extends AbstractEntityDao<PeticionCambioMasivoGestoresAsunto, Long> implements CambioMasivoGestoresAsuntoDao{

	@Autowired
	private CambioMasivoGestoresAsuntoDaoSQL sqls;
	
	@Override
	public void insertDirectoPeticiones(Usuario solicitante, String tipoGestor, Long idGestorOriginal, Long idNuevoGestor, Date fechaInicio, Date fechaFin) {
		Query query = getSession().createSQLQuery(sqls.getInsertDirectoPeticiones());
		parametrizaQuery(solicitante, tipoGestor, idGestorOriginal, idNuevoGestor, fechaInicio, fechaFin, query);
		
		query.executeUpdate();
	}

	@Override
	public int contarPeticiones(Usuario solicitante, String tipoGestor, Long idGestorOriginal, Long idNuevoGestor, Date fechaInicio, Date fechaFin) {
		Query query = getSession().createSQLQuery(sqls.getCountPeticiones());
		parametrizaQuery(null, tipoGestor, idGestorOriginal, idNuevoGestor, fechaInicio, fechaFin, query);
		
		List result = query.list();
		return result.size();
	}
	
	private void parametrizaQuery(Usuario solicitante, String tipoGestor, Long idGestorOriginal, Long idNuevoGestor, Date fechaInicio, Date fechaFin, Query query) {
		query.setParameter(sqls.getCodigoTipoGestor(), tipoGestor);
		query.setParameter(sqls.getIdGestorOriginal(), idGestorOriginal);
		
		query.setParameter(sqls.getIdGestorNuevo(), idNuevoGestor);
		
		if (!Checks.esNulo(solicitante)){
			query.setParameter(sqls.getIdSolicitante(), solicitante.getId());
		}
		query.setParameter(sqls.getFechaInicio(), fechaInicio);
		
		if (Checks.esNulo(fechaFin)){
			try {
				fechaFin = DateFormat.toDate("31/12/9999");
			} catch (ParseException e) {
			}
		}
		
		query.setParameter(sqls.getFechaFin(), fechaFin);
		
		if (!Checks.esNulo(solicitante)){
			query.setParameter(sqls.getUsuarioCrear(), solicitante.getUsername());
		}
		
	}

}
