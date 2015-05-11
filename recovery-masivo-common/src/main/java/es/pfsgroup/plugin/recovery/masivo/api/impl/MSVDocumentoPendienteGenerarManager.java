package es.pfsgroup.plugin.recovery.masivo.api.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.api.MSVDocumentoPendienteGenerarApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDocumentoPendienteDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.documentacionPendiente.MSVDocumentoPendienteGenerar;
import es.pfsgroup.procedimientos.recoveryapi.ProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDDTipoInput;

@Component
public class MSVDocumentoPendienteGenerarManager implements MSVDocumentoPendienteGenerarApi{

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Override
	@BusinessOperation(MSV_BO_ALTA_DOCUMENTO_PENDIENTE_PROCESAR)
	public MSVDocumentoPendienteGenerar crearNuevoDocumentoPendiente(
			MSVDocumentoPendienteDto dto) {
		MSVDocumentoPendienteGenerar documentoPte=new MSVDocumentoPendienteGenerar();
		Procedimiento p = getprocedimiento(dto.getIdProcedimiento());
		documentoPte.setProcedimiento(p);
		documentoPte.setAsunto(p.getAsunto());
		documentoPte.setNumeroCasoNova(dto.getNumeroCasoNova());
		documentoPte.setTipoInput(getTipoInput(dto.getCodigoTipoInput()));
		documentoPte.setRequieraMail(dto.getRequiereMail());
		documentoPte.setTipoProcedimiento(buscaTipoProcedimiento(dto.getCodigoTipoProcedimiento()));
		documentoPte.setEstadoProceso(buscaEstadoProceso(MSVDDEstadoProceso.CODIGO_PTE_PROCESAR));
		documentoPte.setToken(dto.getToken());
		
		@SuppressWarnings("unused")
		MSVDocumentoPendienteGenerar documento=genericDao.save(MSVDocumentoPendienteGenerar.class, documentoPte);
		
		return documentoPte;
	}

	@Override
	@BusinessOperation(MSV_BO_MODIFICAR_DOCUMENTO_PENDIENTE_PROCESAR)
	public void modificarDocumentoPendiente(MSVDocumentoPendienteDto dto) {
		MSVDocumentoPendienteGenerar documento;
		if (!Checks.esNulo(dto.getId())){
			documento=this.getDocumentoPendienteById(dto.getId());
		}else {
			if (!Checks.esNulo(dto.getToken())){
				documento=this.getDocumentoPendienteByToken(dto.getToken());
			}
			else {
				throw new BusinessOperationException("No puedo identificar el documento a modificar");
			}
		}
		if (!Checks.esNulo(documento)){
			if (!Checks.esNulo(dto.getCodigoEstado())){
				documento.setEstadoProceso(buscaEstadoProceso(dto.getCodigoEstado()));
			}
			genericDao.save(MSVDocumentoPendienteGenerar.class, documento);
		}
		
	}
	
	@Override
	@BusinessOperation(MSV_BO_GET_DOCUMENTO_PENDIENTE_PROCESAR_BY_ID)
	public MSVDocumentoPendienteGenerar getDocumentoPendienteById(Long id) {
		if (!Checks.esNulo(id)){
			return genericDao.get(MSVDocumentoPendienteGenerar.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
		} else {
			return null;
		}
	}


	@Override
	@BusinessOperation(MSV_BO_GET_DOCUMENTO_PENDIENTE_PROCESAR_BY_IDTOKEN)
	public MSVDocumentoPendienteGenerar getDocumentoPendienteByToken(
			Long idToken) {
		if (!Checks.esNulo(idToken)){
			return genericDao.get(MSVDocumentoPendienteGenerar.class, genericDao.createFilter(FilterType.EQUALS, "token", idToken));
		} else {
			return null;
		}
	}
	
	private RecoveryBPMfwkDDTipoInput getTipoInput(String codigoTipoInput) {
		if (!Checks.esNulo(codigoTipoInput)){
			RecoveryBPMfwkDDTipoInput tipoInput=genericDao.get(RecoveryBPMfwkDDTipoInput.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipoInput));
			if (!Checks.esNulo(tipoInput)){
				return tipoInput;
			}else {
				throw new BusinessOperationException("No se ha encontrado ningun tipo de input con ese código "+codigoTipoInput);
			}
		}else {
			throw new BusinessOperationException("No se puede crear un documento que no esté asociado a un tipo de input");
		}
	}

	private Procedimiento getprocedimiento(Long idProcedimiento) {
		if (!Checks.esNulo(idProcedimiento)){
			Procedimiento p= proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
			if (!Checks.esNulo(p)){
				return p;
			}else {
				throw new BusinessOperationException("No se ha encontrado ningún procedimiento con ese id "+idProcedimiento);
			}		
		}else {
			throw new BusinessOperationException("No se puede crear un documento que no esté asociado a un procedimeinto");
		}
	}
	
	private TipoProcedimiento buscaTipoProcedimiento(
			String codigoTipoProcedimiento) {
		if (!Checks.esNulo(codigoTipoProcedimiento)){
			TipoProcedimiento tipoProcedimento= genericDao.get(TipoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipoProcedimiento));
			if (!Checks.esNulo(tipoProcedimento)){
				return tipoProcedimento;
			}else {
				throw new BusinessOperationException("No se ha encontrado ningún tipo de procedimiento con este código "+codigoTipoProcedimiento);
			}		
		}else {
			throw new BusinessOperationException("No se puede crear un documento que no tenga un tipo de procedimiento asociado");
		}
	}

	private MSVDDEstadoProceso buscaEstadoProceso(String codigoPteProcesar) {
		if (!Checks.esNulo(codigoPteProcesar)){
			MSVDDEstadoProceso estado= genericDao.get(MSVDDEstadoProceso.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoPteProcesar));
			if (!Checks.esNulo(estado)){
				return estado;
			}else {
				throw new BusinessOperationException("No se ha encontrado ningún tipo estado de proceso con este codigo "+codigoPteProcesar);
			}		
		}else {
			throw new BusinessOperationException("No se puede crear un documento que no tenga un estado");
		}
	}


	


}
