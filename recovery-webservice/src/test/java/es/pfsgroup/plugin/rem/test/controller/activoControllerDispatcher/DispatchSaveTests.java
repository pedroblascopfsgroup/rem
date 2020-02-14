package es.pfsgroup.plugin.rem.test.controller.activoControllerDispatcher;

import static org.mockito.Mockito.*;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import static org.junit.Assert.*;
import static es.pfsgroup.plugin.rem.activo.ActivoPropagacionFieldTabMap.*;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.ui.ModelMap;

import es.pfsgroup.plugin.rem.controller.ActivoController;
import es.pfsgroup.plugin.rem.controller.ActivoControllerDispatcher;
import es.pfsgroup.plugin.rem.model.DtoActivoCargasTab;
import es.pfsgroup.plugin.rem.model.DtoActivoFichaCabecera;
import es.pfsgroup.plugin.rem.model.DtoActivoInformacionAdministrativa;
import es.pfsgroup.plugin.rem.model.DtoActivoSituacionPosesoria;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@RunWith(MockitoJUnitRunner.class)
public class DispatchSaveTests {
	
	private static final String ABCDE = "ABCDE";

	private static final long ID_ACTIVO = 1L;

	private ActivoControllerDispatcher dispatcher;
	
	@Mock
	private ActivoController controller;
	
	@Mock
	private HttpServletRequest request;
	
	@Before
	public void before () {
		dispatcher = new ActivoControllerDispatcher(controller);
	}
	
	@After
	public void after () {
		reset(controller);
		dispatcher = null;
	}
	
	@Test
	public void requestNull () {
		try {
			dispatcher.dispatchSave(null, null);
			verifyZeroInteractions(controller);
		} catch (RuntimeException e) {
			fail("El método no debería haber fallado (" + e.getMessage() + ")");
		}
	}
	
	@Test
	public void requestVacio () {
		try {
			dispatcher.dispatchSave(new JSONObject(), null);
			verifyZeroInteractions(controller);
		} catch (RuntimeException e) {
			fail("El método no debería haber fallado (" + e.getMessage() + ")");
		}
	}
	
	@Test
	public void guardarDatosBasicos () {
		HashMap<String, Object> modelData = new HashMap<String, Object>();
		modelData.put("descripcion", ABCDE);
		modelData.put("campo2", "valor2");
		
		JSONObject json = createInputJson(ID_ACTIVO);
		putModel(json, TAB_DATOS_BASICOS, modelData);
		dispatcher.dispatchSave(json, null);
		
		ArgumentCaptor<DtoActivoFichaCabecera> captor = ArgumentCaptor.forClass(DtoActivoFichaCabecera.class);
		verify(controller).saveDatosBasicos(captor.capture(), eq(ID_ACTIVO), any(ModelMap.class));
		
		DtoActivoFichaCabecera dto = captor.getValue();
		assertEquals(ABCDE, dto.getDescripcion());
	}
	
	
	@Test
	public void guardarSituacionPosesoria () {
		HashMap<String, Object> modelData = new HashMap<String, Object>();
		modelData.put("tipoTituloPosesorioCodigo", ABCDE);
		modelData.put("necesarias", "1");
		
		JSONObject json = createInputJson(ID_ACTIVO);
		putModel(json, TAB_SIT_POSESORIA, modelData);
		dispatcher.dispatchSave(json, null);
		
		ArgumentCaptor<DtoActivoSituacionPosesoria> captor = ArgumentCaptor.forClass(DtoActivoSituacionPosesoria.class);
		verify(controller).saveActivoSituacionPosesoria(captor.capture(), eq(ID_ACTIVO), any(ModelMap.class), null);
		
		DtoActivoSituacionPosesoria dto = captor.getValue();
		assertEquals(ABCDE, dto.getTipoTituloPosesorioCodigo());
		assertEquals(new Integer(1), dto.getNecesarias());
	}
	
	@Test
	public void guardarDosModels () {
		HashMap<String, Object> modelCargas = new HashMap<String, Object>();
		modelCargas.put("conCargas", 0);
		
		HashMap<String, Object> modelInfoAdm = new HashMap<String, Object>();
		modelInfoAdm.put("numExpediente", ABCDE);
		
		JSONObject json = createInputJson(ID_ACTIVO);
		putModel(json, TAB_CARGAS_ACTIVO, modelCargas);
		putModel(json, TAB_INFO_ADMINISTRATIVA, modelInfoAdm);
		dispatcher.dispatchSave(json, null);
		
		ArgumentCaptor<DtoActivoCargasTab> captorCargas = ArgumentCaptor.forClass(DtoActivoCargasTab.class);
		ArgumentCaptor<DtoActivoInformacionAdministrativa> captorInfoAdm = ArgumentCaptor.forClass(DtoActivoInformacionAdministrativa.class);
		
		verify(controller).saveActivoCargaTab(captorCargas.capture(), any(ModelMap.class));
		verify(controller).saveActivoInformacionAdministrativa(captorInfoAdm.capture(), eq(ID_ACTIVO), any(ModelMap.class));
		
		DtoActivoCargasTab dtoCargas = captorCargas.getValue();
		DtoActivoInformacionAdministrativa dtoInfoAdm = captorInfoAdm.getValue();
		
		assertEquals(new Long(ID_ACTIVO), dtoCargas.getIdActivo());
		assertEquals(new Integer(0), dtoCargas.getConCargas());
		
		assertEquals(ABCDE, dtoInfoAdm.getNumExpediente());
	}
	
	

	private JSONObject createInputJson(long idActivo) {
		JSONObject request = new JSONObject();
		request.put("id", idActivo);
		request.put("models", new JSONArray());
		return request;
	}
	
	private void putModel(JSONObject json, String modelName, Map<String, Object> data) {
		JSONObject model = new JSONObject();
		model.put("name",modelName);
		JSONObject modelData = new JSONObject();
		
		modelData.putAll(data);
		
		model.put("data", modelData);
		
		json.getJSONArray("models").add(model);
	}

}
