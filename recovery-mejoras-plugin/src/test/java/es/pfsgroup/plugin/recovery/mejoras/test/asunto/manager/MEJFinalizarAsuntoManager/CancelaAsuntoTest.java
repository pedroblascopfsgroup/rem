package es.pfsgroup.plugin.recovery.mejoras.test.asunto.manager.MEJFinalizarAsuntoManager;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.math.RandomUtils;
import org.junit.Test;
import org.junit.runner.RunWith;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.registro.ModificacionAsuntoListener;

/**
 * Tests del método cancelar asunto. {@link MEJFinalizarAsuntoManager#cancelaAsunto}
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class CancelaAsuntoTest extends AbstractMEJFinalizarAsuntoManagerTests{

	private Asunto asunto;
	private Long idAsunto;
	private Date fechaCancelacion;
	private DDEstadoAsunto ddEstadoAsunto;
	private Procedimiento procedimiento;
	private DDEstadoProcedimiento ddEstadoProcedimiento;
	private List<Procedimiento> procedimientos;
	
	int cantidadProcedimientos;
	
	@Captor 
	ArgumentCaptor<Map<String, Object>> mapCaptor;

	
	@Override
	public void preChildTest() {
		
		cantidadProcedimientos = RandomUtils.nextInt(10);
		idAsunto = RandomUtils.nextLong();
		fechaCancelacion = new Date(Math.abs(System.currentTimeMillis() - RandomUtils.nextInt(1000*60*60*24*365)));
		procedimientos = new ArrayList<Procedimiento>();

		asunto = mock(Asunto.class);
		ddEstadoAsunto = mock(DDEstadoAsunto.class);
		procedimiento = mock(Procedimiento.class);
		ddEstadoProcedimiento = mock(DDEstadoProcedimiento.class);
	}

	@Override
	public void postChildTest() {
		asunto = null;
		idAsunto = null;
		fechaCancelacion = null;
		ddEstadoAsunto = null;
		procedimiento = null;
		ddEstadoProcedimiento = null;
		procedimientos = null;
		
	}
	
	/**
	 * Tets con un asunto aceptado y una cantida aleatoria de procedimientos aceptados.
	 */
	@Test
	public void testAsuntoAceptado(){
		
		//Simulaciones.
		this.simulaListaProcedimientos(cantidadProcedimientos, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO);
		this.simulaAsunto(DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO);

		//Lanzamos el proceso a probar.
		mejFinalizarAsuntoManager.cancelaAsunto(asunto, fechaCancelacion);
		
		//Comprobaciones.
		this.verificaComportamientoProcedimientos(cantidadProcedimientos);
		this.verificaComportamientoAsunto(1);
	}
	

	/**
	 * Comprobamos el funcionamiento con un asunto cancelado.
	 */
	@Test
	public void testAsuntoCancelado(){
		//Simulaciones.
		this.simulaListaProcedimientos(cantidadProcedimientos, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO);
		this.simulaAsunto(DDEstadoAsunto.ESTADO_ASUNTO_CANCELADO);

		//Lanzamos el proceso a probar.
		mejFinalizarAsuntoManager.cancelaAsunto(asunto, fechaCancelacion);
		
		//Comprobaciones.
		this.verificaComportamientoProcedimientos(cantidadProcedimientos);
		this.verificaComportamientoAsunto(0);
	}
	
	/**
	 * Comprobamos el funcionamiento con procedimientos cancelados.
	 */
	@Test
	public void testProcedimientosCancelados(){
		//Simulaciones.
		this.simulaListaProcedimientos(cantidadProcedimientos, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO);
		this.simulaAsunto(DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO);

		//Lanzamos el proceso a probar.
		mejFinalizarAsuntoManager.cancelaAsunto(asunto, fechaCancelacion);
		
		//Comprobaciones.
		this.verificaComportamientoProcedimientos(0);
		this.verificaComportamientoAsunto(1);
	}
	
	/**
	 * Comprobamos el funcionamiento con procedimientos cerrados.
	 */
	@Test
	public void testProcedimientosCerrados(){
		//Simulaciones.
		this.simulaListaProcedimientos(cantidadProcedimientos, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO);
		this.simulaAsunto(DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO);

		//Lanzamos el proceso a probar.
		mejFinalizarAsuntoManager.cancelaAsunto(asunto, fechaCancelacion);
		
		//Comprobaciones.
		this.verificaComportamientoProcedimientos(0);
		this.verificaComportamientoAsunto(1);
	}


	
	
	/**
	 * Simulamos el comportamiento del asunto.
	 * @param estadoAsunto
	 */
	private void simulaAsunto(String estadoAsunto) {
		when(asunto.getId()).thenReturn(idAsunto);
		when(asunto.getEstadoAsunto()).thenReturn(ddEstadoAsunto);
		when(ddEstadoAsunto.getCodigo()).thenReturn(estadoAsunto);
		when(asunto.getProcedimientos()).thenReturn(procedimientos);
	}

	/**
	 * Obtenemos una lista de procedimientos.
	 * @param cantidad número de procedimientos a devolver.
	 */
	private void simulaListaProcedimientos(int cantidad, String estadoProcedimiento) {
		when(procedimiento.getEstadoProcedimiento()).thenReturn(ddEstadoProcedimiento);
		when(ddEstadoProcedimiento.getCodigo()).thenReturn(estadoProcedimiento);
		
		for (int i=0;i<cantidad;i++){
			procedimientos.add(procedimiento);			
		}
		
	}

	/**
	 * Comprobamos que se lanza el evento y se guarda el procedimiento.
	 * @param veces
	 */
	private void verificaComportamientoAsunto(int veces) {
		//Comprobamos que se lanza el evento correctamente.
		verify(mockMEJModAsuntoREG, times(veces)).fireEvent(mapCaptor.capture());
		if (veces > 0){
			assertEquals(idAsunto, (Long)mapCaptor.getValue().get(ModificacionAsuntoListener.ID_ASUNTO));
			assertEquals(fechaCancelacion, (Date)mapCaptor.getValue().get("FechaCancelacion"));
		}
		
		//Comprobamos que se guarda el asunto
		verify(mockAsuntoDao, times(veces)).saveOrUpdate(asunto);
	}
	
	/**
	 * Comprobamos que se guardan los procedimientos.
	 * @param veces veces que se lanza el método guardar procedimiento.
	 */
	private void verificaComportamientoProcedimientos(int veces) {
		verify(mockProcedimientoDao, times(veces)).saveOrUpdate(procedimiento);
	}
}
