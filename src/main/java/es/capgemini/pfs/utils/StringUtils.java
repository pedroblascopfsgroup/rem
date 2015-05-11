package es.capgemini.pfs.utils;

public class StringUtils extends es.capgemini.devon.utils.StringUtils {

    public static boolean emtpyString(String str) {
        return (str == null) || (str.trim().equals(""));
    }

}
