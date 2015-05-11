package es.capgemini.pfs.batch.configuracion.dao.impl;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.batch.configuracion.dao.ConfiguracionEntradaDao;
import es.capgemini.pfs.batch.configuracion.model.ConfiguracionEntrada;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;

@Repository("ConfiguracionEntradaDao")
public class ConfiguracionEntradaDaoImpl extends AbstractEntityDao<ConfiguracionEntrada, Long> implements ConfiguracionEntradaDao {
	
	private void setParameters(Query query, HashMap<String, Object> params) {
		if (params == null) {
			return;
		}
		for (String key : params.keySet()) {
			Object param = params.get(key);
			query.setParameter(key, param);
		}
	}	

	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<ConfiguracionEntrada> obtenerAgenciasOrdenadosCarSubAge(String estadoEsquemaCodigo) {
		HQLBuilder hb = new HQLBuilder("from ConfiguracionEntrada");
		HQLBuilder.addFiltroIgualQue(hb, "carteraBorrado", false);
		HQLBuilder.addFiltroIgualQue(hb, "subcarteraBorrado", false);
		HQLBuilder.addFiltroIgualQue(hb, "agenciaBorrado", false);
		if(!Checks.esNulo(estadoEsquemaCodigo))
			HQLBuilder.addFiltroIgualQue(hb, "estadoEsquemaCodigo", estadoEsquemaCodigo);
		hb.orderBy("carteraId, subcarteraId, agenciaId", HQLBuilder.ORDER_ASC);
		
		return (List<ConfiguracionEntrada>)HibernateQueryUtils.list(this, hb);
	}

	/**
	 * {@inheritDoc}
	 * @return 
	 */	
	@Override
	public Long obtenerEsquema() {
		HQLBuilder hb = new HQLBuilder("from ConfiguracionEntrada");
		HQLBuilder.addFiltroIgualQue(hb, "rowId", 1);
		
		return HibernateQueryUtils.uniqueResult(this, hb).getEsquemaId();
	}

	/**
	 * {@inheritDoc}
	 * @return 
	 */		
	@Override
	public List<Object[]> obtenerEsquemasSubCarterasPorEstadosEsquema(String[] estadosEsquemas) {
		String sb = "Select distinct c.esquemaId, c.subcarteraId " +
					"from ConfiguracionEntrada c " +
					"Where c.esquemaBorrado = 0 " +
					"And c.subcarteraBorrado = 0 " +
					"And c.estadoEsquemaCodigo IN ('" + Arrays.toString(estadosEsquemas).replace(", ","','").replaceAll("[\\[\\]]", "") + "') " +
					"Order by c.esquemaId, c.subcarteraId";
					
		Query query = getSession().createQuery(sb);

		return (List<Object[]>)query.list();		
	}

}
