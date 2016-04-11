package es.pfsgroup.plugin.recovery.mejoras.acuerdos.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.EXTAsuntoManager;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.core.api.expediente.EXTExpedientesApi;
import es.capgemini.pfs.expediente.EXTExpedientesManager;
import es.capgemini.pfs.expediente.model.Expediente;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.api.AsuntoAcuerdoApi;
import es.pfsgroup.recovery.api.ExpedienteApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

@Component
public class AsuntoAcuerdoManager extends BusinessOperationOverrider<AsuntoAcuerdoApi> implements AsuntoAcuerdoApi{

	@Autowired
	private Executor executor;
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private EXTAsuntoManager extAsuntoManager;
	
	@Autowired
	private EXTExpedientesManager extExpedienteManager;
	
	@Autowired
	private EXTExpedientesApi extExpedientesApi;

	@Override
	public String managerName() {
		// TODO Auto-generated method stub
		return "AsuntoAcuerdoManager";
	}
	
	@BusinessOperation(BO_ASUNTO_ORIGEN)
	public Asunto asuntoOrigen(Long idAsunto) {
		EXTAsunto asunto = extAsuntoManager.getAsuntoById(idAsunto);
		if(!Checks.esNulo(asunto.getAsuOrigen())){
			Long idOrigen = asunto.getAsuOrigen().getId();
			if(!Checks.esNulo(idOrigen)){
				EXTAsunto asuntoOrigen = extAsuntoManager.getAsuntoById(idOrigen);
				return asuntoOrigen;
			}
		}
		return null;
	}
	
	@BusinessOperation(BO_EXPEDIENTE_ORIGEN)
	public Expediente expedienteOrigen(Long idAsunto) {
		EXTAsunto asunto = extAsuntoManager.getAsuntoById(idAsunto);
		if(!Checks.esNulo(asunto.getExpOrigen())){
			Long idOrigen = asunto.getExpOrigen().getId();
			if(!Checks.esNulo(idOrigen)){
				Expediente expediente = extExpedientesApi.getExpediente(idOrigen);
				return expediente;
			}
		}
		return null;
	}
	
	@BusinessOperation(BO_CORE_ASUNTO_ACUERDO)
	public Boolean esAsuntoAcuerdo(Long idAsunto) {
		EXTAsunto asunto = extAsuntoManager.getAsuntoById(idAsunto);
		if(!Checks.esNulo(asunto.getTipoAsunto())){
			String codigoAsunto = asunto.getTipoAsunto().getCodigo();
			if(!Checks.esNulo(codigoAsunto)){
				if(codigoAsunto.equals("ACU")){
					return true;
				}
			}
		}
		return false;
	}
}
