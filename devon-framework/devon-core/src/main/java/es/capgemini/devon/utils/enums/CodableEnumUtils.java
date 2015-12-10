package es.capgemini.devon.utils.enums;

import es.capgemini.devon.exception.FrameworkException;

/**
 * Enum utils to get an Codable Enum by his "code"
 * 
 * @author Nicolás Cornaglia
 */
public class CodableEnumUtils {

    @SuppressWarnings("unchecked")
    public static <T extends CodableEnum> T getByCode(String code, Class<T> enumClass) throws FrameworkException {
        try {
            T[] allValues = (T[]) enumClass.getMethod("values", new Class[0]).invoke(null, new Object[0]);
            for (T value : allValues) {
                if (value.getCode().equals(code)) {
                    return value;
                }
            }
        } catch (Exception e) {
            throw new FrameworkException(e);
        }
        return null;
    }

}
