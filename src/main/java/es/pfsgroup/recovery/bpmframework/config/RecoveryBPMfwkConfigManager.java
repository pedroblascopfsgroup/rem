package es.pfsgroup.recovery.bpmframework.config;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.Assertions;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkConfigApi;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkTipoProcInput;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError.ProblemasConocidos;

/**
 * Implementación del api pública de acceso a la configuración de tipos de inputs.
 * @author manuel
 *
 */
@Service
public class RecoveryBPMfwkConfigManager implements RecoveryBPMfwkConfigApi {

    @Autowired
    private transient GenericABMDao genericDao;
    
//	/* (non-Javadoc)
//	 * @see es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkConfigApi#getInputConfig(java.lang.String, java.lang.String)
//	 */
//	@Override
//	@BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_GET_INPUT_CONFIG)
//	//FIXME: Sustituir este método por getInputConfigNodo (de momento lo trampeamos para que devuelva la primera configuracion que cumpla)
//	@Deprecated
//	public	RecoveryBPMfwkCfgInputDto getInputConfig(final String codigoTipoInput, final String codigoTipoProcedimiento) {
//
//		RecoveryBPMfwkCfgInputDto cfgInputDto = new RecoveryBPMfwkCfgInputDto();
//
//		//RecoveryBPMfwkTipoProcInput configTipoProcInput = this.getTipoProcInput(codigoTipoInput, codigoTipoProcedimiento);
//
//		List<RecoveryBPMfwkTipoProcInput> listaConfigTipoProcInput = this.getListaTipoProcInput(codigoTipoInput, codigoTipoProcedimiento);
//		
//		for (RecoveryBPMfwkTipoProcInput recoveryBPMfwkTipoProcInput : listaConfigTipoProcInput) {
//			cfgInputDto = this.populateDto(recoveryBPMfwkTipoProcInput);
//			break;
//		}
//		
//		return cfgInputDto;
//	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkConfigApi#getInputConfig(java.lang.String, java.lang.String)
	 */
	@Override
	@BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_GET_INPUT_CONFIG_NODO)
	public	RecoveryBPMfwkCfgInputDto getInputConfigNodo(final String codigoTipoInput, final String codigoTipoProcedimiento, final String codigoNodo) 
			throws RecoveryBPMfwkError{

		RecoveryBPMfwkCfgInputDto cfgInputDto = null;
		
		List<RecoveryBPMfwkTipoProcInput> listaConfigTipoProcInput = this.getListaTipoProcInput(codigoTipoInput, codigoTipoProcedimiento);
		
		for (RecoveryBPMfwkTipoProcInput recoveryBPMfwkTipoProcInput : listaConfigTipoProcInput) {
			//Comprobar que el nodo está incluido en la relación
			if (compruebaValidezTipoInputParaNodo(codigoNodo, recoveryBPMfwkTipoProcInput)) {
				if (cfgInputDto == null) {
					cfgInputDto = this.populateDto(recoveryBPMfwkTipoProcInput);
				} else {
					throw new RecoveryBPMfwkError(ProblemasConocidos.CONFIGURACION_AMBIGUA, 
							"Existe más de una línea de configuración para el tipo de input '" + codigoTipoInput + 
								"' y el nodo '" + codigoNodo + "'");
				}
			}
		}
		
		if (cfgInputDto == null) {
			throw new RecoveryBPMfwkError(ProblemasConocidos.CONFIGURACION_ERRONEA, 
					"No existe configuración para el tipo de input '" + codigoTipoInput + 
						"' y el nodo '" + codigoNodo + "'");
		}
		
		return cfgInputDto;
	}
	
	/**
     * Obtiene de la BBDD la lista de configuraciones de un tipo de input y tipo de procedimiento
     * 
     * @param codigoTipoInput
     * @param codigoTipoProcedimiento
     * @return
     */
    private List<RecoveryBPMfwkTipoProcInput> getListaTipoProcInput(final String codigoTipoInput, final String codigoTipoProcedimiento) {
    	
    	Assertions.assertNotNull(codigoTipoInput, "El código de tipo de input no se puede pasar nulo");
    	Assertions.assertNotNull(codigoTipoProcedimiento, "El código de tipo de procedimiento no se puede pasar nulo");
    	
        final Filter f1 = genericDao.createFilter(FilterType.EQUALS, "tipoInput.codigo", codigoTipoInput);
        final Filter f2 = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimiento.codigo", codigoTipoProcedimiento);
        return genericDao.getList(RecoveryBPMfwkTipoProcInput.class, f1, f2);
    }
    
    /**
     * Comprueba la validez del tipo de nodo para la configuración input-procedimiento
     * @param codigoNodo
     * @param tipoProcInput
     * @return boolean
     */
	private boolean compruebaValidezTipoInputParaNodo(String codigoNodo,
			RecoveryBPMfwkTipoProcInput tipoProcInput) {

		if (tipoProcInput == null)
			return false;
//		String nodosIncluidos = tipoProcInput.getNodesIncluded();
//		String nodosExcluidos = tipoProcInput.getNodesExcluded();
//		boolean resultado = false;
//
//		if (nodosIncluidos == null || nodosExcluidos == null)
//			return false;
//		if (nodosIncluidos.indexOf(codigoNodo) >= 0) {
//			resultado = true;
//		} else if ((nodosIncluidos.indexOf("ALL") >= 0)
//				&& (nodosExcluidos.indexOf(codigoNodo) < 0)) {
//			resultado = true;
//		}

		return tipoProcInput.contieneElNodo(codigoNodo);
	}

//    /**
//     * Obtiene de la BBDD la configuración de un tipo de input
//     * 
//     * @param codigoTipoInput
//     * @param codigoTipoProcedimiento
//     * @return
//     */
//	@Deprecated
//    private RecoveryBPMfwkTipoProcInput getTipoProcInput(final String codigoTipoInput, final String codigoTipoProcedimiento) {
//    	
//    	Assertions.assertNotNull(codigoTipoInput, "El código de tipo de input no se puede pasar nulo");
//    	Assertions.assertNotNull(codigoTipoProcedimiento, "El código de tipo de procedimiento no se puede pasar nulo");
//    	
//        final Filter f1 = genericDao.createFilter(FilterType.EQUALS, "tipoInput.codigo", codigoTipoInput);
//        final Filter f2 = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimiento.codigo", codigoTipoProcedimiento);
//        return genericDao.get(RecoveryBPMfwkTipoProcInput.class, f1, f2);
//    }
    
    /**
     * Rellena la información contenida en un dto del api de configuración en función de la información recuperada
     * de la base de datos.
     * 
     * @param configTipoProcInput
     * @return si el objeto de entrada es nulo devuelve null. En caso contrario, devuleve un dto.
     */
    private RecoveryBPMfwkCfgInputDto populateDto(final RecoveryBPMfwkTipoProcInput configTipoProcInput) {
    	
    	if (configTipoProcInput == null) return null;
    	RecoveryBPMfwkCfgInputDto cfgInputDto = new RecoveryBPMfwkCfgInputDto();
    	
    	if(configTipoProcInput.getTipoProcedimiento() != null)
    		cfgInputDto.setCodigoTipoProcedimiento(configTipoProcInput.getTipoProcedimiento().getCodigo());
    	if(configTipoProcInput.getTipoInput() != null){
    		cfgInputDto.setCodigoTipoInput(configTipoProcInput.getTipoInput().getCodigo());
    		if(configTipoProcInput.getTipoAccion() != null)
    			cfgInputDto.setCodigoTipoAccion(configTipoProcInput.getTipoAccion().getCodigo());
    	}

    	if (RecoveryBPMfwkTipoProcInput.ALL_INCLUDED.equals(configTipoProcInput.getNodesIncluded())){
    		cfgInputDto.setDefaultNodesIncluded(true);
    	}else{
    		cfgInputDto.setDefaultNodesIncluded(false);
    	}
   		cfgInputDto.setNodesExcluded(configTipoProcInput.getNodesExcludedAsArray());
   		cfgInputDto.setNodesIncluded(configTipoProcInput.getNodesIncludedAsArray());
    	
    	cfgInputDto.setNombreTransicion(configTipoProcInput.getNombreTransicion());
    	
    	if(configTipoProcInput.getPlantilla() != null){
    		cfgInputDto.setCodigoPlantilla(configTipoProcInput.getPlantilla().getCodigo());
    	}
    	
   		cfgInputDto.setPreProcessBo(configTipoProcInput.getPreProcessBo());
   		cfgInputDto.setPostProcessBo(configTipoProcInput.getPostProcessBo());
    	
    	cfgInputDto.setConfigDatos(configTipoProcInput.getInputDatosAsCfgInputDtoMap());
    	
    	return cfgInputDto;
	}

}
