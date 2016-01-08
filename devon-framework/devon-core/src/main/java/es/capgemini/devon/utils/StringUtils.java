package es.capgemini.devon.utils;

import org.springframework.util.ObjectUtils;

/**
 * @author Nicolás Cornaglia
 */
public class StringUtils {

    public static String COMMA_SEPARATOR = ",";
    public static String SEMICOLON_SEPARATOR = ";";
    public static String DEFAULT_SEPARATOR = COMMA_SEPARATOR;
    public static String DEFAULT_STRING_DELIMITER = "\"";

    public static String arrayToDelimitedString(Object[] arr, String delimiter, String stringDelimiter) {
        if (ObjectUtils.isEmpty(arr)) {
            return "";
        }
        StringBuilder sb = new StringBuilder(255);
        for (int i = 0; i < arr.length; i++) {
            if (i > 0) {
                sb.append(delimiter);
            }
            if (arr[i] instanceof String) {
                sb.append(stringDelimiter).append(arr[i]).append(stringDelimiter);
            } else {
                sb.append(arr[i]);
            }

        }
        return sb.toString();
    }

    public static String arrayToCommaDelimitedString(Object[] arr) {
        return arrayToDelimitedString(arr, COMMA_SEPARATOR, DEFAULT_STRING_DELIMITER);
    }

    public static String arrayToSemiColonDelimitedString(Object[] arr) {
        return arrayToDelimitedString(arr, SEMICOLON_SEPARATOR, DEFAULT_STRING_DELIMITER);
    }

}
