package es.capgemini.pfs.actitudAptitudActuacion;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.convert.converters.Converter;
import org.springframework.stereotype.Component;

import es.capgemini.devon.binding.Alias;
import es.capgemini.pfs.actitudAptitudActuacion.model.DDTipoAyudaActuacion;

/**
 * Convierte Strings de la request a objetos de tipo TipoAyudaActuacion.
 *
 * @author mtorrado
 *
 */
@SuppressWarnings("unchecked")
@Component
public class DDTipoAyudaActuacionConverter implements Converter, Alias {

    @Autowired
    private TipoAyudaActuacionManager tipoAyudaActuacionManager;

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
    public Object convertSourceToTargetClass(Object source, Class targetClass) throws Exception {
        return tipoAyudaActuacionManager.getByCodigo(source.toString());
    }

    /**
     * Return sourceClass.
     *
     * @return Class
     */
    @Override
    public Class getSourceClass() {
        return java.lang.String.class;
    }

    /**
     * Retorna TipoAyudaActuacion.class.
     *
     * @return TipoAyudaActuacion.class
     */
    @Override
    public Class getTargetClass() {
        return DDTipoAyudaActuacion.class;
    }

    /**
     * Retorna un alias.
     *
     * @return alias String
     */
    public String getAlias() {
        return "DDTipoAyudaActuacion";
    }

}
