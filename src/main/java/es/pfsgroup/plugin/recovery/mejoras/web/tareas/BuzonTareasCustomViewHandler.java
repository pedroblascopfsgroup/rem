package es.pfsgroup.plugin.recovery.mejoras.web.tareas;

/**
 * Implementar esta interfaz para sobreescribir los ViewHandlers.
 * <p>
 * Según el patrón por defecto de sobreescritura, se usará la interfaz
 * {@link BuzonTareasViewHandler} para programar los manejadores genéricos de
 * las tareas y ésta interfaz para cuando se requiera la personalziación de un
 * determinado VH. Este patrón viene implementado por
 * {@link BuzonTareasViewHandlerOverrideDefaultPattern} que es capaz de detectar
 * cuando un determinado manejador ha sido sobreescrito y devolverlo en vez del
 * genérico.
 * 
 * @author bruno
 * 
 */
public interface BuzonTareasCustomViewHandler extends BuzonTareasViewHandler {

}
