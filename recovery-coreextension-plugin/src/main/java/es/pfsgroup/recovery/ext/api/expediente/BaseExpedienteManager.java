package es.pfsgroup.recovery.ext.api.expediente;

import es.capgemini.pfs.comite.model.DecisionComiteAutomatico;
import es.capgemini.pfs.exclusionexpedientecliente.model.ExclusionExpedienteCliente;
import es.capgemini.pfs.expediente.dto.DtoInclusionExclusionContratoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.pfsgroup.recovery.api.ExpedienteApi;

public abstract class BaseExpedienteManager implements ExpedienteApi {

	@Override
	public void excluirContratosAlExpediente(
			DtoInclusionExclusionContratoExpediente arg0) {
		// TODO Auto-generated method stub

	}

	@Override
	public ExclusionExpedienteCliente findExclusionExpedienteClienteByExpedienteId(
			Long arg0) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Expediente getExpediente(Long arg0) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void incluirContratosAlExpediente(
			DtoInclusionExclusionContratoExpediente arg0) {
		// TODO Auto-generated method stub

	}

	@Override
	public Long crearDatosParaDecisionComiteAutomatica(Long idExpediente,
			DecisionComiteAutomatico dca) {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override
	public void saveOrUpdate(Expediente arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void tomarDecisionComite(Long arg0, String arg1, boolean arg2,
			boolean arg3) {
		// TODO Auto-generated method stub
		
	}
	
	@Override
	public Expediente crearExpedienteAutomatico(Long arg0, Long arg1,
			Long arg2, Long arg3, Long arg4) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void setInstanteCambioEstadoExpediente(Long arg0) {
		// TODO Auto-generated method stub
		
	}
	
	@Override
	public void cambiarEstadoItinerarioExpediente(Long arg0, String arg1) {
		// TODO Auto-generated method stub
		
	}
	
	@Override
	public void calcularComiteExpediente(Long arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void congelarExpediente(Long arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void desCongelarExpediente(Long arg0) {
		// TODO Auto-generated method stub
		
	}

}
