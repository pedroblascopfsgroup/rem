package es.capgemini.pfs.scoring;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.metrica.dto.DtoMetrica;
import es.capgemini.pfs.metrica.model.Metrica;
import es.capgemini.pfs.metrica.model.MetricaTipoAlerta;
import es.capgemini.pfs.metrica.model.MetricaTipoAlertaGravedad;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.scoring.dto.DtoAlerta;
import es.capgemini.pfs.scoring.dto.DtoPuntuacionParcial;
import es.capgemini.pfs.scoring.dto.DtoPuntuacionTotal;
import es.capgemini.pfs.scoring.dto.DtoSimulacion;

/**
 * Clase que realiza las tareas de calculo de scoring en el common.
 * En principio solo no guardaria datos, porque lo hace el batch.
 * @author aesteban
 *
 */
@Service
public class SimulacionManager {

	@Autowired
    private Executor executor;

    public static final String MET_ACTIVA = "metActiva";
    public static final String MET_INACTIVA = "metInactiva";

    /**
     * Realiza una simulaciónn para los parámetros indicados.
     * @param metrica Metrica
     * @param dto dtoMetrica
     * @return Lista de puntuacion total?
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_SIMULACCION_MGR_SIMULAR)
    public List<DtoSimulacion> simular(Metrica metrica, DtoMetrica dto) {
        List<DtoPuntuacionTotal> totales = calcularTotales(metrica, dto);
        List<DtoSimulacion> dtosSim = new ArrayList<DtoSimulacion>();
        if (totales.isEmpty()) {
            return dtosSim;
        }

        Double maxVCRTotal = totales.get(0).getVolumenRiesgoCliente().doubleValue();
        double rangoIntervaloVRC = getRangoIntervaloVRC(totales, dto.getCantidadIntervaloVRC());
        int cantIntVrc = dto.getCantidadIntervaloVRC();
        Set<String> nombresIntervalo = buscarNombreIntervalos(totales);

        for (int j = 1; j <= cantIntVrc; j++) {
            List<DtoPuntuacionTotal> totalesOrdenados = getTotalesOrdenadosDelRangoVRC(totales, j);
            DtoSimulacion dtoSim = new DtoSimulacion();
            Double maxVCR;
            Double minVCR;
            //Intervalo mayor
            if (j == 1) {
                maxVCR = maxVCRTotal;
                minVCR = maxVCR - rangoIntervaloVRC;
            } else {
                maxVCR = maxVCRTotal - (rangoIntervaloVRC * (j - 1));
                minVCR = maxVCR - rangoIntervaloVRC;
            }
            dtoSim.setMaxVRC(Double.valueOf(Math.round(maxVCR)));
            dtoSim.setMinVRC(Double.valueOf(Math.round(minVCR)));
            dtoSim.setIntervalos(crearListaIntervalosSumarizados(totalesOrdenados, nombresIntervalo));
            dtosSim.add(dtoSim);
        }

        return dtosSim;
    }

    /**
     * Recupera los totales que corresponden al rango de VRC indicado
     * ordenados por VRC de mayor a menor.
     * @param totales
     * @param j
     * @return
     */
    private List<DtoPuntuacionTotal> getTotalesOrdenadosDelRangoVRC(List<DtoPuntuacionTotal> totales, int j) {
        List<DtoPuntuacionTotal> subList = new ArrayList<DtoPuntuacionTotal>();
        for (DtoPuntuacionTotal puntuacionTotal : totales) {
            if (puntuacionTotal.getRangoVolumenRiesgoCliente().equals(j)) {
                subList.add(puntuacionTotal);
            }
        }
        return subList;
    }

    /**
     * Retorna un mapa cuyo key el nombre del intervalo y su valor es otro mapa con el numero de clientes y VRC total.
     * @param totales
     * @return
     */
    private Map<String, Map<String, Double>> crearListaIntervalosSumarizados(List<DtoPuntuacionTotal> totales, Set<String> nombresIntervalo) {
        Map<String, Map<String, Double>> intervalosSumarizados = new HashMap<String, Map<String, Double>>();
        //Inicializo el map
        Map<String, Double> map;
        for (String nombreIntervalo : nombresIntervalo) {
            map = new HashMap<String, Double>();
            map.put(DtoSimulacion.KEY_CANT_CLIENTES, 0D);
            map.put(DtoSimulacion.KEY_TOTAL_VRC, 0D);
            intervalosSumarizados.put(nombreIntervalo, map);
        }

        for (DtoPuntuacionTotal total : totales) {
            map = intervalosSumarizados.get(total.getIntervalo());

            Double cantClientes = map.get(DtoSimulacion.KEY_CANT_CLIENTES) + 1;
            Double totalVRC = map.get(DtoSimulacion.KEY_TOTAL_VRC) + total.getVolumenRiesgoCliente();
            map.put(DtoSimulacion.KEY_CANT_CLIENTES, cantClientes);
            map.put(DtoSimulacion.KEY_TOTAL_VRC, totalVRC);
            intervalosSumarizados.put(total.getIntervalo(), map);
        }
        return intervalosSumarizados;
    }

    /**
     * Retorna los totales ordenados por VRE.
     * @param metrica
     * @param dto
     * @return TreeSet
     */
    @SuppressWarnings("unchecked")
	private List<DtoPuntuacionTotal> calcularTotales(Metrica metrica, DtoMetrica dto) {
        List<DtoAlerta> alertas = (List<DtoAlerta>)executor.execute(
        		PrimariaBusinessOperation.BO_ALERTA_MGR_GET_DTO_ALERTAS_ACTIVAS);
        List<DtoPuntuacionParcial> parciales = calcularParciales(metrica, alertas);
        List<DtoPuntuacionTotal> puntuacionTotales = calcularPuntuacionesTotales(parciales);
        int rating = 1;
        double rangoIntervalo = new Double(puntuacionTotales.size()) / dto.getCantidadIntervaloRating();
        for (DtoPuntuacionTotal total : puntuacionTotales) {
            //Rating
            total.setRating(rating);
            rating++;
            //Intervalo
            total.setIntervalo(calcularIntervalo(total, rangoIntervalo));
        }
        return setearRangosVRC(puntuacionTotales, dto.getCantidadIntervaloVRC());
    }


    /**
     * Calcula los totales por persona y los ordena por el total.
     * @param parciales
     * @return
     */
    private List<DtoPuntuacionTotal> calcularPuntuacionesTotales(List<DtoPuntuacionParcial> parciales) {
        Map<Long, DtoPuntuacionTotal> totales = new HashMap<Long, DtoPuntuacionTotal>();
        for (DtoPuntuacionParcial parcial : parciales) {
            DtoPuntuacionTotal total = totales.get(parcial.getPersonaId());
            if (total == null) {
                total = new DtoPuntuacionTotal();
                total.setPuntuacion(0L);
                // Trunco el VRC para despues calcular a que rango pertenece correctamente.
                total.setVolumenRiesgoCliente(new Float(Math.floor(parcial.getRiesgoPersona())));
                total.setPersonaId(parcial.getPersonaId());
            }
            total.setPuntuacion(total.getPuntuacion() + parcial.getPuntuacion());
            totales.put(parcial.getPersonaId(), total);
        }
        List<DtoPuntuacionTotal> totalesOrdenados = new ArrayList<DtoPuntuacionTotal>();
        totalesOrdenados.addAll(totales.values());
        Collections.sort(totalesOrdenados, new Comparator<DtoPuntuacionTotal>() {
            @Override
            public int compare(DtoPuntuacionTotal t1, DtoPuntuacionTotal t2) {
                return t2.getPuntuacion().compareTo(t1.getPuntuacion());
            }
        });
        return totalesOrdenados;
    }

    /**
     * Calcula el nombre del intervalo para el total dado.
     * @param puntuacionTotal
     * @param rangoIntervalo
     */
    private String calcularIntervalo(DtoPuntuacionTotal puntuacionTotal, double rangoIntervalo) {
        final int VEINTISEIS = 26;
        final double VEINTISEIS_MAS = 26.001;
        final int SESENTA_Y_CUATRO = 64;
        double caracterCeil = Math.ceil(puntuacionTotal.getRating() / rangoIntervalo);
        // Si el caracter no se pasa de 26 significa que con 1 caracter me basta.
        if (caracterCeil <= VEINTISEIS) {
            char caracter = (char) (caracterCeil + SESENTA_Y_CUATRO);
            return "" + caracter;
        }
        // Necesito armar un string AA
        double cantidadLetrasPrevias = Math.floor(puntuacionTotal.getRating() / rangoIntervalo / VEINTISEIS_MAS);
        char primerCaracter = (char) (cantidadLetrasPrevias + SESENTA_Y_CUATRO);
        char segundoCaracter = (char) (caracterCeil - (cantidadLetrasPrevias * VEINTISEIS) + SESENTA_Y_CUATRO);
        return "" + primerCaracter + segundoCaracter;

    }

    /**
     * Setea el orden del rango de VRC que pertenece cada total.
     * @param puntuacionTotales
     * @param cantidadIntervaloVRC
     */
    private List<DtoPuntuacionTotal> setearRangosVRC(List<DtoPuntuacionTotal> puntuacionTotales, int cantidadIntervaloVRC) {
        if (puntuacionTotales.isEmpty()) {
            return puntuacionTotales;
        }
        Collections.sort(puntuacionTotales, new Comparator<DtoPuntuacionTotal>() {
            @Override
            public int compare(DtoPuntuacionTotal t1, DtoPuntuacionTotal t2) {
                return t2.getVolumenRiesgoCliente().compareTo(t1.getVolumenRiesgoCliente());
            }
        });

        Float maxVCR = puntuacionTotales.get(0).getVolumenRiesgoCliente();
        double rangoIntervalo = getRangoIntervaloVRC(puntuacionTotales, cantidadIntervaloVRC);
        for (DtoPuntuacionTotal total : puntuacionTotales) {
            Float diff = maxVCR - total.getVolumenRiesgoCliente();
            Double rango = 1D;
            if (diff != 0) {
                rango = Math.ceil(diff / rangoIntervalo);
            }

            total.setRangoVolumenRiesgoCliente(rango.intValue());
        }
        return puntuacionTotales;
    }

    private double getRangoIntervaloVRC(List<DtoPuntuacionTotal> puntuacionTotales, int cantidadIntervaloVRC) {
        Float maxVCR = puntuacionTotales.get(0).getVolumenRiesgoCliente();
        Float minVCR = puntuacionTotales.get(puntuacionTotales.size() - 1).getVolumenRiesgoCliente();
        return new Double(maxVCR - minVCR) / cantidadIntervaloVRC;
    }

    private Set<String> buscarNombreIntervalos(List<DtoPuntuacionTotal> totales) {
        Set<String> set = new HashSet<String>();
        for (DtoPuntuacionTotal total : totales) {
            set.add(total.getIntervalo());
        }
        return set;
    }

    /**
     * Calcula los valores parciales para cada alerta segun la metrica.
     * @param metrica
     * @param alertas
     * @return
     */
    private List<DtoPuntuacionParcial> calcularParciales(Metrica metrica, List<DtoAlerta> alertas) {
        boolean metDefecto = metrica.getTipoPersona() != null;
        List<DtoPuntuacionParcial> parciales = new ArrayList<DtoPuntuacionParcial>();
        for (DtoAlerta alerta : alertas) {
            DtoPuntuacionParcial parcial = new DtoPuntuacionParcial();
            parcial.setPersonaId(alerta.getPersonaId());
            parcial.setRiesgoPersona(alerta.getRiesgoPersona());
            parcial.setPuntuacion(calcularPuntuacion(alerta, metrica, metDefecto));
            parciales.add(parcial);
        }
        return parciales;
    }

    /**
     * Busca la configuración de la metrica para el tipo y nivel de alerta.
     * Si no existe busca una de defecto o del segmento correspondiente.
     * Una vez encontrada multiplica los pesos/valores.
     * @param alerta alerta
     * @param metrica metrica
     * @return Long
     */
    private Long calcularPuntuacion(DtoAlerta alerta, Metrica metrica, boolean metDefecto) {
        String codTipoAlerta = alerta.getCodigoTipoAlerta();
        String codNivel = alerta.getCodigoNivelGravedad();
        Long puntuacion = getPesoEnMetrica(metrica, codTipoAlerta, codNivel);

        if (puntuacion != null) {
            return puntuacion;
        }

        Metrica nuevaMetrica;
        if (metDefecto) {
            nuevaMetrica = (Metrica)executor.execute(
            		PrimariaBusinessOperation.BO_METRICA_MGR_GET_METRICA,
            		crearDto(null, alerta.getCodigoSegmento()), true);
        } else {
            nuevaMetrica = (Metrica)executor.execute(
            		PrimariaBusinessOperation.BO_METRICA_MGR_GET_METRICA,
            		crearDto(alerta.getCodigoTipoPersona(), null), 
            		true);
        }
        //        sw.stop();
        //        System.out.println("recuperando metrica. Tiempo total: " + sw.getTotalTimeMillis() + " ms.");
        puntuacion = getPesoEnMetrica(nuevaMetrica, codTipoAlerta, codNivel);

        if (puntuacion != null) {
            return puntuacion;
        }
        return null;
    }

    private DtoMetrica crearDto(String tipoPersona, String codigoSegmento) {
        DtoMetrica dto = new DtoMetrica();
        dto.setCodigoTipoPersona(tipoPersona);
        dto.setCodigoSegmento(codigoSegmento);
        return dto;
    }

    /**
     * Calcula la puntuacion para los parámetros indicados. Si no puedte retorna nulo
     * @param metrica
     * @param tipoAlerta
     * @param nivelGravedad
     * @return Long
     */
    private Long getPesoEnMetrica(Metrica metrica, String codTipoAlerta, String codNivelGravedad) {
        for (MetricaTipoAlerta mtt : metrica.getMetricasTipoAlerta()) {
            if (mtt.getTipoAlerta().getCodigo().equalsIgnoreCase(codTipoAlerta)) {
                for (MetricaTipoAlertaGravedad mtg : mtt.getMetricasTipoAlertaGravedad()) {
                    if (mtg.getNivelGravedad().getCodigo().equalsIgnoreCase(codNivelGravedad)) {
                        if (mtg.getPeso() != null) {
                            return new Long(mtt.getPreocupacion() * mtg.getPeso());
                        }
                    }
                }
            }
        }

        return null;
    }
}
