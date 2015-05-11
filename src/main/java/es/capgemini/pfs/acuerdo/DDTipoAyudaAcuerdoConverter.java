package es.capgemini.pfs.acuerdo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.convert.converters.Converter;
import org.springframework.stereotype.Component;

import es.capgemini.devon.binding.Alias;
import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.acuerdo.model.DDTipoAyudaAcuerdo;
import es.capgemini.pfs.comun.ComunBusinessOperation;

/**
 * Convierte Strings de la request en objetos de tipo.
 * @author Lisandro Medrano
 *
 */
@Component
public class DDTipoAyudaAcuerdoConverter implements Converter, Alias {

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
        return executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoAyudaAcuerdo.class, source.toString());
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
     * Retorna TipoAyudaActuacion.class.
     *
     * @return TipoAyudaActuacion.class
     */
    @Override
    public Class<DDTipoAyudaAcuerdo> getTargetClass() {
        return DDTipoAyudaAcuerdo.class;
    }

    /**
     * Retorna un alias.
     *
     * @return alias String
     */
    public String getAlias() {
        return "DDTipoAyudaAcuerdo";
    }
}
