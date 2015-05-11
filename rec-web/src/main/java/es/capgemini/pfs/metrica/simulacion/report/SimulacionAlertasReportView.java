package es.capgemini.pfs.metrica.simulacion.report;

import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.eclipse.birt.report.engine.api.EngineConstants;
import org.eclipse.birt.report.engine.api.HTMLRenderOption;
import org.eclipse.birt.report.engine.api.HTMLServerImageHandler;
import org.eclipse.birt.report.engine.api.IReportRunnable;
import org.eclipse.birt.report.engine.api.IRunAndRenderTask;
import org.eclipse.birt.report.model.api.CellHandle;
import org.eclipse.birt.report.model.api.ElementFactory;
import org.eclipse.birt.report.model.api.GridHandle;
import org.eclipse.birt.report.model.api.LabelHandle;
import org.eclipse.birt.report.model.api.ReportDesignHandle;
import org.eclipse.birt.report.model.api.RowHandle;
import org.eclipse.birt.report.model.api.TableHandle;
import org.eclipse.birt.report.model.api.activity.SemanticException;

import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.report.ReportContext;
import es.capgemini.devon.view.ReportAbstractView;
import es.capgemini.pfs.config.ConfigManager;
import es.capgemini.pfs.metrica.dto.DtoMetrica;
import es.capgemini.pfs.persona.dao.DDTipoPersonaDao;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.scoring.ScoringManager;
import es.capgemini.pfs.scoring.dto.DtoSimulacion;
import es.capgemini.pfs.segmento.dao.SegmentoDao;
import es.capgemini.pfs.segmento.model.DDSegmento;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.utils.FormatUtils;

/**
 * Reporte a PDF de la simulaciÃ³n de Alertas.
 * @author marruiz
 */
public class SimulacionAlertasReportView extends ReportAbstractView {

    private final Log logger = LogFactory.getLog(getClass());

    private final String CONTENT_TYPE_PDF = "application/pdf";
    private final String CONTENT_TYPE_XLS = "application/vnd.ms-excel";

    /**
     * La vista retorna un PDF.
     */
    public SimulacionAlertasReportView() {
    }

    /**
     * Agrega el contenido dinÃ¡mico al reporte.
     * @param report ReportDesignHandle: aquÃ­ se "vuelca" el contenido
     * @param dto DtoMetrica: parÃ¡metros pasados
     * @param out Map: los datos de las tablas
     */
    private void buildReport(ReportDesignHandle reportDesignHandle,
                             DtoMetrica dto,
                             Map<String, List<DtoSimulacion>> out)
      throws SemanticException {

        ElementFactory designFactory = reportDesignHandle.getElementFactory();
        MessageService messageService = (MessageService)getApplicationContext().getBean("messageService");

        TableHandle tabla;
        RowHandle row;
        CellHandle cell;
        LabelHandle label;

        int cantIntRating = dto.getCantidadIntervaloRating();
        int cantIntVRC = dto.getCantidadIntervaloVRC();

        Set<String> idTablas = out.keySet();

        // Iteramos las tablas que hay en el dto, aunque solo deberÃ­a de haber dos
        for(String idTabla : idTablas) {
            tabla = (TableHandle) designFactory.newTableItem("tabla" + idTabla, cantIntRating * 2 + 1, 1, cantIntVRC, 1);
            List<DtoSimulacion> metricas = out.get(idTabla);

            // Generamos el encabezado de la tabla
            String[] letrasHeader = ScoringManager.calcularIndices(cantIntRating);
            row = (RowHandle) tabla.getHeader().get(0);
            String numCliente = messageService.getMessage("metricas.numClientes");
            String volumenRiesgo = messageService.getMessage("metricas.volumenRiesgo");
            for(int iCol = 1; iCol < cantIntRating*2+1; iCol += 2) {
                // Columna NÂ° Clientes
                cell = (CellHandle) row.getCells().get(iCol);
                if((iCol-1)%4==0) {
                    cell.setProperty("backgroundColor", "#C0D0D0");
                }
                label = designFactory.newLabel("labelHeader_numClientes_"+letrasHeader[iCol/2]);
                label.setText(letrasHeader[iCol/2] + "\n" + numCliente);
                label.setProperty("textAlign", "center");
                label.setProperty("fontWeight", "bold");
                cell.getContent().add(label);
                setearBordesCelda(cell);
                // Columna Volumen Riesgo
                cell = (CellHandle) row.getCells().get(iCol+1);
                if((iCol-1)%4==0) {
                    cell.setProperty("backgroundColor", "#C0D0D0");
                }
                label = designFactory.newLabel("labelHeader_volumenRiesgo_"+letrasHeader[iCol/2]);
                label.setText(letrasHeader[iCol/2] + "\n" + volumenRiesgo);
                label.setProperty("textAlign", "center");
                label.setProperty("fontWeight", "bold");
                cell.getContent().add(label);
                setearBordesCelda(cell);
            }

            // Generamos el contenido de la tabla
            String de = messageService.getMessage("metricas.de") + " ";
            String a = " " + messageService.getMessage("metricas.a") + " ";
            String desde, hasta;
            DecimalFormat monedaDecimalFormat = new DecimalFormat(FormatUtils.FORMATO_MONEDA);
            Map<String, Double> valorMap;
            Double valor;
            String valorFormateado;
            for(int iRow = 0; iRow<cantIntVRC; iRow++) {
                row = (RowHandle) tabla.getDetail().get(iRow);
                // Columna con la leyenda de los intÃ©rvalos
                cell = (CellHandle) row.getCells().get(0);
                label = designFactory.newLabel("label"+iRow+"-"+0);
                if(metricas.get(iRow).getMinVRC()%1.0==0) {
                    desde = "" + metricas.get(iRow).getMinVRC().intValue();
                } else {
                    desde = monedaDecimalFormat.format(metricas.get(iRow).getMinVRC().doubleValue());
                }
                if(metricas.get(iRow).getMaxVRC()%1.0==0) {
                    hasta = "" + metricas.get(iRow).getMaxVRC().intValue();
                } else {
                    hasta = monedaDecimalFormat.format(metricas.get(iRow).getMaxVRC().doubleValue());
                }
                label.setText(de + desde + a + hasta);
                label.setProperty("fontWeight", "bold");
                //label.setProperty("width", "3in");
                cell.getContent().add(label);
                setearBordesCelda(cell);
                for(int iCol = 1; iCol < cantIntRating*2+1; iCol += 2) {
                    // Columna NÂ° Clientes
                    cell = (CellHandle) row.getCells().get(iCol);
                    cell = (CellHandle) row.getCells().get(iCol);
                    if((iCol-1)%4==0) {
                        cell.setProperty("backgroundColor", "#C0D0D0");
                    }
                    label = designFactory.newLabel("label"+iRow+"-"+iCol);
                    valorMap = metricas.get(iRow).getIntervalos().get(letrasHeader[(iCol-1)/2]);
                    if(valorMap!=null) {
                        valor = valorMap.get("cantClientes");
                        if(valor==null || valor==0.0) {
                            valorFormateado = "0";
                        } else {
                            valorFormateado = "" + valor.longValue();
                        }
                    } else {
                        valorFormateado = "0";
                    }
                    label.setText(valorFormateado);
                    label.setProperty("textAlign", "right");
                    cell.getContent().add(label);
                    setearBordesCelda(cell);
                    // Columna Volumen Riesgo
                    cell = (CellHandle) row.getCells().get(iCol+1);
                    if((iCol-1)%4==0) {
                        cell.setProperty("backgroundColor", "#C0D0D0");
                    }
                    label = designFactory.newLabel("label"+iRow+"-"+iCol+1);
                    valorMap = metricas.get(iRow).getIntervalos().get(letrasHeader[(iCol-1)/2]);
                    if(valorMap!=null) {
                        valor = valorMap.get("totalVRC");
                        if(valor==null || valor==0.0) {
                            valorFormateado = "0";
                        } else {
                            valorFormateado = monedaDecimalFormat.format(valor);
                        }
                    } else {
                        valorFormateado = "0";
                    }
                    label.setText(valorFormateado);
                    label.setProperty("textAlign", "right");
                    cell.getContent().add(label);
                    setearBordesCelda(cell);
                }
            }

            // Agregamos la tabla creada dinÃ¡micamente a la ya creada como contenedora en el diseÃ±o,
            // con nombre 'contenedor-XXXX', donde XXXX es el nombre de la tabla que ya viene en el DTO
            GridHandle tablaGrupoNuevaConf = (GridHandle) reportDesignHandle.findElement("contenedor-" + idTabla);
            ((CellHandle) tablaGrupoNuevaConf.getCell(0, 2)).getContent().add(tabla);
            // Si es un XLS cambiamos el tamaÃ±o de la pÃ¡gina dinÃ¡micamente para que se adapte
            // al largo de la pÃ¡gina
            if(getContentType().equals(CONTENT_TYPE_XLS)) {
                int coef = 50;
                if(dto.getCantidadIntervaloRating()<4) {
                    coef = 100;
                } else if(dto.getCantidadIntervaloRating()>=4 && dto.getCantidadIntervaloRating()<7) {
                    coef = 80;
                }
                int size = coef * dto.getCantidadIntervaloRating();
                reportDesignHandle.findMasterPage("Simple MasterPage").setProperty("type", "custom");
                reportDesignHandle.findMasterPage("Simple MasterPage").setProperty("height", "210mm");
                reportDesignHandle.findMasterPage("Simple MasterPage").setProperty("width", size + "mm");
                reportDesignHandle.findMasterPage("Simple MasterPage").setProperty("orientation", "landscape");
                reportDesignHandle.findMasterPage("Simple MasterPage").setProperty("backgroundColor", "white");
            }
        }
    }


    private void setearBordesCelda(CellHandle cell) throws SemanticException {
        cell.setProperty("borderTopStyle", "solid");
        cell.setProperty("borderBottomStyle", "solid");
        cell.setProperty("borderLeftStyle", "solid");
        cell.setProperty("borderRightStyle", "solid");
        cell.setProperty("borderTopWidth", "thin");
        cell.setProperty("borderBottomWidth", "thin");
        cell.setProperty("borderLeftWidth", "thin");
        cell.setProperty("borderRightWidth", "thin");
    }

    /**
     * {@inheritDoc}
     */
    protected void renderMergedOutputModel(Map map, HttpServletRequest req, HttpServletResponse resp) throws Exception {

        if(((String) map.get("output")).equals(HTMLRenderOption.OUTPUT_FORMAT_PDF)) {
            setContentType(CONTENT_TYPE_PDF);
        } else {
            setContentType(CONTENT_TYPE_XLS);
        }

        String name = "reporte-indicadorAlertas-" + Calendar.getInstance().getTimeInMillis();
        if(getContentType().equals(CONTENT_TYPE_PDF)) {
            name += "." + HTMLRenderOption.OUTPUT_FORMAT_PDF;
        } else {
            name += ".xls";
        }
        if (map != null && map.containsKey("REPORT_NAME")) {
            name = map.get("REPORT_NAME").toString();
        }

        resp.setHeader("Content-Disposition", "inline; filename=" + name);
        resp.setHeader("Expires", "0");
        resp.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
        resp.setHeader("Pragma", "public");

        resp.setDateHeader("Expires", 0); //prevents caching at the proxy
        resp.setHeader("Cache-Control", "max-age=0");


        // Leemos los parÃ¡metros en el dto, y procesamos la peticiÃ³n
        DtoMetrica dto = new DtoMetrica(req.getParameterMap());

        DDSegmento segmento = ((SegmentoDao)getApplicationContext().getBean("SegmentoDao")).findByCodigo(dto.getCodigoSegmento());
        DDTipoPersona tipoPersona = ((DDTipoPersonaDao)getApplicationContext().getBean("DDTipoPersonaDao")).findByCodigo(dto.getCodigoTipoPersona());
        // Como esta clase no es un Service ni un Component porque estÃ¡ en la vista, obtengo
        // la referencia al manager desde el application context
        Map<String, List<DtoSimulacion>> out = ((ScoringManager)getApplicationContext().getBean("scoringManager")).simular(dto);

        resp.setContentType(getContentType());
        ServletContext sc = req.getSession().getServletContext();
        IReportRunnable design;
        try {
            //Open report design
            design = ReportContext.getBirtEngine().openReportDesign(sc.getRealPath(getUrl().replaceAll(getViewName() + "/", "")));

            // Elemento que nos permitirÃ¡ agregar componentes dinÃ¡micamente al reporte
            ReportDesignHandle report = (ReportDesignHandle) design.getDesignHandle();
            buildReport(report, dto, out);


            //create task to run and render report
            IRunAndRenderTask task = ReportContext.getBirtEngine().createRunAndRenderTask(design);
            task.getAppContext().put(EngineConstants.APPCONTEXT_CLASSLOADER_KEY, ReportAbstractView.class.getClassLoader());

            //set output options
            HTMLRenderOption options = new HTMLRenderOption();
            //set the image handler to a HTMLServerImageHandler if you plan on using the base image url.
            options.setImageHandler(new HTMLServerImageHandler());
            //options.setOutputFormat(HTMLRenderOption.OUTPUT_FORMAT_HTML);
            options.setOutputFormat(getRenderOutputFormat());
            options.setOutputStream(resp.getOutputStream());
            options.setBaseImageURL(req.getContextPath() + "/img");
            options.setImageDirectory(sc.getRealPath("/img"));
            task.setRenderOption(options);

            loadFlowParameters(map, task);

            // Pasamos algunos parÃ¡metros para que los tome el diseÃ±o directamente como variables

            // Path donde estÃ¡n los logos
            //task.setParameterValue("img_src", sc.getRealPath("img"));
            task.setParameterValue("img_src", getImgPath(req));
            // Nombre del archivo con la imagen de logo
            task.setParameterValue("logo_entidad",
                    ((UsuarioManager)getApplicationContext().getBean("usuarioManager"))
                          .getUsuarioLogado().getEntidad().configValue("logo"));
            task.setParameterValue("entidadDescripcion",
                    ((ConfigManager)getApplicationContext().getBean("configManager"))
                          .getConfigByKey("entidadDescripcion").getValor());
            task.setParameterValue("tipoPersona", tipoPersona);
            task.setParameterValue("cantidadIntervaloRating", dto.getCantidadIntervaloRating());
            task.setParameterValue("cantidadIntervaloVRC", dto.getCantidadIntervaloVRC());
            if(segmento!=null) {
                task.setParameterValue("segmento", segmento);
            } else {
                task.setParameterValue("segmento",
                        ((MessageService)getApplicationContext().getBean("messageService")).getMessage("metricas.todos"));
            }
            task.setParameterValue("mostrarConfVigente", new Boolean(true));
            if(out.get(ScoringManager.MET_INACTIVA)!=null) {
            	task.setParameterValue("mostrarConfNueva", new Boolean(true));
            } else {
            	task.setParameterValue("mostrarConfNueva", new Boolean(false));
            }

            //run report
            task.run();
            task.close();
        } catch (Throwable e) {
            logger.error(e);
            throw new ServletException(e);
        }
    }


    /**
     * {@inheritDoc}
     */
    public String getRenderOutputFormat() {
        if(getContentType().equals(CONTENT_TYPE_PDF)) {
            return HTMLRenderOption.OUTPUT_FORMAT_PDF;
        } else {
            return "xls";
        }
    }

    /**
     * {@inheritDoc}
     */
    public String getViewName() {
        return "reportSimulacion";
    }

    /**
     * TODO Este mÃ©todo estÃ¡ como privado en la clase abstracta, pasar a pÃºblico!
     * Metodo encargado de pasar todos los parametros retornado por el flow como
     * entrada para el reporte.
     * @param map
     * @param task
     */
    private void loadFlowParameters(Map map, IRunAndRenderTask task) {
        for (Iterator<Object> i = map.keySet().iterator(); i.hasNext();) {
            Object key = i.next();
            if (key != null /*&& key.toString().startsWith(REPORT_PARAM_KEY)*/) {
                //Agregamos los parametros para el result set
                task.addScriptableJavaObject(key.toString()/*.substring(REPORT_PARAM_KEY.length())*/, map.get(key));
                //Agregamos los parametros para el reporte
                task.setParameterValue(key.toString(), map.get(key));
            }

        }
    }

    /**
     * TODO Este mÃ©todo estÃ¡ como privado en la clase abstracta, pasar a pÃºblico!
     * Metodo encargado de definir el path donde se van a buscar las imagenes.
     * @param request
     */
    private String getImgPath(HttpServletRequest request) {
        //Primero tratamos de obtenerlo de la configuraciÃ³n
        Properties appProperties = ((Properties)getApplicationContext().getBean("appProperties"));
        if (appProperties != null && appProperties.get("img_src") != null) return appProperties.get("img_src").toString();
        //Tratamos de obtenerlo de la ruta del srv
        return request.getRequestURL().substring(0, request.getRequestURL().indexOf(request.getContextPath()) + request.getContextPath().length())
                + "/img/";
    }
}
