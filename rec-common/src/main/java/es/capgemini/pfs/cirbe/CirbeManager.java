package es.capgemini.pfs.cirbe;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.cirbe.dao.CirbeDao;
import es.capgemini.pfs.cirbe.dto.DtoCirbe;
import es.capgemini.pfs.cirbe.dto.DtoResumenCirbe;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.utils.FormatUtils;

/**
 * Manager de las operaciones con de las carga CIRBE.
 * @author marruiz
 */
@Service
public class CirbeManager {

    private static final long UN_DIA_EN_MILLIS = 24L * 60L * 60L * 1000L;

    @Autowired
    private CirbeDao cirbeDao;

    /**
     * @param idPersona Long
     * @param fecha1 String
     * @param fecha2 String
     * @param fecha3 String
     * @return List Date: todas las fechas de extracción cirbe
     * donde el cliente tenga una carga.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CIRBE_MGR_GET_FECHAS_EXTRAC_PERSONA)
    public List<Date> getFechasExtraccionPersona(Long idPersona, String fecha1, String fecha2, String fecha3) {
        SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
        Date f1 = null;
        Date f2 = null;
        Date f3 = null;
        try {
            if (fecha1 != null) {
                f1 = sdf1.parse(fecha1);
            }
            if (fecha2 != null) {
                f2 = sdf1.parse(fecha2);
            }
            if (fecha3 != null) {
                f3 = sdf1.parse(fecha3);
            }
        } catch (ParseException e) {

        }
        return cirbeDao.getFechasExtraccionPersona(idPersona, f1, f2, f3);
    }
    
    /**
     * @param idPersona Long
     * @param fecha1 String
     * @param fecha2 String
     * @param fecha3 String
     * @return List Date: todas las fechas de actualización cirbe
     * donde el cliente tenga una carga.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CIRBE_MGR_GET_FECHAS_ACTUALIZACION_PERSONA)
    public List<Date> getFechasActualizacionPersona(Long idPersona, String fecha1, String fecha2, String fecha3) {
        SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
        Date f1 = null;
        Date f2 = null;
        Date f3 = null;
        try {
            if (fecha1 != null) {
                f1 = sdf1.parse(fecha1);
            }
            if (fecha2 != null) {
                f2 = sdf1.parse(fecha2);
            }
            if (fecha3 != null) {
                f3 = sdf1.parse(fecha3);
            }
        } catch (ParseException e) {

        }
        return cirbeDao.getFechasActualizacionPersona(idPersona, f1, f2, f3);
    }

    /**
     * @param idPersona Long
     * @param fecha String: recibimos la fecha como String <code>dd/MM/yyyy</code>
     * @return List Date: todas las fechas de extracción cirbe
     * donde el cliente tenga una carga, anteriores a la pasada.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CIRBE_MGR_GET_FECHAS_EXTRAC_PERSONA_DESDE)
    List<Date> getFechasExtraccionPersonaDesde(Long idPersona, String fecha) {
        Date f = FormatUtils.strADate(fecha, FormatUtils.DDMMYYYY);
        return cirbeDao.getFechasExtraccionPersonaDesde(idPersona, f);
    }

    /**
     * @param idPersona Long
     * @param desde String: fecha última deseada, en formato String <code>dd/MM/yyyy</code>
     * @param hasta String: fecha más antigua deseada, en formato String <code>dd/MM/yyyy</code>
     * @return List Date: todas las fechas de extracción cirbe
     * donde el cliente tenga una carga, anteriores a la pasada.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CIRBE_MGR_GET_FECHAS_EXTRAC_PERSONA_HASTA)
    List<Date> getFechasExtraccionPersonaHasta(Long idPersona, String desde, String hasta) {
        Date fdesde = null, fhasta = null;
        if (desde == null || desde.equals("")) {
            new BusinessOperationException("cirbe.filtro.desde.error");
        }

        fdesde = FormatUtils.strADate(desde, FormatUtils.DDMMYYYY);
        if (hasta != null && !hasta.equals("")) {
            fhasta = FormatUtils.strADate(hasta, FormatUtils.DDMMYYYY);
        }
        return cirbeDao.getFechasExtraccionPersonaHasta(idPersona, fdesde, fhasta);
    }

    /**
     * Devuelve toda la carga cirbe de la persona entre las fechas pasadas.
     * @param idPersona Long
     * @param fecha1 String: fecha del primer combo pasada como cadena en el formato <code>dd/MM/yyyy</code>
     * @param fecha2 String: fecha del segundo combo pasada como cadena en el formato <code>dd/MM/yyyy</code>
     * @param fecha3 String: fecha del tercer combo pasada como cadena en el formato <code>dd/MM/yyyy</code>
     * @return DtoResumenCirbe
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CIRBE_MGR_GET_CIRBE_DATA)
    public DtoResumenCirbe getCirbeData(Long idPersona, String fecha1, String fecha2, String fecha3) {
        Date f1 = FormatUtils.strADate(fecha1, FormatUtils.DDMMYYYY);
        Date f2 = FormatUtils.strADate(fecha2, FormatUtils.DDMMYYYY);
        Date f3 = FormatUtils.strADate(fecha3, FormatUtils.DDMMYYYY);
        DtoResumenCirbe resumen = new DtoResumenCirbe();
        resumen.setFecha1(f1);
        if (fecha2 != null) {
            resumen.setFecha2(f2);
        }
        if (fecha3 != null) {
            resumen.setFecha3(f3);
        }
        List<DtoCirbe> rows = cirbeDao.getCirbeData(idPersona, resumen.getFecha1(), resumen.getFecha2(), resumen.getFecha3());
        resumen.setRows(rows);
        return resumen;
    }

    /**
     * Develve las fechas de cirbe para la que haya datos retrocediendo tantos días como se indique.
     * En el caso de no haber un registro para esa fecha se toma la próxima anterior.
     * @param idPersona la person para la que se buscan registros.
     * @param diasAtras los días que hay que retroceder a partir de la fecha de hoy.
     * @return la fecha para la que hay registros de cirbe o null si no hay.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CIRBE_MGR_GET_FECHA_CIRBE)
    public Date getFechaCirbe(Long idPersona, Long diasAtras) {
        Calendar cal = new GregorianCalendar();
        cal.setTimeInMillis((System.currentTimeMillis() - diasAtras * UN_DIA_EN_MILLIS));
        return cirbeDao.getFechaCirbeProximaAnterior(idPersona, cal.getTime());
    }

    /**
     * Refresca las listas de los combos que no fueron modificados.
     * @param noSeleccionados la lista de valores no seleccionados
     * @param valorSeleccionado el valor que contenía el combo, lo tengo que agregar a la lista.
     * @return la lista de valores no seleccionados más el que ya estaba marcado en el combo.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CIRBE_MGR_REFREZCAR_LISTAS)
    public List<Date> refrescarListas(List<Date> noSeleccionados, String valorSeleccionado) {
        List<Date> fechas = new ArrayList<Date>();
        fechas.addAll(noSeleccionados);
        SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
        Date d = null;
        try {
            d = sdf1.parse(valorSeleccionado);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        fechas.add(d);
        return fechas;
    }

    /**
     * Actualiza la lista de fechas seleccionadas cuando se cambia un combo.
     * @param noSeleccionados los elementos que no estaban seleccionados.
     * @param nuevaSeleccion el nuevo valor seleccioando del combo.
     * @param viejaSeleccion el valor que estaba seleccionado antes.
     * @return la nueva lista de valores seleccionados.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CIRBE_MGR_ACTUALIZAR_FECHAS_SELECCIONADAS)
    public List<Date> actualizarFechasSeleccionadas(List<Date> noSeleccionados, String nuevaSeleccion, String viejaSeleccion) {
        List<Date> fechas = new ArrayList<Date>();

        SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
        Date d = null;
        Date viejo = null;
        try {
            d = sdf1.parse(nuevaSeleccion);
            viejo = sdf1.parse(viejaSeleccion);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        for (Date fechaVieja : noSeleccionados) {
            if (fechaVieja.getTime() == d.getTime()) {
                noSeleccionados.remove(fechaVieja);
                break;
            }
        }
        fechas.addAll(noSeleccionados);
        fechas.add(viejo);
        return fechas;
    }
}
