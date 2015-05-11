package es.pfsgroup.recovery.ext.impl.persona;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.DDTipoItinerario;
import es.capgemini.pfs.persona.dao.EXTPersonaDao;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.ext.api.persona.EXTPersonaApi;

@Component
public class EXTPersonaNuevasFuncionalidadesManager implements EXTPersonaApi{
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
    private EXTPersonaDao personaDao;
	
	/**
     * obtiene la cantidad de vencidos de una persona.
     * @return cantidad de vencidos
     */
	@BusinessOperation(EXT_BO_PER_MGR_OBTENER_CANTIDAD_VENCIDOS_USUARIO_CARTERIZADO)
    public Long obtenerCantidadDeVencidosUsuarioCarterizado() {
        DtoBuscarClientes clientes = new DtoBuscarClientes();
        //DDEstadoItinerario estado = ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS).get(0);
        clientes.setSituacion(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);
        clientes.setIsPrimerTitContratoPase(Boolean.TRUE);
        clientes.setCodigoZonas(getCodigosDeZona(clientes));
        Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
        clientes.setPerfiles(usuario.getPerfiles());
        clientes.setIsBusquedaGV(Boolean.TRUE);
        clientes.setCodigoGestion(DDTipoItinerario.ITINERARIO_RECUPERACION);
        return personaDao.obtenerCantidadDeVencidosUsuario(clientes, true, usuario);
    }
	
	@Override
	 @BusinessOperation(EXT_BO_PER_MGR_OBTENER_CANTIDAD_SEG_SINTOMATICO_USUARIO)
	public Long obtenerCantidadDeSeguimientoSintomaticoUsuarioCarterizado() {
		DtoBuscarClientes clientes = new DtoBuscarClientes();
        //DDEstadoItinerario estado = ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS).get(0);
        clientes.setSituacion(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);
        clientes.setIsPrimerTitContratoPase(Boolean.TRUE);
        clientes.setCodigoZonas(getCodigosDeZona(clientes));
        Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
        clientes.setPerfiles(usuario.getPerfiles());
        clientes.setIsBusquedaGV(Boolean.TRUE);

        clientes.setCodigoGestion(DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SINTOMATICO);
        Long contador = personaDao.obtenerCantidadDeVencidosUsuario(clientes, true, usuario);

        return contador;
	}


	@Override
	@BusinessOperation(EXT_BO_PER_MGR_OBTENER_CANTIDAD_SEG_SISTEMATICO_USUARIO)
	public Long obtenerCantidadDeSeguimientoSistematicoUsuarioCarterizado() {
		DtoBuscarClientes clientes = new DtoBuscarClientes();
        //DDEstadoItinerario estado = ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS).get(0);
        clientes.setSituacion(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);
        clientes.setIsPrimerTitContratoPase(Boolean.TRUE);
        clientes.setCodigoZonas(getCodigosDeZona(clientes));
        Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
        clientes.setPerfiles(usuario.getPerfiles());
        clientes.setIsBusquedaGV(Boolean.TRUE);

        clientes.setCodigoGestion(DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SISTEMATICO);
        Long contador = personaDao.obtenerCantidadDeVencidosUsuario(clientes,true, usuario);

        return contador;
	}
	
	
	private Set<String> getCodigosDeZona(DtoBuscarClientes clientes) {
        Set<String> zonas;
        if (clientes.getCodigoZona() != null && clientes.getCodigoZona().trim().length() > 0) {
            List<String> list = Arrays.asList((clientes.getCodigoZona().split(",")));
            zonas = new HashSet<String>(list);
        } else {
        	Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
            zonas = usuario.getCodigoZonas();
        }
        return zonas;
    }


	

}
