package es.capgemini.pfs.cobropago.model;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.convert.converters.Converter;
import org.springframework.stereotype.Component;

import es.capgemini.devon.binding.Alias;
import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.comun.ComunBusinessOperation;

/**
 * Convierte Strings de la request a objetos de tipo DDEstadoCobroPago.
 * @author Lisandro Medrano
 *
 */
@Component
public class DDEstadoCobroPagoConverter implements Converter, Alias {

    @Autowired
    private Executor executor;

    /**
     *{@inheritDoc}
     */
    @Override
    @SuppressWarnings("unchecked")
    public Object convertSourceToTargetClass(Object source, Class target) throws Exception {
        return executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoCobroPago.class, source.toString());
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
    public Class<DDEstadoCobroPago> getTargetClass() {
        return DDEstadoCobroPago.class;
    }

    /**
     *{@inheritDoc}
     */
    @Override
    public String getAlias() {
        return "DDEstadoCobroPago";
    }

}
