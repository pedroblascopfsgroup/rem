package es.pfsgroup.recovery.recobroConfig.test.agenciasRecobro.controller.impl;

import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.ui.ModelMap;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.cirbe.model.DDPais;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.dto.RecobroAgenciaDto;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroConfig.agenciasRecobro.controller.impl.RecobroAgenciaController;
import es.pfsgroup.recovery.recobroConfig.test.AbstractRecobroControllerTest;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.RecobroAgenciasConstants;

/**
 * Clase para los test de la clase {@link RecobroAgenciaController}
 * @author diana
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class RecobroAgenciaControllerTest extends AbstractRecobroControllerTest{
	
	@InjectMocks
	RecobroAgenciaController recobroAgenciaController;
	
	@Mock
	Page mockPagina;
	
	private RecobroAgenciaDto dto;
	
	private ModelMap map;
	
	private Long idAgencia;
	
	private RecobroAgencia agencia;
	
	private List<DDTipoVia> ddTipoVia;
	private List<DDProvincia> ddProvincias;
	private List<Localidad> ddPoblacion;
	private List<DDPais> ddPais;
	
	
	@Override
	public void childBefore() {
		dto = new RecobroAgenciaDto();
		map = new ModelMap();
		idAgencia=random.nextLong();
		agencia = new RecobroAgencia();
		agencia.setId(idAgencia);
		dto.setId(idAgencia);
		ddTipoVia=new ArrayList<DDTipoVia>();
		ddProvincias = new ArrayList<DDProvincia>();
		ddPais= new ArrayList<DDPais>();
		ddPoblacion = new ArrayList<Localidad>();
		
	}

	@Override
	public void childAfter() {
		dto = null;
		map = null;
		idAgencia= null;
		agencia = null;
		ddTipoVia=null;
		ddProvincias=null;
		ddPoblacion = null;
		ddPais=null;
		
	}

	@Test
	public void testBuscarAgencia() {
		when(mockRecobroAgenciaManager.buscaAgencias(any(RecobroAgenciaDto.class))).thenReturn(mockPagina);
		
		String resultado = recobroAgenciaController.buscarAgencia(dto, map);
		
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR ,RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_LISTA_AGENCIAS_JSON , resultado);
    	
		
	}
/*
	@Test
	public void testCrearAgencia() {
		
		when(mockDiccionarioManager.dameValoresDiccionario(DDTipoVia.class)).thenReturn(ddTipoVia);
		when(mockDiccionarioManager.dameValoresDiccionario(DDProvincia.class)).thenReturn(ddProvincias);
		when(mockDiccionarioManager.dameValoresDiccionario(Localidad.class)).thenReturn(ddPoblacion);
		when(mockDiccionarioManager.dameValoresDiccionario(DDPais.class)).thenReturn(ddPais);
		when(mockDiccionarioManager.dameValoresDiccionario(DDPais.class)).thenReturn(ddPais);
		String resultado = recobroAgenciaController.crearAgencia( map);
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR,RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_ALTA_AGENCIA , resultado);
    	
	}
*/
	@Test
	public void testBorrarAgencia() {
		String resultado = recobroAgenciaController.borrarAgencia(idAgencia, map);
		
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR,RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT , resultado);
    	
	}
/*
	@Test
	public void testActualizarAgencia() {
		when(mockRecobroAgenciaManager.getAgencia(idAgencia)).thenReturn(agencia);
		
		String resultado = recobroAgenciaController.actualizarAgencia (idAgencia, map);
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR,RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_ALTA_AGENCIA  , resultado);
   	
	}
*/ 
	@Test
	public void testOpenABMAgencia() {
		String resultado = recobroAgenciaController.openABMAgencia(map);
		
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR,RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_OPEN_BUSQUEDA_AGENCIAS , resultado);
    	
	}
	
	@Test
	public void testSaveAgencia (){
		String resultado = recobroAgenciaController.saveAgencia(dto, map);
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR,RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT , resultado);
    	
	}

	

}
