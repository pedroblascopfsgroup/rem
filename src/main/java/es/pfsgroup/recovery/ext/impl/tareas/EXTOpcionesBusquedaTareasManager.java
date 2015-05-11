package es.pfsgroup.recovery.ext.impl.tareas;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.ext.api.tareas.EXTOpcionesBusquedaTareas;
import es.pfsgroup.recovery.ext.api.tareas.EXTOpcionesBusquedaTareasApi;

@Component
public class EXTOpcionesBusquedaTareasManager implements
		EXTOpcionesBusquedaTareasApi {

	@Autowired
	private FuncionManager funcionManager;
	
	@Autowired
	private ApiProxyFactory proxyFactory;	

	@BusinessOperation(EXT_OPCIONES_BUSQUEDA_TAREAS_TIENE_OPCION)
	public boolean tieneOpcion(EXTOpcionesBusquedaTareas opcion, Usuario u) {
		if ((u == null) || (opcion == null)) {
			return false;
		} else {
			return funcionManager.tieneFuncion(u, opcion.getFuncionRequerida());
		}
	}

	@BusinessOperation(EXT_OPCIONES_BUSQUEDA_TAREAS_TIENE_OPCION_BUZON_OPTIMIZADO)
	public boolean tieneOpcionBuzonOptimizado() {
		Usuario u = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		return tieneOpcion(EXTOpcionesBusquedaTareas.getBuzonesTareasOptimizados(), u);
	}
}
