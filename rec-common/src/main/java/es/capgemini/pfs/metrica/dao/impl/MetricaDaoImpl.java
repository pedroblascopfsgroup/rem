package es.capgemini.pfs.metrica.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.metrica.dao.MetricaDao;
import es.capgemini.pfs.metrica.dto.DtoMetrica;
import es.capgemini.pfs.metrica.model.Metrica;

/**
 * Implementación del dao de métricas.
 * @author aesteban
 *
 */
@Repository("MetricaDao")
public class MetricaDaoImpl extends AbstractEntityDao<Metrica, Long> implements MetricaDao {

    /**
     * {@inheritDoc}
     */
    @Override
    public void borrarMetricaFisicamente(Metrica metrica) {
        getHibernateTemplate().delete(metrica);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Metrica> getMetricasPorDefecto() {
        String hql = "from Metrica m where m.activo= 1 and m.tipoPersona is not null and m.segmento is null";
        return getHibernateTemplate().find(hql);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Metrica> buscarMetricasPorSegmentos() {
        String hql = "from Metrica m where m.activo= 1 and m.segmento is not null and m.tipoPersona is null";
        return getHibernateTemplate().find(hql);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    @SuppressWarnings("unchecked")
    public Metrica getMetrica(DtoMetrica dto, Boolean metricaActiva) {
        String hql = "from Metrica m where m.activo= ? ";
        List params = new ArrayList();
        params.add(metricaActiva);
        String codSegmento = dto.getCodigoSegmento();
        if (codSegmento != null) {
            hql += " and m.segmento.codigo = ?";
            params.add(codSegmento);
        } else {
            hql += " and m.segmento is null";
            String tipoPersona = dto.getCodigoTipoPersona();
            if (tipoPersona != null) {
                hql += " and m.tipoPersona.codigo = ?";
                params.add(tipoPersona);
            } else {
                hql += " and m.tipoPersona is null";
            }
        }

        List<Metrica> metricas = getHibernateTemplate().find(hql, params.toArray());

        if (metricas.size() > 0) {
            return metricas.get(0);
        }
        return null;
    }

}
