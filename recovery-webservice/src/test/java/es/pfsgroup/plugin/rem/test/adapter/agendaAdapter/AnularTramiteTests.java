package es.pfsgroup.plugin.rem.test.adapter.agendaAdapter;

import static org.junit.Assert.*;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.mockito.stubbing.Answer;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.PreciosApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPropuestaPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;

@RunWith(MockitoJUnitRunner.class)
public class AnularTramiteTests {

	private static final int NUMERO_TAREAS_ACTIVAS = 3;

	private static final Long ID_TRAMITE = 1L;

	private static final Long ID_TRABAJO = 2L;

	private static final Long ID_PROPUESTA_PRECIOS = 3L;

	@InjectMocks
	private AgendaAdapter adapter;

	@Mock
	private ActivoTramiteApi activoTramiteApi;

	@Mock
	private TareaActivoApi tareaActivoApi;

	@Mock
	private GenericABMDao genericDao;

	@Mock
	private PreciosApi preciosApi;
	
	private ActivoTramite tramite;

	@Before
	public void before() {
		/*
		 * Obtener el trámite y el trabajo
		 */
		tramite = new ActivoTramite();
		tramite.setId(ID_TRAMITE);
		tramite.setTipoTramite(tipoTramite(ActivoTramiteApi.CODIGO_TRAMITE_PROPUESTA_PRECIOS));
		Trabajo trabajo = new Trabajo();
		trabajo.setId(ID_TRABAJO);
		tramite.setTrabajo(trabajo);
		when(activoTramiteApi.get(ID_TRAMITE)).thenReturn(tramite);

		/*
		 * Obtener tareas del trámite
		 */
		List<TareaExterna> listaTareas = new ArrayList<TareaExterna>();
		for (int i = 0; i < NUMERO_TAREAS_ACTIVAS; i++) {
			TareaExterna tarea = new TareaExterna();
			tarea.setId(new Long(i));
			listaTareas.add(tarea);
		}
		when(activoTramiteApi.getListaTareaExternaActivasByIdTramite(anyLong())).thenReturn(listaTareas);

		/*
		 * Obtener propuesta de precios
		 */
		PropuestaPrecio propuesta = new PropuestaPrecio();
		propuesta.setId(ID_PROPUESTA_PRECIOS);
		when(preciosApi.getPropuestaByTrabajo(ID_TRABAJO)).thenReturn(propuesta);
	}

	@After
	public void after() {
		reset(activoTramiteApi, tareaActivoApi, genericDao, preciosApi);
		tramite = null;
	}

	@Test
	public void finalizarTramite() {
		Boolean result = adapter.anularTramite(ID_TRAMITE);

		assertEquals(result, true);
		verify(tareaActivoApi, times(NUMERO_TAREAS_ACTIVAS)).saltoFin(anyLong());
	}

	@Test
	public void cambiarEstadoTramite() {
		/*
		 * Obtener el estado del procedimiento "Cerrado"
		 */
		configuraGetDiccionario(DDEstadoProcedimiento.class, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO);

		adapter.anularTramite(ID_TRAMITE);

		ArgumentCaptor<ActivoTramite> captor = ArgumentCaptor.forClass(ActivoTramite.class);
		verify(activoTramiteApi).saveOrUpdateActivoTramite(captor.capture());
		ActivoTramite tramite = captor.getValue();
		assertEquals("El estado del trámite no es el esperado", DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO,
				tramite.getEstadoTramite().getCodigo());
	}
	
	@Test
	public void anularTrabajo () {
		/*
		 * Obtener el estado del trabajo "Anulado"
		 */
		configuraGetDiccionario(DDEstadoTrabajo.class, DDEstadoTrabajo.ESTADO_ANULADO);
		adapter.anularTramite(ID_TRAMITE);
		
		ArgumentCaptor<Trabajo> captor = ArgumentCaptor.forClass(Trabajo.class);
		verify(genericDao).save(eq(Trabajo.class), captor.capture());
		Trabajo trabajo = captor.getValue();
		assertEquals("El estado del trabajo no es el esperado", DDEstadoTrabajo.ESTADO_ANULADO, trabajo.getEstado().getCodigo());
	}

	@Test
	public void anularPropuestaDePrecios() {
		/*
		 * Obtener el estado de la propuesta "Anulada"
		 */
		configuraGetDiccionario(DDEstadoPropuestaPrecio.class, DDEstadoPropuestaPrecio.ESTADO_ANULADA);

		adapter.anularTramite(ID_TRAMITE);

		ArgumentCaptor<PropuestaPrecio> captor = ArgumentCaptor.forClass(PropuestaPrecio.class);
		verify(genericDao).save(eq(PropuestaPrecio.class), captor.capture());
		PropuestaPrecio propuesta = captor.getValue();
		assertEquals("El estado de la propuesta de precios no es el esperado", DDEstadoPropuestaPrecio.ESTADO_ANULADA,
				propuesta.getEstado().getCodigo());
	}

	@Test
	public void noEsUnaPropuestaDePrecios() {
		tramite.setTipoTramite(tipoTramite(ActivoTramiteApi.CODIGO_TRAMITE_ADMISION));
		configuraGetDiccionario(DDEstadoPropuestaPrecio.class, DDEstadoPropuestaPrecio.ESTADO_ANULADA);
		
		adapter.anularTramite(ID_TRAMITE);
		
		verifyZeroInteractions(preciosApi);
		verify(genericDao, times(0)).save(eq(PropuestaPrecio.class), any(PropuestaPrecio.class));
	}

	private TipoProcedimiento tipoTramite(String codigo) {
		TipoProcedimiento propuestaPrecios = new TipoProcedimiento();
		propuestaPrecios.setCodigo(codigo);
		return propuestaPrecios;
	}

	private <T extends Dictionary> void configuraGetDiccionario(Class<T> clazz, String value) {
		Filter filtro = mock(Filter.class);
		when(genericDao.createFilter(FilterType.EQUALS, "codigo", value)).thenReturn(filtro);
		T estado = mock(clazz);
		when(estado.getCodigo()).thenReturn(value);
		when(genericDao.get(clazz, filtro)).thenReturn(estado);
	}

}
