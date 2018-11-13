package es.pfsgroup.plugin.rem.gasto.dao.impl;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.gasto.dao.AdjuntoGastoDao;
import es.pfsgroup.plugin.rem.model.AdjuntoGasto;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

@Repository("AdjuntoGastoDao")
public class AdjuntoGastoDaoImpl extends AbstractEntityDao<AdjuntoGasto, Long> implements AdjuntoGastoDao {

    private static final Boolean AUDITORIA_SIN_BORRAR = false;


    @Override
    public Boolean existeAdjuntoPorNombreYTipoDocumentoYNumeroHayaGasto(String nombreAdjunto, String matriculaDocumento, Long numHayaGasto) {
        Session session = getSession();
        Criteria criteriaCount = session.createCriteria(AdjuntoGasto.class);
        criteriaCount.setProjection(Projections.rowCount());

        criteriaCount.add(Restrictions.eq("nombre", nombreAdjunto));
        criteriaCount.add(Restrictions.eq("auditoria.borrado", AUDITORIA_SIN_BORRAR));
        criteriaCount.createCriteria("gastoProveedor").add(Restrictions.eq("numGastoHaya", numHayaGasto));
        criteriaCount.createCriteria("tipoDocumentoGasto").add(Restrictions.eq("matricula", matriculaDocumento));

        Integer totalCount = HibernateUtils.castObject(Integer.class, criteriaCount.uniqueResult());
        session.disconnect();

        return totalCount > 0;
    }
}
