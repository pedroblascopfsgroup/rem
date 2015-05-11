package es.capgemini.pfs.dsm;

import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;

import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.security.model.UsuarioSecurity;

/**
 * TODO Documentar.
 *
 * @author Nicolás Cornaglia
 */
public class EntityDataSource extends AbstractRoutingDataSource {

    /**
     * setea el datasource.
     * @return id
     */
    @Override
    protected Object determineCurrentLookupKey() {
        Long dbId = DataSourceManager.NO_DATASOURCE_ID;
        UsuarioSecurity usuario = (UsuarioSecurity) SecurityUtils.getCurrentUser();
        if (usuario == null) {
            if (DbIdContextHolder.getDbId() == null) {
                dbId = DataSourceManager.NO_DATASOURCE_ID;
            } else {
                dbId = DbIdContextHolder.getDbId();
            }
        } else {
            if (usuario.getEntidad() != null) {
                dbId = usuario.getEntidad().getId();
            } else {
                dbId = DataSourceManager.MASTER_DATASOURCE_ID;
            }
        }

        if (log.isTraceEnabled()) {
            log.trace("Retornando ID de BD [" + dbId + "]");
        }
        return dbId;

    }

    /**
     * afterPropertiesSet.
     */
    @Override
    public final void afterPropertiesSet() {
    }

    /**
     * registerTargetDataSources.
     * @param targetDataSources datasources
     */
    @SuppressWarnings("unchecked")
    public void registerTargetDataSources(Map targetDataSources) {
        setTargetDataSources(targetDataSources);
        super.afterPropertiesSet();
    }

    private static Log log = LogFactory.getLog(EntityDataSource.class);

}
