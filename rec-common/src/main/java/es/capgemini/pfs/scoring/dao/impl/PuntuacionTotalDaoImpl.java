package es.capgemini.pfs.scoring.dao.impl;

import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.scoring.dao.PuntuacionTotalDao;
import es.capgemini.pfs.scoring.model.PuntuacionParcial;
import es.capgemini.pfs.scoring.model.PuntuacionTotal;

/**
 * Implementación del dao de PuntuacionTotal.
 * @author aesteban
 *
 */
@Repository("PuntuacionTotalDao")
public class PuntuacionTotalDaoImpl extends AbstractEntityDao<PuntuacionTotal, Long> implements PuntuacionTotalDao {

    /**
     * Devuelve la lista de puntuaciones totales para la persona para la fecha indicada.
     * @param fecha la fecha.
     * @param idPersona el id de la persona.
     * @return la lista de Puntuación total.
     */
    @SuppressWarnings("unchecked")
    public PuntuacionTotal buscarPorFechaYPersona(Date fecha, Long idPersona) {
        StringBuffer hql = new StringBuffer();
        hql.append("from PuntuacionTotal pt where pt.persona.id = :idPersona ");
        hql.append(" and pt.fechaProcesado = :fechaProcesado");
        List<PuntuacionTotal> pt = getHibernateTemplate().findByNamedParam(hql.toString(), new String[] { "idPersona", "fechaProcesado" },
                new Object[] { idPersona, fecha });

        if (pt != null && pt.size() > 0)
            return pt.get(0);
        else
            return null;
    }

    /**
     * Devuelve la lista de fechas para las cuales hay puntuaciones para una persona determinada.
     * @param idPersona el id de la persona que se busca
     * @param fechas las fechas que ya están en la consulta, para que no salgan en el combo.
     * @return la lista de fechas para las que tiene datos.
     */
    @SuppressWarnings("unchecked")
    public List<Date> getFechasPuntuacionTotal(Long idPersona, List<Date> fechas) {
        String hql = "select distinct fechaProcesado from PuntuacionTotal where persona.id = :idPersona";
//        String[] params = new String[fechas.size() + 1];
//        Object[] values = new Object[fechas.size() + 1];
        String[] params = new String[1];
        Object[] values = new Object[1];
        
        params[0] = "idPersona";
        values[0] = idPersona;

//        for (int i = 0; i < fechas.size(); i++) {
//            hql += " and fechaProcesado != :fecha" + i;
//            params[i + 1] = "fecha" + i;
//            values[i + 1] = fechas.get(i);
//        }

        hql += " order by fechaProcesado DESC";

        return getHibernateTemplate().findByNamedParam(hql, params, values);
    }

    /**
     * Devuelve las fechas para inicializar la pantalla de consulta del scoring de un cliente.
     * @param idPersona el id de la persona
     * @param fecha la fecha para la qué se búsca la más próxima
     * @return la fecha menor o igual más próxima a la pasada por parámetro.
     */
    @SuppressWarnings("unchecked")
    public Date getFechaMasProxima(Long idPersona, Date fecha) {
        String hql = "select max(fechaProcesado) from PuntuacionTotal where persona.id = :idPersona and fechaProcesado <= :fechaProcesado ";
        List<Date> fechas = getHibernateTemplate().findByNamedParam(hql.toString(), new String[] { "idPersona", "fechaProcesado" },
                new Object[] { idPersona, fecha });
        if (fechas.size() > 0) { return fechas.get(0); }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<PuntuacionParcial> getPuntuacionesOrdenadas(Long idPuntuacionTotal) {

        StringBuffer hql = new StringBuffer();
        hql.append(" select ppa from PuntuacionParcial ppa ");
        hql.append(" where puntuacionTotal.id = :idPuntuacionTotal ");
        hql.append(" order by alerta.tipoAlerta.grupoAlerta.codigo ASC, alerta.tipoAlerta.codigo ASC, alerta.nivelGravedad.peso DESC ");

        return getHibernateTemplate().findByNamedParam(hql.toString(), "idPuntuacionTotal", idPuntuacionTotal);
    }
}
