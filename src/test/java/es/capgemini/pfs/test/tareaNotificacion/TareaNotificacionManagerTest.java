package es.capgemini.pfs.test.tareaNotificacion;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.test.CommonTestAbstract;

public class TareaNotificacionManagerTest extends CommonTestAbstract{
	
	@Autowired
	TareaNotificacionManager tareaNotificacionManager;

	@Test
	public final void testGetListByProcedimientoSubtipo() {
		tareaNotificacionManager.getListByProcedimientoSubtipo(1L, SubtipoTarea.CODIGO_ACEPTACION_DECISION_PROCEDIMIENTO);
	}

	@Test
	public final void testGetNotificacionesAlertas() {
		tareaNotificacionManager.getNotificacionesAlertas();
	}

	@Test
	public final void testGet() {
		tareaNotificacionManager.get(1L);
	}

	@Test
	public final void testBuscarTareaActualExpediente() {
		tareaNotificacionManager.buscarTareaActualExpediente(1L);
	}

	@Test
	public final void testBuscarTareasPendiente() {
		DtoBuscarTareaNotificacion dto = new DtoBuscarTareaNotificacion();
		tareaNotificacionManager.buscarTareasPendiente(dto);
	}

	@Test
	public final void testBuscarComunicacionesCliente() {
		tareaNotificacionManager.buscarComunicacionesCliente(1L);
	}

	@Test
	public final void testBuscarComunicacionesExpediente() {
		tareaNotificacionManager.buscarComunicacionesExpediente(1L);
	}

	@Test
	public final void testBuscarComunicacionesAsunto() {
		tareaNotificacionManager.buscarComunicacionesAsunto(1L);
	}

	@Test
	public final void testBuscarComunicaciones() {
		DtoBuscarTareaNotificacion dtoBuscarTareaNotificacion = new DtoBuscarTareaNotificacion();
		dtoBuscarTareaNotificacion.setIdTipoEntidadInformacion(DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE);
		dtoBuscarTareaNotificacion.setIdEntidadInformacion(1L);
		tareaNotificacionManager.buscarComunicaciones(dtoBuscarTareaNotificacion);
	}

	@Test
	public final void testObtenerProrrogaExpediente() {
		tareaNotificacionManager.obtenerProrrogaExpediente(1L);
	}

	@Test
	public final void testObtenerSolicitudCancelacionExpediente() {
		tareaNotificacionManager.obtenerSolicitudCancelacionExpediente(1L);
	}

	@Test
	public final void testObtenerCantidadDeTareasPendientes() {
		DtoBuscarTareaNotificacion dto = new DtoBuscarTareaNotificacion();
		tareaNotificacionManager.obtenerCantidadDeTareasPendientes(dto);
	}

	@Test
	public final void testBuscarTareaSolCancExp() {
		tareaNotificacionManager.buscarTareaSolCancExp(1L, 1L);
	}

	@Test
	public final void testGetListByProcedimiento() {
		tareaNotificacionManager.getListByProcedimiento(1L);
	}

	@Test
	public final void testBuscarTareasParaExcel() {
		DtoBuscarTareaNotificacion dto = new DtoBuscarTareaNotificacion();
		tareaNotificacionManager.buscarTareasParaExcel(dto);
	}

	@Test
	public final void testGetSubtipoTareaByCode() {
		tareaNotificacionManager.getSubtipoTareaByCode(SubtipoTarea.CODIGO_ACEPTACION_DECISION_PROCEDIMIENTO);
	}

	@Test
	public final void testBuscarPlazoTareasDefaultPorCodigo() {
		tareaNotificacionManager.buscarPlazoTareasDefaultPorCodigo(PlazoTareasDefault.CODIGO_ACEPTAR_ASUNTO);
	}

	@Test
	public final void testBuscarTareasAsociadasACliente() {
		tareaNotificacionManager.buscarTareasAsociadasACliente(1L);
	}

}
