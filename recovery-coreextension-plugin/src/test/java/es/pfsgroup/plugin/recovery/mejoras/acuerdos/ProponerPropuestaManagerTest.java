package es.pfsgroup.plugin.recovery.mejoras.acuerdos;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;

import org.apache.commons.lang.math.RandomUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.acuerdo.dao.AcuerdoDao;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.manager.PropuestaManager;

@RunWith(MockitoJUnitRunner.class)
public class ProponerPropuestaManagerTest {

	@Mock
	private UtilDiccionarioApi mockUtilDiccionarioApi;

	@Mock
	private AcuerdoDao acuerdoDao;

	@InjectMocks
	private PropuestaManager propuestaManager;

	/**
	 * Generic Id used to test
	 */
	private static final Long ID_PROPUESTA = RandomUtils.nextLong();

	/**
	 * Si el expediente se encuentra en fase “Completar expediente” la propuesta cambiará a estado “Propuesto”
	 */
	@Test
	public void testProponerExpedienteEnEstadoCompletar() {
		// Mock methods
		mockPropuestaWithExpediente(DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE);
		mockDiccionarioEstadoAcuerdoByCod(DDEstadoAcuerdo.ACUERDO_PROPUESTO);

		// Method to test
		propuestaManager.proponer(ID_PROPUESTA);

		// Capture the result
		ArgumentCaptor<Acuerdo> capturador = ArgumentCaptor.forClass(Acuerdo.class);
		Mockito.verify(acuerdoDao).saveOrUpdate(capturador.capture());

		// Check the result
		Acuerdo acuerdoYaPropuesto = capturador.getValue();
		assertEquals(DDEstadoAcuerdo.ACUERDO_PROPUESTO, acuerdoYaPropuesto.getEstadoAcuerdo().getCodigo());
	}

	/**
	 * Si el expediente se encuentra en fase "Revisión expediente" la propuesta cambiará a estado “Propuesto”
	 */
	@Test
	public void testProponerExpedienteEnEstadoRevision() {
		// Mock methods
		mockPropuestaWithExpediente(DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE);
		mockDiccionarioEstadoAcuerdoByCod(DDEstadoAcuerdo.ACUERDO_PROPUESTO);

		// Method to test
		propuestaManager.proponer(ID_PROPUESTA);

		// Capture the result
		ArgumentCaptor<Acuerdo> capturador = ArgumentCaptor.forClass(Acuerdo.class);
		Mockito.verify(acuerdoDao).saveOrUpdate(capturador.capture());

		// Check the result
		Acuerdo acuerdoYaPropuesto = capturador.getValue();
		assertEquals(DDEstadoAcuerdo.ACUERDO_PROPUESTO, acuerdoYaPropuesto.getEstadoAcuerdo().getCodigo());
	}

	/**
	 * Si el expediente se encuentra en fase “Decisión de comité”  la Propuesta cambiará a estado “Elevado”
	 */
	@Test
	public void testProponerExpedienteEnEstadoDecision() {
		// Mock methods
		mockPropuestaWithExpediente(DDEstadoItinerario.ESTADO_DECISION_COMIT);
		mockDiccionarioEstadoAcuerdoByCod(DDEstadoAcuerdo.ACUERDO_ACEPTADO);

		// Method to test
		propuestaManager.proponer(ID_PROPUESTA);

		// Capture the result
		ArgumentCaptor<Acuerdo> capturador = ArgumentCaptor.forClass(Acuerdo.class);
		Mockito.verify(acuerdoDao).saveOrUpdate(capturador.capture());

		// Check the result
		Acuerdo acuerdoYaPropuesto = capturador.getValue();
		assertEquals(DDEstadoAcuerdo.ACUERDO_ACEPTADO, acuerdoYaPropuesto.getEstadoAcuerdo().getCodigo());
	}

	private void mockDiccionarioEstadoAcuerdoByCod(String codigoEstadoAcuerdo) {
		DDEstadoAcuerdo estadoPropuesto = new DDEstadoAcuerdo(); 
		estadoPropuesto.setCodigo(codigoEstadoAcuerdo);

		when(mockUtilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoAcuerdo.class, codigoEstadoAcuerdo)).thenReturn(estadoPropuesto);
	}

	private void mockPropuestaWithExpediente(String codigoEstadoItinerario) {
		DDEstadoItinerario estadoExp = new DDEstadoItinerario();
		estadoExp.setCodigo(codigoEstadoItinerario);

		Expediente expedienteConEstadoItinerario = new Expediente();
		expedienteConEstadoItinerario.setEstadoItinerario(estadoExp);

		Acuerdo propuesta = new Acuerdo();
		propuesta.setExpediente(expedienteConEstadoItinerario);
		
		when(acuerdoDao.get(ID_PROPUESTA)).thenReturn(propuesta);
	}

}
