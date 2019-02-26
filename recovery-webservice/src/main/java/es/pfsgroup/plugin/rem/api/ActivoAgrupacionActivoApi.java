package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;

public interface ActivoAgrupacionActivoApi {
	
	/**
     * Recupera ActivoAgrupacionActivo.
     * @param id Long
     * @return ActivoAgrupacionActivo
     */
    @BusinessOperationDefinition("activoAgrupacionActivoManager.get")
    public ActivoAgrupacionActivo get(Long id);
    
    @BusinessOperationDefinition("activoAgrupacionActivoManager.save")
    public Long save(ActivoAgrupacionActivo agrupacionActivo);
    
    @BusinessOperationDefinition("activoAgrupacionActivoManager.deleteByIdAgrupacion")
    public void delete(ActivoAgrupacionActivo agrupacionActivo);

    @BusinessOperationDefinition("activoAgrupacionActivoManager.getActivoAgrupacionActivoByIdActivoAndIdAgrupacion")
	public ActivoAgrupacionActivo getActivoAgrupacionActivoByIdActivoAndIdAgrupacion(long idActivo, long idAgrupacion);   
    
    @BusinessOperationDefinition("activoAgrupacionActivoManager.getByIdActivoAndIdAgrupacion")
	public ActivoAgrupacionActivo getByIdActivoAndIdAgrupacion(long idActivo, long idAgrupacion);
    
    @BusinessOperationDefinition("activoAgrupacionActivoManager.numActivosPorActivoAgrupacion") 
    public int numActivosPorActivoAgrupacion(long idAgrupacion);
    
    @BusinessOperationDefinition("activoAgrupacionActivoManager.primerActivoPorActivoAgrupacion") 
    public ActivoAgrupacionActivo primerActivoPorActivoAgrupacion(long idAgrupacion);
	
	public boolean isUniqueNewBuildingActive(Activo activo);

	public boolean isUniqueRestrictedActive(Activo activo);
	
	public boolean estaAgrupacionActivoConFechaBaja(Activo activo);

	public boolean isUniqueAgrupacionActivo(Activo activo, ActivoAgrupacion agrupacionActivo);
	
	/**
	 * Devuelve una lista de ActivoAgrupacionActivo aplicando el filtro que recibe.
	 * @param dtoAgrupActivo con los parametros de filtro
	 * @return List<ActivoAgrupacionActivo> 
	 */
	public List<ActivoAgrupacionActivo> getListActivosAgrupacion(DtoAgrupacionFilter dtoAgrupActivo);

	Boolean existenOfertasActivasEnAgrupacion(Long idAgrupacion);
	
	/**
	 * Devuelve la fila de la base de datos de ActivoAgrupacionActivo que contiene el activo principal de la agrupacion.
	 * @param idAgrupacion
	 * @return
	 */
	public ActivoAgrupacionActivo getActivoAgrupacionActivoPrincipalByIdAgrupacion(long idAgrupacion);

}