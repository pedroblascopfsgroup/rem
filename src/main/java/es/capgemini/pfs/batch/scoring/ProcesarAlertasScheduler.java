package es.capgemini.pfs.batch.scoring;

import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import es.capgemini.devon.startup.Initializable;

/** Genera los jobs para el el proceso de alertas.
 * @author Pablo Müller
 *
 */
public class ProcesarAlertasScheduler implements ApplicationContextAware, Initializable {

    

    /**
     * Punto de entrada.
     */
    @Override
    public void initialize() {
        
    }

    /**
     * Setea el applicationContext.
     * @param applicationContext el contexto.
     */
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) {

    }

    /**
     * devuelve el orden.
     * @return el orden.
     */
    public int getOrder() {
        return 1001;
    }
}
