package es.capgemini.pfs.actitudAptitudActuacion;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.convert.converters.Converter;
import org.springframework.stereotype.Component;

import es.capgemini.devon.binding.Alias;
import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.actitudAptitudActuacion.model.DDPropuestaActuacion;
import es.capgemini.pfs.comun.ComunBusinessOperation;

/**
 * @author marruiz
 */
@Component
public class DDPropuestaActuacionConverter implements Converter, Alias {

    @Autowired
    private Executor executor;

    /**
     * convertSourceToTargetClass.
     *
     * @param source
     *            Object
     * @param targetClass
     *            Class
     * @throws Exception
     *             excepción
     * @return Object
     */
    @Override
    @SuppressWarnings("unchecked")
    public Object convertSourceToTargetClass(Object source, Class targetClass) throws Exception {
        return executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDPropuestaActuacion.class, source.toString());
    }

    /**
     * Return sourceClass.
     *
     * @return Class
     */
    @Override
    public Class<String> getSourceClass() {
        return java.lang.String.class;
    }

    /**
     * @return DDPropuestaActuacion.class
     */
    @Override
    public Class<DDPropuestaActuacion> getTargetClass() {
        return DDPropuestaActuacion.class;
    }

    /**
     * Retorna un alias.
     *
     * @return alias String
     */
    public String getAlias() {
        return "DDPropuestaActuacion";
    }
}
