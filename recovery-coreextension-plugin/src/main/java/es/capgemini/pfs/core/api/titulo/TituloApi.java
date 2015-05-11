package es.capgemini.pfs.core.api.titulo;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.titulo.dto.DtoTitulo;
import es.capgemini.pfs.titulo.model.Titulo;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.ext.impl.titulo.dto.EXTDtoTitulo;

public interface TituloApi {
	
	static final String CORE_BO_GETDTOTITULO="plugin.coreextension.exttituloManager.getExtDto";
	
	@BusinessOperationDefinition(PrimariaBusinessOperation.BO_TITULO_MGR_SAVE_TITULO_DTO)
    @Transactional(readOnly = false)
    public void saveTitulo(DtoTitulo dto) ;
	
	@BusinessOperationDefinition(PrimariaBusinessOperation.BO_TITULO_MGR_GET_TITULO)
    public Titulo getTitulo(Long idTitulo);
	
	 /**
     * Crea y retorna el dto para un titulo si existe o vacio si ser� nuevo.
     * @param idContrato long
     * @param idTitulo long
     * @return DtoTitulo
     */
    @BusinessOperationDefinition(CORE_BO_GETDTOTITULO)
    public EXTDtoTitulo getExtDto(Long idContrato, Long idTitulo);

}
