package es.capgemini.pfs.titulo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.convert.converters.Converter;
import org.springframework.stereotype.Component;

import es.capgemini.devon.binding.Alias;
import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.titulo.model.DDTipoTitulo;

/** Convierte Strings de la request a objetos de tipo DDTipoTitulo.
 * @author amarinso
 *
 */
@Component
public class DDTipoTituloConverter implements Converter, Alias {

    @Autowired
    private Executor executor;

    /**
     * convertSourceToTargetClass.
     * @param source Object
     * @param targetClass Class
     * @throws Exception excepción
     * @return Object
     */
    @Override
    @SuppressWarnings("unchecked")
    public Object convertSourceToTargetClass(Object source, Class targetClass) throws Exception {
        return executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoTitulo.class, source.toString());
    }

    /**
     * Return sourceClass.
     * @return Class
     */
    @Override
    public Class<String> getSourceClass() {
        return java.lang.String.class;
    }

    /**
     * Retorna  DDTipoTitulo.class.
     * @return DDTipoTitulo.class
     */
    @Override
    public Class<DDTipoTitulo> getTargetClass() {
        return DDTipoTitulo.class;
    }

    /**
     * Retorna un alias.
     * @return alias String
     */
    public String getAlias() {
        return "DDTipoTitulo";
    }
}
