package es.pfsgroup.plugin.recovery.config.test.manager.ADMPerfilManager;

import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoMoreInteractions;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.junit.Test;

import es.capgemini.pfs.users.domain.FuncionPerfil;
import es.pfsgroup.testfwk.FieldCriteria;
import es.pfsgroup.testfwk.TestData;

public class BorrarFuncionPerfilTest extends AbstractADMPerfilManagerTest {

	@Test
	public void testBorrarFuncionPerfil() throws Exception {
		final Long ID_FUNCION = 3L;
		final Long ID_PERFIL = 4L;
		List<FuncionPerfil> fps = Arrays.asList(TestData.newTestObject(
				FuncionPerfil.class, new FieldCriteria("id", 1L)),
				TestData.newTestObject(FuncionPerfil.class, new FieldCriteria(
						"id", 2L)));

		when(funcionPerfilDao.find(ID_FUNCION, ID_PERFIL)).thenReturn(fps);
		manager.borrarFuncionPerfil(ID_PERFIL, ID_FUNCION);
		
		for (FuncionPerfil fp : fps){
			verify(funcionPerfilDao).delete(fp);
		}

	}
	
	public void testBorrarFuncionPerfil_noExisteRelacion_nohacenada() throws Exception {
		final Long ID_FUNCION = 3L;
		final Long ID_PERFIL = 4L;
		List<FuncionPerfil> fps = new ArrayList<FuncionPerfil>();

		when(funcionPerfilDao.find(ID_FUNCION, ID_PERFIL)).thenReturn(fps);
		manager.borrarFuncionPerfil(ID_PERFIL, ID_FUNCION);
		
		verify(funcionPerfilDao).find(ID_FUNCION, ID_PERFIL);
		verifyNoMoreInteractions(funcionPerfilDao);
	}
}
