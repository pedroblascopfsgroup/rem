package es.capgemini.devon.console;

/**
 * @author Nicolás Cornaglia
 */
public interface ConsolePlugin {

    /**
     * Devuelve el nombre del plugin
     * 
     * @return
     */
    public String getName();

    /**
     * Devuelve la acción a realizar, normalmente el nombre de un flow
     * 
     * @return
     */
    public String getAction();
}
