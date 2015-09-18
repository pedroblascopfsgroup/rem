package es.pfgroup.monioring.bach.load;

/**
 * Posibles resultados del checkeo de una carga del batch.
 * 
 * @author bruno
 * 
 */
public enum CheckStatusResult {
    OK // Sin errores
    , ERROR // Hay errores en la carga
    , RUNNING // Se está ejecutando en estos momentos
    , NOT_EXECUTED // No se ha detectado ninguna ejecució
    , NOOP // Ejecutado pero no ha hecho nada.

}
