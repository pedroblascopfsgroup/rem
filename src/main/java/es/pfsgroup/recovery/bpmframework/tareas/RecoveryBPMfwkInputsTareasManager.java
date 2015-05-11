package es.pfsgroup.recovery.bpmframework.tareas;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputApi;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.tareas.model.RecoveryBPMfwkInputsTareas;

@Service
@Transactional(readOnly = false)
public class RecoveryBPMfwkInputsTareasManager implements
		RecoveryBPMfwkInputsTareasApi {

	@Autowired
	GenericABMDao genericDao;
	
	@Autowired
	ApiProxyFactory proxyFactory;
	
	@Override
	@BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_SAVE_INPUT_TAREAS)
	public RecoveryBPMfwkInputsTareas save(Long idInput, Long idTarea) {

		RecoveryBPMfwkInputsTareas inputsTareas = new RecoveryBPMfwkInputsTareas();
		
		inputsTareas.setInput(proxyFactory.proxy(RecoveryBPMfwkInputApi.class).get(idInput));
		inputsTareas.setTarea(proxyFactory.proxy(TareaExternaApi.class).get(idTarea));
		
		return genericDao.save(RecoveryBPMfwkInputsTareas.class, inputsTareas);
		
	}
	
	@Override
	@BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_GET_INPUTS_BY_TAREA)
	public List<RecoveryBPMfwkInput> getInputsByTarea(Long idTarea) {
		
		List<RecoveryBPMfwkInput> inputs = new ArrayList<RecoveryBPMfwkInput>();
		
		TareaExterna tareaExterna = proxyFactory.proxy(TareaExternaApi.class).get(idTarea);
		if (!Checks.esNulo(tareaExterna)) {
			final Filter f = genericDao.createFilter(FilterType.EQUALS, "tarea", tareaExterna);
			List<RecoveryBPMfwkInputsTareas> inputsTareas = genericDao.getList(RecoveryBPMfwkInputsTareas.class, f);
			for (RecoveryBPMfwkInputsTareas inputTarea : inputsTareas) {
				inputs.add(inputTarea.getInput());
			}
		}
		return inputs;
	}

	
}
