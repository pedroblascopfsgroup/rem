package es.capgemini.pfs.metrica.dao.impl;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.metrica.dao.FicheroMetricaDao;
import es.capgemini.pfs.metrica.dto.DtoMetrica;
import es.capgemini.pfs.metrica.model.FicheroMetrica;
import es.capgemini.pfs.persona.dao.DDTipoPersonaDao;
import es.capgemini.pfs.segmento.dao.SegmentoDao;

/**
 * Implementación del dao fichero de métricas.
 * @author aesteban
 *
 */
@Repository("FicheroMetricaDao")
public class FicheroMetricaDaoImpl extends AbstractEntityDao<FicheroMetrica, Long> implements FicheroMetricaDao {

    @Autowired
    private DDTipoPersonaDao tipoPersonaDao;
    @Autowired
    private SegmentoDao segmentoDao;

    /**
     * {@inheritDoc}
     */
    @Override
    public FicheroMetrica guardarFichero(DtoMetrica dto) {
        FicheroMetrica ficheroMetrica = new FicheroMetrica();
        ficheroMetrica.setTipoPersona(tipoPersonaDao.findByCodigo(dto.getCodigoTipoPersona()));
        ficheroMetrica.setSegmento(segmentoDao.findByCodigo(dto.getCodigoSegmento()));
        ficheroMetrica.setFechaCarga(new Date());
        ficheroMetrica.setFileItem(dto.getFileItem());
        save(ficheroMetrica);
        return ficheroMetrica;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void borrarFisicamente(FicheroMetrica ficheroInactivo) {
        getHibernateTemplate().delete(ficheroInactivo);
    }
}
