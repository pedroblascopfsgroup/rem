package es.capgemini.pfs.cobropago.model;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.convert.converters.Converter;
import org.springframework.stereotype.Component;

import es.capgemini.devon.binding.Alias;
import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.comun.ComunBusinessOperation;

/**
 * Comverter para Subtipo Cobro Pago.
 */
@Component
public class DDSubtipoCobroPagoConverter implements Converter, Alias {

    @Autowired
    private Executor executor;

    /**
     *{@inheritDoc}
     */
    @Override
    @SuppressWarnings("unchecked")
    public Object convertSourceToTargetClass(Object source, Class target) throws Exception {
        return executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDSubtipoCobroPago.class, source.toString());
    }

    /**
     *{@inheritDoc}
     */
    @Override
    public Class<String> getSourceClass() {
        return java.lang.String.class;
    }

    /**
     *{@inheritDoc}
     */
    @Override
    public Class<DDSubtipoCobroPago> getTargetClass() {
        return DDSubtipoCobroPago.class;
    }

    /**
     *{@inheritDoc}
     */
    @Override
    public String getAlias() {
        return "DDSubtipoCobroPago";
    }

}
