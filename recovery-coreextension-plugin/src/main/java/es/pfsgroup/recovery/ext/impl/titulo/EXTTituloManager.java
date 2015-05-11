package es.pfsgroup.recovery.ext.impl.titulo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.titulo.TituloApi;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.titulo.dto.DtoTitulo;
import es.capgemini.pfs.titulo.model.DDSituacion;
import es.capgemini.pfs.titulo.model.DDTipoTitulo;
import es.capgemini.pfs.titulo.model.Titulo;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.ext.impl.titulo.dto.EXTDtoTitulo;
import es.pfsgroup.recovery.ext.impl.titulo.model.EXTTitulo;

@Component
public class EXTTituloManager extends BusinessOperationOverrider<TituloApi> implements TituloApi{

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Override
	public String managerName() {
		return "tituloManager";
	}
	
	@Override
	@BusinessOperation(overrides=PrimariaBusinessOperation.BO_TITULO_MGR_SAVE_TITULO_DTO)
	@Transactional(readOnly=false)
	public void saveTitulo(DtoTitulo dto) {
		if (dto instanceof EXTDtoTitulo){
			EXTDtoTitulo extDto=(EXTDtoTitulo) dto;
			Titulo titulo ;
			
	        if (Checks.esNulo(extDto.getTitulo())) {
	            titulo = new EXTTitulo();
	            titulo.setContrato(extDto.getContrato());
	        }else{
	        	if (extDto.getTitulo() instanceof EXTTitulo){
	        	titulo= genericDao.get(EXTTitulo.class, genericDao.createFilter(FilterType.EQUALS, "id", extDto.getTitulo().getId()));
	        	}else {
	        		titulo=extDto.getTitulo();
	        		parent().saveTitulo(dto);
	        	}
	        }

	        DDTipoTitulo tipoTitulo = (DDTipoTitulo)executor.execute(
	        		ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
	        		DDTipoTitulo.class,
	        		extDto.getCodigoTipo());
	        titulo.setTipoTitulo(tipoTitulo);
	        DDSituacion situacion = (DDSituacion)executor.execute(
	        		ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
	        		DDSituacion.class,
	        		extDto.getCodigoSituacion());
	        titulo.setSituacion(situacion);
	        titulo.setIntervenido(extDto.getIntervenido());
	        titulo.setComentario(extDto.getComentario());
	        if (titulo instanceof EXTTitulo){
	        	((EXTTitulo) titulo).setNombreNotario(extDto.getNombreNotario());
		        ((EXTTitulo) titulo).setCalleNotario(extDto.getCalleNotario());
		        ((EXTTitulo) titulo).setCodigoPostalNotario(extDto.getCodigoPostal());
		        ((EXTTitulo) titulo).setNumeroNotario(extDto.getNumeroNotario());
		        ((EXTTitulo) titulo).setLocalidadNotario(extDto.getLocalidad());
		        ((EXTTitulo) titulo).setProvinciaNotario(extDto.getProvincia());
		        ((EXTTitulo) titulo).setTelefono1Notario(extDto.getTelefono1());
		        ((EXTTitulo) titulo).setTelefono2Notario(extDto.getTelefono2());
		        genericDao.save(EXTTitulo.class, (EXTTitulo)titulo);
	        }
	        else{
	        	genericDao.save(Titulo.class, titulo);
	        }
	        
		}else{
		parent().saveTitulo(dto);
		}
		
	}

	@Override
	@BusinessOperation(CORE_BO_GETDTOTITULO)
	public EXTDtoTitulo getExtDto(Long idContrato, Long idTitulo) {
		EXTDtoTitulo dto = new EXTDtoTitulo();
        // Si el id es -1 significa que se quiere crear un titulo
        if (idTitulo != -1) {
            dto.setTitulo((proxyFactory.proxy(TituloApi.class).getTitulo(idTitulo)));
        }
        Contrato contrato = (Contrato)executor.execute(
        		PrimariaBusinessOperation.BO_CNT_MGR_GET,
        		idContrato);
        dto.setContrato(contrato);
        return dto;
	}

	@Override
	public Titulo getTitulo(Long idTitulo) {
		// TODO Auto-generated method stub
		return null;
	}

}
