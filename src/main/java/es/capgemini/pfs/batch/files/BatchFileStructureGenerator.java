package es.capgemini.pfs.batch.files;

import java.io.File;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.capgemini.devon.startup.Initializable;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;

/**
 * @author Nicolás Cornaglia
 */
@Service
public class BatchFileStructureGenerator implements Initializable, Constants {

    private final Log logger = LogFactory.getLog(getClass());

    @Resource
    private EntidadDao entidadDao;

    @Resource
    private Properties appProperties;

    /**
     * Create the base batch directories for the Entities.
     * @see es.capgemini.pfs.startup.Initializable#initialize()
     */
    @Override
    public void initialize() {
        String batchFilesHome = appProperties.getProperty(BATCH_FILES_HOME);
        List<Entidad> configs = entidadDao.getList();
        for (Entidad entidad : configs) {
            if (logger.isDebugEnabled()) {
                logger.debug("Generating dir [" + batchFilesHome + File.separator + entidad.configValue(Entidad.WORKING_CODE_KEY) + "]");
            }
            (new File(batchFilesHome + File.separator + entidad.configValue(Entidad.WORKING_CODE_KEY))).mkdirs();
        }
    }

    /**
     * @param entidadDao the entidadDao to set
     */
    public void setEntidadDao(EntidadDao entidadDao) {
        this.entidadDao = entidadDao;
    }

    /**
     * @param appProperties the appProperties to set
     */
    public void setAppProperties(Properties appProperties) {
        this.appProperties = appProperties;
    }

    /**
     * getOrder.
     * @return int
     */
    @Override
    public int getOrder() {
        return Integer.valueOf("200").intValue();
    }

    /**
     * To String.
     * @return String
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        return "BatchFileStructureGenerator: [" + "order:" + getOrder() + "]";
    }

}
