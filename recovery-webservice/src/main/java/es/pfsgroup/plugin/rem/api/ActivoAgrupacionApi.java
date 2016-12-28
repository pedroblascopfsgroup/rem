package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesCreateDelete;
import es.pfsgroup.plugin.rem.model.DtoSubdivisiones;
import es.pfsgroup.plugin.rem.rest.dto.File;

public interface ActivoAgrupacionApi {
	
	/**
     * Recupera la Agrupacion indicada.
     * @param id Long
     * @return Agrupacion
     */
    @BusinessOperationDefinition("activoAgrupacionManager.get")
    public ActivoAgrupacion get(Long id);

    @BusinessOperationDefinition("activoAgrupacionManager.getAgrupacionIdByNumAgrupRem")
    public Long getAgrupacionIdByNumAgrupRem(Long numAgrupRem);
    
    @BusinessOperationDefinition("activoAgrupacionManager.saveOrUpdate")
    public boolean saveOrUpdate(ActivoAgrupacion activoAgrupacion);
    
    @BusinessOperationDefinition("activoAgrupacionManager.deleteById")
    public boolean deleteById(Long id);
    
    
    @BusinessOperationDefinition("activoAgrupacionManager.getListAgrupaciones")
    public Page getListAgrupaciones(DtoAgrupacionFilter dto, Usuario usuarioLogado);
    
    @BusinessOperationDefinition("activoAgrupacionManager.getListActivosAgrupacionById")
    public Page getListActivosAgrupacionById(DtoAgrupacionFilter dto, Usuario usuarioLogado);
    
//    @BusinessOperationDefinition("activoAgrupacionManager.getNextNumAgrupacionRemManual")
//    private Long getNextNumAgrupacionRemManual();
    
    @BusinessOperationDefinition("activoAgrupacionManager.haveActivoPrincipal")
    public Long haveActivoPrincipal(Long id);
    
    @BusinessOperationDefinition("activoAgrupacionManager.haveActivoRestringidaAndObraNueva")
    public Long haveActivoRestringidaAndObraNueva(Long id);
    
    @BusinessOperationDefinition("activoAgrupacionManager.uploadFoto")
    public String uploadFoto(WebFileItem fileItem);
    
    public String uploadFoto(File fileItem);
    
    @BusinessOperationDefinition("activoAgrupacionManager.getFotosActivosAgrupacionById")
    public List<ActivoFoto> getFotosActivosAgrupacionById(Long id);

    @BusinessOperationDefinition("activoAgrupacionManager.uploadFotoSubdivision")
	String uploadFotoSubdivision(WebFileItem fileItem);
    
    public String uploadFotoSubdivision(File fileItem);

	public boolean createAgrupacion(DtoAgrupacionesCreateDelete dtoAgrupacion);

/*    @BusinessOperationDefinition("activoAgrupacionManager.deleteActivoPrincipalByIdActivoAgrupacionActivo")
	void deleteActivoPrincipalByIdActivoAgrupacionActivo(Long id);*/
	
	public Long getNextNumAgrupacionRemManual();
	
	public Page getListSubdivisionesAgrupacionById(DtoAgrupacionFilter agrupacionFilter);
	
	public Page getListActivosSubdivisionById(DtoSubdivisiones subdivision);

	public List<ActivoFoto> getFotosSubdivision(DtoSubdivisiones subdivision);

	public List<ActivoFoto> getFotosAgrupacionById(Long id);
		
}