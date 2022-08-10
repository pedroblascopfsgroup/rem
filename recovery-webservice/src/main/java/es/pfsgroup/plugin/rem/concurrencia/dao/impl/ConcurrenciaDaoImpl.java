package es.pfsgroup.plugin.rem.concurrencia.dao.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.plugin.rem.concurrencia.dao.ConcurrenciaDao;
import es.pfsgroup.plugin.rem.model.Concurrencia;
import es.pfsgroup.plugin.rem.model.VGridCambiosPeriodoConcurrencia;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosAgrupacionConcurrencia;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosConcurrencia;

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
	
	@SuppressWarnings("unchecked")
	@Override
	public List<VGridOfertasActivosConcurrencia> getListOfertasVivasConcurrentes(Long idActivo, Long idConcurrencia) {

		String hql = " from VGridOfertasActivosConcurrencia voac ";

		HQLBuilder hb = new HQLBuilder(hql);

		if(idActivo != null) {
			hb.appendWhere(" voac.idActivo = "+idActivo);
		}
		
		if(idConcurrencia != null) {
			hb.appendWhere(" voac.idConcurrencia = "+ idConcurrencia);
		} else {
			Long conId = getIdConcurrenciaReciente(idActivo, null);
			if(conId != null)
				hb.appendWhere(" voac.idConcurrencia = "+ conId);
		}

		
		return (List<VGridOfertasActivosConcurrencia>) this.getSessionFactory().getCurrentSession()
				.createQuery(hb.toString()).list();
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<VGridOfertasActivosConcurrencia> getListOfertasVivasAgrupacionConcurrentes(Long idAgrupacion, Long numeroAgrupacion, Long idConcurrencia) {

		String hql = " from VGridOfertasActivosConcurrencia voac ";

		HQLBuilder hb = new HQLBuilder(hql);

		if(numeroAgrupacion != null) {
			hb.appendWhere(" voac.numActivoAgrupacion = "+numeroAgrupacion);
		}
		
		if(idConcurrencia != null) {
			hb.appendWhere(" voac.idConcurrencia = "+ idConcurrencia);
		} else {
			Long conId = getIdConcurrenciaReciente(null, idAgrupacion);
			if(conId != null)
				hb.appendWhere(" voac.idConcurrencia = "+ conId);
		}

		
		return (List<VGridOfertasActivosConcurrencia>) this.getSessionFactory().getCurrentSession()
				.createQuery(hb.toString()).list();
	}
	
	@Override
	public Long getIdConcurrenciaReciente(Long idActivo, Long idAgrupacion) {
		
		String consulta = "";
		
		if(idAgrupacion != null)
			consulta = " agr_id = " + idAgrupacion + " and";
		else if (idActivo != null)
			consulta = " act_id = " + idActivo + " and";
		
		String resultado = rawDao.getExecuteSQL("SELECT con_id FROM (SELECT con_id, act_id, agr_id" +
				"               FROM con_concurrencia WHERE con_fecha_ini <= SYSDATE" +
				"               ORDER BY con_fecha_fin DESC) WHERE" + consulta + " ROWNUM = 1");
		
		if (resultado != null)
			return Long.valueOf(resultado);
		
		return null;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<VGridOfertasActivosAgrupacionConcurrencia> getListOfertasTerminadasConcurrentes(Long idActivo, Long idConcurrencia) {

		String hql = " from VGridOfertasActivosAgrupacionConcurrencia voaac ";

		HQLBuilder hb = new HQLBuilder(hql);

		if(idActivo != null) {
			hb.appendWhere(" voaac.idActivo = "+idActivo);
		}
		
		if(idConcurrencia != null) {
			hb.appendWhere(" voaac.idConcurrencia = "+ idConcurrencia);
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
	
	@Override
	public boolean isOfertaEnPlazoEntrega(Long idOferta) {
		
		String resultados = rawDao.getExecuteSQL("SELECT count(1) FROM OFR_OFERTAS ofr \n" + 
				"JOIN OFC_OFERTAS_CONCURRENCIA ofc ON ofc.OFR_ID = ofr.OFR_ID \n" + 
				"WHERE (ofc.OFC_FECHA_DOC IS NULL and ofc.FECHACREAR + 72/24 > SYSDATE \n" + 
				"or ofc.OFC_FECHA_DEPOSITO IS NULL AND ofc.OFC_FECHA_DOC + 96/24 > SYSDATE) \n" + 
				"AND ofr.OFR_id ="+idOferta);
		
		return Integer.parseInt(resultados) > 0;
	}
	
	@Override
	public String getPeriodoConcurrencia(Long idConcurrencia) {
		
		String resultados = rawDao.getExecuteSQL("SELECT ROUND(CON_FECHA_FIN-CON_FECHA_INI, 0) AS PERIODO_CONCURRENCIA FROM CON_CONCURRENCIA WHERE CON_ID="+idConcurrencia);
		
		return resultados;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<VGridCambiosPeriodoConcurrencia> getListCambiosPeriodoConcurenciaByIdConcurrencia(Long idConcurrencia) {

		String hql = " from VGridCambiosPeriodoConcurrencia vcmb ";

		HQLBuilder hb = new HQLBuilder(hql);

		if(idConcurrencia != null) {
			hb.appendWhere(" vcmb.idConcurrencia = "+ idConcurrencia);
		}
		
		return (List<VGridCambiosPeriodoConcurrencia>) this.getSessionFactory().getCurrentSession()
				.createQuery(hb.toString()).list();
	}
	
}
