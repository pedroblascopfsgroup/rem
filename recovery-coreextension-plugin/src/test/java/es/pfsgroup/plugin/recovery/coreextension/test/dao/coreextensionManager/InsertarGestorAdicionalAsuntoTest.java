package es.pfsgroup.plugin.recovery.coreextension.test.dao.coreextensionManager;

import static org.mockito.Matchers.*;
import static org.mockito.Mockito.*;

import org.apache.commons.lang.math.RandomUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.multigestor.dao.EXTGestorAdicionalAsuntoDao;
import es.capgemini.pfs.multigestor.dao.EXTGestorAdicionalAsuntoHistoricoDao;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsuntoHistorico;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

/**
 * Tests del m�todo {@link es.pfsgroup.plugin.recovery.coreextension.dao.coreextensionManager#insertarGestorAdicionalAsunto(Long, Long, Long, Long)}
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class InsertarGestorAdicionalAsuntoTest extends AbstractCoreextensionManagerTest {

	@Mock
	private EXTAsunto mockAsunto;
	
	@Mock 
	AsuntoApi mockAsuntoApi;

	@Mock
	EXTGestorAdicionalAsuntoDao mockGestorAdicionalAsuntoDao;
	
	@Mock
	EXTGestorAdicionalAsuntoHistoricoDao mockGestorAdicionalAsuntoHistoricoDao;

	@Override
	public void childBefore() {
		
		when(mockProxyFactory.proxy(AsuntoApi.class)).thenReturn(mockAsuntoApi);

	}

	@Override
	public void childAfter() {
		reset(mockAsuntoApi);
		reset(mockGestorAdicionalAsuntoDao);
		reset(mockGestorAdicionalAsuntoHistoricoDao);
		
	}
	
	/**
	 * Test nuevo gestor.
	 * @throws Exception 
	 */
	@Test
	public void testInsertarGestorAdicionalAsunto() throws Exception{
		
		Long idAsunto = RandomUtils.nextLong();
		Long idTipoGestor = RandomUtils.nextLong();
		Long idUsuario = RandomUtils.nextLong();
		Long idTipoDespacho = RandomUtils.nextLong();
		
		when(mockProxyFactory.proxy(AsuntoApi.class).get(idAsunto)).thenReturn(mockAsunto);

		try {
			coreextensionManager.insertarGestorAdicionalAsunto(idTipoGestor, idAsunto, idUsuario, idTipoDespacho);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		verify(mockGestorAdicionalAsuntoDao, times(1)).save(any(EXTGestorAdicionalAsunto.class));
		verify(mockGestorAdicionalAsuntoHistoricoDao, times(1)).save(any(EXTGestorAdicionalAsuntoHistorico.class));
		
	}
	
	/**
	 * Test actualizar gestor.
	 * @throws Exception 
	 */
	@Test
	public void testActualizarGestorAdicionalAsunto() throws Exception{
		
		Long idAsunto = RandomUtils.nextLong();
		Long idTipoGestor = RandomUtils.nextLong();
		Long idUsuario = RandomUtils.nextLong();
		Long idTipoDespacho = RandomUtils.nextLong();
		
		EXTGestorAdicionalAsunto gaa = mock(EXTGestorAdicionalAsunto.class);
		GestorDespacho gestor = mock(GestorDespacho.class);
		Usuario usuario = mock(Usuario.class);
		
		when(mockProxyFactory.proxy(AsuntoApi.class).get(idAsunto)).thenReturn(mockAsunto);
		when(mockGenericDao.get(eq(EXTGestorAdicionalAsunto.class), any(Filter.class), any(Filter.class))).thenReturn(gaa);
		
		when(gaa.getGestor()).thenReturn(gestor);
		when(gestor.getUsuario()).thenReturn(usuario);
		when(usuario.getId()).thenReturn(RandomUtils.nextLong());
		
		try {
			coreextensionManager.insertarGestorAdicionalAsunto(idTipoGestor, idAsunto, idUsuario, idTipoDespacho);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		verify(mockGestorAdicionalAsuntoDao, times(1)).saveOrUpdate(any(EXTGestorAdicionalAsunto.class));
		verify(mockGestorAdicionalAsuntoHistoricoDao, times(1)).actualizaFechaHasta(idAsunto, idTipoGestor);
		verify(mockGestorAdicionalAsuntoHistoricoDao, times(1)).save(any(EXTGestorAdicionalAsuntoHistorico.class));
		
	}
	
	/**
	 * Test. Se acctualiza el gestor con el mismo gestor que ya era gestor, es decir, el idUsuario es igual a gestor.usuario.id.
	 * @throws Exception 
	 */
	@Test
	public void testActualizarGestorConUnGestorYaExistente() throws Exception{
		
		Long idAsunto = RandomUtils.nextLong();
		Long idTipoGestor = RandomUtils.nextLong();
		Long idUsuario = RandomUtils.nextLong();
		Long idTipoDespacho = RandomUtils.nextLong();
		
		EXTGestorAdicionalAsunto gaa = mock(EXTGestorAdicionalAsunto.class);
		GestorDespacho gestor = mock(GestorDespacho.class);
		Usuario usuario = mock(Usuario.class);
		
		when(mockProxyFactory.proxy(AsuntoApi.class).get(idAsunto)).thenReturn(mockAsunto);
		when(mockGenericDao.get(eq(EXTGestorAdicionalAsunto.class), any(Filter.class), any(Filter.class))).thenReturn(gaa);
		
		when(gaa.getGestor()).thenReturn(gestor);
		when(gestor.getUsuario()).thenReturn(usuario);
		when(usuario.getId()).thenReturn(idUsuario);
		
		try {
			coreextensionManager.insertarGestorAdicionalAsunto(idTipoGestor, idAsunto, idUsuario, idTipoDespacho);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		verify(mockGestorAdicionalAsuntoDao, times(1)).saveOrUpdate(any(EXTGestorAdicionalAsunto.class));
		verify(mockGestorAdicionalAsuntoHistoricoDao, never()).actualizaFechaHasta(idAsunto, idTipoGestor);
		verify(mockGestorAdicionalAsuntoHistoricoDao, never()).save(any(EXTGestorAdicionalAsuntoHistorico.class));
		
	}

}
