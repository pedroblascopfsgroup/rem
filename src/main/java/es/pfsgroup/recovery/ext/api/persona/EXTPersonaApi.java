package es.pfsgroup.recovery.ext.api.persona;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface EXTPersonaApi {

	public static final String EXT_BO_PER_MGR_OBTENER_CANTIDAD_VENCIDOS_USUARIO_CARTERIZADO = "es.pfsgroup.recovery.ext.api.persona.obtenerCantidadDeVencidosUsuarioCarterizado";
	public static final String EXT_BO_PER_MGR_OBTENER_CANTIDAD_SEG_SINTOMATICO_USUARIO = "es.pfsgroup.recovery.ext.api.persona.obtenerCantidadDeSeguimientoSintomaticoUsuarioCarterizado";
	public static final String EXT_BO_PER_MGR_OBTENER_CANTIDAD_SEG_SISTEMATICO_USUARIO = "es.pfsgroup.recovery.ext.api.persona.obtenerCantidadDeSeguimientoSistematicoUsuarioCarterizado";

	/**
     * obtiene la cantidad de vencidos de una persona.
     * @return cantidad de vencidos
     */
    @BusinessOperationDefinition(EXT_BO_PER_MGR_OBTENER_CANTIDAD_VENCIDOS_USUARIO_CARTERIZADO)
    public Long obtenerCantidadDeVencidosUsuarioCarterizado();
    
    /**
     * obtiene la cantidad de vencidos de una persona.
     * @return cantidad de vencidos
     */
    @BusinessOperationDefinition(EXT_BO_PER_MGR_OBTENER_CANTIDAD_SEG_SINTOMATICO_USUARIO)
    public Long obtenerCantidadDeSeguimientoSintomaticoUsuarioCarterizado();
    
    
    /**
     * obtiene la cantidad de vencidos de una persona.
     * @return cantidad de vencidos
     */
    @BusinessOperationDefinition(EXT_BO_PER_MGR_OBTENER_CANTIDAD_SEG_SISTEMATICO_USUARIO)
    public Long obtenerCantidadDeSeguimientoSistematicoUsuarioCarterizado();
}
