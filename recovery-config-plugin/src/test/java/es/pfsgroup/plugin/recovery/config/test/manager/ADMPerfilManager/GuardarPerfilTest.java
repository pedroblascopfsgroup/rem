package es.pfsgroup.plugin.recovery.config.test.manager.ADMPerfilManager;

import static org.junit.Assert.fail;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyLong;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.Assert;
import org.junit.Test;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.users.domain.Perfil;
import es.pfsgroup.plugin.recovery.config.perfiles.dto.ADMDtoPerfil;
import es.pfsgroup.recovery.ext.impl.perfil.model.EXTPerfil;
import es.pfsgroup.testfwk.TestData;

public class GuardarPerfilTest extends AbstractADMPerfilManagerTest {

	@Test
	public void testNuevoPerfil() throws Exception {
		final Long NEW_ID = 200L;
		ADMDtoPerfil dto = new ADMDtoPerfil();
		dto.setDescripcion("descripcion");
		dto.setDescripcionLarga("descripcion larga");
		EXTPerfil mockPerfil = mock(EXTPerfil.class);
		when(perfilDao.createNew()).thenReturn(mockPerfil);
		when(perfilDao.getLastCodigo()).thenReturn(42L);
		when(perfilDao.save(mockPerfil)).thenReturn(NEW_ID);

		Perfil result = manager.guardaPerfil(dto);

		verify(mockPerfil).setId(NEW_ID);
		verify(mockPerfil).setCodigo("43");
		verify(mockPerfil).setDescripcion(dto.getDescripcion());
		verify(mockPerfil).setDescripcionLarga(dto.getDescripcionLarga());
		verify(perfilDao, times(1)).save(mockPerfil);
		Assert.assertEquals(mockPerfil, result);
	}

	@Test
	public void testActualizarPerfil() throws Exception {
		ADMDtoPerfil dto = TestData.newTestObject(ADMDtoPerfil.class);
		EXTPerfil mockPerfil = mock(EXTPerfil.class);

		when(perfilDao.get(dto.getId())).thenReturn(mockPerfil);
		Perfil result = manager.guardaPerfil(dto);

		verify(mockPerfil).setDescripcion(dto.getDescripcion());
		verify(mockPerfil).setDescripcionLarga(dto.getDescripcionLarga());

		verify(perfilDao, times(1)).saveOrUpdate(mockPerfil);

		verify(mockPerfil, never()).setCodigo(anyString());
		verify(mockPerfil, never()).setId(anyLong());
		Assert.assertEquals(mockPerfil, result);
	}

	@Test
	public void testNuevoActualizar_dtoSinDatos_lanzarExcepcion() {
		ADMDtoPerfil dto = new ADMDtoPerfil();

		try {
			manager.guardaPerfil(dto);
			fail("Se deber�a haber lanzado la excepci�n");
		} catch (BusinessOperationException e) {
		}
		verify(perfilDao, never()).saveOrUpdate(any(EXTPerfil.class));
		verify(perfilDao, never()).save(any(EXTPerfil.class));

		dto.setId(1L);
		try {
			manager.guardaPerfil(dto);
			fail("Se deber�a haber lanzado la excepci�n");
		} catch (BusinessOperationException e) {
		}
		verify(perfilDao, never()).saveOrUpdate(any(EXTPerfil.class));
		verify(perfilDao, never()).save(any(EXTPerfil.class));

		dto.setDescripcion("");
		dto.setDescripcionLarga("");
		try {
			manager.guardaPerfil(dto);
			fail("Se deber�a haber lanzado la excepci�n");
		} catch (BusinessOperationException e) {
		}
		verify(perfilDao, never()).saveOrUpdate(any(EXTPerfil.class));
		verify(perfilDao, never()).save(any(EXTPerfil.class));

	}
}
