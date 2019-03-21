package es.pfsgroup.plugin.rem.expedienteComercial.dao.impl;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.DDSubtipoDocumentoExpedienteDao;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoDocumentoExpediente;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

@Repository("DDSubtipoDocumentoExpedienteDao")
public class DDSubtipoDocumentoExpedienteDaoImpl extends AbstractEntityDao<DDSubtipoDocumentoExpediente, Long> implements DDSubtipoDocumentoExpedienteDao {

    private static final Boolean AUDITORIA_SIN_BORRAR = false;


    @Override
    public DDSubtipoDocumentoExpediente getSubtipoDocumentoExpedienteComercialPorMatricula(String matriculaDocumento) {
        Session session = this.getSessionFactory().getCurrentSession();;
        Criteria criteria = session.createCriteria(DDSubtipoDocumentoExpediente.class);
        criteria.add(Restrictions.eq("matricula", matriculaDocumento));
        criteria.add(Restrictions.eq("auditoria.borrado", AUDITORIA_SIN_BORRAR));

        // Debería existir un solo resultado, pero existen casos de matrícula compartida por diferentes documentos.
        DDSubtipoDocumentoExpediente ddSubtipoDocumentoExpediente = HibernateUtils.castObject(DDSubtipoDocumentoExpediente.class, criteria.list().get(0));
       
        return ddSubtipoDocumentoExpediente;
    }

    @Override
    public Boolean existeMatriculaRegistradaEnSubtipoDocumento(String matricula) {
        Session session = this.getSessionFactory().getCurrentSession();;
        Criteria criteriaCount = session.createCriteria(DDSubtipoDocumentoExpediente.class);
        criteriaCount.setProjection(Projections.rowCount());

        criteriaCount.add(Restrictions.eq("matricula", matricula));
        criteriaCount.add(Restrictions.eq("auditoria.borrado", AUDITORIA_SIN_BORRAR));

        Integer totalCount = HibernateUtils.castObject(Integer.class, criteriaCount.uniqueResult());
        
        return totalCount > 0;
    }
}
