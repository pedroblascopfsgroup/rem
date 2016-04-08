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

import es.pfsgroup.plugin.precontencioso.liquidacion.generar.dao.DatosDescubiertoDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.DescubiertoLiqVO;

@Repository
public class DatosDescubiertoDaoImpl implements DatosDescubiertoDao {

	@Autowired
	@Resource(name = "entitySessionFactory")
	private SessionFactory sessionFactory;

	@Override
	public List<DescubiertoLiqVO> getDescubiertoLiquidacion(Long idLiquidacion) {
		Session session = sessionFactory.getCurrentSession();

		Query query = session.createSQLQuery(plainQueryCaptacionLiq())
				.addScalar("CPL_PCO_LIQ_ID", Hibernate.LONG)
				.addScalar("CPL_COEAAH", Hibernate.BIG_DECIMAL)
				.addScalar("CPL_COCAAH", Hibernate.BIG_DECIMAL)
				.addScalar("CPL_NUDCAH", Hibernate.BIG_DECIMAL)
				.addScalar("CPL_NUCTAH", Hibernate.BIG_DECIMAL)
				.addScalar("CPL_SAANAH", Hibernate.BIG_DECIMAL)
				.addScalar("CPL_COCPAH", Hibernate.BIG_DECIMAL)
				.addScalar("CPL_IDPRAH", Hibernate.BIG_DECIMAL)
				.addScalar("CPL_IMMOAH", Hibernate.BIG_DECIMAL)
				.addScalar("CPL_SAPOAH", Hibernate.BIG_DECIMAL)
				.addScalar("CPL_FVVAAH", Hibernate.DATE)
				.addScalar("CPL_FEOCAH", Hibernate.DATE)
				.addScalar("CPL_NOCOAH", Hibernate.STRING)
				.setLong("idLiquidacion", idLiquidacion);

		return query.setResultTransformer(Transformers.aliasToBean(DescubiertoLiqVO.class)).list();
	}

	private String plainQueryCaptacionLiq() {
		StringBuilder plainQueryRecibosLiq = new StringBuilder();
		plainQueryRecibosLiq.append(" SELECT * ");
		plainQueryRecibosLiq.append(" FROM CPL_CAPTACION_EXTRACT_LIQ ");
		plainQueryRecibosLiq.append(" WHERE BORRADO = 0 ");
		plainQueryRecibosLiq.append("  AND CPL_PCO_LIQ_ID = :idLiquidacion ORDER BY CPL_NUSEAH");

		return plainQueryRecibosLiq.toString();
	}

}
