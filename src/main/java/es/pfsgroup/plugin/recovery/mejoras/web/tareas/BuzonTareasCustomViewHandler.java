package es.pfsgroup.plugin.recovery.mejoras.web.tareas;

/**
 * Implementar esta interfaz para sobreescribir los ViewHandlers.
 * <p>
 * Seg�n el patr�n por defecto de sobreescritura, se usar� la interfaz
 * {@link BuzonTareasViewHandler} para programar los manejadores gen�ricos de
 * las tareas y �sta interfaz para cuando se requiera la personalziaci�n de un
 * determinado VH. Este patr�n viene implementado por
 * {@link BuzonTareasViewHandlerOverrideDefaultPattern} que es capaz de detectar
 * cuando un determinado manejador ha sido sobreescrito y devolverlo en vez del
 * gen�rico.
 * 
 * @author bruno
 * 
 */
public interface BuzonTareasCustomViewHandler extends BuzonTareasViewHandler {

}
