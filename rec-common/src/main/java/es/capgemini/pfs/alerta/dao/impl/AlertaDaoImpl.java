package es.capgemini.pfs.alerta.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.alerta.dao.AlertaDao;
import es.capgemini.pfs.alerta.model.Alerta;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.scoring.dto.DtoAlerta;

/**
 * @author Andrés Esteban
 *
 */
@Repository("AlertaDao")
public class AlertaDaoImpl extends AbstractEntityDao<Alerta, Long> implements AlertaDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<DtoAlerta> getDtoAlertasActivas() {
        String hql = "select a.tipoAlerta.codigo AS codTipoAlera, a.nivelGravedad.codigo , a.persona.id,"
                + "a.persona.tipoPersona.codigo , a.persona.segmento.codigo , a.persona.riesgoDirecto from Alerta a " + "where a.activo = 1";
        List<Object[]> resultados = getHibernateTemplate().find(hql);
        List<DtoAlerta> alertas = new ArrayList<DtoAlerta>();
        DtoAlerta dto;
        for (Object[] obj : resultados) {
            dto = new DtoAlerta();
            dto.setCodigoTipoAlerta((String) obj[0]);
            dto.setCodigoNivelGravedad((String) obj[1]);
            dto.setPersonaId((Long) obj[2]);
            dto.setCodigoTipoPersona((String) obj[3]);
            dto.setCodigoSegmento((String) obj[4]);
            dto.setRiesgoPersona((Float) obj[5]);
            alertas.add(dto);
        }
        return alertas;
    }

}
