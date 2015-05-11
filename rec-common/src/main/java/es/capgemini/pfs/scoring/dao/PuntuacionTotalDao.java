package es.capgemini.pfs.scoring.dao;

import java.util.Date;
import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.scoring.model.PuntuacionParcial;
import es.capgemini.pfs.scoring.model.PuntuacionTotal;

/**
 * Dao para la PuntuacionTotal.
 * @author aesteban
 *
 */
public interface PuntuacionTotalDao extends AbstractDao<PuntuacionTotal, Long> {

    /**
     * Devuelve la lista de puntuaciones totales para la persona para la fecha indicada.
     * @param fecha la fecha.
     * @param idPersona el id de la persona.
     * @return la lista de Puntuación total.
     */
    PuntuacionTotal buscarPorFechaYPersona(Date fecha, Long idPersona);

    /**
     * Devuelve la lista de fechas para las cuales hay puntuaciones para una persona determinada.
     * @param idPersona el id de la persona que se busca
     * @param fechas las fechas que ya están en la consulta, para que no salgan en el combo.
     * @return la lista de fechas para las que tiene datos.
     */
    List<Date> getFechasPuntuacionTotal(Long idPersona, List<Date> fechas);

    /**
     * Devuelve las fechas para inicializar la pantalla de consulta del scoring de un cliente.
     * @param idPersona el id de la persona
     * @param fecha la fecha para la qué se búsca la más próxima
     * @return la fecha menor o igual más próxima a la pasada por parámetro.
     */
    Date getFechaMasProxima(Long idPersona, Date fecha);

    /**
     * Devuelve un listado ordenador por grupo, tipo de alerta y gravedad de todas las puntuaciones parciales de una puntuacion total
     * @param idPuntuacionTotal
     * @return
     */
    List<PuntuacionParcial> getPuntuacionesOrdenadas(Long idPuntuacionTotal);
}
