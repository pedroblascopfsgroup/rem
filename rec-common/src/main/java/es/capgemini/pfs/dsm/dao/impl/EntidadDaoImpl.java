package es.capgemini.pfs.dsm.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.dao.AbstractMasterDao;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;

/**
 * @author Nicolás Cornaglia
 */
@Repository("EntidadDao")
public class EntidadDaoImpl extends AbstractMasterDao<Entidad, Long> implements EntidadDao {

    /**
     * {@inheritDoc}
     */
    @Override
    public Entidad findByWorkingCode(String workingCode) {
        return (Entidad) (getHibernateTemplate().find(
                "select c.entidad from EntidadConfig c where c.dataKey='workingCode' and c.dataValue = ?", workingCode)).iterator().next();
    }
    
    @Override
    public Entidad findByDescripcion(String descripcion) {
        return (Entidad) (getHibernateTemplate().find(
                "select c from Entidad c where c.descripcion = ?", descripcion)).iterator().next();
    }

    
}
