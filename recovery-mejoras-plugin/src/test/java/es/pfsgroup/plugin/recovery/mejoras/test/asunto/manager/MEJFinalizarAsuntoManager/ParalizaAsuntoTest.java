package es.pfsgroup.plugin.recovery.mejoras.test.asunto.manager.MEJFinalizarAsuntoManager;

import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.math.RandomUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;

@RunWith(MockitoJUnitRunner.class)
public class ParalizaAsuntoTest  extends AbstractMEJFinalizarAsuntoManagerTests{

	private Asunto asunto;
	private Long idAsunto;

	private Date fechaParalizacion;
	private DDEstadoAsunto ddEstadoAsunto;
	private Procedimiento procedimiento;
	private DDEstadoProcedimiento ddEstadoProcedimiento;
	private List<Procedimiento> procedimientos;
	
	private MEJProcedimiento mejProcedimiento;
	private Long idProcessBPM;
	
	int cantidadProcedimientos;
	
	@Override
	public void preChildTest() {
		
		cantidadProcedimientos = RandomUtils.nextInt(10);
		idAsunto = RandomUtils.nextLong();
		idProcessBPM = RandomUtils.nextLong();
		fechaParalizacion = new Date(Math.abs(System.currentTimeMillis() - RandomUtils.nextInt(1000*60*60*24*365)));
		procedimientos = new ArrayList<Procedimiento>();

		asunto = mock(Asunto.class);
		ddEstadoAsunto = mock(DDEstadoAsunto.class);
		procedimiento = mock(Procedimiento.class);
		ddEstadoProcedimiento = mock(DDEstadoProcedimiento.class);
		mejProcedimiento = mock(MEJProcedimiento.class);
		
	}

	@Override
	public void postChildTest() {
		asunto = null;
		idAsunto = null;

		fechaParalizacion = null;
		ddEstadoAsunto = null;
		procedimiento = null;
		ddEstadoProcedimiento = null;
		procedimientos = null;
		idProcedimiento = null;
		mejProcedimiento = null;
		idProcessBPM = null;
		
	}
	
	/**
	 * Tets con un asunto aceptado y una cantida aleatoria de procedimientos aceptados.
	 */
	@Test
	public void testProcedimientosAceptados(){
		
		//Simulaciones.
		this.simulaListaProcedimientos(cantidadProcedimientos, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO);
		this.simulaAsunto(DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO);
		this.simulaMejProcedimiento(idProcessBPM);

		//Lanzamos el proceso a probar.
		mejFinalizarAsuntoManager.paralizaAsunto(asunto, fechaParalizacion);
		
		//Comprobaciones.
		this.verificaComportamientoProcedimientos(cantidadProcedimientos);

	}
	
	/**
	 * Tets con un asunto aceptado y una cantida aleatoria de procedimientos cancelados.
	 */
	@Test
	public void testProcedimientosCancelados(){
		
		//Simulaciones.
		this.simulaListaProcedimientos(cantidadProcedimientos, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO);
		this.simulaAsunto(DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO);
		this.simulaMejProcedimiento(idProcessBPM);

		//Lanzamos el proceso a probar.
		mejFinalizarAsuntoManager.paralizaAsunto(asunto, fechaParalizacion);
		
		//Comprobaciones.
		this.verificaComportamientoProcedimientos(0);

	}
	
	/**
	 * Tets con un asunto aceptado y una cantida aleatoria de procedimientos cerrados.
	 */
	@Test
	public void testProcedimientosCerrados(){
		
		//Simulaciones.
		this.simulaListaProcedimientos(cantidadProcedimientos, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO);
		this.simulaAsunto(DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO);
		this.simulaMejProcedimiento(idProcessBPM);

		//Lanzamos el proceso a probar.
		mejFinalizarAsuntoManager.paralizaAsunto(asunto, fechaParalizacion);
		
		//Comprobaciones.
		this.verificaComportamientoProcedimientos(0);

	}
	
	/**
	 * Tets con un asunto aceptado y una cantida aleatoria de procedimientos sin BPM.
	 */
	@Test
	public void testProcedimientosSinBPM(){
		
		//Simulaciones.
		this.simulaListaProcedimientos(cantidadProcedimientos, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO);
		this.simulaAsunto(DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO);
		this.simulaMejProcedimiento(null);

		//Lanzamos el proceso a probar.
		mejFinalizarAsuntoManager.paralizaAsunto(asunto, fechaParalizacion);
		
		//Comprobaciones.
		verify(mockJBPMProcessManager, never()).aplazarProcesosBPM(idProcessBPM, fechaParalizacion);
		verify(mockGenericDao, times(cantidadProcedimientos)).save(MEJProcedimiento.class, mejProcedimiento);

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
	 * @param cantidad n�mero de procedimientos a devolver.
	 */
	private void simulaListaProcedimientos(int cantidad, String estadoProcedimiento) {
		when(procedimiento.getEstadoProcedimiento()).thenReturn(ddEstadoProcedimiento);
		when(ddEstadoProcedimiento.getCodigo()).thenReturn(estadoProcedimiento);
		when(procedimiento.getId()).thenReturn(idProcedimiento);
		
		for (int i=0;i<cantidad;i++){
			procedimientos.add(procedimiento);			
		}
		
	}
	
	/**
	 * Obtenemos una lista de procedimientos.
	 * @param cantidad n�mero de procedimientos a devolver.
	 */
	private void simulaMejProcedimiento(Long idProcessBPM) {
		
		when(mockGenericDao.get(MEJProcedimiento.class, mockFilter)).thenReturn(mejProcedimiento);
		when(mejProcedimiento.getProcessBPM()).thenReturn(idProcessBPM);
		
	}
	
	/**
	 * Comprobamos que se guardan los procedimientos.
	 * @param veces veces que se lanza el m�todo guardar procedimiento.
	 */
	private void verificaComportamientoProcedimientos(int veces) {
		
		verify(mockJBPMProcessManager, times(veces)).aplazarProcesosBPM(idProcessBPM, fechaParalizacion);
		verify(mockGenericDao, times(veces)).save(MEJProcedimiento.class, mejProcedimiento);
	}

}
