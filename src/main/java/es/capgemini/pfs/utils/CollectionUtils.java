package es.capgemini.pfs.utils;

import java.util.Collection;

/**
 * @author lgiavedo
 *
 */
public final class CollectionUtils {

    @SuppressWarnings("unchecked")
    public static String[] toString(Collection data) {
        return toString(data.toArray());
    }

    public static String[] toString(Object[] data) {
        if (data == null) return new String[] {};
        String[] result = new String[data.length];
        for (int i = 0; i < data.length; i++) {
            result[i] = data[i].toString();
        }
        return result;
    }

    public static String convertListToListString(String str) {
        StringBuilder res = new StringBuilder();

        String[] aux = str.split(",");
        for (String s : aux) {
            res.append("'").append(s).append("',");
        }

        res.deleteCharAt(res.length() - 1);

        return res.toString();
    }

}
