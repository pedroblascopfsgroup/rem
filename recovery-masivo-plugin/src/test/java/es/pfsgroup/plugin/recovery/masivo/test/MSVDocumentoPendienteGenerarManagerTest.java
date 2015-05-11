package es.pfsgroup.plugin.recovery.masivo.test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.mockito.Matchers.anyLong;
import static org.mockito.Mockito.when;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVDocumentoPendienteGenerarManager;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDocumentoPendienteDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.documentacionPendiente.MSVDocumentoPendienteGenerar;
import es.pfsgroup.procedimientos.recoveryapi.ProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDDTipoInput;

@RunWith(MockitoJUnitRunner.class)
public class MSVDocumentoPendienteGenerarManagerTest {
	
	@InjectMocks 
	MSVDocumentoPendienteGenerarManager documentoPendienteGenerarManager;
	
	@Mock
	GenericABMDao mockGenericDao;
	
	@Mock
	ApiProxyFactory mockProxy;
	
	@Mock
	ProcedimientoApi mockProcedimientoApi;

	@Test
	public void testCrearNuevoDocumentoPendiente() {
		MSVDocumentoPendienteDto dto=new MSVDocumentoPendienteDto();
		dto.setIdProcedimiento(1L);
		dto.setCodigoTipoInput("INPUT");
		dto.setCodigoTipoProcedimiento("TIPO_PROCEDIMIENTO");
		dto.setCodigoEstado(MSVDDEstadoProceso.CODIGO_PTE_PROCESAR);
		MSVDDEstadoProceso estadoProceso=new MSVDDEstadoProceso();
		estadoProceso.setCodigo(MSVDDEstadoProceso.CODIGO_PTE_PROCESAR);
		Procedimiento procedimiento=new Procedimiento();
		TipoProcedimiento tipoProcedimiento=new TipoProcedimiento();
		tipoProcedimiento.setCodigo("TIPO_PROCEDIMIENTO");
		RecoveryBPMfwkDDTipoInput tipoInput=new RecoveryBPMfwkDDTipoInput();
		tipoInput.setCodigo("INPUT");
		Asunto asunto=new Asunto();
		procedimiento.setId(1L);
		procedimiento.setTipoProcedimiento(tipoProcedimiento);
		procedimiento.setAsunto(asunto);
		
		when(mockProxy.proxy(ProcedimientoApi.class)).thenReturn(mockProcedimientoApi);
		
		when(mockGenericDao.get(RecoveryBPMfwkDDTipoInput.class, mockGenericDao.createFilter(FilterType.EQUALS, "codigo", "INPUT"))).thenReturn(tipoInput);
		when(mockGenericDao.get(MSVDDEstadoProceso.class, mockGenericDao.createFilter(FilterType.EQUALS, "codigo", MSVDDEstadoProceso.CODIGO_PTE_PROCESAR))).thenReturn(estadoProceso);
		when(mockProcedimientoApi.getProcedimiento(anyLong())).thenReturn(procedimiento);
		when(mockGenericDao.get(TipoProcedimiento.class, mockGenericDao.createFilter(FilterType.EQUALS, "codigo", "TIPO_PROCEDIMIENTO"))).thenReturn(tipoProcedimiento);
		
		MSVDocumentoPendienteGenerar resultado= documentoPendienteGenerarManager.crearNuevoDocumentoPendiente(dto);
		
		assertNotNull(resultado);
	}

	@Test
	public void testModificarDocumentoPendiente() {
		MSVDocumentoPendienteGenerar documento=new MSVDocumentoPendienteGenerar();
		documento.setId(1L);
		
		MSVDocumentoPendienteDto dto=new MSVDocumentoPendienteDto();
		dto.setId(1L);
		dto.setCodigoTipoProcedimiento("TIPO_PROCEDIMIENTO");
		dto.setCodigoEstado(MSVDDEstadoProceso.CODIGO_EN_PROCESO);
		MSVDDEstadoProceso estadoProceso=new MSVDDEstadoProceso();
		estadoProceso.setCodigo(MSVDDEstadoProceso.CODIGO_EN_PROCESO);
		
		when(mockGenericDao.get(MSVDocumentoPendienteGenerar.class, mockGenericDao.createFilter(FilterType.EQUALS, "id", 1L))).thenReturn(documento);
		when(mockGenericDao.get(MSVDDEstadoProceso.class, mockGenericDao.createFilter(FilterType.EQUALS, "codigo", MSVDDEstadoProceso.CODIGO_PTE_PROCESAR))).thenReturn(estadoProceso);
		
		documentoPendienteGenerarManager.modificarDocumentoPendiente(dto);
		
		assertEquals(MSVDDEstadoProceso.CODIGO_EN_PROCESO, documento.getEstadoProceso().getCodigo());
	}
	
	@Test
	public void testModificarDocumentoPendienteByToken() {
		MSVDocumentoPendienteGenerar documento=new MSVDocumentoPendienteGenerar();
		documento.setId(1L);
		
		MSVDocumentoPendienteDto dto=new MSVDocumentoPendienteDto();
		dto.setToken(1L);
		dto.setCodigoTipoProcedimiento("TIPO_PROCEDIMIENTO");
		dto.setCodigoEstado(MSVDDEstadoProceso.CODIGO_EN_PROCESO);
		MSVDDEstadoProceso estadoProceso=new MSVDDEstadoProceso();
		estadoProceso.setCodigo(MSVDDEstadoProceso.CODIGO_EN_PROCESO);
		
		when(mockGenericDao.get(MSVDDEstadoProceso.class, mockGenericDao.createFilter(FilterType.EQUALS, "codigo", MSVDDEstadoProceso.CODIGO_PTE_PROCESAR))).thenReturn(estadoProceso);
		when(mockGenericDao.get(MSVDocumentoPendienteGenerar.class, mockGenericDao.createFilter(FilterType.EQUALS, "codigo", 1L))).thenReturn(documento);
		
		documentoPendienteGenerarManager.modificarDocumentoPendiente(dto);
		
		assertEquals(MSVDDEstadoProceso.CODIGO_EN_PROCESO, documento.getEstadoProceso().getCodigo());
	}

	@Test
	public void testGetDocumentoPendienteById() {
		MSVDocumentoPendienteGenerar documento=new MSVDocumentoPendienteGenerar();
		documento.setId(1L);
		when(mockGenericDao.get(MSVDocumentoPendienteGenerar.class, mockGenericDao.createFilter(FilterType.EQUALS, "id", 1L))).thenReturn(documento);
		
		MSVDocumentoPendienteGenerar resultado=documentoPendienteGenerarManager.getDocumentoPendienteById(1L);
		
		assertNotNull(resultado);
	}

	@Test
	public void testGetDocumentoPendienteByToken() {
		MSVDocumentoPendienteGenerar documento=new MSVDocumentoPendienteGenerar();
		documento.setToken(1L);
		when(mockGenericDao.get(MSVDocumentoPendienteGenerar.class, mockGenericDao.createFilter(FilterType.EQUALS, "token", 1L))).thenReturn(documento);
		
		MSVDocumentoPendienteGenerar resultado=documentoPendienteGenerarManager.getDocumentoPendienteByToken(1L);
		
		assertNotNull(resultado);
	}

}
