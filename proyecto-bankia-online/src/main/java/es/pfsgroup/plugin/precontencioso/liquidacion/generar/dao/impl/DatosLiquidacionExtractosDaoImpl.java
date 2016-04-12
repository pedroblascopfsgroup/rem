package es.pfsgroup.plugin.precontencioso.liquidacion.generar.dao.impl;

import java.util.List;

import javax.annotation.Resource;

import org.hibernate.Hibernate;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.transform.Transformers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.pfsgroup.plugin.precontencioso.liquidacion.generar.dao.DatosLiquidacionDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.dao.DatosLiquidacionExtractosDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.CabeceraExpedienteLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.CabeceraLiquidacionLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.DatosGeneralesLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.InteresesContratoLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.MovimientoLiquidacionLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.RecibosLiqVO;

@Repository
public class DatosLiquidacionExtractosDaoImpl implements DatosLiquidacionExtractosDao {

	@Autowired
	@Resource(name = "entitySessionFactory")
	private SessionFactory sessionFactory;

	@Override
	public List<CabeceraExpedienteLiqVO> getCabeceraExpedienteLiquidacion(Long idLiquidacion) {
		Session session = sessionFactory.getCurrentSession();

		Query query = session.createSQLQuery(plainQueryCabeceraExp())
				.addScalar("CEL_PCO_LIQ_ID", Hibernate.LONG)
				.addScalar("CEL_NOMBRE", Hibernate.STRING)
				.addScalar("CEL_NCTAOP", Hibernate.STRING)
				//.addScalar("CEL_COEXPD", Hibernate.BIG_DECIMAL)
				.addScalar("CEL_COEXPD", Hibernate.STRING)
				.addScalar("CEL_NUCTOP", Hibernate.BIG_DECIMAL)
				.addScalar("CEL_IMLIAC", Hibernate.BIG_DECIMAL)
				.setLong("idLiquidacion", idLiquidacion);

		return query.setResultTransformer(Transformers.aliasToBean(CabeceraExpedienteLiqVO.class)).list();
	}

	private String plainQueryCabeceraExp() {
		StringBuilder plainQueryCabeceraExp = new StringBuilder();
		plainQueryCabeceraExp.append(" SELECT * ");
		plainQueryCabeceraExp.append(" FROM CEL_CAB_EXP_LQ_CUENTAS_CREDITO ");
		plainQueryCabeceraExp.append(" WHERE BORRADO = 0 ");
		plainQueryCabeceraExp.append("  AND CEL_PCO_LIQ_ID = :idLiquidacion ");

		return plainQueryCabeceraExp.toString();
	}

	@Override
	public List<CabeceraLiquidacionLiqVO> getCabeceraLiquidacion(Long idLiquidacion) {
		Session session = sessionFactory.getCurrentSession();

		Query query = session.createSQLQuery(plainQueryCabeceraLiq())
			.addScalar("CLQ_PCO_LIQ_ID", Hibernate.LONG)
			.addScalar("CLQ_NCTAOP", Hibernate.STRING)
			.addScalar("CLQ_DESLIQ", Hibernate.STRING)
			.addScalar("CLQ_POINDB", Hibernate.BIG_DECIMAL)
			.addScalar("CLQ_IMLIAC", Hibernate.BIG_DECIMAL)
			.addScalar("CLQ_FEFCON", Hibernate.DATE)
			.addScalar("CLQ_FANTLQ", Hibernate.DATE)
			.addScalar("CLQ_FEVALQ", Hibernate.DATE)
			.setLong("idLiquidacion", idLiquidacion);

		return query.setResultTransformer(Transformers.aliasToBean(CabeceraLiquidacionLiqVO.class)).list();
	}

	private String plainQueryCabeceraLiq() {
		StringBuilder plainQueryCabeceraLiq = new StringBuilder();
		plainQueryCabeceraLiq.append(" SELECT * ");
		plainQueryCabeceraLiq.append(" FROM CLQ_CAB_LIQ_CUENTAS_CREDITO ");
		plainQueryCabeceraLiq.append(" WHERE BORRADO = 0 ");
		plainQueryCabeceraLiq.append("  AND CLQ_PCO_LIQ_ID = :idLiquidacion ");
		plainQueryCabeceraLiq.append("	ORDER BY CLQ_FANTLQ ASC ");

		return plainQueryCabeceraLiq.toString();
	}

	@Override
	public List<MovimientoLiquidacionLiqVO> getMovimientoLiquidacion(Long idLiquidacion) {
		Session session = sessionFactory.getCurrentSession();

		Query query = session.createSQLQuery(plainQueryMovimientoLiq())
			.addScalar("MLQ_PCO_LIQ_ID", Hibernate.LONG)
			.addScalar("MLQ_FECHAO", Hibernate.DATE)
			.addScalar("MLQ_FECHAV", Hibernate.DATE)
			.addScalar("MLQ_CNCORT", Hibernate.STRING)
			.addScalar("MLQ_IMMOVY", Hibernate.STRING)
			.addScalar("MLQ_CASALY", Hibernate.STRING)
			.addScalar("MLQ_CADISY", Hibernate.STRING)
			.addScalar("MLQ_CANUDY", Hibernate.STRING)
			.addScalar("MLQ_CANUCY", Hibernate.STRING)
			.addScalar("MLQ_CANUEY", Hibernate.STRING)
			.setLong("idLiquidacion", idLiquidacion);

		return query.setResultTransformer(Transformers.aliasToBean(MovimientoLiquidacionLiqVO.class)).list();
	}

	private String plainQueryMovimientoLiq() {
		StringBuilder plainQueryMovimientoLiq = new StringBuilder();
		plainQueryMovimientoLiq.append(" SELECT * ");
		plainQueryMovimientoLiq.append(" FROM MLQ_MOV_LIQ_CUENTAS_CREDITO ");
		plainQueryMovimientoLiq.append(" WHERE BORRADO = 0 ");
		plainQueryMovimientoLiq.append("  AND MLQ_PCO_LIQ_ID = :idLiquidacion ");
		plainQueryMovimientoLiq.append("	ORDER BY MLQ_NUSECT ASC ");

		return plainQueryMovimientoLiq.toString();
	}

}
