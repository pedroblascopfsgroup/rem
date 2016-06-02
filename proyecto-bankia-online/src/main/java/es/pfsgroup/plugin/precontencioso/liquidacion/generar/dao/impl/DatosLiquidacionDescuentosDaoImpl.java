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
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.dao.DatosLiquidacionDescuentosDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.DatosGeneralesLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.EfectosLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.EntregasLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.InteresesContratoLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.RecibosLiqVO;

@Repository
public class DatosLiquidacionDescuentosDaoImpl implements DatosLiquidacionDescuentosDao {

	@Autowired
	@Resource(name = "entitySessionFactory")
	private SessionFactory sessionFactory;

	@Override
	public List<EfectosLiqVO> getEfectosLiquidacion(Long idLiquidacion, String condicion) {
		Session session = sessionFactory.getCurrentSession();

		Query query = session.createSQLQuery(plainQueryEfectosLiq())
				.addScalar("DEF_PCO_LIQ_ID", Hibernate.LONG)
				.addScalar("DEF_IDRECV", Hibernate.STRING)
				.addScalar("DEF_TIPOEF", Hibernate.STRING)
				.addScalar("DEF_NOLIB9", Hibernate.STRING)
				.addScalar("DEF_FEVCTR", Hibernate.DATE)
				.addScalar("DEF_FEREAM", Hibernate.DATE)
				.addScalar("DEF_IMCPRC", Hibernate.BIG_DECIMAL)
				.addScalar("DEF_IDEGPR", Hibernate.BIG_DECIMAL)
				.addScalar("DEF_IDEOTG", Hibernate.BIG_DECIMAL)
				.addScalar("DEF_CDINTS", Hibernate.BIG_DECIMAL)
				.addScalar("DEF_IMPRTV", Hibernate.BIG_DECIMAL)
				.addScalar("DEF_IMDEUD", Hibernate.BIG_DECIMAL)
				.setLong("idLiquidacion", idLiquidacion)
				.setString("condicion", condicion);

		return query.setResultTransformer(Transformers.aliasToBean(EfectosLiqVO.class)).list();
	}

	private String plainQueryEfectosLiq() {
		StringBuilder plainQueryRecibosLiq = new StringBuilder();
		plainQueryRecibosLiq.append(" SELECT * ");
		plainQueryRecibosLiq.append(" FROM DEF_DOCUMENTOS_EFECTOS_LIQ ");
		plainQueryRecibosLiq.append(" WHERE BORRADO = 0 ");
		plainQueryRecibosLiq.append("  AND DEF_PCO_LIQ_ID = :idLiquidacion ");
		plainQueryRecibosLiq.append("  AND DEF_COTIVT = :condicion ");
		plainQueryRecibosLiq.append("  ORDER BY DEF_FEVCTR ASC ");

		return plainQueryRecibosLiq.toString();
	}

	@Override
	public List<EntregasLiqVO> getEntregasCuentasLiquidacion(Long idLiquidacion) {
		Session session = sessionFactory.getCurrentSession();

		Query query = session.createSQLQuery(plainQueryEntregasLiq())
			.addScalar("ECL_PCO_LIQ_ID", Hibernate.LONG)
			.addScalar("ECL_FEDOEN", Hibernate.DATE)
			.addScalar("ECL_FEREAM", Hibernate.DATE)
			.addScalar("ECL_IMENOP", Hibernate.BIG_DECIMAL)
			.addScalar("ECL_CDINTS", Hibernate.BIG_DECIMAL)
			.addScalar("ECL_IMINEO", Hibernate.BIG_DECIMAL)
			.addScalar("ECL_IMDEUD", Hibernate.BIG_DECIMAL)
			.setLong("idLiquidacion", idLiquidacion);

		return query.setResultTransformer(Transformers.aliasToBean(EntregasLiqVO.class)).list();
	}

	private String plainQueryEntregasLiq() {
		StringBuilder plainQueryDatosGeneralesLiq = new StringBuilder();
		plainQueryDatosGeneralesLiq.append(" SELECT * ");
		plainQueryDatosGeneralesLiq.append(" FROM ECL_ENTREGAS_CUENTA_LIQ ");
		plainQueryDatosGeneralesLiq.append(" WHERE BORRADO = 0 ");
		plainQueryDatosGeneralesLiq.append("  AND ECL_PCO_LIQ_ID = :idLiquidacion ");
		plainQueryDatosGeneralesLiq.append("  ORDER BY ECL_FEDOEN ASC ");

		return plainQueryDatosGeneralesLiq.toString();
	}
}
