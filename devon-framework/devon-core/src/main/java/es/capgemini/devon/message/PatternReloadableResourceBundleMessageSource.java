package es.capgemini.devon.message;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.core.io.UrlResource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.core.io.support.ResourcePatternResolver;
import org.springframework.core.io.support.ResourcePatternUtils;

/**
 * @author Nicolás Cornaglia
 */
public class PatternReloadableResourceBundleMessageSource extends ReloadableResourceBundleMessageSource {

    protected final Log logger = LogFactory.getLog(getClass());

    private ResourceLoader resourceLoader = new DefaultResourceLoader();

    /**
     * Soporte para wilcards en los ficheros de recursos
     * @see PathMatchingResourcePatternResolver
     * 
     * @see org.springframework.context.support.ReloadableResourceBundleMessageSource#setBasenames(java.lang.String[])
     */
    @Override
    public void setBasenames(String[] basenames) {

        ResourcePatternResolver resolver = ResourcePatternUtils.getResourcePatternResolver(resourceLoader);

        List<String> resources = new ArrayList<String>();

        for (int i = 0; i < basenames.length; i++) {
            String basename = basenames[i].trim();

            Resource[] resolvedResources = new Resource[] {};
            try {
                resolvedResources = resolver.getResources(basename);
            } catch (IOException e) {
                //e.printStackTrace();
            }
            if (resolvedResources.length == 0) {
                resources.add(basename);
            } else {
                for (int j = 0; j < resolvedResources.length; j++) {
                    if (!resolvedResources[j].getFilename().contains("_")) {
                        if (resolvedResources[j].exists()) {
                            if (resolvedResources[j] instanceof UrlResource) {
                                String name = resolvedResources[j].toString();
                                resources.add("classpath:" + name.substring(name.indexOf("!") + 1, name.lastIndexOf(".")));
                            } else {
                                try {
                                    String name = resolvedResources[j].getFile().getAbsolutePath();
                                    resources.add("file:/" + name.substring(0, name.lastIndexOf(".")));
                                } catch (IOException e) {
                                }
                            }
                        } else {
                            resources.add(basename);
                        }
                    }
                }
            }
        }

        for (String r : resources) {
            logger.info("Setting [" + r + "] as message source.");
        }

        super.setBasenames(resources.toArray(new String[0]));
    }

    @Override
    public void setResourceLoader(ResourceLoader resourceLoader) {
        this.resourceLoader = (resourceLoader != null ? resourceLoader : new DefaultResourceLoader());
        super.setResourceLoader(resourceLoader);
    }

}
