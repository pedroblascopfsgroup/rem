/**
 * 
 */
package es.capgemini.pfs.migracion;

import java.util.Date;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import es.capgemini.pfs.asunto.dao.AsuntoDao;

/**
 * Mini aplicación para crear tareas de aceptar asunto para los asuntos decididos
 * y para la tarea de recopilacion de documentacion para los procedimientos asociados
 * que tengan algunos de los codigos de procedimientos a migrar.
 * @author aesteban
 *
 */

public class CrearTareas implements ApplicationContextAware {

    private ClassPathXmlApplicationContext context;

    @Autowired
    private AsuntoDao asuntosDao;

    private CrearTareas() {
    }

    /**
     * @param args argumentos.
     */
    public static void main(String[] args) {
        CrearTareas crearTaraeas = new CrearTareas();
        crearTaraeas.setApplicationContext(null);
        crearTaraeas.crear();
    }

    private void crear() {
        asuntosDao.getList();
    }

    /**
     * Levanta el contexto de la app.
     * @param arg0 arg
     * @throws BeansException e
     */
    @Override
    public void setApplicationContext(ApplicationContext arg0) throws BeansException {
        Runtime.getRuntime().addShutdownHook(new Thread() {
            @Override
            public void run() {
                context.stop();
                System.out.println(new Date().toString() + " System stopped by command line");
            }
        });
        context = new ClassPathXmlApplicationContext(new String[] { "ac-application-config.xml" });

    }

}
