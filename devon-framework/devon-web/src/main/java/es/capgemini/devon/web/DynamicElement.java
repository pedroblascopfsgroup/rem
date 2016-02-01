package es.capgemini.devon.web;

/**
 * Interfaz para elementos que se cargan dinámicamente a la vista.
 * 
 * Los elementos se clasifican en grupos que tienen el mismo getName(), por ejemplo "menu", "cliente.tabs"
 * 
 * Un plugin podrá sobreescribir un elemento existente con el mismo nombre si tiene mayor priority
 * 
 */
public interface DynamicElement {

    public String getName();

    public String getFileName();

    public int getOrder();

    public String getEntity();

    public int getPriority();

    public boolean valid(Object param);

    public void setEntity(String entity);
}
