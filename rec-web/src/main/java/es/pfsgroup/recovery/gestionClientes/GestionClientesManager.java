package es.pfsgroup.recovery.gestionClientes;

import static es.pfsgroup.recovery.gestionClientes.dao.GestionClientesDao.COLUMN_STA_CODIGO;
import static es.pfsgroup.recovery.gestionClientes.dao.GestionClientesDao.COLUMN_STA_DESCRIPCION;
import static es.pfsgroup.recovery.gestionClientes.dao.GestionClientesDao.COLUMN_TOTAL_COUNT;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.itinerario.model.DDTipoItinerario;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.gestionClientes.dao.GestionClientesDao;

@Service
public class GestionClientesManager {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GestionClientesDao dao;
	
	@Resource
	private MessageService messageService;

	@SuppressWarnings("rawtypes")
	public List<GestionClientesCountDTO> getContadoresGestionVencidos() {
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

		List<Map> contadores = dao.obtenerCantidadDeVencidosUsuario(usuario);

		ArrayList<GestionClientesCountDTO> result = new ArrayList<GestionClientesCountDTO>();
		if (contadores != null) {

			for (Map map : contadores) {
				Object codigo = map.get(COLUMN_STA_CODIGO);
				if ((codigo != null) && SubtipoTarea.CODIGO_GESTION_VENCIDOS.equals(codigo.toString())) {
					// addCantidadTareasGestionVencidos
					result.add(
							creaGestionClientesCountDTO(map, messageService.getMessage("cliente.gestion.vencidos"), messageService.getMessage("cliente.gestionar.vencidos")));
				} else if ((codigo != null)
						&& SubtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SINTOMATICO.equals(codigo.toString())) {
					// addCantidadTareasSeguimientoSintomatico
					result.add(creaGestionClientesCountDTO(map, messageService.getMessage("cliente.gestion.seguimiento.sintomatico"), messageService.getMessage("cliente.gestionar.seguimiento.sintomatico")));
				} else if ((codigo != null)
						&& SubtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SISTEMATICO.equals(codigo.toString())) {
					// addCantidadTareasSeguimientoSistematico
					result.add(creaGestionClientesCountDTO(map, messageService.getMessage("cliente.gestion.seguimiento.sistematico"), messageService.getMessage("cliente.gestionar.seguimiento.sistematico")));
				}
			}

		}
		return result;
	}

	@SuppressWarnings("rawtypes")
	private GestionClientesCountDTO creaGestionClientesCountDTO(Map map, String descripcionTarea,
			String descripcionSubstring) {
		Object cantidadVecidos = map.get(COLUMN_TOTAL_COUNT);
		Object descSubptipo = map.get(COLUMN_STA_DESCRIPCION);
		Object codigoSubtipo = map.get(COLUMN_STA_CODIGO);

		GestionClientesCountDTO dto = new GestionClientesCountDTO();
		dto.setDescripcionTarea(descripcionTarea);
		dto.setDescripcion(descripcionSubstring + cantidadVecidos.toString());
		if (descSubptipo != null) {
			dto.setSubtipo(descSubptipo.toString());
		}
		if (codigoSubtipo != null) {
			dto.setCodigoSubtipoTarea(codigoSubtipo.toString());
		}
		dto.setDtype(TareaNotificacion.class.getSimpleName());
		dto.setCategoriaTarea("");
		return dto;
	}

	public Page getDatosVencidos(GestionClientesBusquedaDTO dto) {
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		return dao.obtenerListaGestionClientes(DDTipoItinerario.ITINERARIO_RECUPERACION, usuario, dto);
	}
	
	public Page getDatosSeguimientoSistematico(GestionClientesBusquedaDTO dto) {
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		return dao.obtenerListaGestionClientes(DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SISTEMATICO, usuario, dto);
	}
	
	public Page getDatosSeguimientoSintomatico(GestionClientesBusquedaDTO dto) {
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		return dao.obtenerListaGestionClientes(DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SINTOMATICO, usuario, dto);
	}
}
