package es.capgemini.pfs.diccionarios;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.util.List;

import javax.annotation.Resource;
import javax.persistence.Column;

import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.hibernate.dao.AbstractHibernateDao;
import es.capgemini.pfs.auditoria.model.Auditoria;

/** DAO gen�rico para recuperar diccionarios. Sílo tratar� con entidades cuyo nombre comience con DD
 *
 * @author amarinso
 *
 */
@SuppressWarnings("unchecked")
@Repository
public class DictionaryDao extends AbstractHibernateDao<Dictionary, Long> {

    /** obtiene los elementos de la tabla de diccionario que se pide.
     * @param domainClass el nombre de la clase debe comenzar por DD
     * @return l
     */
    public List<Dictionary> getList(String domainClass) {

        /*
        if (!domainClass.startsWith("DD")) { throw new IllegalArgumentException("Sílo podemos recuperar diccionarios cuya clase comience con DD. ["
                + domainClass + "] no lo cumple"); }
        */
        return getSession().createQuery("from " + domainClass + " where " + Auditoria.UNDELETED_RESTICTION).setCacheable(true).list();
    }

    private String getMappingDelCampoCodigo(Class domainClass) {
        Field field;
        try {
            field = domainClass.getDeclaredField("codigo");
        } catch (Exception e) {
            throw new UserException("No se puede obtener el código del elemento de dicionario " + domainClass.getName());
        }
        Annotation annotation = field.getAnnotation(Column.class);
        return ((Column) annotation).name();
    }

    /** Obtiene el registro cuyo valor pasamos como par�metro. Es necesaria la clase para poder utilizar reflection.
     * @param domainClass d
     * @param codigo codigo
     * @return bycode
     */
    public Dictionary getByCode(Class domainClass, String codigo) {

        String className = domainClass.getName().replace(domainClass.getPackage().getName() + ".", "");

        if (!className.startsWith("DD")) { throw new IllegalArgumentException("Sílo podemos recuperar diccionarios cuya clase comience con DD. ["
                + domainClass + "] no lo cumple"); }
        List<Dictionary> listado = getSession().createQuery(
                "from " + className + " where " + getMappingDelCampoCodigo(domainClass) + "= '" + codigo + "' and " + Auditoria.UNDELETED_RESTICTION)
                .setCacheable(true).list();
        if (listado.size() > 0) { return listado.get(0); }
        return null;
    }

    /**
     * PONER JAVADOC FO.
     * @param entitySessionFactory e
     */
    @Resource
    public void setEntitySessionFactory(SessionFactory entitySessionFactory) {
        super.setSessionFactory(entitySessionFactory);
    }

    /**
     * Obtiene el registro cuyo valor pasamos como codigo, a partir del Nombre de la clase. 
     * @param className
     * @param codigo
     * @return
     */
    public Dictionary getByCode(String className, String codigo) {
        Class domainClass = null;
        try {
            domainClass = Class.forName(className);
            return getByCode(domainClass, codigo);
        } catch (ClassNotFoundException e) {
            throw new IllegalArgumentException("No se encontro la clase " + className);
        }
    }
}
