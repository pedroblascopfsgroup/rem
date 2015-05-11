package es.capgemini.pfs.batch.politicas;

import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

import es.capgemini.devon.startup.Initializable;

/** Genera los jobs para el el proceso de alertas.
 * @author Pablo Müller
 *
 */
@Component
public class ProcesarObjetivosScheduler implements ApplicationContextAware, Initializable {


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
