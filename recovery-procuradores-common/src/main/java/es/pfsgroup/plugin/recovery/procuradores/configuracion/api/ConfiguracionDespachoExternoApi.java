package es.pfsgroup.plugin.recovery.procuradores.configuracion.api;

import java.util.List;

import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categorizacion;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.dto.ConfiguracionDespachoExternoDto;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.model.ConfiguracionDespachoExterno;

public interface ConfiguracionDespachoExternoApi {

	
	public static final String PLUGIN_PROCURADORES_GET_CATEGORIZACION_TAREAS = "es.pfsgroup.plugin.recovery.procuradores.configuracion.api.getCategorizacionTareas";
	public static final String PLUGIN_PROCURADORES_GET_CATEGORIZACION_RESOLUCIONES = "es.pfsgroup.plugin.recovery.procuradores.configuracion.api.getCategorizacionResoluciones";
	public static final String PLUGIN_PROCURADORES_IS_DESPACHO_INTEGRAL = "es.pfsgroup.plugin.recovery.procuradores.configuracion.api.isDespachoIntegral";
	public static final String PLUGIN_PROCURADORES_GET_CONFIGURACION_DESPACHO_EXTERNO = "es.pfsgroup.plugin.recovery.procuradores.configuracion.api.getConfiguracion";
	public static final String PLUGIN_PROCURADORES_GUARDAR_CONFIGURACION_DESPACHO_EXTERNO = "es.pfsgroup.plugin.recovery.procuradores.configuracion.api.guardarConfiguracion";
	public static final String PLUGIN_PROCURADORES_BUSCA_DESPACHOS_POR_USUARIO = "es.pfsgroup.plugin.recovery.procuradores.configuracion.api.buscaDespachosPorUsuarioYTipo";
	public static final String PLUGIN_PROCURADORES_ACTIVO_DESPACHO_INTEGRAL = "es.pfsgroup.plugin.recovery.procuradores.configuracion.api.activoDespachoIntegral";
	public static final String PLUGIN_PROCURADORES_ACTIVO_CATEGORIZACION = "es.pfsgroup.plugin.recovery.procuradores.configuracion.api.activoCategorizacion";
	
	/**
	 * Obtiene una {@link Categorizacion} por idDespacho.
	 * @param idDespacho identificador del {@link DespachoExterno}.
	 * @return {@link Categorizacion}
	 */
	@BusinessOperationDefinition(ConfiguracionDespachoExternoApi.PLUGIN_PROCURADORES_GET_CATEGORIZACION_TAREAS)
	public Categorizacion getCategorizacionTareas(Long idDespacho);
	
	/**
	 * Obtiene una {@link Categorizacion} por idDespacho.
	 * @param idDespacho identificador del {@link DespachoExterno}.
	 * @return {@link Categorizacion}
	 */
	@BusinessOperationDefinition(ConfiguracionDespachoExternoApi.PLUGIN_PROCURADORES_GET_CATEGORIZACION_RESOLUCIONES)
	public Categorizacion getCategorizacionResoluciones(Long idDespacho);
	
	/**
	 * Devuelve True si el despacho está configurado como Despacho Integral.
	 * @param idDespacho identificador del {@link DespachoExterno}.
	 * @return true o false
	 */
	@BusinessOperationDefinition(ConfiguracionDespachoExternoApi.PLUGIN_PROCURADORES_IS_DESPACHO_INTEGRAL)
	public Boolean isDespachoIntegral(Long idDespacho);
	
	/**
	 * Obtiene una {@link ConfiguracionDespachoExterno} por idDespacho.
	 * @param idDespacho identificador del {@link DespachoExterno}.
	 * @return {@link ConfiguracionDespachoExterno}
	 */
	@BusinessOperationDefinition(ConfiguracionDespachoExternoApi.PLUGIN_PROCURADORES_GET_CONFIGURACION_DESPACHO_EXTERNO)
	public ConfiguracionDespachoExterno getConfiguracion(Long idDespacho);
	
	/**
	 *Guarda una {@link ConfiguracionDespachoExterno} por idDespacho.
	 * @param Dto de la configuracion {@link ConfiguracionDespachoExternoDto}.
	 * @return {@link ConfiguracionDespachoExterno}
	 */
	@BusinessOperationDefinition(ConfiguracionDespachoExternoApi.PLUGIN_PROCURADORES_GUARDAR_CONFIGURACION_DESPACHO_EXTERNO)
	public ConfiguracionDespachoExterno guardarConfiguracion(ConfiguracionDespachoExternoDto configuracionDespachoExternoDto);
	
    /**
     * Devuelve los despachos de un usuario y tipo
     * @param idUsuario
     * @param ddTipoDespachoExterno Constante de DDTipoDespachoExterno
     * @return
     */
	@BusinessOperationDefinition(ConfiguracionDespachoExternoApi.PLUGIN_PROCURADORES_BUSCA_DESPACHOS_POR_USUARIO)
    public List<GestorDespacho> buscaDespachosPorUsuarioYTipo(Long idUsuario, String ddTipoDespachoExterno);
	
	
	/**
	 * Devuelve true si el usuario está configurado con despacho integral
	 * @return true o false
	 */
	@BusinessOperationDefinition(ConfiguracionDespachoExternoApi.PLUGIN_PROCURADORES_ACTIVO_DESPACHO_INTEGRAL)
	public Boolean activoDespachoIntegral();
	
	
	/**
	 * Devuelve la categorización del despacho del usuario logado.
	 * @return
	 */
	@BusinessOperationDefinition(ConfiguracionDespachoExternoApi.PLUGIN_PROCURADORES_ACTIVO_CATEGORIZACION)
	public Long activoCategorizacion();
}


