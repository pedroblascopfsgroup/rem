/*
 * Copyright 2006-2007 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package es.capgemini.devon.dao.datasource;

import java.util.Map;
import java.util.Properties;

import javax.sql.DataSource;

import org.springframework.beans.factory.config.AbstractFactoryBean;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.util.Assert;

import es.capgemini.devon.utils.DatabaseUtils;
import es.capgemini.devon.utils.ResourceUtils;

/**
 * @author Modified: Nicolás Cornaglia
 */
public class InitializingDataSourceFactoryBean extends AbstractFactoryBean {

    private Resource[] resourceInitScripts = new ClassPathResource[] {};
    private Resource[] resourceDestroyScripts = new ClassPathResource[] {};
    private DataSource dataSource;
    private String flagTable;
    private boolean allwaysInitialize = false;
    private boolean initialized = false;
    private String info;
    private Map<String, Object> parameters;

    @javax.annotation.Resource
    protected Properties appProperties;

    /**
     * @throws Throwable
     * @see java.lang.Object#finalize()
     */
    @Override
    protected void finalize() throws Throwable {
        super.finalize();
        initialized = false;
        if (logger.isDebugEnabled()) {
            logger.debug("finalize called");
        }
    }

    @Override
    protected void destroyInstance(Object instance) {
        try {
            //executeScripts(resourceDestroyScripts, parameters);
        } catch (Exception e) {
            if (logger.isWarnEnabled()) {
                logger.warn("Could not execute destroy scripts", e);
            }
        }
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        Assert.notNull(dataSource);
        super.afterPropertiesSet();
    }

    @Override
    protected Object createInstance() {
        Assert.notNull(dataSource);
        if (!initialized) {
            if (allwaysInitialize() || mustInitialize(dataSource)) {
                logger.info("Initializing datasource [" + getInfo() + "]");
                try {
                    DatabaseUtils.executeScripts(dataSource, resourceDestroyScripts, parameters, true, appProperties);
                } catch (Exception e) {
                    logger.debug("Could not execute destroy scripts", e);
                }
                DatabaseUtils.executeScripts(dataSource, resourceInitScripts, parameters, false, appProperties);
            }
            initialized = true;
        }
        return dataSource;
    }

    private boolean mustInitialize(DataSource dataSource) {
        if (flagTable != null) {
            return !DatabaseUtils.tableExists(dataSource, flagTable);
        } else {
            return false;
        }
    }

    @Override
    public Class<DataSource> getObjectType() {
        return DataSource.class;
    }

    public void setInitScripts(String initScripts) {
        resourceInitScripts = ResourceUtils.getStringAsResources(initScripts);
    }

    public void setInitScripts(String[] initScripts) {
        resourceInitScripts = ResourceUtils.getStringsAsResources(initScripts);
    }

    public void setDestroyScripts(String destroyScripts) {
        resourceDestroyScripts = ResourceUtils.getStringAsResources(destroyScripts);
    }

    public void setDestroyScripts(String[] destroyScripts) {
        resourceDestroyScripts = ResourceUtils.getStringsAsResources(destroyScripts);
    }

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public void setFlagTable(String flagTable) {
        this.flagTable = flagTable;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }

    public void setParameters(Map<String, Object> parameters) {
        this.parameters = parameters;
    }

    public boolean allwaysInitialize() {
        return allwaysInitialize;
    }

    public void setAllwaysInitialize(boolean allwaysInitialize) {
        this.allwaysInitialize = allwaysInitialize;
    }

    /**
     * @param appProperties the appProperties to set
     */
    public void setProperties(Properties properties) {
        this.appProperties = properties;
    }

}
