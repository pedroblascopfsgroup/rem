package es.pfsgroup.plugin.rem.presupuesto.dao;

import java.math.BigDecimal;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosTrabajoPresupuesto;

@Repository("PresupuestoDao")
public class PresupuestoDaoImpl extends AbstractEntityDao<VBusquedaActivosTrabajoPresupuesto, Long>implements PresupuestoDao{

	@Override
	public String getSaldoDisponible(Long idActivo, String ejercicioActual) {
		StringBuilder functionHQL = new StringBuilder("SELECT MAX(SALDO_DISPONIBLE) FROM REM01.V_BUSQUEDA_ACT_TBJ_PRESUPUESTO WHERE ACT_ID = :ACT_ID AND EJE_ANYO = :EJERCICIO");
		Query callFunctionSql = this.getSessionFactory().getCurrentSession().createSQLQuery(functionHQL.toString());

		callFunctionSql.setParameter("ACT_ID", idActivo);
		callFunctionSql.setParameter("EJERCICIO", ejercicioActual);
		BigDecimal resultadoBg = (BigDecimal) callFunctionSql.uniqueResult();
		String resultado = "0";
		if(!Checks.esNulo(resultado)){
			resultado = resultadoBg.toString();
		}
		
		return resultado;
		
	}

}
