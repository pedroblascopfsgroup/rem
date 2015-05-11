package es.pfsgroup.plugin.recovery.masivo.dao.impl;

import org.hibernate.HibernateException;
import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVPlazaCodigoPostalDao;
import es.pfsgroup.plugin.recovery.masivo.model.MSVConfEnvioImpresion;

@Repository("MSVPlazaCodigoPostalDao")
public class MSVPlazaCodigoPostalDaoImpl extends AbstractEntityDao<MSVConfEnvioImpresion, Long> implements MSVPlazaCodigoPostalDao {

	@Override
	public String obtenerNombrePlazaDeCP(Long idDireccion) {
		String result="";
		String sql = "select pla.DD_PLA_DESCRIPCION_LARGA from dd_pla_plazas pla " + 
				"inner join cpp_codigo_postal_plaza cpp on cpp.CPP_PLAZA=pla.DD_PLA_CODIGO " + 
				"inner join dir_direcciones dir on dir.DIR_COD_POST_INTL=cpp.CPP_CODIGO_POSTAL " + 
				"where dir.dir_id="+ idDireccion ;
		Object resultado = null;
		try {
			resultado = getSession().createSQLQuery(sql).uniqueResult();
		} catch (DataAccessResourceFailureException e) {
			System.out
					.println("[MSVPlazaCodigoPostalDaoImpl:obtenerNombrePlazaDeCP] DataAccessResourceFailureException "
							+ e.getMessage() + "(" + idDireccion + ")");
			e.printStackTrace();
		} catch (HibernateException e) {
			System.out
			.println("[MSVPlazaCodigoPostalDaoImpl:obtenerNombrePlazaDeCP] HibernateException "
					+ e.getMessage() + "(" + idDireccion + ")");
			e.printStackTrace();
		} catch (IllegalStateException e) {
			System.out
			.println("[MSVPlazaCodigoPostalDaoImpl:obtenerNombrePlazaDeCP] IllegalStateException "
					+ e.getMessage() + "(" + idDireccion + ")");
			e.printStackTrace();
		}
		if (!Checks.esNulo(resultado)){
			result=resultado.toString();
		}
		return result;
	}

}
