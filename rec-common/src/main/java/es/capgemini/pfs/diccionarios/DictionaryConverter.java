package es.capgemini.pfs.diccionarios;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.convert.converters.Converter;
import org.springframework.stereotype.Component;

import es.capgemini.devon.binding.Alias;

/** Conversor automático para entidades de tipo diccionario.
 * @author amarinso
 *
 */
@Component
public class DictionaryConverter implements Converter, Alias {

    @Autowired
    private DictionaryManager dictionaryManager;

    /**
     * PONER JAVADOC FO.
     * @param source source
     * @param target target
     * @return class class
     * @throws Exception e
     */
    @SuppressWarnings("unchecked")
	@Override
    public Object convertSourceToTargetClass(Object source, Class target) throws Exception {
        return dictionaryManager.getByCode(target, source.toString());
    }

    /**
     * PONER JAVADOC FO.
     * @return class
     */
    @Override
    public Class<String> getSourceClass() {
        return java.lang.String.class;
    }

    /**
     * PONER JAVADOC FO.
     * @return class
     */
    @Override
    public Class<Dictionary> getTargetClass() {
        return Dictionary.class;
    }

    /**
     * PONER JAVADOC FO.
     * @return alias
     */
    @Override
    public String getAlias() {
        return "GenericDictionary";
    }

}
