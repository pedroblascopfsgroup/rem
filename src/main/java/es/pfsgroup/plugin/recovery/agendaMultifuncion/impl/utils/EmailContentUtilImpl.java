package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils;

import java.util.Map;

import org.apache.velocity.app.VelocityEngine;
import org.springframework.stereotype.Component;
import org.springframework.ui.velocity.VelocityEngineUtils;

@Component
public class EmailContentUtilImpl implements EmailContentUtil {

    @Override
    public String createContenntWithVelocity(VelocityEngine velocityEngine, String customizeTempate, Map<String, String> model) {
        return VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, customizeTempate, model);
    }

}
