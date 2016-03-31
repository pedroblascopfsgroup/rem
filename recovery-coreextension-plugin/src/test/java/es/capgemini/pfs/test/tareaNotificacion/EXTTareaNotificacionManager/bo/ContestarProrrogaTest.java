package es.capgemini.pfs.test.tareaNotificacion.EXTTareaNotificacionManager.bo;

import java.util.Date;
import java.util.Random;

import static org.mockito.Mockito.*;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.prorroga.dto.DtoSolicitarProrroga;
import es.capgemini.pfs.prorroga.model.CausaProrroga;
import es.capgemini.pfs.prorroga.model.Prorroga;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.test.tareaNotificacion.EXTTareaNotificacionManager.AbstractExtTareaNotificacionManagerTests;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;

/**
 * Comprobaciones de la operación de negocio de contestar prórroga
 * @author bruno
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class ContestarProrrogaTest extends AbstractExtTareaNotificacionManagerTests{
	
	private Long idTareaOriginal;
	
	private Long idProrroga;
	
	private Date fechaPropuesta;
	
	private Long idExpediente;
	
	private Long idTareaAsociadaProrroga;
	
	private String descripcionCausaProrroga;
	
	
	@Mock
	private TareaNotificacion mockTareaOriginal;
	@Mock
	private Prorroga mockProrroga;

	@Mock
	private DDTipoEntidad mockTipoEntidadExpediente;

	@Mock
	private DDTipoEntidad mockTipoEntidadProcedimiento;

	@Mock
	private Expediente mockExpediente;

	@Mock
	private DDEstadoItinerario mockEstadoItinerarioCE;

	@Mock
	private EXTTareaNotificacion mockTareaAsociadaProrroga;

	@Mock
	private CausaProrroga mockCausaProrroga;
	
	@Mock
	private IntegracionBpmService integracionBPMService;

	@Override
	public void setUpChildTest() {
		Random r = new Random();
		idTareaOriginal = r.nextLong();
		idProrroga = r.nextLong();
		fechaPropuesta = new Date(r.nextLong());
		idExpediente = r.nextLong();
		idTareaAsociadaProrroga = r.nextLong();
		descripcionCausaProrroga = "Causa prorroga " + r.nextLong();
		
		when(mockParentManager.get(idTareaOriginal)).thenReturn(mockTareaOriginal);
		
		when(mockTareaOriginal.getProrroga()).thenReturn(mockProrroga);
		when(mockProrroga.getId()).thenReturn(idProrroga);
		when(mockProrroga.getFechaPropuesta()).thenReturn(fechaPropuesta);
		
		when(mockProrroga.getTareaAsociada()).thenReturn(mockTareaAsociadaProrroga);
		when(mockTareaAsociadaProrroga.getId()).thenReturn(idTareaAsociadaProrroga);
		
		when(mockProrroga.getCausaProrroga()).thenReturn(mockCausaProrroga);
		when(mockCausaProrroga.getDescripcion()).thenReturn(descripcionCausaProrroga);
		
		simularInteracciones().simulaRespuestaProrroga(mockProrroga);
		
		simularInteracciones().simulaGetTipoEntidad(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, mockTipoEntidadExpediente);
		when(mockTipoEntidadExpediente.getCodigo()).thenReturn(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);
		simularInteracciones().simulaGetTipoEntidad(DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, mockTipoEntidadProcedimiento);
		when(mockTipoEntidadProcedimiento.getCodigo()).thenReturn(DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO);
		
		simularInteracciones().simulaGetExpediente(idExpediente, mockExpediente);
		when(mockExpediente.getId()).thenReturn(idExpediente);
		
		when(mockEstadoItinerarioCE.getCodigo()).thenReturn(DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE);
	}

	@Override
	public void tearDownChildTest() {
		idTareaOriginal = null;
		idProrroga = null;
		fechaPropuesta = null;
		idExpediente = null;
		idTareaAsociadaProrroga = null;
		descripcionCausaProrroga = null;
		reset(mockTareaOriginal);
		reset(mockProrroga);
		reset(mockTipoEntidadExpediente);
		reset(mockTipoEntidadProcedimiento);
		reset(mockExpediente);
		reset(mockEstadoItinerarioCE);
		reset(mockTareaAsociadaProrroga);
		reset(mockCausaProrroga);
	}
	
	/**
	 * Probamos el caso general de contestar una prórroga en un expediente en estado CE en la que ésta se acepta
	 */
	@Test
	public void testContestarProrroga_aceptarProrroga_expediente_CE(){
		DtoSolicitarProrroga dto = new DtoSolicitarProrroga();
		dto.setIdTareaOriginal(idTareaOriginal);
		dto.setIdEntidadInformacion(idExpediente);
		dto.setIdTipoEntidadInformacion(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);
		// No se sabe muy bien de dónde sale esto, pero para que se acepten prórrogas lso códigos son 7 o 11 (el 7 no se prueba)
		dto.setCodigoRespuesta("11");
		
		when(mockExpediente.getEstadoItinerario()).thenReturn(mockEstadoItinerarioCE);
		
		manager.contestarProrroga(dto);
		
		verificarInteracciones().seHaGeneradoRespuestaProrroga(dto);
		
		verificarInteracciones().seHaGuardadoLaTarea(mockTareaAsociadaProrroga);
	}

}
