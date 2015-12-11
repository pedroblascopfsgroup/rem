package es.capgemini.devon.hibernate.utils;

import java.util.Properties;

import org.hibernate.EmptyInterceptor;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.devon.utils.PropertyPlaceholderUtils;

/**
 * @author Nicolás Cornaglia
 */
public class HibernateSqlInterceptor extends EmptyInterceptor {

    private static final long serialVersionUID = 1L;

    private Properties properties;

    /**
     * @see org.hibernate.EmptyInterceptor#onPrepareStatement(java.lang.String)
     */
    @Override
    public String onPrepareStatement(String sql) {
        String prepedStatement = super.onPrepareStatement(sql);

        String entityDBSchema = "";
        if (DbIdContextHolder.getDbId() != -1) {
            entityDBSchema = DbIdContextHolder.getDbSchema() + ".";
        }
        prepedStatement = prepedStatement.replaceAll("\\$\\{entity\\.schema\\}\\.", entityDBSchema);

        prepedStatement = PropertyPlaceholderUtils.resolve(prepedStatement, properties);
        return prepedStatement;
    }

    /**
     * @param properties the properties to set
     */
    public void setProperties(Properties properties) {
        this.properties = properties;
    }

}
