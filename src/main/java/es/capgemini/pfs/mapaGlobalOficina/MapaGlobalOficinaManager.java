package es.capgemini.pfs.mapaGlobalOficina;

import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.CSVWriteCursorReadCallBack;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.FileManager;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.exceptions.ParametrizationException;
import es.capgemini.pfs.mapaGlobalOficina.dao.MapaGlobalOficinaDao;
import es.capgemini.pfs.mapaGlobalOficina.dto.DtoBuscarMapaGlobalOficina;
import es.capgemini.pfs.mapaGlobalOficina.dto.DtoExportRow;
import es.capgemini.pfs.mapaGlobalOficina.dto.DtoExportRowCount;
import es.capgemini.pfs.mapaGlobalOficina.model.DDCriterioAnalisis;
import es.capgemini.pfs.mapaGlobalOficina.model.MapaGlobalOficina;
import es.capgemini.pfs.subfase.model.DDFase;
import es.capgemini.pfs.utils.FormatUtils;
import es.capgemini.pfs.utils.ObjetoResultado;

/**
 * Manager de la parte de analisis.
 * @author Andrés Esteban
 *
 */
@Service
public class MapaGlobalOficinaManager {

	@Autowired
    private Executor executor;
    @Autowired
    private MapaGlobalOficinaDao mapaGlobalOficinaDao;
    @Autowired
    private FileManager fileManager;
    @Resource
    private MessageService messageService;
    private Double numeroClientes;
    private Double numeroContratos;
    private Double saldoVencido;
    private Double saldoTotal;

    /**
     * Retorna el arquetipo que corresponde al id indicado.
     * @param id arquetipo id
     * @return arquetipo
     */
    public MapaGlobalOficina get(Long id) {
        return mapaGlobalOficinaDao.get(id);
    }

    /**
     * @param codigo String
     * @return DDCriterioAnalisis
     */
    @BusinessOperation(ComunBusinessOperation.BO_MAPA_GLOB_OFI_MGR_FIND_DD_CRITERIO_ANALISIS_BY_CODIGO)
    @Transactional
    public DDCriterioAnalisis findDDCriterioAnalisisByCodigo(String codigo) {
        return (DDCriterioAnalisis)executor.execute(
				ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
				DDCriterioAnalisis.class, 
				codigo);
    }

    /**
     * @return List DDCriterioAnalisis: todos los tipos de criterios para un análisis
     */
    @SuppressWarnings("unchecked")
	@BusinessOperation(ComunBusinessOperation.BO_MAPA_GLOB_OFI_MGR_GET_CRITERIOS_ANALISIS)
    @Transactional
    public List<DDCriterioAnalisis> getCriteriosAnalisis() {
        return (List<DDCriterioAnalisis>)executor.execute(
				ComunBusinessOperation.BO_DICTIONARY_GET_LIST,
				DDCriterioAnalisis.class.getName());
    }

    /**
     * Busca los 'MapaGlobalOfina', es decir, datos analizados de la BBDD segÃºn los criterios indicados en el dto.
     * @param dto criterios de busqueda.
     * @return Lista de ObjetoResultado
     * @throws Exception e
     */
    @BusinessOperation(ComunBusinessOperation.BO_MAPA_GLOB_OFI_MGR_BUSCAR)
    public List<ObjetoResultado> buscar(DtoBuscarMapaGlobalOficina dto) throws Exception {
        validarCriterios(dto);
        int count = mapaGlobalOficinaDao.buscarCount(dto);

        ObjetoResultado oRes = new ObjetoResultado();
        oRes.setResultados(new Long(count));

        if (count == 0) {
            AbstractMessageSource ms = MessageUtils.getMessageSource();
            String mensaje = ms.getMessage("analisis.busqueda.salida.jerarquico.noHayDatos", new Object[] {}, MessageUtils.DEFAULT_LOCALE);

            oRes.setCodigoResultado(ObjetoResultado.RESULTADO_ERROR);
            oRes.setMensajeError(mensaje);
        } else {
            oRes.setCodigoResultado(ObjetoResultado.RESULTADO_OK);
        }

        List<ObjetoResultado> list = new ArrayList<ObjetoResultado>(1);
        list.add(oRes);
        return list;
    }

    /**
     * Busca los 'MapaGlobalOfina', es decir, datos analizados de la BBDD según los criterios indicados en el dto
     * y los exporta con el BIRT a PDF o XLS.
     * @param dto criterios de busqueda.
     * @return List DtoExportRow
     * @throws Exception e
     */
    @BusinessOperation
    @Transactional
    public List<DtoExportRow> exportarABirt(DtoBuscarMapaGlobalOficina dto) throws Exception {
        validarCriterios(dto);
        List<DtoExportRow> list = new ArrayList<DtoExportRow>();
        if (DDCriterioAnalisis.CRITERIO_SALIDA_JERARQUICO.equalsIgnoreCase(dto.getCriterioSalida())) {
            list = mapaGlobalOficinaDao.buscarAgrupandoPorJerarquia(dto);
        } else if (DDCriterioAnalisis.CRITERIO_SALIDA_FASE.equalsIgnoreCase(dto.getCriterioSalida())) {
            list = mapaGlobalOficinaDao.buscarAgrupandoPorSubfases(dto);
        } else if (DDCriterioAnalisis.CRITERIO_SALIDA_PRODUCTO.equalsIgnoreCase(dto.getCriterioSalida())) {
            list = mapaGlobalOficinaDao.buscarAgrupandoPorProducto(dto);
        } else if (DDCriterioAnalisis.CRITERIO_SALIDA_SEGMENTO.equalsIgnoreCase(dto.getCriterioSalida())) {
            list = mapaGlobalOficinaDao.buscarAgrupandoPorSegmento(dto);
        }
        // Calcula los porcentajes
        calcularTotales(list);
        for (DtoExportRow row : list) {
            row.setPorcenNumeroClientes(FormatUtils.porcentajeRedendeado(row.getNumeroClientes().doubleValue(), numeroClientes.doubleValue()));
            row.setPorcenNumeroContratos(FormatUtils.porcentajeRedendeado(row.getNumeroContratos().doubleValue(), numeroContratos.doubleValue()));
            row.setPorcenSaldoVencido(FormatUtils.porcentajeRedendeado(row.getSaldoVencidoAbs().doubleValue(), saldoVencido.doubleValue()));
            row.setPorcenSaldoTotal(FormatUtils.porcentajeRedendeado(row.getSaldoTotalAbs().doubleValue(), saldoTotal.doubleValue()));
        }
        return list;
    }

    /**
     * Busca los 'MapaGlobalOfina', es decir, datos analizados de la BBDD según los criterios indicados en el dto
     * y los exporta a un CSV.
     * @param dto criterios de busqueda.
     * @return FileItem: archivo de texto plano CSV
     * @throws Exception e
     */
    @BusinessOperation(ComunBusinessOperation.BO_MAPA_GLOB_OFI_MGR_EXPORTAR_A_CSV)
    @Transactional
    public FileItem exportarACsv(DtoBuscarMapaGlobalOficina dto) throws Exception {
        validarCriterios(dto);
        if (DDCriterioAnalisis.CRITERIO_SALIDA_FASE.equalsIgnoreCase(dto.getCriterioSalida())) {
            return generarArchivoCsv(mapaGlobalOficinaDao.buscarAgrupandoPorSubfases(dto), true);
        }
        if (DDCriterioAnalisis.CRITERIO_SALIDA_JERARQUICO.equalsIgnoreCase(dto.getCriterioSalida())) {
            return generarArchivoCsv(mapaGlobalOficinaDao.buscarAgrupandoPorJerarquia(dto), false);
        }
        if (DDCriterioAnalisis.CRITERIO_SALIDA_PRODUCTO.equalsIgnoreCase(dto.getCriterioSalida())) {
            return generarArchivoCsv(mapaGlobalOficinaDao.buscarAgrupandoPorProducto(dto), false);
        }
        if (DDCriterioAnalisis.CRITERIO_SALIDA_SEGMENTO.equalsIgnoreCase(dto.getCriterioSalida())) {
            return generarArchivoCsv(mapaGlobalOficinaDao.buscarAgrupandoPorSegmento(dto), false);
        }
        return null;
    }

    /**
     * Retorna en un DTO si en cada una de las fases distintas de gestión exportadas hay registros,
     * este resultado es usado por el generador del PDF para saber si dibujar la tabla correspondiente
     * a cada fase.
     * @param dto DTO con los datos del form
     * @param list List DtoExportRow: tabla con los datos a mostrar en el PDF
     * @return DtoExportRowCount
     */
    @BusinessOperation(ComunBusinessOperation.BO_MAPA_GLOB_OFI_MGR_CONTAR_REGISTROS_POR_FASE)
    public DtoExportRowCount contarRegistrosPorFase(DtoBuscarMapaGlobalOficina dto, List<DtoExportRow> list) {
        DtoExportRowCount exportRowCount = new DtoExportRowCount();
        exportRowCount.setHayGestionNormal(false);
        exportRowCount.setHayGestionPrimaria(false);
        exportRowCount.setHayGestionInterna(false);
        exportRowCount.setHayGestionExterna(false);
        if (DDCriterioAnalisis.CRITERIO_SALIDA_FASE.equalsIgnoreCase(dto.getCriterioSalida())) {
            Iterator<DtoExportRow> it = list.iterator();
            while (it.hasNext()) {
                DtoExportRow row = it.next();
                DDFase faseNormal = (DDFase)executor.execute(
        				ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
        				DDFase.class, 
        				DDFase.FASE_NORMAL);
                DDFase fasePrimaria = (DDFase)executor.execute(
        				ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
        				DDFase.class, 
        				DDFase.FASE_PRIMARIA);
                DDFase faseInterna = (DDFase)executor.execute(
        				ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
        				DDFase.class, 
        				DDFase.FASE_INTERNA);
                DDFase faseExterna = (DDFase)executor.execute(
        				ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
        				DDFase.class, 
        				DDFase.FASE_EXTERNA);

                if (row.getDescripcion().equals(faseNormal.getDescripcion())) {
                    exportRowCount.setHayGestionNormal(true);
                } else if (row.getDescripcion().equals(fasePrimaria.getDescripcion())) {
                    exportRowCount.setHayGestionPrimaria(true);
                } else if (row.getDescripcion().equals(faseInterna.getDescripcion())) {
                    exportRowCount.setHayGestionInterna(true);
                } else if (row.getDescripcion().equals(faseExterna.getDescripcion())) {
                    exportRowCount.setHayGestionExterna(true);
                }
            }
        }
        return exportRowCount;
    }

    /**
     * Genera un archivo CSV a partir de la lista de rows.
     * @param mapas lista de mapas
     * @param fase indica si crear el CSV para subfases
     * @return archivo CSV
     * @throws Exception e
     */
    private FileItem generarArchivoCsv(List<DtoExportRow> rows, boolean fase) throws Exception {
        calcularTotales(rows);
        CSVWriteCursorReadCallBack leeDatos = new CSVWriteCursorReadCallBack("analisis.csv", fileManager);
        List<String> titulos = new ArrayList<String>();
        if (fase) {
            titulos.add(messageService.getMessage("analisis.exportar.fase"));
            titulos.add(messageService.getMessage("analisis.exportar.subfase"));
        } else {
            titulos.add(messageService.getMessage("analisis.exportar.bloque"));
        }
        titulos.add(messageService.getMessage("analisis.exportar.nclientes"));
        titulos.add(messageService.getMessage("analisis.exportar.porcejClientes"));
        titulos.add(messageService.getMessage("analisis.exportar.ncontratos"));
        titulos.add(messageService.getMessage("analisis.exportar.porcejContratos"));
        titulos.add(messageService.getMessage("analisis.exportar.saldoVencido"));
        titulos.add(messageService.getMessage("analisis.exportar.porcejVencido"));
        titulos.add(messageService.getMessage("analisis.exportar.saldoTotal"));
        titulos.add(messageService.getMessage("analisis.exportar.porcejTotal"));

        List<Object> values;
        leeDatos.beforeFirst();
        leeDatos.doWithLine(titulos.toArray());

        Locale locale = new Locale("es", "ES");
        NumberFormat nf = NumberFormat.getNumberInstance(locale);

        for (DtoExportRow row : rows) {
            values = new ArrayList<Object>();
            values.add(row.getDescripcion());
            if (fase) {
                values.add(row.getDescripcionSecundaria());
            }
            values.add(row.getNumeroClientes());
            values.add(formatoPorcentaje(row.getNumeroClientes().doubleValue(), numeroClientes));
            values.add(row.getNumeroContratos());
            values.add(formatoPorcentaje(row.getNumeroContratos().doubleValue(), numeroContratos));
            values.add(nf.format(row.getSaldoVencidoAbs()));
            values.add(formatoPorcentaje(row.getSaldoVencidoAbs().doubleValue(), saldoVencido));
            values.add(nf.format(row.getSaldoTotalAbs()));
            values.add(formatoPorcentaje(row.getSaldoTotalAbs().doubleValue(), saldoTotal));

            leeDatos.doWithLine(values.toArray());
        }

        values = new ArrayList<Object>();
        if (fase) {
            values.add("");
        }
        values.add(messageService.getMessage("analisis.exportar.total"));
        values.add(numeroClientes.longValue());
        values.add(formatoPorcentaje(numeroClientes, numeroClientes));
        values.add(numeroContratos.longValue());
        values.add(formatoPorcentaje(numeroContratos, numeroContratos));
        values.add(nf.format(saldoVencido));
        values.add(formatoPorcentaje(saldoVencido, saldoVencido));
        values.add(nf.format(saldoTotal));
        values.add(formatoPorcentaje(saldoTotal, saldoTotal));

        leeDatos.doWithLine(values.toArray());
        leeDatos.afterLast();
        return leeDatos.getFileItem();
    }

    private String formatoPorcentaje(Double n, Double total) {
        DecimalFormat pf = new DecimalFormat("##.### %");
        if (total == 0) {
            return pf.format(0);
        }
        return pf.format(n / total);
    }

    /**
     * Valida los criterio de busqueda ingresados.
     * De ser error lanza una excepciï¿½n.
     * @param dto criterios de busqueda.
     */
    private void validarCriterios(DtoBuscarMapaGlobalOficina dto) {
        if (DDCriterioAnalisis.CRITERIO_SALIDA_JERARQUICO.equalsIgnoreCase(dto.getCriterioSalida())) {
            if ("".equals(dto.getJerarquia().trim()) && emptyArray(dto.getCodigoZonas())) {
                throw new ParametrizationException("analisis.completarJerarquia");
            }
        }
    }

    private void calcularTotales(List<DtoExportRow> rows) {
        numeroClientes = 0D;
        numeroContratos = 0D;
        saldoVencido = 0D;
        saldoTotal = 0D;
        for (DtoExportRow row : rows) {
            numeroClientes += row.getNumeroClientes();
            numeroContratos += row.getNumeroContratos();
            saldoVencido += row.getSaldoVencidoAbs();
            saldoTotal += row.getSaldoTotalAbs();
        }

    }

    private boolean emptyArray(Set<String> set) {
        if (set == null) {
            return true;
        }
        if (set.isEmpty()) {
            return true;
        }

        if (set.size() == 1) {
            if (set.iterator().next().trim().equals("")) {
                return true;
            }
        }
        return false;
    }
}
