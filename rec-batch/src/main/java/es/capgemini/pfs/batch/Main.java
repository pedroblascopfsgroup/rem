package es.capgemini.pfs.batch;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import es.capgemini.devon.batch.UnzipActivity;
import es.capgemini.devon.profiling.ProfilerManager;
import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.pfs.utils.JBPMProcessManager;

/**
 * Esta clase lanza la aplicaci�n batch.
 * @author jbosnjak
 *
 */
public class Main {

    private static final String QUIT = "quit";
    private static final String SHORT_EXIT = "e";

    private static final String EXIT = "exit";
    private static final String SHORT_QUIT = "q";

    private static final String STATS = "stats";
    private static final String SHORT_STATS = "s";

    private ClassPathXmlApplicationContext context;

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * @param args parametros
     */
    public static void main(String[] args) {
        Main mainPfs = new Main();

        mainPfs.startup();
    }

    private Main() {
    }

    private void startup() {
        Runtime.getRuntime().addShutdownHook(new Thread() {
            @Override
            public void run() {
                context.stop();
                logger.info(" System stopped by command line");
            }
        });

        //Obtenemos las propiedades para realizar el unzip de los ficheros correspondientes
        Properties unzipProperties = new Properties();
        try {
            InputStream unzipPropIS = ClassLoader.getSystemResourceAsStream("unzip.properties");
            if (unzipPropIS != null) {
                unzipProperties.load(unzipPropIS);
                new UnzipActivity().run(unzipProperties);
            } else {
                logger.error("Error al intentar cargar las propiedades para Unzip");
            }

        } catch (IOException e1) {
            logger.error("Error al ejecutar la tarea Unzip: " + e1.getMessage());
        }

        //Iniciamos el contexto Spring
        context = new ClassPathXmlApplicationContext(new String[] { "ac-application-config.xml" });
        String value = System.getProperty("ignoreJobExecutor");
        if ((value == null) || (! "true".equals(value))) {
	        String startJobExecutor = ((Properties)ApplicationContextUtil.getBean("appProperties")).getProperty("batch.jbpm.startJobExecutor");
	        if(Boolean.parseBoolean(startJobExecutor)){
	            ((JBPMProcessManager)ApplicationContextUtil.getBean(JBPMProcessManager.BEAN_KEY)).startJobExecutor();
	        }
        }else{
        	logger.info("JobExecutor ignored!");
        }
        

        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String s = null;
        try {
            while ((s = in.readLine()) != null && s.length() != 0) {
                if (EXIT.equalsIgnoreCase(s) || QUIT.equalsIgnoreCase(s) || SHORT_EXIT.equalsIgnoreCase(s) || SHORT_QUIT.equalsIgnoreCase(s)) {
                    System.exit(0);
                } else {
                    try {
                        if (STATS.equalsIgnoreCase(s) || SHORT_STATS.equalsIgnoreCase(s)) {
                            printStatistics();
                        }
                    } catch (Exception e) {
                        logger.error("Error: " + e.getMessage());
                    }
                }
            }
        } catch (IOException e) {
            System.exit(0);
        }
    }

    @SuppressWarnings("unchecked")
    private void printStatistics() {
        ProfilerManager profilerManager = (ProfilerManager) context.getBean("profilerManager");
        Map<String, List<Object>> result = profilerManager.getStatistics();

        List<Object> data = result.get(ProfilerManager.DATA_KEY);

        System.out.format("|%1$-70s|%2$-10s|%3$-10s|%4$-10s|%5$-10s|%6$-10s|%7$-10s|%8$-10s|%9$-14s|%10$-14s\n", "Label", "Hits", "Total", "Min",
                "Max", "Avg", "StdDev", "LastValue", "FirstAccess", "LastAccess");

        String format = "|%1$-70s|%2$-10f|%3$-10f|%4$-10f|%5$-10f|%6$-10f|%7$-10f|%8$-10f|%9$tm/%9$te %9$tH:%9$tM:%9$tS|%10$tm/%10$te %10$tH:%10$tM:%10$tS\n";
        for (Object r : data) {
            Map<String, Object> row = (Map<String, Object>) r;
            logger.info(String.format(format, row.get("Label"), row.get("Hits"), row.get("Total"), row.get("Min"), row.get("Max"), row.get("Avg"),
                    row.get("StdDev"), row.get("LastValue"), row.get("FirstAccess"), row.get("LastAccess")));
        }
    }
}
