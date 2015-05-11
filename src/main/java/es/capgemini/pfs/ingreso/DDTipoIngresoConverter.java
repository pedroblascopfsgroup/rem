package es.capgemini.pfs.ingreso;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.convert.converters.Converter;
import org.springframework.stereotype.Component;

import es.capgemini.devon.binding.Alias;
import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.ingreso.model.DDTipoIngreso;

/**
 * Convierte Strings de la request a objetos de tipo DDTipoIngreso.
 * @author Mariano Ruiz
 */
@Component
public class DDTipoIngresoConverter implements Converter, Alias {

    @Autowired
    private Executor executor;

    /**
     * {@inheritDoc}
     */
    @Override
    @SuppressWarnings("unchecked")
    public Object convertSourceToTargetClass(Object source, Class targetClass) throws Exception {
        return executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoIngreso.class, source.toString());
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Class<String> getSourceClass() {
        return java.lang.String.class;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Class<DDTipoIngreso> getTargetClass() {
        return DDTipoIngreso.class;
    }

    /**
     * @return string
     */
    public String getAlias() {
        return "DDTipoIngreso";
    }
}
