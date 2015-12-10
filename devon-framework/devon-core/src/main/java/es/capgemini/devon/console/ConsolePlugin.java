package es.capgemini.devon.console;

/**
 * @author Nicol�s Cornaglia
 */
public interface ConsolePlugin {

    /**
     * Devuelve el nombre del plugin
     * 
     * @return
     */
    public String getName();

    /**
     * Devuelve la acci�n a realizar, normalmente el nombre de un flow
     * 
     * @return
     */
    public String getAction();
}
