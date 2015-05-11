package es.capgemini.pfs.batch.prepoliticas;

import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

import es.capgemini.devon.startup.Initializable;

/** Genera los jobs para el el proceso de prepoliticas.
 * @author lgiavedo
 *
 */
@Component
public class ProcesarPrepoliticasScheduler implements ApplicationContextAware, Initializable {


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
    @Override
    public int getOrder() {
        return 1001;
    }
}
