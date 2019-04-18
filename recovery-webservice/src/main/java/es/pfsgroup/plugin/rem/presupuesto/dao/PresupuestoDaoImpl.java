package es.pfsgroup.plugin.rem.presupuesto.dao;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosTrabajoPresupuesto;
import es.pfsgroup.plugin.rem.model.VBusquedaPresupuestosActivo;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;

@Repository("PresupuestoDao")
public class PresupuestoDaoImpl extends AbstractEntityDao<VBusquedaActivosTrabajoPresupuesto, Long>
		implements PresupuestoDao {

	@Override
	public String getSaldoDisponible(Long idActivo, String ejercicioActual) {
		StringBuilder functionHQL = new StringBuilder(
				"SELECT MAX(SALDO_DISPONIBLE) FROM REM01.V_BUSQUEDA_ACT_TBJ_PRESUPUESTO WHERE ACT_ID = :ACT_ID AND EJE_ANYO = :EJERCICIO");
		Query callFunctionSql = this.getSessionFactory().getCurrentSession().createSQLQuery(functionHQL.toString());

		callFunctionSql.setParameter("ACT_ID", idActivo);
		callFunctionSql.setParameter("EJERCICIO", ejercicioActual);
		BigDecimal resultadoBg = (BigDecimal) callFunctionSql.uniqueResult();
		String resultado = "0";
		if (!Checks.esNulo(resultado)) {
			resultado = resultadoBg.toString();
		}

		return resultado;

	}

	@SuppressWarnings("unchecked")
	@Override
	public List<VBusquedaPresupuestosActivo> getListHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dto) {

		List<VBusquedaPresupuestosActivo> lista = new ArrayList<VBusquedaPresupuestosActivo>();

		String sql = "SELECT PTO_ID,ACT_ID,EJE_ANYO,INCREMENTO,PTO_IMPORTE_INICIAL FROM REM01.V_BUSQUEDA_PRESUPUESTOS_ACTIVO WHERE ACT_ID = :ACT_ID";
		if(!Checks.esNulo(dto.getIdPresupuesto())){
			sql += " AND PTO_ID = :PTO_ID";
		}
		
		StringBuilder functionHQL = new StringBuilder(sql);
		Query callFunctionSql = this.getSessionFactory().getCurrentSession().createSQLQuery(functionHQL.toString());

		callFunctionSql.setParameter("ACT_ID", Long.valueOf(dto.getIdActivo()));
		if(!Checks.esNulo(dto.getIdPresupuesto())){
			callFunctionSql.setParameter("PTO_ID", Long.valueOf(dto.getIdPresupuesto()));
		}
		

		List<Object[]> resultados = callFunctionSql.list();
		if (!Checks.estaVacio(resultados)) {
			for (Object[] resultado : resultados) {
				if (resultado != null && resultado.length == 5) {
					VBusquedaPresupuestosActivo item = new VBusquedaPresupuestosActivo();
					if (resultado[0] != null)
						item.setId(((BigDecimal) resultado[0]).toString());
					if (resultado[1] != null)
						item.setIdActivo(((BigDecimal) resultado[1]).toString());
					if (resultado[2] != null)
						item.setEjercicioAnyo((String) resultado[2]);
					if (resultado[3] != null)
						item.setSumaIncrementos(((BigDecimal) resultado[3]).doubleValue());
					if (resultado[4] != null)
						item.setImporteInicial(((BigDecimal) resultado[4]).doubleValue());

					lista.add(item);
				}
			}
		}

		return lista;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<VBusquedaActivosTrabajoPresupuesto> getListActivosTrabajoPresupuesto(DtoActivosTrabajoFilter dto) {
		List<VBusquedaActivosTrabajoPresupuesto> lista = new ArrayList<VBusquedaActivosTrabajoPresupuesto>();

		String sql = "SELECT ACT_ID,IMPORTE_PARTICIPA,EJE_ANYO,SALDO_DISPONIBLE FROM REM01.V_BUSQUEDA_ACT_TBJ_PRESUPUESTO WHERE ACT_ID = :ACT_ID";
		if(!Checks.esNulo(dto.getEstadoContable())){
			sql += " AND DD_EST_ESTADO_CONTABLE = :ESTADO_CONTABLE";
		}
		
		
		StringBuilder functionHQL = new StringBuilder(sql);
		Query callFunctionSql = this.getSessionFactory().getCurrentSession().createSQLQuery(functionHQL.toString());

		callFunctionSql.setParameter("ACT_ID", Long.valueOf(dto.getIdActivo()));
		if(!Checks.esNulo(dto.getEstadoContable())){
			callFunctionSql.setParameter("ESTADO_CONTABLE", Long.valueOf(dto.getEstadoContable()));
		}
		

		List<Object[]> resultados = callFunctionSql.list();
		if (!Checks.estaVacio(resultados)) {
			for (Object[] resultado : resultados) {
				if (resultado != null && resultado.length == 2) {
					VBusquedaActivosTrabajoPresupuesto item = new VBusquedaActivosTrabajoPresupuesto();
					if (resultado[0] != null)
						item.setIdActivo(((BigDecimal) resultado[0]).toString());
					if (resultado[1] != null)
						item.setImporteParticipa(((BigDecimal) resultado[1]).toString());
					if (resultado[2] != null)
						item.setEjercicio((String) resultado[2]);
					if (resultado[3] != null)
						item.setSaldoDisponible(((BigDecimal) resultado[3]).toString());
					
					lista.add(item);
				}
			}
		}

		return lista;
		
	}

}
