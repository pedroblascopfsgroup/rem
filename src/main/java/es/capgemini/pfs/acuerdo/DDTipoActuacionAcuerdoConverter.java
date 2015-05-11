package es.capgemini.pfs.acuerdo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.convert.converters.Converter;
import org.springframework.stereotype.Component;

import es.capgemini.devon.binding.Alias;
import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.acuerdo.model.DDTipoActuacionAcuerdo;
import es.capgemini.pfs.comun.ComunBusinessOperation;

/**
 * @author marruiz
 */
@Component
public class DDTipoActuacionAcuerdoConverter implements Converter, Alias {

    @Autowired
    private Executor executor;

    /**
     * {@inheritDoc}
     */
    @Override
    @SuppressWarnings("unchecked")
    public Object convertSourceToTargetClass(Object source, Class targetClass) throws Exception {
        return executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoActuacionAcuerdo.class, source.toString());
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
    public Class<DDTipoActuacionAcuerdo> getTargetClass() {
        return DDTipoActuacionAcuerdo.class;
    }

    /**
     * @return string
     */
    public String getAlias() {
        return "DDTipoActuacionAcuerdo";
    }
}
