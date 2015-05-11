package es.pfsgroup.recovery.recobroCommon.ranking.dao.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.ranking.dao.api.RecobroRankingHistoricoSubcarteraDAO;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroRankingHistoricoSubcartera;

/**
 * Implementación del DAO de rankings históricos de subcarteras de recobro
 * @author Guillem
 *
 */
@Repository
public class RecobroRankingHistoricoSubcarteraDAOImpl extends AbstractEntityDao<RecobroRankingHistoricoSubcartera, Long> implements	RecobroRankingHistoricoSubcarteraDAO {

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<RecobroRankingHistoricoSubcartera> obtenerRankingHistoricoSubcarteraFecha(RecobroSubCartera subCartera, Date fechaHistorico) throws Throwable {
		SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
		
		StringBuilder hql = new StringBuilder();
		hql.append("SELECT obj FROM RecobroRankingHistoricoSubcartera obj " +
				"WHERE obj.fechaHistorico = " +
				"(SELECT MAX(fechaHistorico) FROM RecobroRankingHistoricoSubcartera " +
				 //"WHERE fechaHistorico <= trunc("+ fechaHistorico + ") " +
				"WHERE fechaHistorico <= TO_DATE('"+ df.format(fechaHistorico) + "','dd/MM/yyyy') " +
				"AND subCartera = " + subCartera.getId() + ") " +
				"AND obj.subCartera = " + subCartera.getId());
		return getHibernateTemplate().find(hql.toString());
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public Date obtenerUltimaFechaRanking() {
		StringBuilder hql = new StringBuilder();
		hql.append("Select Trunc(Max(h.FECHA_HIST)) from H_RAS_RANKING_SUBCARTERA h");
		
		return (Date)getSession().createSQLQuery(hql.toString()).uniqueResult();
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public void HistorificarRankingSubcartera() {
		String sqlSecuence = "SELECT S_H_RAS_RANKING_SUBCARTERA.NEXTVAL FROM DUAL";
		Long secuenciaHistorico = (Long)getSession().createSQLQuery(sqlSecuence).uniqueResult();	
		String sql = "INSERT INTO H_RAS_RANKING_SUBCARTERA " +
						"SELECT TRUNC(SYSDATE), "+  secuenciaHistorico  +", RAS_ID, RCF_SCA_ID, RCF_AGE_ID, RAS_POSICION, RAS_PORCENTAJE, RAS_COEFICIENTE, " +
							"VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO " +
						"FROM RAS_RANKING_SUBCARTERA";		
		getSession().createSQLQuery(sql).executeUpdate();
		
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public void HistorificarRankingSubcarteraDetalle() {
		String sqlSecuence = "SELECT S_H_RSD_RANKING_SUBCAR_DETALLE.NEXTVAL FROM DUAL";
		Long secuenciaHistorico = (Long)getSession().createSQLQuery(sqlSecuence).uniqueResult();	
		String sql ="INSERT INTO H_RSD_RANKING_SUBCAR_DETALLE " +
						"SELECT TRUNC(SYSDATE), " + secuenciaHistorico + ", RSD_ID, RCF_SCA_ID, RCF_AGE_ID, RCF_DD_VAR_ID, RSD_PESO, RSD_RESULTADO, RSD_POSICION, " +
							"VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO " +
						"FROM RSD_RANKING_SUBCAR_DETALLE";		
		getSession().createSQLQuery(sql).executeUpdate();
		
	}

}
