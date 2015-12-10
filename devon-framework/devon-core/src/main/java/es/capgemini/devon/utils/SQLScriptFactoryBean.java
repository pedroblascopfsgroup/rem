package es.capgemini.devon.utils;

import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.FactoryBean;

/**
 * @author Nicolás Cornaglia
 */
public class SQLScriptFactoryBean implements FactoryBean {

    private String key;

    @Resource
    Properties sqlScripts;
    
    @javax.annotation.Resource
    protected Properties appProperties;

    @Override
    public Object getObject() throws Exception {
    	String originalScript = sqlScripts.getProperty(key, "");
    	String script = PropertyPlaceholderUtils.resolve(originalScript, appProperties);
    	return script;
    }

    @Override
    public Class getObjectType() {
        return String.class;
    }

    @Override
    public boolean isSingleton() {
        return false;
    }

    /**
     * @param key the key to set
     */
    public void setKey(String key) {
        this.key = key;
    }

}
