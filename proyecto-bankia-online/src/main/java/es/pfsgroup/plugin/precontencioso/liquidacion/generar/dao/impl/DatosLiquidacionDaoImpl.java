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
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.DatosGeneralesLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.InteresesContratoLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.RecibosLiqVO;

@Repository
public class DatosLiquidacionDaoImpl implements DatosLiquidacionDao {

	@Autowired
	@Resource(name = "entitySessionFactory")
	private SessionFactory sessionFactory;

	@Override
	public List<RecibosLiqVO> getRecibosLiquidacion(Long idLiquidacion) {
		Session session = sessionFactory.getCurrentSession();

		Query query = session.createSQLQuery(plainQueryRecibosLiq())
				.addScalar("RCB_PCO_LIQ_ID", Hibernate.LONG)
				.addScalar("RCB_IDRECV", Hibernate.STRING)
				.addScalar("RCB_FEVCTR", Hibernate.DATE)
				.addScalar("RCB_CDINTS", Hibernate.BIG_DECIMAL)
				.addScalar("RCB_CDINTM", Hibernate.BIG_DECIMAL)
				.addScalar("RCB_IMCPRC", Hibernate.BIG_DECIMAL)
				.addScalar("RCB_IMPRTV", Hibernate.BIG_DECIMAL)
				.addScalar("RCB_IMCGTA", Hibernate.BIG_DECIMAL)
				.addScalar("RCB_IMINDR", Hibernate.BIG_DECIMAL)
				.addScalar("RCB_IMBIM4", Hibernate.BIG_DECIMAL)
				.addScalar("RCB_IMDEUD", Hibernate.BIG_DECIMAL)
				.setLong("idLiquidacion", idLiquidacion);

		return query.setResultTransformer(Transformers.aliasToBean(RecibosLiqVO.class)).list();
	}

	private String plainQueryRecibosLiq() {
		StringBuilder plainQueryRecibosLiq = new StringBuilder();
		plainQueryRecibosLiq.append(" SELECT * ");
		plainQueryRecibosLiq.append(" FROM RCB_RECIBOS_LIQ ");
		plainQueryRecibosLiq.append(" WHERE BORRADO = 0 ");
		plainQueryRecibosLiq.append("  AND RCB_PCO_LIQ_ID = :idLiquidacion ");

		return plainQueryRecibosLiq.toString();
	}

	@Override
	public List<DatosGeneralesLiqVO> getDatosGeneralesContratoLiquidacion(Long idLiquidacion) {
		Session session = sessionFactory.getCurrentSession();

		Query query = session.createSQLQuery(plainQueryDatosGeneralesLiq())
			.addScalar("DGC_PCO_LIQ_ID", Hibernate.LONG)
			.addScalar("DGC_IDPRIG", Hibernate.STRING)
			.addScalar("DGC_NMPRTO", Hibernate.STRING)
			.addScalar("DGC_FEVACM", Hibernate.DATE)
			.addScalar("DGC_IMCCNS", Hibernate.BIG_DECIMAL)
			.addScalar("DGC_IMCPAM", Hibernate.BIG_DECIMAL)
			.addScalar("DGC_FEFOEZ", Hibernate.DATE)
			.addScalar("DGC_NOMFED1", Hibernate.STRING)
			.addScalar("DGC_COIBTQ", Hibernate.STRING)
			.addScalar("DGC_IMDEUD", Hibernate.BIG_DECIMAL)
			.addScalar("DGC_IMVRE2", Hibernate.BIG_DECIMAL)
			.setLong("idLiquidacion", idLiquidacion);

		return query.setResultTransformer(Transformers.aliasToBean(DatosGeneralesLiqVO.class)).list();
	}

	private String plainQueryDatosGeneralesLiq() {
		StringBuilder plainQueryDatosGeneralesLiq = new StringBuilder();
		plainQueryDatosGeneralesLiq.append(" SELECT * ");
		plainQueryDatosGeneralesLiq.append(" FROM DGC_DATOS_GENERALES_CNT_LIQ ");
		plainQueryDatosGeneralesLiq.append(" WHERE BORRADO = 0 ");
		plainQueryDatosGeneralesLiq.append("  AND DGC_PCO_LIQ_ID = :idLiquidacion ");

		return plainQueryDatosGeneralesLiq.toString();
	}

	@Override
	public List<InteresesContratoLiqVO> getInteresesContratoLiquidacion(Long idLiquidacion) {
		Session session = sessionFactory.getCurrentSession();

		Query query = session.createSQLQuery(plainQueryInteresesContratoLiq())
			.addScalar("INC_PCO_LIQ_ID", Hibernate.LONG)
			.addScalar("INC_FEPTDE", Hibernate.DATE)
			.addScalar("INC_FEPTHA", Hibernate.DATE)
			.addScalar("INC_CDINTS", Hibernate.BIG_DECIMAL)
			.setLong("idLiquidacion", idLiquidacion);

		return query.setResultTransformer(Transformers.aliasToBean(InteresesContratoLiqVO.class)).list();
	}

	private String plainQueryInteresesContratoLiq() {
		StringBuilder plainQueryInteresesContratoLiq = new StringBuilder();
		plainQueryInteresesContratoLiq.append(" SELECT * ");
		plainQueryInteresesContratoLiq.append(" FROM INC_INTERESES_CONTRATO_LIQ ");
		plainQueryInteresesContratoLiq.append(" WHERE BORRADO = 0 ");
		plainQueryInteresesContratoLiq.append("  AND INC_PCO_LIQ_ID = :idLiquidacion ");
		plainQueryInteresesContratoLiq.append("  AND INC_CDTIIN != 'D' ");
		plainQueryInteresesContratoLiq.append("	ORDER BY INC_FEPTDE ASC ");

		return plainQueryInteresesContratoLiq.toString();
	}

}
