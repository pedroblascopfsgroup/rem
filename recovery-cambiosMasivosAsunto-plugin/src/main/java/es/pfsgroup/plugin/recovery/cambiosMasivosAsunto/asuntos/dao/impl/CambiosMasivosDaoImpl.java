package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.asuntos.dao.impl;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.asuntos.dao.CambiosMasivosDao;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dao.impl.CambioMasivoGestoresAsuntoDaoSQL;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.model.PeticionCambioMasivoGestoresAsunto;

@Repository("CambiosMasivosDao")
public class CambiosMasivosDaoImpl extends
		AbstractEntityDao<PeticionCambioMasivoGestoresAsunto, Long> implements
		CambiosMasivosDao {

	@Autowired
	private CambioMasivoGestoresAsuntoDaoSQL sqls;

	@Override
	public List<PeticionCambioMasivoGestoresAsunto> buscarCambioGestoresPendientesPaginados(
			Long idAsunto) {

		Query q = getHibernateTemplate()
				.getSessionFactory()
				.getCurrentSession()
				.createQuery(
						"select cma from PeticionCambioMasivoGestoresAsunto cma "
								+ "where cma.asunto.id = :idAsunto AND "
								+ "		cma.auditoria.borrado = 0 AND "
								+ " 	    (cma.fechaInicio > current_date()) ");
		q.setParameter("idAsunto", idAsunto);
		List<PeticionCambioMasivoGestoresAsunto> resultado = q.list();

		return resultado;

	}

	@Override
	public void insertDirectoPeticionesPorAsuntos(Usuario solicitante,
			String tipoGestor, Long idNuevoGestor, Date fechaInicio,
			Date fechaFin, List<Long> listaAsuntos) {

		String cadenaConAsuntos = null;
		for (Long idAsunto : listaAsuntos) {
			if (cadenaConAsuntos == null) {
				cadenaConAsuntos = String.valueOf(idAsunto);
			}
			cadenaConAsuntos = cadenaConAsuntos + ", "
					+ String.valueOf(idAsunto);
		}

		Query query = getSession().createSQLQuery(
				sqls.getInsertDirectoPeticionesPorAsunto()
						+ " and vtar.ASU_ID in (" + cadenaConAsuntos + ")");
		parametrizaQuery(solicitante, tipoGestor, idNuevoGestor, fechaInicio,
				fechaFin, listaAsuntos, query);

		query.executeUpdate();
	}

	private void parametrizaQuery(Usuario solicitante, String tipoGestor,
			Long idNuevoGestor, Date fechaInicio, Date fechaFin,
			List<Long> listaAsuntos, Query query) {
		query.setParameter(sqls.getCodigoTipoGestor(), tipoGestor);
		query.setParameter(sqls.getIdGestorNuevo(), idNuevoGestor);

		if (!Checks.esNulo(solicitante)) {
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

		if (!Checks.esNulo(solicitante)) {
			query.setParameter(sqls.getUsuarioCrear(),
					solicitante.getUsername());
		}

		// query.setParameter(sqls.getAsuntosAmodificar(), listaAsuntos);

	}
}
