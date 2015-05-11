package es.pfsgroup.plugin.recovery.masivo.test.launcher.impl;

import static org.junit.Assert.*;

import static org.mockito.Matchers.any;

import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;
import static org.mockito.Mockito.any;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.times;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Properties;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.recovery.masivo.launcher.MSVCargaDocumentacionLauncherApi;
import es.pfsgroup.plugin.recovery.masivo.launcher.impl.MSVCargaDocumentacionLauncher;

//@RunWith(MockitoJUnitRunner.class)
public class MSVCargaDocumentacionLauncherTest {

//	@InjectMocks
//	MSVCargaDocumentacionLauncher msvCargaDocumentacionLauncher;
//
//	@Mock
//	Properties mockProperties;
//
//	private String horaInicio = "12:00:00";
//	private String horaFin = "14:00:00";
//	private String intervalo = "3";
//	private String directorio = "/tmp/tempFiles/";
//
//	private SimpleDateFormat formatter = new SimpleDateFormat("HH:mm:ss");
//
////	@Test
////	public void testGetHoraInicio() {
////		msvCargaDocumentacionLauncher.setHoraInicio(horaInicio);
////		assertEquals("Error al obtener hora de inicio",
////				msvCargaDocumentacionLauncher.getHoraInicio(), horaInicio);
////	}
////
////	@Test
////	public void testGetHoraFin() {
////		msvCargaDocumentacionLauncher.setHoraFin(horaFin);
////		assertEquals("Error al obtener hora de fin",
////				msvCargaDocumentacionLauncher.getHoraFin(), horaFin);
////	}
////
////	@Test
////	public void testGetIntervalo() {
////		msvCargaDocumentacionLauncher.setIntervalo(intervalo);
////		assertEquals("Error al obtener intervalo",
////				msvCargaDocumentacionLauncher.getIntervalo(), intervalo);
////	}
//
//	@Test
//	public void testGetDirectorio() {
//		msvCargaDocumentacionLauncher.setDirectorio(directorio);
//		assertEquals("Error al obtener directorio",
//				msvCargaDocumentacionLauncher.getDirectorio(), directorio);
//	}
//
//	/**
//	 * Comprobamos que si no podemos parsear el intervalo a un Long valido no falla
//	 */
////	@Test
////	public void testComenzarServicioErrorNumberFormat() {
////		msvCargaDocumentacionLauncher.init();
////		msvCargaDocumentacionLauncher.setIntervalo("A");
////		msvCargaDocumentacionLauncher.comenzarServicio();
////	}
////
////	/**
////	 * Comprobamos que si estamos fuera de horas no entra en el bucle
////	 */
////	@Test
////	public void testComenzarServicioFueraHoras() {
////		msvCargaDocumentacionLauncher.init();
////		GregorianCalendar horaSimulada = new GregorianCalendar();
////		horaSimulada.add(Calendar.HOUR, 1);
////		String horaSimuladaAntesInicio = formatter.format(horaSimulada
////				.getTime());
////		msvCargaDocumentacionLauncher.setHoraInicio(horaSimuladaAntesInicio);
////		msvCargaDocumentacionLauncher.comenzarServicio();
////
////		assertEquals("Error al detectar hora actual fuera de ventana horaria",
////				"FUERA_HORAS_NO_ENTRA",
////				msvCargaDocumentacionLauncher.getResultado());
////
////	}
////
////	/**
////	 * Comprobamos que si detro de horas entra en el bucle y sale 
////	 * (simulamos intevalo a casi cero, para no ralentizar las
////	 * pruebas)
////	 */
////	@Test
////	public void testComenzarServicioDentroHoras() {
////		msvCargaDocumentacionLauncher.init();
////		GregorianCalendar horaSimulada = new GregorianCalendar();
////		horaSimulada.add(Calendar.SECOND, -5);
////		String unMinutoAntesDeAhora = formatter.format(horaSimulada.getTime());
////		horaSimulada = new GregorianCalendar();
////		horaSimulada.add(Calendar.SECOND, 5);
////		String unMinutoDespuesDeAhora = formatter.format(horaSimulada
////				.getTime());
////		msvCargaDocumentacionLauncher.setHoraInicio(unMinutoAntesDeAhora);
////		msvCargaDocumentacionLauncher.setHoraFin(unMinutoDespuesDeAhora);
////		msvCargaDocumentacionLauncher.setIntervalo("0");
////		msvCargaDocumentacionLauncher.comenzarServicio();
////
////		assertEquals("Error al entrar en el bucle", "ENTRA_Y_SALE",
////				msvCargaDocumentacionLauncher.getResultado());
////
////	}
////
////	@Test
////	public void testDetenerServicio() {
////		msvCargaDocumentacionLauncher.detenerServicio();
////		assertEquals("Error al detener el servicio", false,
////				msvCargaDocumentacionLauncher.isEnMarcha());
////	}
////
////	@Test
////	public void testInit() {
////
////		String defHoraInicio = "00:00:00";
////		String defHoraFin = "01:00:00";
////		String defIntervalo = "5";
////		String defDirectorio = "/tmp/";
////
////		when(
////				mockProperties
////						.getProperty(MSVCargaDocumentacionLauncherApi.KEY_HORA_INICIO))
////				.thenReturn(null);
////		when(
////				mockProperties
////						.getProperty(MSVCargaDocumentacionLauncherApi.KEY_HORA_FIN))
////				.thenReturn(null);
////		when(
////				mockProperties
////						.getProperty(MSVCargaDocumentacionLauncherApi.KEY_INTERVALO))
////				.thenReturn(null);
////		when(
////				mockProperties
////						.getProperty(MSVCargaDocumentacionLauncherApi.KEY_DIRECTORIO))
////				.thenReturn(null);
////
////		msvCargaDocumentacionLauncher.init();
////
////		assertEquals("Error de inicializaci�n de hora de inicio con nulos",
////				msvCargaDocumentacionLauncher.getHoraInicio(), defHoraInicio);
////		assertEquals("Error de inicializaci�n de hora de fin con nulos",
////				msvCargaDocumentacionLauncher.getHoraFin(), defHoraFin);
////		assertEquals("Error de inicializaci�n de intervalo con nulos",
////				msvCargaDocumentacionLauncher.getIntervalo(), defIntervalo);
////		assertEquals("Error de inicializaci�n de directorio con nulos",
////				msvCargaDocumentacionLauncher.getDirectorio(), defDirectorio);
////
////		when(
////				mockProperties
////						.getProperty(MSVCargaDocumentacionLauncherApi.KEY_HORA_INICIO))
////				.thenReturn(horaInicio);
////		when(
////				mockProperties
////						.getProperty(MSVCargaDocumentacionLauncherApi.KEY_HORA_FIN))
////				.thenReturn(horaFin);
////		when(
////				mockProperties
////						.getProperty(MSVCargaDocumentacionLauncherApi.KEY_INTERVALO))
////				.thenReturn(intervalo);
////		when(
////				mockProperties
////						.getProperty(MSVCargaDocumentacionLauncherApi.KEY_DIRECTORIO))
////				.thenReturn(directorio);
////
////		msvCargaDocumentacionLauncher.setAppProperties(mockProperties);
////		msvCargaDocumentacionLauncher.init();
////
////		assertEquals("Error de inicializaci�n de hora de inicio",
////				msvCargaDocumentacionLauncher.getHoraInicio(), horaInicio);
////		assertEquals("Error de inicializaci�n de hora de fin",
////				msvCargaDocumentacionLauncher.getHoraFin(), horaFin);
////		assertEquals("Error de inicializaci�n de intervalo",
////				msvCargaDocumentacionLauncher.getIntervalo(), intervalo);
////		assertEquals("Error de inicializaci�n de directorio",
////				msvCargaDocumentacionLauncher.getDirectorio(), directorio);
////
////	}
////
////	@Before
////	public void before() {
////		when(
////				mockProperties
////						.get(MSVCargaDocumentacionLauncherApi.KEY_HORA_INICIO))
////				.thenReturn(horaInicio);
////		when(mockProperties.get(MSVCargaDocumentacionLauncherApi.KEY_HORA_FIN))
////				.thenReturn(horaFin);
////		when(mockProperties.get(MSVCargaDocumentacionLauncherApi.KEY_INTERVALO))
////				.thenReturn(intervalo);
////		when(
////				mockProperties
////						.get(MSVCargaDocumentacionLauncherApi.KEY_DIRECTORIO))
////				.thenReturn(directorio);
////	}
//
//	@After
//	public void after() {
//		reset(mockProperties);
//	}

}
