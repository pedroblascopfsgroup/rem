package es.pfsgroup.plugin.rem.concurrencia.dao.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.plugin.rem.concurrencia.dao.ConcurrenciaDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.Concurrencia;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosAgrupacionConcurrencia;

@Repository("concurrenciaDao")
public class ConcurrenciaDaoImpl extends AbstractEntityDao<Concurrencia, Long> implements ConcurrenciaDao{
		
	@Autowired
	private MSVRawSQLDao rawDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public boolean isAgrupacionEnConcurrencia (Long agrId) {
		
		String resultados = rawDao.getExecuteSQL("SELECT count(*) FROM act_agr_agrupacion agr \n" + 
			"join act_aga_agrupacion_activo aga on agr.agr_id = aga.agr_id\n" + 
			"join act_activo act on act.act_id = aga.act_id \n" + 
			"join con_concurrencia cn on cn.act_id = act.act_id \n" + 
			"where SYSDATE BETWEEN cn.con_fecha_ini and cn.con_fecha_fin AND agr.agr_id =" + agrId);

		return Integer.parseInt(resultados) > 0;
	}
	
	@Override
	public boolean isAgrupacionConOfertasDeConcurrencia (Long agrId) {
		
		String resultados = rawDao.getExecuteSQL("SELECT count(*) FROM act_agr_agrupacion agr \n" + 
				"join act_aga_agrupacion_activo aga on agr.agr_id = aga.agr_id \n" + 
				"join act_activo act on act.act_id = aga.act_id \n" + 
				"join act_ofr aof on aof.act_id = act.act_id \n" + 
				"join ofr_ofertas ofr on aof.ofr_id = ofr.ofr_id \n" + 
				"join dd_eof_estados_oferta eof on ofr.dd_eof_id = eof.dd_eof_id 	\n" + 
				"where eof.dd_eof_codigo in ('01', '04', '08', '07', '09') AND ofr.OFR_CONCURRENCIA = 1 AND agr.agr_id =" + agrId);
		
		return Integer.parseInt(resultados) > 0;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<VGridOfertasActivosAgrupacionConcurrencia> getListOfertasVivasConcurrentes(Long idActivo) {

		String hql = " from VGridOfertasActivosAgrupacionConcurrencia voa2 ";
		String listaIdsOfertas = "";

		HQLBuilder hb = new HQLBuilder(hql);

		if (!Checks.esNulo(idActivo)) {
			Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
			Activo activo = genericDao.get(Activo.class, filtroIdActivo);

			List<ActivoOferta> listaActivoOfertas = activo.getOfertas();

			for (ActivoOferta activoOferta : listaActivoOfertas) {
				listaIdsOfertas = listaIdsOfertas.concat(activoOferta.getPrimaryKey().getOferta().getId().toString())
						.concat(",");
			}
			listaIdsOfertas = listaIdsOfertas.concat("-1");

			hb.appendWhere(" voa2.idOferta in (" + listaIdsOfertas + ") ");
		}

		return (List<VGridOfertasActivosAgrupacionConcurrencia>) this.getSessionFactory().getCurrentSession()
				.createQuery(hb.toString()).list();
	}

	@Override
	public boolean isActivoEnConcurrencia(Long idActivo) {
		
		String resultados = rawDao.getExecuteSQL("SELECT count(*) FROM act_activo act \n" + 
				"JOIN con_concurrencia cn ON cn.act_id = act.act_id AND cn.borrado = 0 \n" + 
				"where SYSDATE BETWEEN cn.con_fecha_ini and cn.con_fecha_fin \n" + 
				"AND act.act_id = " + idActivo);
		
		return Integer.parseInt(resultados) > 0;
	}
}
