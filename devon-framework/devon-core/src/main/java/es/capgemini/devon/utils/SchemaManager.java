package es.capgemini.devon.utils;

/**
 * Interfaz para la definicion del schema que se va a setear en la clase DbIdContextHolder
 * 
 * @author lgiavedo
 */
public interface SchemaManager {

    public abstract String getSchemaForDbId(Long dbId);

}
