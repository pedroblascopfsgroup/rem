package es.pfsgroup.plugin.recovery.masivo.test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.fail;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.mockito.Mockito.mock;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import org.junit.After;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVNotificacionDemandadosManager;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVDemandadosDao;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVDireccionFechaNotificacionDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVFechasNotificacionDto;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVDireccionFechaNotificacion;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoDemandado;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoNotificacion;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoNotificacionFilter;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoResumen;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoResumenPersona;
import es.pfsgroup.recovery.api.ProcedimientoApi;

/**
 * Tests de la clase MSVNotificacionDemandadosManager
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class MSVNotificacionDemandadosManagerTest {
	
	@InjectMocks MSVNotificacionDemandadosManager msvNotificacionDemandadosManager;
	
	@Mock private MSVDemandadosDao mockMSVDemandadosDao;
	@Mock private MSVDireccionFechaNotificacionDao mockMSVDireccionFechaNotificacionDao;
	@Mock private ApiProxyFactory mockProxyFactory;
	@Mock private ProcedimientoApi mockProcedimientoApi;
//	@Mock private MSVInfoNotificacion mockMSVInfoNotificacion;

	private Random r = new Random();
	
	@After
	public void after(){
		reset(mockMSVDemandadosDao);
		reset(mockMSVDireccionFechaNotificacionDao);
		reset(mockProxyFactory);
//		reset(mockMSVInfoNotificacion);
		reset(mockProcedimientoApi);
	}
	
	/**
	 * Test del m�todo getResumenNotificaciones(idProcedimiento)
	 */
	@Test
	public void tesGetResumenNotificaciones(){
		
		Long idProcedimiento = null;
		List<MSVInfoResumen> result = null;
		List<MSVInfoDemandado> msvInfoDemandados = new ArrayList<MSVInfoDemandado>();
		List<MSVDireccionFechaNotificacion> msvDireccionFechaNotificacion = new ArrayList<MSVDireccionFechaNotificacion>();
		List<MSVInfoResumen> infoResumen = new ArrayList<MSVInfoResumen>();
		
		//Comportamiento general del m�todo.
		when(mockMSVDemandadosDao.getDemandadosYDomicilios(idProcedimiento)).thenReturn(msvInfoDemandados);
		when(mockMSVDireccionFechaNotificacionDao.getFechasNotificacion(idProcedimiento)).thenReturn(msvDireccionFechaNotificacion);
//		when(mockMSVInfoNotificacion.getInfoResumen()).thenReturn(infoResumen);
		
		//Comprobamos que salta la excepci�n si idProcedimiento es nulo.
		try {
			result = msvNotificacionDemandadosManager.getResumenNotificaciones(idProcedimiento);
			fail("No ha saltado la excepci�n de idProcedimiento null");
		} catch (Exception e) {
			
		}
		
		//Comprobamos el proceso de ejecuci�n normal.
		idProcedimiento = r .nextLong();
		
		//Como este m�todo se ejecuta dentro del m�todo de pruebas invocamos su simulaci�n.
		this.simulaPopulateInfoNotificacion(idProcedimiento);

		try {
			result = msvNotificacionDemandadosManager.getResumenNotificaciones(idProcedimiento);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Error en la ejecuci�n del proceso getResumenNotificaciones");
		}
		
		//Comprobamos que el resultado no es nulo.
		assertNotNull(result);
		//Comprobamos que se rellenan los demandados, los domicilios y las fechas.			
		verify(mockMSVDemandadosDao, times(1)).getDemandadosYDomicilios(idProcedimiento);
		verify(mockMSVDireccionFechaNotificacionDao, times(1)).getFechasNotificacion(idProcedimiento);
		//Comprobamos que el procedimiento es el correcto.
		assertEquals(infoResumen.size(), result.size());
	}
	
	@Test
	public void testGetDetalleNotificaciones(){
		
		//Comprobamos que salta la excepci�n si idPersona es nulo.
		Random r = new Random();
		Long idProcedimiento = r.nextLong();
		Long idPersona = null;
		List<MSVInfoResumenPersona> result = null;
		//List<MSVInfoResumenPersona> infoResumenPersona = new ArrayList<MSVInfoResumenPersona>();
		try {
			msvNotificacionDemandadosManager.getDetalleNotificaciones(idProcedimiento, idPersona);
			fail("No ha saltado la excepci�n de idPersona null");
		} catch (Exception e) {}
		
		//Comprobamos que salta la excepci�n si idProcedimiento es nulo.
		idProcedimiento = null;
		idPersona = r.nextLong();
		try {
			msvNotificacionDemandadosManager.getDetalleNotificaciones(idProcedimiento, idPersona);
			fail("No ha saltado la excepci�n de idProcedimiento null");
		} catch (Exception e) {	}
		
		//Comprobamos el proceso de ejecuci�n normal.
		idProcedimiento = r.nextLong();
		idPersona = r.nextLong();
		
		//Como este m�todo se ejecuta dentro del m�todo de pruebas invocamos su simulaci�n.
		this.simulaPopulateInfoNotificacion(idProcedimiento);
//		when(mockMSVInfoNotificacion.getInfoResumenPersona()).thenReturn(infoResumenPersona);
		
		try {
			result = msvNotificacionDemandadosManager.getDetalleNotificaciones(idProcedimiento, idPersona);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Error en la ejecuci�n del proceso getDetalleNotificaciones");
		}
		
		//Comprobamos que el resultado no es nulo.
		assertNotNull(result);
		
		//Comprobamos la ejecuci�n del proceso.
//		ArgumentCaptor<MSVInfoNotificacionFilter> argFiltro = ArgumentCaptor.forClass(MSVInfoNotificacionFilter.class);
//		verify(mockMSVInfoNotificacion, times(1)).addFiltro(argFiltro.capture());
//		verify(mockMSVInfoNotificacion, times(1)).filtra();
//		verify(mockMSVInfoNotificacion, times(1)).getInfoResumenPersona();
		
		//Comprobamos que los datos del filtro se rellenan correctamente.
//		assertEquals("El idPersona no se pasa correctamente al filtro.",idPersona, argFiltro.getValue().getIdPersona());
//		assertEquals("El tipo de filtro no es correcto.",MSVInfoNotificacionFilter.FILTRO_PESONA, argFiltro.getValue().getTipoFiltro());
	}
	
	@Test
	public void testGetHistoricoDetalleNotificaciones() throws Exception{
		//Comprobamos que salta la excepci�n si idPersona es nulo.
		Random r = new Random();
		MSVFechasNotificacionDto dto = new MSVFechasNotificacionDto();
		Long idProcedimiento = r.nextLong();
		Long idPersona = null;
		String idDireccion = null;
		String tipoFecha = MSVDireccionFechaNotificacion.CODIGO_TIPO_FECHA_AVERIGUACION;
		List<MSVDireccionFechaNotificacion> result = null;
		//List<MSVDireccionFechaNotificacion> infoFechasNotificacion = new ArrayList<MSVDireccionFechaNotificacion>();

		try {
			dto.setIdPersona(idPersona);
			dto.setIdProcedimiento(idProcedimiento);
			dto.setTipoFecha(tipoFecha);
			msvNotificacionDemandadosManager.getHistoricoDetalleNotificaciones(dto);
			fail("No ha saltado la excepci�n de idPersona null");
		} catch (BusinessOperationException e) {}
		
		//Comprobamos que salta la excepci�n si idProcedimiento es nulo.
		idProcedimiento = null;
		idPersona = r.nextLong();
		tipoFecha = MSVDireccionFechaNotificacion.CODIGO_TIPO_FECHA_AVERIGUACION;
		try {
			dto.setIdPersona(idPersona);
			dto.setIdProcedimiento(idProcedimiento);
			dto.setTipoFecha(tipoFecha);
			msvNotificacionDemandadosManager.getHistoricoDetalleNotificaciones(dto);
			fail("No ha saltado la excepci�n de idProcedimiento null");
		} catch (BusinessOperationException e) {	}
		
		//Comprobamos que salta la excepci�n si idProcedimiento es nulo.
		idProcedimiento = r.nextLong();
		idPersona = r.nextLong();
		tipoFecha = null;
		try {
			dto.setIdPersona(idPersona);
			dto.setIdProcedimiento(idProcedimiento);
			dto.setTipoFecha(tipoFecha);
			msvNotificacionDemandadosManager.getHistoricoDetalleNotificaciones(dto);
			fail("No ha saltado la excepci�n de idProcedimiento null");
		} catch (BusinessOperationException e) {	}
		
		//Comprobamos el proceso de ejecuci�n normal.
		idProcedimiento = r.nextLong();
		idPersona = r.nextLong();
		idDireccion = String.valueOf(r.nextLong());
		tipoFecha = MSVDireccionFechaNotificacion.CODIGO_TIPO_FECHA_AVERIGUACION;
		dto.setIdPersona(idPersona);
		dto.setIdProcedimiento(idProcedimiento);
		dto.setIdDireccion(idDireccion);
		dto.setTipoFecha(tipoFecha);
		
		//Como este m�todo se ejecuta dentro del m�todo de pruebas invocamos su simulaci�n.
		this.simulaPopulateInfoNotificacion(idProcedimiento);
//		when(mockMSVInfoNotificacion.getInfoFechasNotificacion()).thenReturn(infoFechasNotificacion);		
		
		try {
			result = msvNotificacionDemandadosManager.getHistoricoDetalleNotificaciones(dto);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Error en la ejecuci�n del proceso getDetalleNotificaciones");
		}
		
		//Comprobamos que el resultado no es nulo.
		assertNotNull(result);
		
		//Comprobamos la ejecuci�n del proceso.
//		ArgumentCaptor<MSVInfoNotificacionFilter> argFiltro = ArgumentCaptor.forClass(MSVInfoNotificacionFilter.class);
//		verify(mockMSVInfoNotificacion, times(3)).addFiltro(argFiltro.capture());
//		verify(mockMSVInfoNotificacion, times(1)).filtra();
//		verify(mockMSVInfoNotificacion, times(1)).getInfoFechasNotificacion();
		
		//Comprobamos que los datos del filtro se rellenan correctamente.
//		assertEquals("El idPersona no se pasa correctamente al filtro.",idPersona, argFiltro.getAllValues().get(0).getIdPersona());
//		assertEquals("El tipo de filtro no es correcto.",MSVInfoNotificacionFilter.FILTRO_PESONA, argFiltro.getAllValues().get(0).getTipoFiltro());		
//
//		assertEquals("El idPersona no se pasa correctamente al filtro.",idDireccion, argFiltro.getAllValues().get(1).getIdDireccion());
//		assertEquals("El tipo de filtro no es correcto.",MSVInfoNotificacionFilter.FILTRO_DIRECCION, argFiltro.getAllValues().get(1).getTipoFiltro());		
//
//		assertEquals("El idPersona no se pasa correctamente al filtro.",tipoFecha, argFiltro.getAllValues().get(2).getTipoFecha());
//		assertEquals("El tipo de filtro no es correcto.",MSVInfoNotificacionFilter.FILTRO_TIPO_FECHA, argFiltro.getAllValues().get(2).getTipoFiltro());		

		
	}
	
	/**
	 * Test del m�todo MSVDireccionFechaNotificacion updateNotificacion(MSVFechasNotificacionDto dto) throws Exception
	 * @throws Exception 
	 */
	@Test
	public void testUpdateNotificacion() throws Exception{
		
		SimpleDateFormat df = new SimpleDateFormat(MSVNotificacionDemandadosManager.DATE_FORMAT);
		Random r = new Random();
		MSVFechasNotificacionDto dto = new MSVFechasNotificacionDto();
		dto.setId(r.nextLong());
		MSVDireccionFechaNotificacion msvDireccionFechaNotificacion = new MSVDireccionFechaNotificacion();
		msvDireccionFechaNotificacion.setId(dto.getId());
		
		ArgumentCaptor<MSVDireccionFechaNotificacion> argDireccion = ArgumentCaptor.forClass(MSVDireccionFechaNotificacion.class);
		
		// Prueba 1
		//Simulamos que no existe el objeto MSVDireccionFechaNotificacion.
		when(mockMSVDireccionFechaNotificacionDao.get(any(Long.class))).thenReturn(null);
		
		try{
			msvNotificacionDemandadosManager.updateNotificacion(dto);
			fail("No se ha lanzado la excepci�n.");
		}catch(BusinessOperationException ex){}

		verify(mockMSVDireccionFechaNotificacionDao, times(1)).get(any(Long.class));
		
		//Funcionamiento general del m�todo.
		when(mockMSVDireccionFechaNotificacionDao.get(any(Long.class))).thenReturn(msvDireccionFechaNotificacion);
		this.simulaPopulateFechasNotificacion(dto, null);
		
		//Prueba 2
		//Error en las fechas
		dto.setFechaResultado("fff");
		dto.setFechaSolicitud("25/12/2013");
		try{
			msvNotificacionDemandadosManager.updateNotificacion(dto);
			fail("No se ha lanzado la excepci�n de fechas.");
		}catch(BusinessOperationException ex){}
		
		verify(mockMSVDireccionFechaNotificacionDao, times(2)).get(any(Long.class));
		
		//Prueba 3
		//Simulamos el caso normal de funcionamiento.
		dto.setFechaResultado("25/12/2013");
		dto.setFechaSolicitud("22/10/2012");

		msvNotificacionDemandadosManager.updateNotificacion(dto);
		
		//Comprobamos la ejecuci�n del proceso.

		verify(mockMSVDireccionFechaNotificacionDao, times(3)).get(any(Long.class));
		verify(mockMSVDireccionFechaNotificacionDao, times(1)).saveOrUpdate(argDireccion.capture());
		
		assertEquals("No coincide el id del objeto", msvDireccionFechaNotificacion.getId(), argDireccion.getValue().getId());
		assertEquals("No coincide la fecha Resultado.", df.parse(dto.getFechaResultado()), argDireccion.getValue().getFechaResultado());
		assertEquals("No coincide la fecha Solicitud.", df.parse(dto.getFechaSolicitud()), argDireccion.getValue().getFechaSolicitud());
	}

	/**
	 * Test del m�todo MSVDireccionFechaNotificacion insertNotificacion(MSVFechasNotificacionDto dto) throws Exception
	 * @throws Exception
	 */
	@Test
	public void testInsertNotificacion() throws Exception{
		
		SimpleDateFormat df = new SimpleDateFormat(MSVNotificacionDemandadosManager.DATE_FORMAT);
		Random r = new Random();
		MSVFechasNotificacionDto dto = new MSVFechasNotificacionDto();
		Long idProcedimiento = r.nextLong();
		Long idPersona = r.nextLong();
		String idDireccion = String.valueOf(r.nextLong());
		dto.setIdProcedimiento(null);
		dto.setIdPersona(idPersona);
		dto.setIdDireccion(idDireccion);
		
		List<Direccion> direcciones = new ArrayList<Direccion>();
		List<Persona> personasAfectadas = new ArrayList<Persona>();
		Persona p = new Persona();
		p.setId(dto.getIdPersona());
		Direccion d = new Direccion();
		d.setCodDireccion(idDireccion);
		direcciones.add(d);
		p.setDirecciones(direcciones);
		personasAfectadas.add(p);
		
		try{
			msvNotificacionDemandadosManager.insertNotificacion(dto);
			fail("No se ha lanzado la excepci�n");
		}catch(BusinessOperationException ex){}
		
		dto.setIdProcedimiento(idProcedimiento);
		dto.setIdPersona(null);
		try{
			msvNotificacionDemandadosManager.insertNotificacion(dto);
			fail("No se ha lanzado la excepci�n");
		}catch(BusinessOperationException ex){}
		
		dto.setIdProcedimiento(idProcedimiento);
		dto.setIdPersona(idPersona);
		
		//Error en las fechas
		dto.setFechaResultado("fff");
		try{
			msvNotificacionDemandadosManager.insertNotificacion(dto);
			fail("No se ha lanzado la excepci�n");
		}catch(BusinessOperationException ex){}		
		
		//Funcionamiento general del m�todo.
		this.simulaPopulateFechasNotificacion(dto, personasAfectadas);
		

		//Simulamos el caso normal de funcionamiento.
		dto.setFechaResultado("25/12/2013");
		dto.setFechaSolicitud("22/10/2012");		
		MSVDireccionFechaNotificacion result = msvNotificacionDemandadosManager.insertNotificacion(dto);

		//Comprobamos el resultado.
		assertNotNull("resultado null",result);
		assertEquals("El resultado no es correcto", MSVDireccionFechaNotificacion.class, result.getClass());
		
		//Comprobamos que se insertan los datos correctamente.
		ArgumentCaptor<MSVDireccionFechaNotificacion> argDireccion = ArgumentCaptor.forClass(MSVDireccionFechaNotificacion.class);
		verify(mockMSVDireccionFechaNotificacionDao, times(1)).save(argDireccion.capture());
		
		assertEquals("No coincide la fecha Resultado.", df.parse(dto.getFechaResultado()), argDireccion.getValue().getFechaResultado());
		assertEquals("No coincide la fecha Solicitud.", df.parse(dto.getFechaSolicitud()), argDireccion.getValue().getFechaSolicitud());
		assertEquals("No coincide la direcci�n.", dto.getIdDireccion(), argDireccion.getValue().getDireccion().getCodDireccion());
		assertEquals("No coincide la persona.", dto.getIdPersona(), argDireccion.getValue().getPersona().getId());
		assertEquals("No coincide el procedimiento.", dto.getIdProcedimiento(), argDireccion.getValue().getProcedimiento().getId());
		
	}


	/**
	 * Test del m�todo MSVDireccionFechaNotificacion updateExcluido(MSVFechasNotificacionDto dto) throws Exception
	 * @throws Exception 
	 */
	@Test
	public void testUpdateExcluido() throws Exception{
		
//		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
		Random r = new Random();

		
		
		MSVFechasNotificacionDto dto = new MSVFechasNotificacionDto();
		
		dto.setIdProcedimiento(r.nextLong());
		dto.setIdPersona(r.nextLong());
		dto.setExcluido(true);
		
		
		
		// Prueba 1
		//Simulamos que no se encuentra la notificacion y por tanto se crea.
		when(mockMSVDireccionFechaNotificacionDao.getFechasNotificacionPorPersona(dto.getIdProcedimiento(), dto.getIdPersona())).thenReturn(null);				
		this.simulaInsertNotificacion(dto);
		
		MSVDireccionFechaNotificacion msvDireccionFechaNotificacionReturn = msvNotificacionDemandadosManager.updateExcluido(dto);
		//Verifica que ha ejecutado el insert
		verify(mockMSVDireccionFechaNotificacionDao, times(1)).save(any(MSVDireccionFechaNotificacion.class));
		
		assertEquals("No coincide el id del Procedimiento", msvDireccionFechaNotificacionReturn.getProcedimiento().getId(), dto.getIdProcedimiento());
		assertEquals("No coincide el id de la Persona", msvDireccionFechaNotificacionReturn.getPersona().getId(), dto.getIdPersona());
		assertEquals("No coincide la propiedad excluido", msvDireccionFechaNotificacionReturn.getExcluido(), dto.getExcluido());
		
		
		//Prueba 2
		//Simulamos que encuentra la notificaci�n y las modifica todas
		dto.setIdProcedimiento(r.nextLong());
		dto.setIdPersona(r.nextLong());
		
		List<MSVDireccionFechaNotificacion> msvDireccionesFechaNotificacion = new ArrayList<MSVDireccionFechaNotificacion>();
		Procedimiento mockPrc = mock(Procedimiento.class);
		when(mockPrc.getId()).thenReturn(r.nextLong());
		
		Persona mockPersona = mock(Persona.class);
		when(mockPersona.getId()).thenReturn(r.nextLong());
		
		for (int i=0;i<=3;i++) {
			MSVDireccionFechaNotificacion msvDireccionFechaNotificacion = new MSVDireccionFechaNotificacion();
			msvDireccionFechaNotificacion.setId(r.nextLong());
			msvDireccionFechaNotificacion.setProcedimiento(mockPrc);
			msvDireccionFechaNotificacion.setPersona(mockPersona);
			
			msvDireccionesFechaNotificacion.add(msvDireccionFechaNotificacion);
			when(mockMSVDireccionFechaNotificacionDao.get(msvDireccionFechaNotificacion.getId())).thenReturn(msvDireccionFechaNotificacion);
		}
		
		when(mockMSVDireccionFechaNotificacionDao.getFechasNotificacionPorPersona(dto.getIdProcedimiento(), dto.getIdPersona())).thenReturn(msvDireccionesFechaNotificacion);				
		msvDireccionFechaNotificacionReturn = msvNotificacionDemandadosManager.updateExcluido(dto);
		
		verify(mockMSVDireccionFechaNotificacionDao, times(4)).saveOrUpdate(any(MSVDireccionFechaNotificacion.class));
		assertEquals("No coincide el id del Procedimiento", msvDireccionFechaNotificacionReturn.getProcedimiento().getId(), dto.getIdProcedimiento());
		assertEquals("No coincide el id de la Persona", msvDireccionFechaNotificacionReturn.getPersona().getId(), dto.getIdPersona());
		assertEquals("No coincide la propiedad excluido", msvDireccionFechaNotificacionReturn.getExcluido(), dto.getExcluido());
		
	}
	
	private void simulaInsertNotificacion(MSVFechasNotificacionDto dto) {
		String idDireccion = String.valueOf(r.nextLong());
		
		List<Direccion> direcciones = new ArrayList<Direccion>();
		List<Persona> personasAfectadas = new ArrayList<Persona>();
		Persona p = new Persona();
		p.setId(dto.getIdPersona());
		Direccion d = new Direccion();
		d.setCodDireccion(idDireccion);
		direcciones.add(d);
		p.setDirecciones(direcciones);
		personasAfectadas.add(p);
		
		//Funcionamiento general del m�todo.
		this.simulaPopulateFechasNotificacion(dto, personasAfectadas);
		
	}
	/**
	 * M�todo que simula el funcionamiento del m�todo insertNotificacion(MSVFechasNotificacionDto dto) throws Exception
	 * @param dto
	 * @param personasAfectadas 
	 * @param msvDireccionFechaNotificacion
	 */
	private void simulaPopulateFechasNotificacion(MSVFechasNotificacionDto dto, List<Persona> personasAfectadas) {
		
		Procedimiento procedimiento = new Procedimiento();
		procedimiento.setId(dto.getIdProcedimiento());
		procedimiento.setPersonasAfectadas(personasAfectadas);
		
		when(mockProxyFactory.proxy(ProcedimientoApi.class)).thenReturn(mockProcedimientoApi);
		when(mockProcedimientoApi.getProcedimiento(dto.getIdProcedimiento())).thenReturn(procedimiento);
		
	}
	
	
	/**
	 * M�todo que simula el funcionamiento del m�todo privado MSVInfoNotificacion createInfoNotificacion(Long idProcedimiento);
	 * @param idProcedimiento
	 */
	private void simulaPopulateInfoNotificacion(Long idProcedimiento) {

		Procedimiento procedimiento = new Procedimiento();
		procedimiento.setId(idProcedimiento);
		List<MSVInfoDemandado> demandados = new ArrayList<MSVInfoDemandado>();
		List<MSVDireccionFechaNotificacion> fechas = new ArrayList<MSVDireccionFechaNotificacion>();
		
		when(mockProxyFactory.proxy(ProcedimientoApi.class)).thenReturn(mockProcedimientoApi);
		when(mockProcedimientoApi.getProcedimiento(idProcedimiento)).thenReturn(procedimiento);
		when(mockMSVDemandadosDao.getDemandadosYDomicilios(idProcedimiento)).thenReturn(demandados);
		when(mockMSVDireccionFechaNotificacionDao.getFechasNotificacion(idProcedimiento)).thenReturn(fechas);
		
	}

}
