package es.capgemini.devon.web.binding;

import java.beans.PropertyEditorSupport;
import java.lang.reflect.ParameterizedType;

import es.capgemini.devon.utils.enums.CodableEnum;
import es.capgemini.devon.utils.enums.CodableEnumUtils;

/**
 * Enums web binding support
 * 
 * @see CodableEnum
 *  
 * @author Nicolás Cornaglia
 */
public class EnumPropertyEditor<EnumType extends CodableEnum> extends PropertyEditorSupport {

    protected Class<EnumType> enumClass = getDomainClass();

    @SuppressWarnings("unchecked")
    protected Class<EnumType> getDomainClass() {
        Object type = getClass().getGenericSuperclass();
        if (type instanceof ParameterizedType) {
            return (Class<EnumType>) ((ParameterizedType) type).getActualTypeArguments()[0];
        } else {
            return (Class<EnumType>) type.getClass();
        }
    }

    @Override
    public void setAsText(String text) throws IllegalArgumentException {
        setValue(CodableEnumUtils.getByCode(text, enumClass));
    }
}