package es.capgemini.devon.utils;

/**
 * @author Nicol�s Cornaglia
 */
public class QueueUtils {

    public static String WK_PREFIX = "[";
    public static String WK_SUFFIX = "]";

    public static String getQueueNameForEntity(String channelName, String workingCode) {
        return channelName + WK_PREFIX + workingCode + WK_SUFFIX;
    }

}
