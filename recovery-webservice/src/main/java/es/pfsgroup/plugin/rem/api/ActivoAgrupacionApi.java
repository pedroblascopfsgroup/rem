package es.pfsgroup.plugin.rem.api;

import java.util.List;
import java.util.Map;

import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.AgrupacionesVigencias;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesCreateDelete;
import es.pfsgroup.plugin.rem.model.DtoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.DtoCondicionEspecificaAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoEstadoDisponibilidadComercial;
import es.pfsgroup.plugin.rem.model.DtoSubdivisiones;
import es.pfsgroup.plugin.rem.model.DtoVigenciaAgrupacion;
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
    
    public String uploadFoto(File fileItem) throws Exception;
    
    @BusinessOperationDefinition("activoAgrupacionManager.getFotosActivosAgrupacionById")
    public List<ActivoFoto> getFotosActivosAgrupacionById(Long id);

    @BusinessOperationDefinition("activoAgrupacionManager.uploadFotoSubdivision")
	String uploadFotoSubdivision(WebFileItem fileItem);
    
    public String uploadFotoSubdivision(File fileItem) throws Exception;

	public boolean createAgrupacion(DtoAgrupacionesCreateDelete dtoAgrupacion);

/*    @BusinessOperationDefinition("activoAgrupacionManager.deleteActivoPrincipalByIdActivoAgrupacionActivo")
	void deleteActivoPrincipalByIdActivoAgrupacionActivo(Long id);*/
	
	public Long getNextNumAgrupacionRemManual();
	
	public Page getListSubdivisionesAgrupacionById(DtoAgrupacionFilter agrupacionFilter);
	
	public Page getListActivosSubdivisionById(DtoSubdivisiones subdivision);

	public List<ActivoFoto> getFotosSubdivision(DtoSubdivisiones subdivision);

	public List<ActivoFoto> getFotosAgrupacionById(Long id);
	
	/**
	 * Asignacion de valores (tasacion y sino, Aprobado venta) por activo, y el total de todos ellos
	 * @param activos lista de ActivoAgrupacionActivo a calcular el valor
	 * @return Map<String,Double> mapa con el valor de tasación/aprobado venta de cada activo. 
	 * El total es null si alguno de los activos no tienen el valor de tasación/aprobado venta
	 */
	public Map<String,Double> asignarValoresTasacionAprobadoVenta(List<ActivoAgrupacionActivo> activos) throws Exception;
	
	/**
	 * Devuelve el porcentaje correspondiente según el valor por activo
	 * @param activo
	 * @param valores
	 * @param total
	 * @return Float porcentaje correspondiente de un activo
	 */
	public Float asignarPorcentajeParticipacionEntreActivos(ActivoAgrupacionActivo activo, Map<String,Double> valores, Double total) throws Exception;
	
	/**
	 * Descongela las ofertas congeladas de los activos pertenecientes a la agrupación
	 * 
	 * @param agrupacion
	 * @return
	 */
	public boolean descongelarOfertasActivoAgrupacion(ActivoAgrupacion agrupacion) throws Exception;
	
	/**
	 * Devuelve el historico de vigencias de la agrupacion
	 * @param agrupacionFilter
	 * @return
	 */
	public  List<AgrupacionesVigencias> getHistoricoVigenciaAgrupaciones(DtoVigenciaAgrupacion agrupacionFilter);
	
	/**
	 * 
	 * @param activo
	 * @param agrupacion
	 * @return
	 */
	public Boolean estaActivoEnOtraAgrupacionVigente(ActivoAgrupacion agrupacion,Activo activo);
	
	/**
	 * 
	 * @param dto
	 * @param usuarioLogado
	 * @return
	 */
	DtoEstadoDisponibilidadComercial getListActivosAgrupacionByIdActivo(DtoAgrupacionFilter dto, Usuario usuarioLogado);
	
	List<DtoCondicionEspecifica> getCondicionEspecificaByAgrupacion(Long id);
	
	Boolean createCondicionEspecifica(DtoCondicionEspecificaAgrupacion dto);
	
	Boolean saveCondicionEspecifica(DtoCondicionEspecificaAgrupacion dto);
	
	Boolean darDeBajaCondicionEspecifica(DtoCondicionEspecificaAgrupacion dto);

	public Usuario getGestorComercialAgrupacion(List<Long> numActivos);
	
	public Boolean arrayComparer(Long idAgr, List<Long> agrupaciones);
	
	/**
	 * Cuenta el numero de activos afecto Gencat que estan presentes en una agrupacion
	 * @param agrupacion
	 * @return int n de activos
	 */
	public int countActivosAfectoGENCAT(ActivoAgrupacion agrupacion);
}