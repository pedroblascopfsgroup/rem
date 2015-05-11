package es.pfsgroup.recovery.ext.impl.utils;

public class StringUtils extends es.capgemini.devon.utils.StringUtils {
	 public static boolean emtpyString(String str) {
	        return (str == null) || (str.trim().equals(""));
	    }
}
