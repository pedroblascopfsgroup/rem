package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.dto.DtoMSVProcesoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoFiltroProcesos;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.utils.JsonViewer;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.thread.ValidarFichero;
import es.pfsgroup.recovery.api.UsuarioApi;

@Controller
public class MasivoController extends ParadiseJsonController {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private AgrupacionAdapter adapter;

	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView procesarMasivo(Long idProcess, Long idOperation, ModelMap model) {

		Boolean result = false;
		try {
			result = adapter.procesarMasivo(idProcess, idOperation);
		} catch (Exception e) {
			logger.error("error procesando masivo", e);
		}

		model.put("data", result);
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView validar(Long idProcess, ModelMap model) {
		processAdapter.setStateValidando(idProcess);
		Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		Thread threadValidarProceso = new Thread(new ValidarFichero(idProcess, usu.getUsername()));
		threadValidarProceso.start();
		model.put("data", true);
		return JsonViewer.createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView mostrarProcesosPaginados(MSVDtoFiltroProcesos dto, ModelMap model) {
		try {
			Page page = processAdapter.mostrarProcesosPaginados(dto);
			List<DtoMSVProcesoMasivo> listProcesosmasivos = new ArrayList<DtoMSVProcesoMasivo>();
			processAdapter.addListProcesosMasivo(page, listProcesosmasivos);
			model.put("data", listProcesosmasivos);
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return createModelAndViewJson(model);
	}
}
