package es.pfsgroup.recovery.panelcontrol.judicial.manager;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.Nivel;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.panelcontrol.judicial.api.PanelControlApi;
import es.pfsgroup.recovery.panelcontrol.judicial.cliente.dao.PanelControlClienteDao;
import es.pfsgroup.recovery.panelcontrol.judicial.contrato.dao.PanelControlContratoDao;
import es.pfsgroup.recovery.panelcontrol.judicial.dto.DtoDetallePanelControl;
import es.pfsgroup.recovery.panelcontrol.judicial.dto.DtoPanelControl;
import es.pfsgroup.recovery.panelcontrol.judicial.tareas.dao.PanelControlTareasPendientesDao;
import es.pfsgroup.recovery.panelcontrol.judicial.vistas.panelControl.dao.PanelControlVistaDao;
import es.pfsgroup.recovery.panelcontrol.judicial.zonas.dao.PanelControlZonaDao;

@Component("panelControlManager")
public class PanelControlManager implements PanelControlApi {

	
	// @Autowired
	// private PanelControlDao panelControlDao;
	//
	@Autowired
	private PanelControlClienteDao clienteDao;

	@Autowired
	private PanelControlContratoDao contratoDao;

	@Autowired
	private PanelControlZonaDao zonaDao;

	@Autowired
	private PanelControlTareasPendientesDao tareaDao;

	@Autowired
	private PanelControlVistaDao panelControlVistaDao;

	/***
	 * 
	 * Devuelve una lista de niveles para el combo de jerarqu�a
	 * 
	 * @return ArrayList de niveles
	 * 
	 * */
	@Override
	@BusinessOperation(PANEL_CONTROL_GET_NIVELES)
	public List<Nivel> getDDNiveles() {

		List<Nivel> lista = new ArrayList<Nivel>();

		Nivel territorial = new Nivel();
		territorial.setId(3L);
		territorial.setDescripcion("Territorial");

		Nivel zona = new Nivel();
		zona.setId(4L);
		zona.setDescripcion("Zona");

		Nivel oficina = new Nivel();
		oficina.setId(5L);
		oficina.setDescripcion("Oficina");

		// lista.add(oficina);
		lista.add(zona);
		// lista.add(territorial);
		return lista;
	}

	/***
	 * 
	 * Devuelve una lista de {@link DtoPanelControl} con los datos necesarios
	 * para el grid Primero hace una consulta para buscar los datos de
	 * clientes,contratos y saldos. Con esa lista se recorre para buscar los
	 * datos de tareas pendientes. Se realiza as� por dos motivos: los datos de
	 * clientes, contratos y saldos se obtienen m�s rapido haciendolo en una
	 * sola consulta y los datos de tareas podemos aprovechar los dao que ya
	 * hab�a para la busqueda
	 * 
	 * @param nivel
	 *            Identificador del {@link Nivel}
	 * @param id
	 *            Identificador de la zona dentro del nivel (usado para buscar
	 *            las zonas hijas de una determinada )
	 * @param cod
	 *            Codigo de la zona dentro del nivel ( usado para buscar las
	 *            zonas hijas de una determinada)
	 * @param subConsulta
	 *            Indica si el listado lo obtenemos de una jerarqu�a, o buscamos
	 *            las zonas hijas de una zona determinada
	 * 
	 * @return Dto que contiene los datos: Nombre zona, suma de clientes, suma
	 *         de contratos, suma de contratos irregulares, suma de saldo
	 *         vencido, suma de saldo no vencido, total de tareas pendientes
	 *         vencidas, total de tareas pendientes para hoy, total tareas
	 *         pendientes para la semana, total tareas pendientes para el mes
	 * 
	 * 
	 * @return ArrayList de {@link DtoPanelControl} con los datos para el grid
	 * 
	 * */
	@Override
	@BusinessOperation(PANEL_CONTROL_GET_DATOS_POR_JERARQUIA)
	public List<DtoPanelControl> getDatosPorJerarquia(Long nivel, Long id,
			String cod, Boolean subConsulta) {

		// List<DDZona> listaZonasNivel =
		// zonaDao.getListaZonasNivel(nivel,cod,subConsulta);
		List<DDZona> listaZonasNivel = zonaDao.getListaZonasParaVista(nivel,
				cod);
		List<DtoPanelControl> lista = new ArrayList<DtoPanelControl>();
		try {
			// lista = panelControlDao.getListaCompleta(nivel,
			// id,listaZonasNivel);

			for (DDZona zona : listaZonasNivel) {

				DtoPanelControl dto = panelControlVistaDao.getDatosZona(zona
						.getNivel().getCodigo(), zona.getCodigo());
				dto.setNivel(zona.getDescripcion());
				dto.setCod(zona.getCodigo());
				dto.setOfiCodigo(zona.getOficina().getCodigo().toString());
				dto.setId(zona.getId());
/*
				DtoBuscarTareaNotificacion dtoBuscarTarea = new DtoBuscarTareaNotificacion();

				List<DDZona> listaZonaTareas = new ArrayList<DDZona>();
				listaZonaTareas.add(zona);// zonaDao.getListaZonasNivelLista(zona.getCodigo());
				dtoBuscarTarea.setZonas(listaZonaTareas);

				Long totalTareasPendientesVencidas = tareaDao
						.obtenerCantidadDeTareasPendientesVencidas(dtoBuscarTarea);
				Long totalTareasPendientesVencidasHoy = tareaDao
						.obtenerCantidadDeTareasPendientesHoy(dtoBuscarTarea);
				Long totalTareasPendientesVencidasSemana = tareaDao
						.obtenerCantidadDeTareasPendientesSemana(dtoBuscarTarea);
				Long totalTareasPendientesVencidasMes = tareaDao
						.obtenerCantidadDeTareasPendientesMes(dtoBuscarTarea);
				dto.setTareasPendientesVencidas(totalTareasPendientesVencidas);
				dto.setTareasPendientesHoy(totalTareasPendientesVencidasHoy);
				dto.setTareasPendientesSemana(totalTareasPendientesVencidasSemana);
				dto.setTareasPendientesMes(totalTareasPendientesVencidasMes);
				*/

				lista.add(dto);
			}
		} catch (Exception e) {
			// log.error("Error PanelControlManager", e);
			e.printStackTrace();
		}

		return lista;
	}

	/***
	 * Devuelve los datos de clientes sobre una determinada zona
	 * 
	 * @param dto
	 *            {@link DtoPanelControl} Dto que contiene los datos de busqueda
	 * 
	 * @return {@link Page} con la lista de Clientes devueltos
	 * 
	 * */
	@Override
	@BusinessOperation(GET_CLIENTES_PANEL_CONTROL)
	public Page getClientesPanelControl(DtoDetallePanelControl dto) {
		List<DDZona> listaZonas = zonaDao.getListaZonasNivelLista(dto.getCod());
		Page p = clienteDao.getListaClientes(dto, listaZonas);
		return p;
	}

	/***
	 * Devuelve los datos de contratos (normales o irregulares ) sobre una
	 * determinada zona
	 * 
	 * @param dto
	 *            {@link DtoPanelControl} Dto que contiene los datos de busqueda
	 * 
	 * @return {@link Page} con la lista de contratos devueltos
	 * 
	 * */
	@Override
	@BusinessOperation(GET_CONTRATOS_PANEL_CONTROL)
	public Page getContratosPanelControl(DtoDetallePanelControl dto) {
		List<DDZona> listaZonas = zonaDao.getListaZonasNivelLista(dto.getCod());
		Page p;
		if (dto.getDetalle().equals(3L)) { // NORMALES
			p = contratoDao.getListaContratos(dto);
		} else {
			p = contratoDao.getListaContratosIregulares(dto, listaZonas); // IRREGULARES
		}
		return p;
	}

	/***
	 * Devuelve los datos de tareas pendientes (vencidas, vencen hoy, vencen en
	 * una semana, vencen en um mes) sobre una determinada zona
	 * 
	 * @param dto
	 *            {@link DtoPanelControl} Dto que contiene los datos de busqueda
	 * 
	 * @return {@link Page} con la lista de Tareas pendientes devueltas
	 * 
	 * */
	@Override
	@BusinessOperation(GET_TAREAS_PANEL_CONTROL)
	public Page getTareasPendientesPanelControl(DtoDetallePanelControl dto) {
		DtoBuscarTareasPanelControl dtoBuscarTarea = new DtoBuscarTareasPanelControl();
		List<DDZona> listaZonas = zonaDao.getListaZonasNivelLista(dto.getCod());

		dtoBuscarTarea.setZonas(listaZonas);
		Page p = null;
		dtoBuscarTarea.setStart(dto.getStart());
		dtoBuscarTarea.setLimit(dto.getLimit());
		dtoBuscarTarea.setSort(dto.getSort());
		dtoBuscarTarea.setDir(dto.getSort());
		dtoBuscarTarea.setPanelTareas(dto.getPanelTareas());
		if (!Checks.esNulo(dto.getPanelTareas()) ){
			p = tareaDao.getListaTareasByCodigo(dtoBuscarTarea);
		}else {
			if (dto.getDetalle().equals(8L)) { // TOTAL TAREAS PENDIENTES VENCIDAS
				p = tareaDao.getListaTareasPendientesVencidas(dtoBuscarTarea);

			} else if (dto.getDetalle().equals(9L)) { // TAREAS PENDIENTES HOY
				p = tareaDao.getListaTareasPendientesHoy(dtoBuscarTarea);

			} else if (dto.getDetalle().equals(10L)) { // TAREAS PENDEINTES SEMANA
				p = tareaDao.getListaTareasPendientesSemana(dtoBuscarTarea);

			} else if (dto.getDetalle().equals(11L)) { // TAREAS PENDIENTES MES
				p = tareaDao.getListaTareasPendientesMes(dtoBuscarTarea);

			}
		}
		return p;
	}

}
