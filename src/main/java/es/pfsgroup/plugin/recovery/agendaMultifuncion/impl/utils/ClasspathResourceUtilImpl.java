package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils;

import java.io.InputStream;

import org.springframework.stereotype.Component;

@Component
public class ClasspathResourceUtilImpl implements ClasspathResourceUtil {

    @Override
    public InputStream getResourceAsStream(String resourceName) {
        return this.getClass().getClassLoader().getResourceAsStream(resourceName);
    }

}
