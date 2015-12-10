package es.capgemini.devon.utils;

import org.springframework.core.io.ClassPathResource;

/**
 * @author Nicolás Cornaglia
 */
public class ResourceUtils {

    public static ClassPathResource[] getStringAsResources(String strings) {
        return getStringsAsResources(strings.split(","));
    }

    public static ClassPathResource[] getStringsAsResources(String[] strings) {
        ClassPathResource[] resources = null;
        if (strings == null) {
            resources = new ClassPathResource[] {};
        } else {
            resources = new ClassPathResource[strings.length];
            for (int i = 0; i < strings.length; i++) {
                resources[i] = new ClassPathResource(strings[i]);
            }
        }
        return resources;
    }
}
