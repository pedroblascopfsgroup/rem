package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.dao.SessionFactoryFacade;

@Repository
public class CambiosBDDao extends AbstractEntityDao<CambioBD, Long> {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private SessionFactoryFacade sesionFactoryFacade;

	public List<CambioBD> listCambios(Class dtoClass, InfoTablasBD infoTablas) {
		if (dtoClass == null) {
			throw new IllegalArgumentException("'dtoClass' no puede ser NULL");
		}

		if (infoTablas == null) {
			throw new IllegalArgumentException("'infoTablas' no puede ser NULL");
		}

		Session session = this.sesionFactoryFacade.getSession(this);
		ArrayList<CambioBD> cambios = new ArrayList<CambioBD>();

		try {
			DbIdContextHolder.setDbId(1L);
			String queryString = "SELECT * FROM " + infoTablas.nombreVistaDatosActuales() + " MINUS SELECT * FROM "
					+ infoTablas.nombreTablaDatosHistoricos() + "";
			;
			Query query = createQuery(session, queryString);
			List<Object[]> resultado = query.list();

			if (resultado != null) {
				for (Object[] r : resultado) {
					String[] fields = getDtoFields(dtoClass);
					CambioBD cambio = new CambioBD(fields);
					cambio.setDatosActuales(r);
					Object[] historico = (Object[]) session.createSQLQuery(
							"SELECT " + columns4Select(fields) + " FROM " + infoTablas.nombreTablaDatosHistoricos()
									+ " WHERE " + infoTablas.clavePrimaria() + " = " + r[0])
							.uniqueResult();
					cambio.setDatosHistoricos(historico);
					cambios.add(cambio);

				}
			}
		} finally {
			if (session != null) {
				if (session.isOpen()) {
					session.close();
				}
			}
		}

		return cambios;

	}

	public void marcaComoEnviados(InfoTablasBD infoTablas) {

		if (infoTablas == null) {
			throw new IllegalArgumentException("'infoTablas' no puede ser NULL");
		}

		Session session = this.sesionFactoryFacade.getSession(this);
		Transaction tx = session.beginTransaction();
		try {
			createQuery(session, "DELETE FROM " + infoTablas.nombreTablaDatosHistoricos()).executeUpdate();
			createQuery(session, "INSERT INTO " + infoTablas.nombreTablaDatosHistoricos() + " SELECT * FROM "
					+ infoTablas.nombreVistaDatosActuales()).executeUpdate();
			tx.commit();
		} catch (Throwable t) {
			logger.fatal("Error al marcar como enviados los registros de la BD", t);
			tx.rollback();
		} finally {
			if (session != null) {
				if (session.isOpen()) {
					session.close();
				}
			}
		}
	}

	private String[] getDtoFields(Class dtoClass) {
		ArrayList<String> fields = new ArrayList<String>();

		for (Field f : dtoClass.getDeclaredFields()) {
			fields.add(f.getName());
		}

		return fields.toArray(new String[] {});
	}

	private String columns4Select(String[] fields) {
		StringBuilder b = new StringBuilder();
		String separador = "";
		for (String s : fields) {
			String s2 = s.replaceAll("([A-Z])", "_$1").toUpperCase();
			b.append(separador).append(s2);
			separador = ", ";
		}
		return b.toString();
	}

	private SQLQuery createQuery(Session session, String queryString) {
		return session.createSQLQuery(queryString);
	}

	/**
	 * @param entitySessionFactory
	 *            SessionFactory
	 */
	@Resource
	public void setEntitySessionFactory(SessionFactory entitySessionFactory) {
		super.setSessionFactory(entitySessionFactory);
	}

}
