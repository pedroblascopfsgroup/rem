package es.capgemini.pfs.bien;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.convert.converters.Converter;
import org.springframework.stereotype.Component;

import es.capgemini.devon.binding.Alias;
import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.bien.model.DDTipoBien;
import es.capgemini.pfs.comun.ComunBusinessOperation;

/**
 * Convierte Strings de la request a objetos de tipo DDTipoBien.
 * @author amarinso
 *
 */
@Component
public class DDTipoBienConverter implements Converter, Alias {

    @Autowired
    private Executor executor;

    /**
     * {@inheritDoc}
     */
    @Override
    @SuppressWarnings("unchecked")
    public Object convertSourceToTargetClass(Object source, Class targetClass) throws Exception {
        return executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoBien.class, source.toString());
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
    public Class<DDTipoBien> getTargetClass() {
        return DDTipoBien.class;
    }

    /**
     * @return string
     */
    public String getAlias() {
        return "DDTipoBien";
    }

}
