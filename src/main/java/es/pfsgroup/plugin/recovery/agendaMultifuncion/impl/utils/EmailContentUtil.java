package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils;

import java.util.Map;

import org.apache.velocity.app.VelocityEngine;

/**
 * Interfaz para crear contenido de emails
 * 
 * @author bruno
 * 
 */
public interface EmailContentUtil {

    /**
     * Crea el contenido del email mediante velocity.
     * 
     * @param velocityEngine
     * @param customizeTempate
     * @param model
     * @return
     */
    String createContenntWithVelocity(VelocityEngine velocityEngine, String customizeTempate, Map<String, String> model);

}
