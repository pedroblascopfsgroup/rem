package es.pfsgroup.plugin.rem.gasto.dao.impl;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.gasto.dao.DDTipoDocumentoGastoDao;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoGasto;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

@Repository("DDTipoDocumentoGastoDao")
public class DDTipoDocumentoGastoDaoImpl extends AbstractEntityDao<DDTipoDocumentoGasto, Long> implements DDTipoDocumentoGastoDao {

    private static final Boolean AUDITORIA_SIN_BORRAR = false;


    @Override
    public DDTipoDocumentoGasto getTipoDocumentoGastoPorMatricula(String matriculaDocumento) {
        Session session = getSession();
        Criteria criteria = session.createCriteria(DDTipoDocumentoGasto.class);
        criteria.add(Restrictions.eq("matricula", matriculaDocumento));
        criteria.add(Restrictions.eq("auditoria.borrado", AUDITORIA_SIN_BORRAR));

        // Debería existir un solo resultado, pero existen casos de matrícula compartida por diferentes documentos.
        DDTipoDocumentoGasto ddTipoDocumentoGasto = HibernateUtils.castObject(DDTipoDocumentoGasto.class, criteria.list().get(0));
        session.disconnect();

        return ddTipoDocumentoGasto;
    }

    @Override
    public Boolean existeMatriculaRegistradaEnTipoDocumento(String matricula) {
        Session session = getSession();
        Criteria criteriaCount = session.createCriteria(DDTipoDocumentoGasto.class);
        criteriaCount.setProjection(Projections.rowCount());

        criteriaCount.add(Restrictions.eq("matricula", matricula));
        criteriaCount.add(Restrictions.eq("auditoria.borrado", AUDITORIA_SIN_BORRAR));

        Integer totalCount = HibernateUtils.castObject(Integer.class, criteriaCount.uniqueResult());
        session.disconnect();

        return totalCount > 0;
    }
}
