package es.pfsgroup.plugin.rem.concurrencia.dao.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.plugin.rem.concurrencia.dao.ConcurrenciaDao;
import es.pfsgroup.plugin.rem.model.Concurrencia;

@Repository("concurrenciaDao")
public class ConcurrenciaDaoImpl extends AbstractEntityDao<Concurrencia, Long> implements ConcurrenciaDao{
		
	@Autowired
	private MSVRawSQLDao rawDao;
	
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
}
