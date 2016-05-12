package es.capgemini.pfs.scoring;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.dynamicDto.DtoCell;
import es.capgemini.pfs.dynamicDto.DtoDynamic;
import es.capgemini.pfs.dynamicDto.DtoDynamicRow;
import es.capgemini.pfs.dynamicDto.DtoMetadata;
import es.capgemini.pfs.metrica.dto.DtoMetrica;
import es.capgemini.pfs.metrica.model.Metrica;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.scoring.dao.PuntuacionTotalDao;
import es.capgemini.pfs.scoring.dto.DtoSimulacion;
import es.capgemini.pfs.scoring.model.PuntuacionParcial;
import es.capgemini.pfs.scoring.model.PuntuacionTotal;
import es.capgemini.pfs.utils.ObjetoResultado;
import es.pfsgroup.commons.utils.Checks;

/**
 * Clase que realiza las tareas de calculo de scoring en el common.
 * En principio solo no guardaria datos, porque lo hace el batch.
 * @author aesteban
 *
 */
@Service
public class ScoringManager {

    @Autowired
    private Executor executor;

    @Autowired
    private PuntuacionTotalDao puntuacionTotalDao;

    @Resource
    private MessageService messageService;

    public static final String MET_ACTIVA = "metActiva";
    public static final String MET_INACTIVA = "metInactiva";

    private static final String ALERTA = "alerta";
    private static final String GRUPO = "grupo";
    private static final String RATING = "Clasificación";
    private static final String TOTAL = "Total";
    private static final String C = "C";

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * Retorna un mapa con dos lista de totales, una usa la metrica activa
     * y la otra la metrica que esta por activarse.
     * @param dto dtoMetrica
     * @return Map
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(PrimariaBusinessOperation.BO_SCORING_MGR_SIMULAR)
    public Map<String, List<DtoSimulacion>> simular(DtoMetrica dto) {
        Metrica metActiva = (Metrica) executor.execute(PrimariaBusinessOperation.BO_METRICA_MGR_GET_METRICA, dto, true);
        Metrica metInactiva = (Metrica) executor.execute(PrimariaBusinessOperation.BO_METRICA_MGR_GET_METRICA, dto, false);
        Map<String, List<DtoSimulacion>> simulacion = new HashMap<String, List<DtoSimulacion>>();

        List<DtoSimulacion> simulacionActiva = (List<DtoSimulacion>) executor.execute(PrimariaBusinessOperation.BO_SIMULACCION_MGR_SIMULAR,
                metActiva, dto);

        simulacion.put(MET_ACTIVA, simulacionActiva);
        if (metInactiva != null) {
            List<DtoSimulacion> simulacionInactiva = (List<DtoSimulacion>) executor.execute(PrimariaBusinessOperation.BO_SIMULACCION_MGR_SIMULAR,
                    metInactiva, dto);
            simulacion.put(MET_INACTIVA, simulacionInactiva);
        }
        return simulacion;
    }

    /**
     * Devuelve si es posible generar un scoring o no
     * @param dto dtoMetrica
     * @return Map
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(PrimariaBusinessOperation.BO_SCORING_MGR_SIMULAR_CHECK)
    public List<ObjetoResultado> simularCheck(DtoMetrica dto) {
        ObjetoResultado oRes = new ObjetoResultado();

        oRes.setCodigoResultado(ObjetoResultado.RESULTADO_ERROR);
        AbstractMessageSource ms = MessageUtils.getMessageSource();
        String mensaje = ms.getMessage("scoring.simulacion.error", new Object[] {}, MessageUtils.DEFAULT_LOCALE);
        oRes.setMensajeError(mensaje);

        try {
            Metrica metActiva = (Metrica) executor.execute(PrimariaBusinessOperation.BO_METRICA_MGR_GET_METRICA, dto, true);

            List<DtoSimulacion> simulacionActiva = (List<DtoSimulacion>) executor.execute(PrimariaBusinessOperation.BO_SIMULACCION_MGR_SIMULAR,
                    metActiva, dto);

            if (simulacionActiva != null) {
                oRes.setCodigoResultado(ObjetoResultado.RESULTADO_OK);
                oRes.setMensajeError(null);
            }
        } catch (Exception e) {
            logger.error(mensaje, e);
        }

        List<ObjetoResultado> list = new ArrayList<ObjetoResultado>(1);
        list.add(oRes);
        return list;
    }

    /**
     * Devuelve un array con las letras que serían índices hasta <code>numIndices</code>,
     * como los nombres de columnas de MS Excel.
     * Lanza RuntimeException si <code>numIndices < 1 || numIndices > 100</code>
     * @param numIndices int
     * @return String[], ej. para <code>numIndices: 50<br>
     * [A, B, C, D,.. AA, AB, .., AV, AW, AX]</code>
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_SCORING_MGR_CALCULAR_INDICES)
    public static String[] calcularIndices(int numIndices) {
        final int max = 100;
        if (numIndices > max) { throw new RuntimeException("Número de índices mayor a " + max); }
        if (numIndices < 1) { throw new RuntimeException("Número de índices " + numIndices + " inválido"); }

        final int primerLetra = 65; // 'A'
        final int numLetras = 26; // Letras del abecedario
        String[] letras = new String[numIndices];
        for (int i = 0; i < numIndices; i++) {
            if (i < numLetras) {
                letras[i] = "" + (char) (i + primerLetra);
            } else {
                letras[i] = "" + (char) ((i / numLetras - 1) + primerLetra) + (char) ((i % numLetras) + primerLetra);
            }
        }
        return letras;
    }

    /**
     * Indica si debe procesar una alerta.
     * La debe procesar solo si la fecha actual es menor a la fecha de extracción de la alerta más el plazo de visibilidad
     * que se especifica en el tipo de alerta.
     * @param pp la PuntuacionParcial
     * @return true si debe procesar.
     */
    private boolean debeProcesarAlerta(PuntuacionParcial pp) {
    	Long time = 0L;
    	if (Checks.esNulo(pp.getAlerta().getTipoAlerta().getPlazoVisibilidad())) {
    		logger.error("scoringManager.debeProcesarAlerta - El plazo de la visibilidad del tipo de alerta no puede ser null");
    		time = pp.getAlerta().getFechaExtraccion().getTime();
    	} else {
    		time = pp.getAlerta().getTipoAlerta().getPlazoVisibilidad() + pp.getAlerta().getFechaExtraccion().getTime();
    	}
        return System.currentTimeMillis() < time;
    }

    /**
     * Devuelve la fila DtoDynamicRow que corresponde al grupo indicado
     * @param rows
     * @return
     */
    private DtoDynamicRow getRowForName(List<DtoDynamicRow> rows, String name, String codigo) {
        for (DtoDynamicRow row : rows) {
            if (codigo.equals(row.getValueForName(name))) return row;
        }
        return null;
    }

    /**
     * Agrega lo que hay en puntuacionesTotales a rows.
     * @param puntuacionesTotales los registros para la nueva fecha
     * @param rows la lista con el contenido anterior al que hay que agregarle lo nuevo.
     */
    private void mergePuntuacionesTotales(PuntuacionTotal puntuacionTotal, List<DtoDynamicRow> rows, Date fecha) {
        /*
            {"data":
            [
                {
                    "grupo":"GA2"
                    ,"C1255512302000":"1810" <- Fecha1
                    ,"subdata":
                    [
                        {"alerta":"Alerta I1B","C1255512302000":"10"}
                        ,{"alerta":"Alerta I2A","C1255512302000":"0"}
                        ,{"alerta":"Alerta I2B","C1255512302000":"50"}
                        ...
                     ]
                 }
                 ,{"grupo":"Total","C1255512302000":"2010","subdata":[]}
                 ,{"grupo":"ClasificaciÃ³n","C1255512302000":"A","subdata":[]}
            ]
            ,"metaData":
            {
                "root":"data"
                ,"fields":[{"name":"grupo"},{"name":"alerta"},{"name":"C1255512302000"},{"name":"subdata"}]
            }
            ,"columns":[
                {"dataIndex":"grupo","header":"Grupo"}
                ,{"dataIndex":"alerta","header":"Alerta"}
                ,{"dataIndex":"C1255512302000","header":"14/10/2009"}
            ]
            ,"fwk":{}
            ,"success":true}
         */

        String tituloColumna = C + String.valueOf(fecha.getTime());
        
        // Prueba
        DtoDynamicRow rowTotal = getRowForName(rows, GRUPO, TOTAL);
        
        //Si el nombre de la columna ya existe, le añadimos un número detras de la cadena
        //Esto lo hacemos porque cuando hay fechas repetidas, el cálculo de las columnas no lo hace bien
        if(rowTotal!=null && rowTotal.getCell(tituloColumna)!=null){
        	for(Integer i = 1;i<=10;i++){
        		if(rowTotal.getCell(tituloColumna + i.toString())==null){
        			tituloColumna = tituloColumna + i.toString();
        			break;
        		}
        	}
        }
        //Recuperamos todas las puntuaciones
        List<PuntuacionParcial> listadoPuntuaciones = puntuacionTotalDao.getPuntuacionesOrdenadas(puntuacionTotal.getId());

        //Recuperamos el totalizador TOTAL y si no existe lo creamos
        
        if (rowTotal == null) {
            rowTotal = new DtoDynamicRow();
            rows.add(rowTotal);
            DtoCell cellTotal = new DtoCell();

            //Y creo la celda de grupo
            cellTotal.setName(GRUPO);
            cellTotal.setValue(TOTAL);
            rowTotal.addCell(cellTotal);
        }

        //Recuperamos del totalizador TOTAL la fecha actual, si no existe la creamos a 0
        DtoCell cellTotalFecha = rowTotal.getCell(tituloColumna);
        if (cellTotalFecha == null) {
            cellTotalFecha = new DtoCell();

            //Y creo la celda de grupo
            cellTotalFecha.setName(tituloColumna);
            if (Checks.esNulo(puntuacionTotal.getPuntuacion().toString())) {
            	logger.error("scoringManager.mergePuntuacionesTotales - La puntuación total no puede ser null");
            	cellTotalFecha.setValue("0");
            } else {
            	cellTotalFecha.setValue(puntuacionTotal.getPuntuacion().toString());
            }
            rowTotal.addCell(cellTotalFecha);
        }

        //Recuperamos el totalizador CLASIFICACION y si no existe lo creamos
        DtoDynamicRow rowClasificacion = getRowForName(rows, GRUPO, RATING);
        if (rowClasificacion == null) {
            rowClasificacion = new DtoDynamicRow();
            rows.add(rowClasificacion);
            DtoCell cellClasificacion = new DtoCell();

            //Y creo la celda de grupo
            cellClasificacion.setName(GRUPO);
            cellClasificacion.setValue(RATING);
            rowClasificacion.addCell(cellClasificacion);
        }

        //Recuperamos del totalizador CLASIFICACION la fecha actual, si no existe la creamos e inicializamos
        DtoCell cellClasificacionFecha = rowClasificacion.getCell(tituloColumna);
        if (cellClasificacionFecha == null) {
            cellClasificacionFecha = new DtoCell();

            //Y creo la celda de grupo
            cellClasificacionFecha.setName(tituloColumna);
            cellClasificacionFecha.setValue(puntuacionTotal.getIntervalo());
            rowClasificacion.addCell(cellClasificacionFecha);
        }

        // ************************************************************ //
        // ***    Iteramos para todas las puntuaciones parciales    *** //
        // ************************************************************ //
        for (PuntuacionParcial pp : listadoPuntuaciones) {
            String codigoGrupo = pp.getAlerta().getTipoAlerta().getGrupoAlerta().getCodigo() + " - " + pp.getAlerta().getTipoAlerta().getGrupoAlerta().getDescripcion();
            String codigoAlerta = pp.getAlerta().getTipoAlerta().getCodigo()  + " - " + pp.getAlerta().getTipoAlerta().getDescripcionLarga();
            Long puntuacionAlerta = pp.getPuntuacion();
            String codigoGravedad = pp.getAlerta().getNivelGravedad().getCodigo()  + " - " + pp.getAlerta().getNivelGravedad().getDescripcion();

            //Recupero el row del grupo y si no existe lo creo
            DtoDynamicRow rowGrupo = getRowForName(rows, GRUPO, codigoGrupo);
            if (rowGrupo == null) {
                rowGrupo = new DtoDynamicRow();
                rows.add(rowGrupo);
                DtoCell cellGrupo = new DtoCell();

                //Y creo la celda de grupo
                cellGrupo.setName(GRUPO);
                cellGrupo.setValue(codigoGrupo);
                rowGrupo.addCell(cellGrupo);
            }

            //Buscamos el valor totalizador del grupo para la fecha y si no existe lo creamos
            DtoCell cellFecha = rowGrupo.getCell(tituloColumna);
            if (cellFecha == null) {
                cellFecha = new DtoCell();

                //Y creo la celda de grupo
                cellFecha.setName(tituloColumna);
                cellFecha.setValue("0");
                rowGrupo.addCell(cellFecha);
            }

            //Buscamos la alerta dentro del grupo y si no existe la creamos
            DtoDynamicRow rowAlerta = getRowForName(rowGrupo.getSubdata(), ALERTA, codigoAlerta);
            if (rowAlerta == null) {
                rowAlerta = new DtoDynamicRow();
                rowGrupo.getSubdata().add(rowAlerta);
                DtoCell cellAlerta = new DtoCell();

                //Y creo la celda de alerta
                cellAlerta.setName(ALERTA);
                cellAlerta.setValue(codigoAlerta);
                rowAlerta.addCell(cellAlerta);
            }

            //Ahora recuperamos para la alerta y la fecha actual
            DtoCell cellPuntuacionAlerta = rowAlerta.getCell(tituloColumna);
            //Si es una nueva alerta, creamos el registro y contabilizamos en los grupos
            if (cellPuntuacionAlerta == null) {
                cellPuntuacionAlerta = new DtoCell();
                cellPuntuacionAlerta.setName(tituloColumna);
                cellPuntuacionAlerta.setValue(codigoGravedad, puntuacionAlerta);
                cellPuntuacionAlerta.setVisible(debeProcesarAlerta(pp));
                rowAlerta.addCell(cellPuntuacionAlerta);

                //Actualizamos la puntuación del grupo
                cellFecha.addValue(puntuacionAlerta);
            }
            //Si no es una nueva alerta, generamos el mensaje de alerta
            else {
                cellPuntuacionAlerta.addPuntuacionTotal(puntuacionAlerta);
                cellFecha.addValue(puntuacionAlerta);
            }
        }

        //Armonizamos las filas (ponemos "total" y "clasificacion" al final de todo el Array)
        rows.remove(rowTotal);
        rows.remove(rowClasificacion);

        rows.add(rowTotal);
        rows.add(rowClasificacion);

    }

    /**
     * Información del tab de scoring de una persona en las fechas indicadas.
     * @param idPersona Long
     * @param fechas String: las fechas se pasan como cadenas separadas por coma
     * @return List DtoScoringPersona
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_SCORING_MGR_GET_SCORING_PERSONA)
    public DtoDynamic getScoringPersona(Long idPersona, String fechas) {
        if (fechas.equals("")) {
            fechas = calcularParaFechasInicio(idPersona);
            if ("".equals(fechas)) {
                //No hay cargas previas
                DtoDynamic dto = new DtoDynamic();
                dto.setMetadata(generarMetadataScoring(new ArrayList<Date>()));
                return dto;
            }
        }
        List<Date> fechasList = new ArrayList<Date>();

        if (fechas != null) {
            String[] fechasArray = fechas.split(",");
            for (int i = 0; i < fechasArray.length; i++) {
                Date fecha = new Date(Long.parseLong(fechasArray[i]));
                fechasList.add(fecha);
            }
        }

        DtoDynamic dto = new DtoDynamic();
        List<DtoDynamicRow> rows = new ArrayList<DtoDynamicRow>();
        dto.setRows(rows);
        dto.setMetadata(generarMetadataScoring(fechasList));
        dto.setTieneSubdata(true);

        for (Date fecha : fechasList) {
            //Traigo los datos para una de las fechas. 
            PuntuacionTotal puntuacionTotal = puntuacionTotalDao.buscarPorFechaYPersona(fecha, idPersona);
            if (!Checks.esNulo(puntuacionTotal)) {
            	mergePuntuacionesTotales(puntuacionTotal, rows, fecha);
            }
        }

        return dto;
    }

    /**
     * Devuelve un listado de las posibles fechas iniciales del scoring de una persona
     * @param idPersona
     * @return 
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_SCORING_MGR_GET_FECHAS_INICIO)
    public String calcularParaFechasInicio(Long idPersona) {
        String fechas = "";
        Calendar c = new GregorianCalendar();
        //Fecha hoy
        c.setTimeInMillis(System.currentTimeMillis());
        Date d = puntuacionTotalDao.getFechaMasProxima(idPersona, c.getTime());
        if (d == null) { return fechas.trim().length() > 0 ? fechas : null; }
        fechas += d.getTime();
        //Fecha hace 30 días
        c.add(Calendar.MONTH, -1);
        d = puntuacionTotalDao.getFechaMasProxima(idPersona, c.getTime());
        if (d == null) { return fechas.trim().length() > 0 ? fechas : null; }
        fechas += "," + d.getTime();
        //fecha hace 60 días
        c.add(Calendar.MONTH, -1);
        d = puntuacionTotalDao.getFechaMasProxima(idPersona, c.getTime());
        if (d == null) { return fechas.trim().length() > 0 ? fechas : null; }
        fechas += "," + d.getTime();
        //fecha hace 90 días
        c.add(Calendar.MONTH, -1);
        d = puntuacionTotalDao.getFechaMasProxima(idPersona, c.getTime());
        if (d == null) { return fechas.trim().length() > 0 ? fechas : null; }
        fechas += "," + d.getTime();
        //fecha hace un año
        c.setTimeInMillis(System.currentTimeMillis());
        c.add(Calendar.YEAR, -1);
        d = puntuacionTotalDao.getFechaMasProxima(idPersona, c.getTime());
        if (d == null) { return fechas.trim().length() > 0 ? fechas : null; }
        fechas += "," + d.getTime();
        return fechas;
    }

    private List<DtoMetadata> generarMetadataScoring(List<Date> fechas) {
        List<DtoMetadata> list = new ArrayList<DtoMetadata>();
        DtoMetadata meta = new DtoMetadata();
        meta.setName(GRUPO);
        meta.setHeader(messageService.getMessage("scoring.grid.grupo"));
        list.add(meta);
        meta = new DtoMetadata();
        meta.setName("alerta");
        meta.setHeader(messageService.getMessage("scoring.grid.alerta"));
        list.add(meta);
        SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
        Integer contador = 1;
        for (Date fecha : fechas) {
            DtoMetadata metadata = new DtoMetadata();
            metadata.setName(C + String.valueOf(fecha.getTime()));
            String titulo = sdf1.format(fecha);
            if(contador==fechas.size()){
            	titulo = titulo + " " + messageService.getMessage("scoring.grid.fechaSeleccionada");
            }
            switch (contador) {
			case 1:
				titulo = titulo + " " + messageService.getMessage("scoring.grid.fechaHoy");
				break;
			case 2:
				titulo = titulo + " " + messageService.getMessage("scoring.grid.fecha1MesPasado");
				break;
			case 3:
				titulo = titulo + " " + messageService.getMessage("scoring.grid.fecha2MesesPasado");
				break;
			case 4:
				titulo = titulo + " " + messageService.getMessage("scoring.grid.fecha3MesesPasado");
				break;
			case 5:
				titulo = titulo + " " + messageService.getMessage("scoring.grid.fecha365DiasPasado");
				break;
			
            }
            metadata.setHeader(titulo);
            metadata.setAlign("right");
            list.add(metadata);
            contador++;
        }
        return list;
    }

    /**
     * Devuelve las fechas para las cuales una persona tiene puntuación total.
     * @param idPersona el id de la persona.
     * @param fechas un string con las fechas que están en la consulta concatenadas y separadas por ","
     * @return la lista de fechas para la cual tiene puntuaciones
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_SCORING_MGR_GET_FECHAS_PUNTUACION_TOTAL)
    public List<Date> getFechasPuntuacionTotal(Long idPersona, String fechas) {
        List<Date> fechasList = new ArrayList<Date>();
        if (!fechas.equals("")) {
            String[] fechasArray = fechas.split(",");
            for (int i = 0; i < fechasArray.length; i++) {
                Date fecha = new Date(Long.parseLong(fechasArray[i]));
                fechasList.add(fecha);
            }
        }
        return puntuacionTotalDao.getFechasPuntuacionTotal(idPersona, fechasList);
    }
}
