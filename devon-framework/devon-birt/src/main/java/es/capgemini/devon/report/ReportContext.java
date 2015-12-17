package es.capgemini.devon.report;

import java.util.Properties;
import java.util.logging.Level;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.eclipse.birt.core.exception.BirtException;
import org.eclipse.birt.core.framework.Platform;
import org.eclipse.birt.core.framework.PlatformConfig;
import org.eclipse.birt.core.framework.PlatformFileContext;
import org.eclipse.birt.report.engine.api.EngineConfig;
import org.eclipse.birt.report.engine.api.IReportEngine;
import org.eclipse.birt.report.engine.api.IReportEngineFactory;
import org.springframework.stereotype.Component;

/**
 * Clase encargada de iniciar el contexto de Birt para la generación del reportes.
 * Se basa en la propiedad birt.home para identificar la ruta de platform que se debe cargar
 * 
 * @author lgiavedo
 *
 */
@Component
public class ReportContext {

    @javax.annotation.Resource
    private Properties appProperties;

    private static IReportEngine birtEngine = null;

    private static final ReportContext instance = new ReportContext();

    public synchronized IReportEngine initBirtEngine() {
        //Verificamos si se debe iniciar la plataforma birt

        if (appProperties.getProperty("birt.loadOnStartup") != null
                && appProperties.getProperty("birt.loadOnStartup").trim().toUpperCase().equals("FALSE"))
            logger.warn("BIRT - No se va ha iniciado la plataforma debido a parametros de configuración!");
        else {
            EngineConfig config = new EngineConfig();

            config.setLogConfig(appProperties.getProperty("birt.logDirectory"), Level.parse(appProperties.getProperty("birt.logLevel")));

            config.setEngineHome("");

            //IPlatformContext context = new PlatformServletContext(servletContext);

            PlatformConfig pc = new PlatformConfig();
            pc.setBIRTHome(appProperties.getProperty("birt.home"));
            PlatformFileContext context = new PlatformFileContext(pc);

            config.setPlatformContext(context);

            try {
                logger.info("Iniciando la plataforma de BIRT");
                Platform.startup(config);
                logger.info("Plataforma BIRT iniciada");

                IReportEngineFactory factory = (IReportEngineFactory) Platform
                        .createFactoryObject(IReportEngineFactory.EXTENSION_REPORT_ENGINE_FACTORY);
                birtEngine = factory.createReportEngine(config);

            } catch (BirtException e) {
                logger.error("Error al inicial la plataforma BIRT. ", e);
            }
        }
        return birtEngine;
    }

    public static synchronized void destroyBirtEngine() {
        if (birtEngine == null) { return; }
        birtEngine.shutdown();
        Platform.shutdown();
        birtEngine = null;
    }

    public static IReportEngine getBirtEngine() {
        if (birtEngine == null) {
            logger.warn("La plataforma BIRT no ha sido iniciado correctamente.");
            instance.initBirtEngine();
        }
        return birtEngine;
    }

    @Override
    public Object clone() throws CloneNotSupportedException {
        throw new CloneNotSupportedException();
    }

    private static final Log logger = LogFactory.getLog(ReportContext.class);

}
