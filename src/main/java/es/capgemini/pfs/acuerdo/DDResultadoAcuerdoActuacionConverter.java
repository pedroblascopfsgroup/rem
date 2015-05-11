package es.capgemini.pfs.acuerdo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.convert.converters.Converter;
import org.springframework.stereotype.Component;

import es.capgemini.devon.binding.Alias;
import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.acuerdo.model.DDResultadoAcuerdoActuacion;
import es.capgemini.pfs.comun.ComunBusinessOperation;

/**
 * @author marruiz
 */
@Component
public class DDResultadoAcuerdoActuacionConverter implements Converter, Alias {

    @Autowired
    private Executor executor;

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public Object convertSourceToTargetClass(Object source, Class targetClass) throws Exception {
        return executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDResultadoAcuerdoActuacion.class, source.toString());
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public Class getSourceClass() {
        return java.lang.String.class;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public Class getTargetClass() {
        return DDResultadoAcuerdoActuacion.class;
    }

    /**
     * @return string
     */
    public String getAlias() {
        return "DDResultadoAcuerdoActuacion";
    }
}
