package es.capgemini.pfs.diccionarios;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.comun.ComunBusinessOperation;

/**
 * Manager que maneja los procesos jbpm judiciales de manera genérica.
 *
 * @author aesteban
 *
 */
@Service
public class DictionaryManager {

    @Autowired
    private DictionaryDao dictionaryDao;

    /**
     * PONER JAVADOC FO.
     * @param domainClass d
     * @return d
     */
    @BusinessOperation(ComunBusinessOperation.BO_DICTIONARY_GET_LIST)
    public List<Dictionary> getList(String domainClass) {
        return dictionaryDao.getList(domainClass);
    }

    /**
     * Devuelve una instancia de una clase de Diccionario de Datos
     * @param className el nombre de la clase
     * @param codigo el codigo de la instancia que se desea
     * @return bycode
     */
    @BusinessOperation(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE_CLASSNAME)
    public Dictionary getByCode(String className, String codigo) {
        return dictionaryDao.getByCode(className, codigo);
    }

    /**
     * 
     * @param domainClass
     * @param codigo
     * @return
     */
    @BusinessOperation(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE)
    @SuppressWarnings("unchecked")
    public Dictionary getByCode(Class domainClass, String codigo) {
        return dictionaryDao.getByCode(domainClass, codigo);
    }
}
