package es.pfsgroup.recovery.haya.integration.bpm.consumer;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.concursal.convenio.ConvenioManager;
import es.pfsgroup.concursal.convenio.dto.DtoAgregarConvenio;
import es.pfsgroup.concursal.convenio.dto.DtoEditarConvenioCredito;
import es.pfsgroup.concursal.convenio.model.Convenio;
import es.pfsgroup.concursal.convenio.model.ConvenioCredito;
import es.pfsgroup.concursal.credito.manager.CreditoManager;
import es.pfsgroup.concursal.credito.model.Credito;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;
import es.pfsgroup.recovery.haya.integration.bpm.ConvenioCreditoPayload;
import es.pfsgroup.recovery.haya.integration.bpm.ConvenioPayload;
import es.pfsgroup.recovery.integration.ConsumerAction;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.Rule;

public class ConvenioConsumer extends ConsumerAction<DataContainerPayload> {
	
	public ConvenioConsumer(Rule<DataContainerPayload> rules) {
		super(rules);
	}
	
	public ConvenioConsumer(List<Rule<DataContainerPayload>> rules) {
		super(rules);
	}

	@Autowired
	private EXTProcedimientoManager extProcedimientoManager;
	
	@Autowired
	private ConvenioManager convenioManager;
	
	@Autowired
	private CreditoManager creditoManager;

	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	private DtoAgregarConvenio load(ConvenioPayload convenioPayload) 
	{
		String convenioGuid = convenioPayload.getGuid();
		if (Checks.esNulo(convenioGuid)) {
			throw new IntegrationDataException("[INTEGRACION] No se puede procesar convenio, no tiene guid");
		}

		// Se comprueba si existe antes de crear uno nuevo
		Convenio convenio = convenioManager.getConvenioByGuid(convenioGuid);
		DtoAgregarConvenio convenioDto = new DtoAgregarConvenio();
		if (convenio == null) {
			convenioDto.setGuid(convenioGuid);
		
			String procGuid = convenioPayload.getGuidProcedimiento();
			MEJProcedimiento prc = extProcedimientoManager.getProcedimientoByGuid(procGuid);
			if (prc == null) {
				throw new IntegrationDataException(String.format("[INTEGRACION] El procedimiento con guid %s asociado al recurso s no existe", procGuid)); 
			}
			
			convenioDto.setIdProcedimiento(prc.getId());
		} 
		else {
			convenioDto.setIdConvenio(convenio.getId());
			convenioDto.setIdProcedimiento(convenio.getProcedimiento().getId());
		}
	
		convenioDto.setFecha(DateFormat.toString(convenioPayload.getFecha()));
		convenioDto.setNumeroProponentes(convenioPayload.getNumProponentes());
		convenioDto.setTotalMasa(convenioPayload.getTotalMasa());
		convenioDto.setPorcentaje(convenioPayload.getPorcentaje());
		
		if (convenioPayload.getAdherirse() != null) {
			convenioDto.setAdherirse(Long.valueOf(convenioPayload.getAdherirse()));
		}
		
		if (convenioPayload.getTipoConvenio() != null) {
			convenioDto.setTipo(Long.valueOf(convenioPayload.getTipoConvenio()));
		}
		
		if (convenioPayload.getInicioConvenio() != null) {
			convenioDto.setInicio(Long.valueOf(convenioPayload.getInicioConvenio()));
		}
		
		if (convenioPayload.getEstadoConvenio() != null) {
			convenioDto.setEstado(Long.valueOf(convenioPayload.getEstadoConvenio()));
		}

		if (convenioPayload.getPosturaConvenio() != null) {
			convenioDto.setPostura(Long.valueOf(convenioPayload.getPosturaConvenio()));
		}

		convenioDto.setDescripcion(convenioPayload.getDescripcion());
		convenioDto.setDescripcionTerceros(convenioPayload.getDescripcionTerceros());
		convenioDto.setDescripcionAnticipado(convenioPayload.getDescripcionAnticipado());
		convenioDto.setDescripcionAdhesiones(convenioPayload.getDescripcionAdhesiones());

		if (convenioPayload.getTipoAlternativa() != null) {
			convenioDto.setAlternativa(Long.valueOf(convenioPayload.getTipoAlternativa()));
		}

		if (convenioPayload.getTipoAdhesion() != null) {
			convenioDto.setTipoAdhesion(Long.valueOf(convenioPayload.getTipoAdhesion()));
		}

		convenioDto.setDescripcionConvenio(convenioPayload.getDescripcionConvenio());
		convenioDto.setTotalMasaOrd(convenioPayload.getTotalMasaOrd());
		convenioDto.setPorcentajeOrd(convenioPayload.getPorcentajeOrd());
		
		return convenioDto;
	}	

	
	private DtoEditarConvenioCredito loadConvenioCredito(ConvenioCreditoPayload convenioCreditoPayload) 
	{
		String convenioCreditoGuid = convenioCreditoPayload.getGuid();
		if (Checks.esNulo(convenioCreditoGuid)) {
			throw new IntegrationDataException("[INTEGRACION] No se puede procesar convenio, un crédito no tiene GUID");
		}
		
		ConvenioCredito convenioCredito = convenioManager.getConvenioCreditoByGuid(convenioCreditoGuid);
		DtoEditarConvenioCredito convenioCreditoDto = new DtoEditarConvenioCredito();
		if (convenioCredito == null) {
			convenioCreditoDto.setGuid(convenioCreditoGuid);
		} 
		else {
			convenioCreditoDto.setIdConvenioCredito(convenioCredito.getId());
		}
		
		String creditoGuid = convenioCreditoPayload.getGuidCredito();
		Credito credito = creditoManager.getCreditoByGuid(creditoGuid);
		if (credito == null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El crédito con guid %s asociado al recurso s no existe", creditoGuid)); 
		}
		
		convenioCreditoDto.setCredito(credito);
		convenioCreditoDto.setQuita(convenioCreditoPayload.getQuita());
		convenioCreditoDto.setEspera(convenioCreditoPayload.getEspera());
		convenioCreditoDto.setCarencia(convenioCreditoPayload.getCarencia());
		convenioCreditoDto.setComentario(convenioCreditoPayload.getComentario());
		
		return convenioCreditoDto;		
	}
		
	@Override
	protected void doAction(DataContainerPayload payLoad) {
		ConvenioPayload convenioPayload = new ConvenioPayload(payLoad);
		
		// Si existe el convenio se edita o se borra
		Convenio convenio = convenioManager.getConvenioByGuid(convenioPayload.getGuid());
		if(convenio != null) {
			
			if(convenioPayload.isBorrado()) {
				convenioManager.borrarConvenio(convenio.getId());
			}
			else {
				DtoAgregarConvenio convenioDto = load(convenioPayload);
						
				convenioManager.editarConvenio(convenioDto);
				
				if(convenioPayload.getConvenioCreditos() != null) {
					for(ConvenioCreditoPayload convenioCreditoPayload: convenioPayload.getConvenioCreditos()) {
						DtoEditarConvenioCredito convenioCreditoDto = loadConvenioCredito(convenioCreditoPayload);
						convenioManager.editarConvenioCredito(convenioCreditoDto);
					}
				}
			}
		}
		// Si no existe se inserta
		else {
			DtoAgregarConvenio convenioDto = load(convenioPayload);
			
			List<DtoEditarConvenioCredito> convenioCreditosDto = new ArrayList<DtoEditarConvenioCredito>();
			if(convenioPayload.getConvenioCreditos() != null) {
				for(ConvenioCreditoPayload convenioCreditoPayload: convenioPayload.getConvenioCreditos()) {
					DtoEditarConvenioCredito convenioCreditoDto = loadConvenioCredito(convenioCreditoPayload);
					convenioCreditosDto.add(convenioCreditoDto);
				}
			}
			
			convenioManager.guardarConvenio(convenioDto, convenioCreditosDto);
		}
	}
}
