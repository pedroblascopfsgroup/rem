package es.pfsgroup.recovery.api;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.arquetipo.model.Arquetipo;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface ArquetipoApi {
	/**
     * Retorna el arquetipo que corresponde al id indicado.
     * @param id arquetipo id
     * @return arquetipo
     */
    @BusinessOperationDefinition(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET_WITH_ESTADO)
    @Transactional
    public Arquetipo getWithEstado(Long id);
}
