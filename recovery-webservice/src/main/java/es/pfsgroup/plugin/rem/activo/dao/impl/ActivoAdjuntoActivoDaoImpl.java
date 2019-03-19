package es.pfsgroup.plugin.rem.activo.dao.impl;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAdjuntoActivoDao;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

@Repository("ActivoAdjuntoActivoDao")
public class ActivoAdjuntoActivoDaoImpl extends AbstractEntityDao<ActivoAdjuntoActivo, Long> implements ActivoAdjuntoActivoDao {

    private static final Boolean AUDITORIA_SIN_BORRAR = false;


    @Override
    public Boolean existeAdjuntoPorNombreYTipoDocumentoYNumActivo(String nombreAdjunto, String matriculaDocumento, Long numActivo) {
        Session session = this.getSessionFactory().getCurrentSession();;
        Criteria criteriaCount = session.createCriteria(ActivoAdjuntoActivo.class);
        criteriaCount.setProjection(Projections.rowCount());

        criteriaCount.add(Restrictions.eq("nombre", nombreAdjunto));
        criteriaCount.add(Restrictions.eq("auditoria.borrado", AUDITORIA_SIN_BORRAR));
        criteriaCount.createCriteria("activo").add(Restrictions.eq("numActivo", numActivo));
        criteriaCount.createCriteria("tipoDocumentoActivo").add(Restrictions.eq("matricula", matriculaDocumento));

        Integer totalCount = HibernateUtils.castObject(Integer.class, criteriaCount.uniqueResult());
       
        return totalCount > 0;
    }
}
