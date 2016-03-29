package es.capgemini.pfs.cirbe.dao;

import java.util.Date;
import java.util.List;

import es.capgemini.pfs.cirbe.dto.DtoCirbe;
import es.capgemini.pfs.cirbe.model.Cirbe;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * Interfaz del dao de clase cirbe.
 * @author marruiz
 *
 */
public interface CirbeDao extends AbstractDao<Cirbe, Long> {

    /**
     * Cantidad máxima de cargas a mostrar en el tab CIRBE de clientes.
     */
    int CANT_FECHAS_CARGAS = 3;

    /**
     * @param idPersona Long
     * @param fecha1 la fecha seleccionada en el combo 1
     * @param fecha2 la fecha seleccionada en el combo 2
     * @param fecha3 la fecha seleccionada en el combo 3
     * @return List Date: todas las fechas de extracción cirbe
     * donde el cliente tenga una carga.
     */
    List<Date> getFechasExtraccionPersona(Long idPersona, Date fecha1, Date fecha2, Date fecha3);
    
    /**
     * @param idPersona Long
     * @param fecha1 la fecha seleccionada en el combo 1
     * @param fecha2 la fecha seleccionada en el combo 2
     * @param fecha3 la fecha seleccionada en el combo 3
     * @return List Date: todas las fechas de actualización cirbe
     * donde el cliente tenga una carga.
     */
    List<Date> getFechasActualizacionPersona(Long idPersona, Date fecha1, Date fecha2, Date fecha3);

    /**
     * @param idPersona Long
     * @param fecha Date
     * @return List Date: todas las fechas de extracción cirbe
     * donde el cliente tenga una carga, anteriores a la pasada.
     */
    List<Date> getFechasExtraccionPersonaDesde(Long idPersona, Date fecha);

    /**
     * @param idPersona Long
     * @param desde Date: fecha última deseada
     * @param hasta Date: fecha más antigua deseada, si es <code>null</code> solo retorna
     * la fecha <code>desde</code>
     * @return List Date: fechas de extracción cirbe donde el cliente tenga una carga,
     * entre <code>desde</code> y <code>hasta</code> inclusives, máximo <code>CANT_FECHAS_CARGAS</code> de fechas
     */
    List<Date> getFechasExtraccionPersonaHasta(Long idPersona, Date desde, Date hasta);

    /**
     * Devuelve toda la carga cirbe de la persona en las fechas pasadas.
     * @param idPersona Long
     * @param fecha1 Date
     * @param fecha2 Date
     * @param fecha3 Date
     * @return DtoCirbe
     */
    List<DtoCirbe> getCirbeData(Long idPersona, Date fecha1, Date fecha2, Date fecha3);

    /**
     * Devuelve la fecha próxima igual o anterior para la que hay registros de cirbe a la fecha que se pasa como parámetro.
     * @param d la fecha de referencia
     * @param idPersona el id de la persona
     * @return la fecha inmediata anterior para la que hay registros.
     */
    Date getFechaCirbeProximaAnterior(Long idPersona,Date d);
}
