package es.capgemini.pfs.config;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.config.dao.ConfigDao;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;

/**
 * TODO Documentar.
 *
 * @author Nicolás Cornaglia
 */
@Service
@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, readOnly = true)
public class ConfigManager {

    @Resource
    private ConfigDao configDao;

    /**
     * Recupera la configuracion por el key.
     * @param key String
     * @return Config
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_CONFIG_MGR_GET_CONFIG_BY_KEY)
    @Transactional(readOnly = true, rollbackForClassName = "java.lang.NullPointerException")
    public Config getConfigByKey(String key) {
        //        configDao.deleteAll();
        //        if (1 == 1) {
        //            throw new NullPointerException();
        //        }
        return configDao.get(key);
    }

    /**
     * Buscar la configuracion por dto.
     * @param dto ConfigListDTO
     * @return Config
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_CONFIG_MGR_GET_CONFIG_BY_DTO)
    public Config getConfigByDTO(ConfigListDTO dto) {
        return configDao.get(dto.getKey());
    }

    /**
     * Crear dto de configuracion.
     * @param key String
     * @return ConfigListDTO
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_CONFIG_MGR_CREATE_CONFIG_LIST_DTO)
    public ConfigListDTO createConfigListDTO(String key) {
        return new ConfigListDTO(key);
    }

    /**
     * @param configDao ConfigDao
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_CONFIG_MGR_SET_CONFIG_DAO)
    public void setConfigDao(ConfigDao configDao) {
        this.configDao = configDao;
    }

}
