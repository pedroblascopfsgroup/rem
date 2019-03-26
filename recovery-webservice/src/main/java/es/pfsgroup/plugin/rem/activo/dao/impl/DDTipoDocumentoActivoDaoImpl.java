package es.pfsgroup.plugin.rem.activo.dao.impl;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.activo.dao.DDTipoDocumentoActivoDao;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

@Repository("DDTipoDocumentoActivoDao")
public class DDTipoDocumentoActivoDaoImpl extends AbstractEntityDao<DDTipoDocumentoActivo, Long> implements DDTipoDocumentoActivoDao {

    private static final Boolean AUDITORIA_SIN_BORRAR = false;

    @Override
    public DDTipoDocumentoActivo getDDTipoDocumentoActivoPorMatricula(String matriculaDocumento) {
        Session session = this.getSessionFactory().getCurrentSession();
        Criteria criteria = session.createCriteria(DDTipoDocumentoActivo.class);
        criteria.add(Restrictions.eq("matricula", matriculaDocumento));
        criteria.add(Restrictions.eq("auditoria.borrado", AUDITORIA_SIN_BORRAR));

        // Debería existir un solo resultado, pero existen casos de matrícula compartida por diferentes documentos (Ej: AI-01-NOTS-01).
        DDTipoDocumentoActivo ddTipoDocumentoActivo = HibernateUtils.castObject(DDTipoDocumentoActivo.class, criteria.list().get(0));
        
        return ddTipoDocumentoActivo;
    }

    @Override
    public Boolean existeMatriculaRegistradaEnTipoDocumento(String matricula) {
        Session session = this.getSessionFactory().getCurrentSession();
        Criteria criteriaCount = session.createCriteria(DDTipoDocumentoActivo.class);
        criteriaCount.setProjection(Projections.rowCount());
        criteriaCount.add(Restrictions.eq("matricula", matricula));
        criteriaCount.add(Restrictions.eq("auditoria.borrado", AUDITORIA_SIN_BORRAR));

        Integer totalCount = HibernateUtils.castObject(Integer.class, criteriaCount.uniqueResult());
       
        return totalCount > 0;
    }
}
