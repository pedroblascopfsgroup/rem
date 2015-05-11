package es.capgemini.pfs.utils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.devon.utils.SchemaManager;
import es.capgemini.pfs.dsm.DataSourceManager;
import es.capgemini.pfs.dsm.dao.EntidadDao;

/**
 * @author lgiavedo
 *
 */
public class SchemaManagerImp implements SchemaManager {

    @Autowired
    private EntidadDao entidadDao;

    /**
     * Recupera el esquema el id de BBDD indicado.
     * @param dbId Long
     * @return string
     */
    @Override
    public String getSchemaForDbId(Long dbId) {
        try {
            if (dbId != -1) {
                String schemma = entidadDao.get(DbIdContextHolder.getDbId()).configValue(DataSourceManager.SCHEMA_KEY);
                return schemma;
            }
        } catch (Exception e) {
            logger.error("Error al intentar setear el schema para la bd!", e);
        }
        return "";
    }

    private final Log logger = LogFactory.getLog(getClass());

}
