package es.pfsgroup.recovery.bpmframework.input;

import java.util.HashSet;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDDTipoInput;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDatoInput;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.util.RecoveryBPMfwkUtils;

@Component
public class RecoveryBPMfwkInputManager implements RecoveryBPMfwkInputApi {

    @Autowired
    private transient GenericABMDao genericDao;

    /*
     * (non-Javadoc)
     * 
     * @see
     * es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputApi#saveInput
     * (es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto)
     */
    @BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_SAVE_INPUT)
    @Override
    public RecoveryBPMfwkInput saveInput(final RecoveryBPMfwkInputDto dto) throws RecoveryBPMfwkError {
        
    	this.validaDto(dto);
    	
        final RecoveryBPMfwkInput input = new RecoveryBPMfwkInput();
        input.setIdProcedimiento(dto.getIdProcedimiento());
        input.setTipo(getTipoInput(dto.getCodigoTipoInput()));
        if (!Checks.esNulo(dto.getAdjunto())) {
            input.setAdjunto(dto.getAdjunto());
        }
        
        RecoveryBPMfwkInput inputGuardado = genericDao.save(RecoveryBPMfwkInput.class, input);
        
        input.setDatosPersistidos(creaYguardaDatosInput(dto.getDatos(), inputGuardado));
        
        return inputGuardado;
    }

    /**
     * A partir de un Map de datos que viene en el DTO, genera un Set de datos asociados a un input y los va persistiendo
     * 
     * @param datos
     * @param input
     * @return
     * @throws RecoveryBPMfwkError 
     */
    private Set<RecoveryBPMfwkDatoInput> creaYguardaDatosInput(final Map<String, Object> datos, final RecoveryBPMfwkInput input) throws RecoveryBPMfwkError {
    	RecoveryBPMfwkUtils.isNotNull(input, "El input no se puede pasar nulo");
        if (Checks.esNulo(input.getId())){
            throw new RecoveryBPMfwkError(RecoveryBPMfwkError.ProblemasConocidos.ARGUMENTOS_INCORRECTOS
            		, "Error de persistencia de datos."
            		, new IllegalStateException("No se ha persistido a�n el input"));
        }
        final HashSet<RecoveryBPMfwkDatoInput> set = new HashSet<RecoveryBPMfwkDatoInput>();
        if (!Checks.esNulo(datos)) {
            RecoveryBPMfwkDatoInput datoInput;
            for (Entry<String, Object> e : datos.entrySet()) {
                datoInput = new RecoveryBPMfwkDatoInput();
                datoInput.setInput(input);
                datoInput.setNombre(e.getKey());
                if (e.getValue() != null)
                	datoInput.setValor(e.getValue().toString());
                set.add(datoInput);
                genericDao.save(RecoveryBPMfwkDatoInput.class, datoInput);
            }
        }
        return set;
    }

    /**
     * Obtiene de la BBDD el tipo de input en base a un c�digo
     * 
     * @param codigoTipoInput
     * @return
     */
    private RecoveryBPMfwkDDTipoInput getTipoInput(final String codigoTipoInput) {
        final Filter f = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipoInput);
        return genericDao.get(RecoveryBPMfwkDDTipoInput.class, f);
    }

    /**
     * Comprueba que el DTO no sea nulo y que venga con la informaci�n m�nima
     * necesaria y, en caso contrario, lanza una IllegalArgumentException
     * 
     * @param dto
     * @throws RecoveryBPMfwkError 
     */
    private void validaDto(final RecoveryBPMfwkInputDto dto) throws RecoveryBPMfwkError {
        RecoveryBPMfwkUtils.isNotNull(dto, "El DTO no puede ser NULL");
        RecoveryBPMfwkUtils.isNotNull(dto.getIdProcedimiento(), "El tipo de procedimiento no puede ser NULL");
        RecoveryBPMfwkUtils.isNotNull(dto.getCodigoTipoInput(), "El C�digo de tipo de input no puede ser NULL");
    }
    
    /**
     * Obtiene de la BBDD el input
     * 
     * @param codigoTipoInput
     * @return
     */
    @BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_GET_INPUT)
    @Override
    public RecoveryBPMfwkInput get(Long idInput) {
        final Filter f = genericDao.createFilter(FilterType.EQUALS, "id", idInput);
        return genericDao.get(RecoveryBPMfwkInput.class, f);
    }

}
