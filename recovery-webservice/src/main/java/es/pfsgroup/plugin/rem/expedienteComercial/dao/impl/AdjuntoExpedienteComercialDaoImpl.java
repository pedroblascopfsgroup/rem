package es.pfsgroup.plugin.rem.expedienteComercial.dao.impl;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.AdjuntoExpedienteComercialDao;
import es.pfsgroup.plugin.rem.model.AdjuntoExpedienteComercial;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

@Repository("AdjuntoExpedienteComercialDao")
public class AdjuntoExpedienteComercialDaoImpl extends AbstractEntityDao<AdjuntoExpedienteComercial, Long> implements AdjuntoExpedienteComercialDao {

    private static final Boolean AUDITORIA_SIN_BORRAR = false;


    @Override
    public Boolean existeAdjuntoPorNombreYTipoDocumentoYNumExpedienteComercial(String nombreAdjunto, String matriculaDocumento, Long numExpedienteComercial) {
        Session session = getSession();
        Criteria criteriaCount = session.createCriteria(AdjuntoExpedienteComercial.class);
        criteriaCount.setProjection(Projections.rowCount());

        criteriaCount.add(Restrictions.eq("nombre", nombreAdjunto));
        criteriaCount.add(Restrictions.eq("auditoria.borrado", AUDITORIA_SIN_BORRAR));
        criteriaCount.createCriteria("expediente").add(Restrictions.eq("numExpediente", numExpedienteComercial));
        criteriaCount.createCriteria("subtipoDocumentoExpediente").add(Restrictions.eq("matricula", matriculaDocumento));

        Integer totalCount = HibernateUtils.castObject(Integer.class, criteriaCount.uniqueResult());
        session.disconnect();

        return totalCount > 0;
    }
}
