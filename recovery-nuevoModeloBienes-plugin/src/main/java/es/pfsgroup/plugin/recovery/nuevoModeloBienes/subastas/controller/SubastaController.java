package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.plazaJuzgado.BuscaPlazaPaginadoDtoInfo;
import es.capgemini.pfs.core.api.plazaJuzgado.PlazaJuzgadoApi;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.NMBDtoBuscarLotesSubastas;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.NMBDtoBuscarSubastas;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.BatchAcuerdoCierreDeuda;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoLoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.InformeActaComiteBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.cierreDeuda.BienLoteDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.cierreDeuda.InformeValidacionCDDBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastaSareb.InformeSubastaSarebBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia.InformeSubastaBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia.InformeSubastaLetradoBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.SubastaApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.BienSubastaDTO;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.EditarInformacionCierreDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.GuardarInstruccionesDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.LotesSubastaDto;
import es.pfsgroup.recovery.ext.impl.asunto.model.DDPropiedadAsunto;
import es.pfsgroup.recovery.geninformes.GENINFVisorInformeController;
import es.pfsgroup.recovery.geninformes.api.GENINFInformesApi;

@Controller
public class SubastaController {

	private static final String SUBASTAS_JSON = "plugin/nuevoModeloBienes/subastas/subastasJSON"; 
	private static final String LOTES_SUBASTA_JSON = "plugin/nuevoModeloBienes/subastas/lotesSubastaJSON"; 
	private static final String WIN_AGREGAR_EXCLUIR_BIEN = "plugin/nuevoModeloBienes/subastas/agregarExcluirBien"; 
	private static final String BIENES_JSON = "plugin/nuevoModeloBienes/subastas/bienesJSON";
	private static final String WIN_INSTRUCCIONES_LOTE = "plugin/nuevoModeloBienes/subastas/instruccionesLoteSubasta"; 
	private static final String DEFAULT = "default"; 
	private static final String LOTES_SUBASTA_BUSCADOR_JSON = "plugin/nuevoModeloBienes/subastas/resultadoLotesSubastaJSON"; 
	private static final String EDITAR_INFORMACION_CIERRE = "plugin/nuevoModeloBienes/subastas/editarInformacionCierre";
	private static final String DICCIONARIO_JSON = "plugin/nuevoModeloBienes/subastas/diccionarioJSON";
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private SubastaApi subastaApi;

	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	@Autowired
    private Executor executor;	
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getSubastasAsunto(@RequestParam(value = "id", required = true) Long id, ModelMap map) {
	
		List<Subasta> subastas = subastaApi.getSubastasAsunto(id);	
		map.put("subastas", subastas);		
		return SUBASTAS_JSON;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getLotesSubasta(@RequestParam(value = "idSubasta", required = true) Long idSubasta, ModelMap map) {
		
		List<LotesSubastaDto> lotesDto = new ArrayList<LotesSubastaDto>();
		List<LoteSubasta> lotes = subastaApi.getLotesSubasta(idSubasta);
		
		for (LoteSubasta lb : lotes) {
			LotesSubastaDto loteSubastaDto = new LotesSubastaDto();
			loteSubastaDto.setLote(lb);
			loteSubastaDto.setNumLote(lb.getNumLote());
			lotesDto.add(loteSubastaDto);
		}
		
		map.put("lotes", lotesDto);
		return LOTES_SUBASTA_JSON;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String winAgregarExcluirBien(@RequestParam(value = "idSubasta", required = true) Long idSubasta,
			@RequestParam(value = "accion", required = true) String accion, ModelMap map) {
		List<LoteSubasta> lotes = subastaApi.getLotesSubasta(idSubasta);
		int numLotes = lotes.size()+10;
		
		map.put("accion", accion);
		map.put("idSubasta", idSubasta);
		map.put("numLotes", numLotes);
		return WIN_AGREGAR_EXCLUIR_BIEN;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getBienes(@RequestParam(value = "idSubasta", required = true) Long idSubasta,
			@RequestParam(value = "accion", required = true) String accion, ModelMap map) {
			List<BienSubastaDTO> bienes = subastaApi.getBienesAgregarExcluir(idSubasta, accion);
			map.put("bienes", bienes);			
		return BIENES_JSON;
	}
	
	@SuppressWarnings("static-access")
	@RequestMapping
	public String guardarAgregarExcluirBien(
			@RequestParam(value = "idSubasta", required = true) Long idSubasta,
			@RequestParam(value = "idsBien", required = true) String idsBien,
			@RequestParam(value = "lotes", required = false) String lotes,
			@RequestParam(value = "accion", required = true) String accion,			
			ModelMap map) {
		
		String[] arrBien = idsBien.split(",");
		if (subastaApi.ACCION_AGREGAR_BIEN.equals(accion)) {
			String[] arrLotes = lotes.split(",");
			subastaApi.agregarBienes(idSubasta, arrBien, arrLotes);
		} else {
			subastaApi.excluirBienes(idSubasta,arrBien);
		}
		
		return DEFAULT;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String winInstruccionesLoteSubasta(@RequestParam(value = "idLote", required = true) Long idLote, ModelMap map) {
		LoteSubasta lote = subastaApi.getLoteSubasta(idLote);
		map.put("instrucciones", lote);
		return WIN_INSTRUCCIONES_LOTE;
	}
	
	@RequestMapping
	public String guardarInstruccionesLote(GuardarInstruccionesDto dto, ModelMap map) {
		subastaApi.guardaInstruccionesLoteSubasta(dto);
		return DEFAULT;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String generarInformeSubastaLetrado(
			@RequestParam(value = "idSubasta", required = true) Long idSubasta, 
			ModelMap model) {
		
		String plantilla ="reportInformeSubastaLetrado.jrxml";
		
		InformeSubastaLetradoBean informe = proxyFactory.proxy(SubastaApi.class).getInformeSubastasLetrado(idSubasta);
		
		List<Object> array = informe.create();
		Map<String, Object> mapaValores = null;
		
		FileItem resultado = proxyFactory.proxy(GENINFInformesApi.class).generarInforme(plantilla, mapaValores, array);
		model.put("fileItem", resultado);
		return GENINFVisorInformeController.JSP_DOWNLOAD_FILE;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String generarInformeSubasta(
			@RequestParam(value = "idAsunto", required = true) Long idAsunto, 
			@RequestParam(value = "idSubasta", required = true) Long idSubasta, 
			@RequestParam(value = "plantilla", required = true) String plantilla, 
			ModelMap model) {
		
		Subasta subasta = subastaApi.getSubasta(idSubasta);
		
		Procedimiento procedimientos = subasta.getProcedimiento();
		//Nos quedamos con el procedimiento de subasta de subasta
		if(SubastaApi.CODIGO_TIPO_PROCEDIMIENTO_SUBASTA_BANKIA.compareTo(procedimientos.getTipoProcedimiento().getCodigo())==0){
			plantilla = "reportInformeSubasta.jrxml";
			InformeSubastaBean informe = new InformeSubastaBean();
			informe.setIdAsunto(idAsunto);
			informe.setIdSubasta(idSubasta);
			informe.setProxyFactory(proxyFactory);
			informe.setSubastaApi(subastaApi);
			List<Object> array = informe.create();
			Map<String, Object> mapaValores = null;
			FileItem resultado = proxyFactory.proxy(GENINFInformesApi.class)
			.generarInforme(plantilla, mapaValores, array);
			
			model.put("fileItem", resultado);
			
			return GENINFVisorInformeController.JSP_DOWNLOAD_FILE;
		} else {
			//sareb
			plantilla = "reportInformeSubastaSareb.jrxml";
			InformeSubastaSarebBean informe = new InformeSubastaSarebBean();
			informe.setIdAsunto(idAsunto);
			informe.setIdSubasta(idSubasta);
			informe.setProxyFactory(proxyFactory);
			informe.setSubastaApi(subastaApi);
			List<Object> array = informe.create();
			Map<String, Object> mapaValores = null;
			FileItem resultado = proxyFactory.proxy(GENINFInformesApi.class)
			.generarInforme(plantilla, mapaValores, array);
			
			model.put("fileItem", resultado);
			
			return GENINFVisorInformeController.JSP_DOWNLOAD_FILE;			
			
		}
					
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String generarInformeValidacionCDD(
			@RequestParam(value = "idSubasta", required = true) Long idSubasta,
			@RequestParam(value = "idBien", required = false) String idsBien,
			ModelMap model) {

		String plantilla = "reportValidacionCDD.jrxml";
		List<Object> array = rellenarInformeValidacionCDD(idSubasta, idsBien);
		Map<String, Object> mapaValores = null;
		FileItem resultado = proxyFactory.proxy(GENINFInformesApi.class)
				.generarInforme(plantilla, mapaValores, array);

		model.put("fileItem", resultado);

		return GENINFVisorInformeController.JSP_DOWNLOAD_FILE;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String generarInformeCierre(
			@RequestParam(value = "idSubasta", required = true) Long idSubasta,
			@RequestParam(value = "idBien", required = false) String idsBien,
			ModelMap model) {

		String plantilla = "reportValidacionCDD.jrxml";
		List<Object> array = rellenarInformeValidacionCDD(idSubasta, idsBien);
		InformeValidacionCDDBean inform = (InformeValidacionCDDBean) array.get(0);
		if(!inform.getValidacionOK()) {
			Map<String, Object> mapaValores = null;
			FileItem resultado = proxyFactory.proxy(GENINFInformesApi.class)
					.generarInforme(plantilla, mapaValores, array);

			model.put("fileItem", resultado);
			return GENINFVisorInformeController.JSP_DOWNLOAD_FILE;
		}else{
			if(Checks.esNulo(idsBien)) {
				getCierreDeudaInstance(idSubasta, null);							
			}else{
				for(Long idBien : obtenerBienEnviarCierre(idsBien)) {
					getCierreDeudaInstance(idSubasta, idBien);
				}
			}
		}
		return null;
	}
	
	private List<Long> obtenerBienEnviarCierre(String idsBien) {
		List<Long> listIdsBien = new ArrayList<Long>();
		if(!Checks.esNulo(idsBien)) {
			String[] arrLoteBien = idsBien.split(",");			
			for (String loteBien : arrLoteBien) {
				String bien = loteBien.substring(0,loteBien.indexOf(";")); 
				listIdsBien.add(Long.valueOf(bien));
			}
		}
		return listIdsBien;
	}
	
	private List<Object> rellenarInformeValidacionCDD(Long idSubasta, String idsBien) {
		InformeValidacionCDDBean informe = new InformeValidacionCDDBean();
		List<BienLoteDto> listBienLote = new ArrayList<BienLoteDto>(); 
		if(!Checks.esNulo(idsBien)) {
			String[] arrLoteBien = idsBien.split(",");
			
			for (String loteBien : arrLoteBien) {
				String bien = loteBien.substring(0,loteBien.indexOf(";")); 
				String lote = loteBien.substring(loteBien.indexOf(";")+1); 
				BienLoteDto dto = new BienLoteDto(Long.valueOf(bien), "", Integer.valueOf(lote));
				listBienLote.add(dto);
			}
			informe.setBienesLote(listBienLote);
		}
		informe.setIdSubasta(idSubasta);
		informe.setProxyFactory(proxyFactory);
		informe.setSubastaApi(subastaApi);
		return informe.create();
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String editarInformacionCierre(
			@RequestParam(value = "idSubasta", required = true) Long idSubasta, 
			ModelMap model) {

		Subasta subasta = subastaApi.getSubasta(idSubasta);
		Procedimiento procedimiento = subasta.getProcedimiento();
		EditarInformacionCierreDto dto = new EditarInformacionCierreDto();
		dto.setIdSubasta(subasta.getId());
		if(Checks.esNulo(procedimiento.getJuzgado())) {
			dto.setIdPlazaJuzgado(null);			
			dto.setCodigoPlaza("");
			dto.setIdTipoJuzgado(null);
			dto.setCodigoJuzgado("");
		}else{
			dto.setIdPlazaJuzgado(procedimiento.getJuzgado().getId());
			dto.setCodigoPlaza(procedimiento.getJuzgado().getCodigo());
			dto.setIdTipoJuzgado(procedimiento.getJuzgado().getPlaza().getId());
			dto.setCodigoJuzgado(procedimiento.getJuzgado().getPlaza().getCodigo());
		}
		dto.setPrincipalDemanda(procedimiento.getSaldoRecuperacion());
		String costasLetrado = subastaApi.obtenValorNodoPrc(procedimiento, "H002_SenyalamientoSubasta", "costasLetrado");
		String costasProcurador = subastaApi.obtenValorNodoPrc(procedimiento, "H002_SenyalamientoSubasta", "costasProcurador");
		String fechaSenyalamiento = subastaApi.obtenValorNodoPrc(procedimiento, "H002_SenyalamientoSubasta", "fechaSenyalamiento");
		String conPostores = subastaApi.obtenValorNodoPrc(procedimiento, "H002_CelebracionSubasta", "comboPostores");
		dto.setCostasLetrado(costasLetrado);
		dto.setCostasProcurador(costasProcurador);
		dto.setFechaSenyalamiento(fechaSenyalamiento);
		dto.setConPostores(conPostores);
		model.put("dto", dto);
		return EDITAR_INFORMACION_CIERRE;
	}
	
	@RequestMapping
	public String saveDatosEditarInformacionCierre(EditarInformacionCierreDto dto, ModelMap map){
		// TODO Crear actualizar e insert valores tarea señalamiento subasta y celebracion subasta
			
		return DEFAULT;
	}

	private void getCierreDeudaInstance(Long idSubasta, Long idBien) {
		BatchAcuerdoCierreDeuda cierreDeuda = getCierreDeudaInstance(idSubasta);
		cierreDeuda.setEntidad(DDPropiedadAsunto.PROPIEDAD_SAREB);
		cierreDeuda.setIdBien(idBien);
		subastaApi.guardaBatchAcuerdoCierre(cierreDeuda);
	};
	
	protected BatchAcuerdoCierreDeuda getCierreDeudaInstance(Long idSubasta) {
		Subasta subasta = subastaApi.getSubasta(idSubasta);
		Procedimiento procedimiento = subasta.getProcedimiento();
		Auditoria auditoria = Auditoria.getNewInstance();
		BatchAcuerdoCierreDeuda cierreDeuda = new BatchAcuerdoCierreDeuda();
		cierreDeuda.setIdProcedimiento(procedimiento.getId());
		cierreDeuda.setIdAsunto(procedimiento.getAsunto().getId());
		cierreDeuda.setFechaAlta(Calendar.getInstance().getTime());
		cierreDeuda.setUsuarioCrear(auditoria.getUsuarioCrear());
		return cierreDeuda;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String generarInformeActaComite(NMBDtoBuscarLotesSubastas dto, ModelMap model) {
		
		String plantilla = "reportInformeActaComite.jrxml";
		
		InformeActaComiteBean informe = new InformeActaComiteBean();
		//informe.setIdAsunto(idAsunto);
		//informe.setIdSubasta(idSubasta);
		informe.setProxyFactory(proxyFactory);
		informe.setSubastaApi(subastaApi);
		List<Object> array = informe.create(dto);
		Map<String, Object> mapaValores = null;
		FileItem resultado = proxyFactory.proxy(GENINFInformesApi.class)
				.generarInformePDF(plantilla, mapaValores, array);
			
		model.put("fileItem", resultado);
			
		return GENINFVisorInformeController.JSP_DOWNLOAD_FILE;
					
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String generarInformeBusquedaSubastasManager(NMBDtoBuscarSubastas b, ModelMap model) {
		
		
				
		model.put("fileItem", proxyFactory.proxy(SubastaApi.class).buscarSubastasXLS(b));
		return GENINFVisorInformeController.JSP_DOWNLOAD_FILE;
	}

	/**
	 * Método para buscar subastas según filtros indicados en el DTO.
	 */
	@RequestMapping
	public String buscarLotesSubasta(NMBDtoBuscarLotesSubastas dto, ModelMap model) {
		Page page = (Page)proxyFactory.proxy(SubastaApi.class).buscarLotesSubastas(dto);
		model.put("lotes", page);
		return LOTES_SUBASTA_BUSCADOR_JSON;
	}	

	@RequestMapping
	public String buscarLotesSubastasXLS(NMBDtoBuscarLotesSubastas dto, ModelMap model) {
		FileItem fileItem = (FileItem)proxyFactory.proxy(SubastaApi.class).buscarLotesSubastasXLS(dto);
		model.put("fileItem", fileItem);
		return "plugin/nuevoModeloBienes/subastas/download";		
	}			
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String editarObservacionesLotesSubasta(@RequestParam Long[] idLotes, @RequestParam String codEstado, ModelMap model){
		//List<DDEstadoCredito> estados = (List<DDEstadoCredito>) executor.execute("ugasconcursoManager.estadosCreditoUGAS");
		//model.put("idAsunto", idAsunto);
		model.put("idLotes", idLotes);
		model.put("codEstado", codEstado);
		return "plugin/nuevoModeloBienes/subastas/editarObservacionesLoteSubasta";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String guardarEstadoLotesSubasta(@RequestParam Long[] idLotes, 
			@RequestParam String codEstado,
			@RequestParam(required=false) String codMotivoSuspSubasta,
			@RequestParam(required=false) String observaciones,
			ModelMap model) {

		DDEstadoLoteSubasta estadoLoteSubasta = (DDEstadoLoteSubasta)diccionarioApi.dameValorDiccionarioByCod(DDEstadoLoteSubasta.class, codEstado);
		proxyFactory.proxy(SubastaOnlineApi.class).guardaEstadoLoteSubasta(idLotes, estadoLoteSubasta, codMotivoSuspSubasta, observaciones);
		//Recorre todos los ids de subasta y comprueba la subasta.
		// 
		return DEFAULT;
	}
	

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getDiccionario(
			@RequestParam(value = "diccionario", required = true) String diccionario,
			ModelMap map) throws ClassNotFoundException {

		List<?> data = proxyFactory.proxy(UtilDiccionarioApi.class)
				.dameValoresDiccionario(Class.forName(diccionario));
		map.put("data", data);
		return DICCIONARIO_JSON;		
	}
	
	@RequestMapping
	public String buscarJuzgadosPlaza(@RequestParam(value = "codigo", required = true) String codigo, ModelMap map){
		List<TipoJuzgado> juzgados = proxyFactory.proxy(PlazaJuzgadoApi.class).buscaJuzgadosPorPlaza(codigo);
		map.put("juzgados", juzgados);
		return "plugin/coreextension/tipoPlaza/listadoJuzgadosPlazaJSON";
	}
	
	@RequestMapping
	public String buscaPlazasPorCod(@RequestParam(value = "codigo", required = true) String codigo, ModelMap map){
		Integer pagina = proxyFactory.proxy(PlazaJuzgadoApi.class).buscarPorCodigo(codigo);
		map.put("paginaParaPlaza", pagina);
		return "plugin/coreextension/tipoPlaza/listadoPaginaPlazaJSON";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String plazasPorDescripcion(final WebRequest request, ModelMap map){
		BuscaPlazaPaginadoDtoInfo dto = DynamicDtoUtils.create(BuscaPlazaPaginadoDtoInfo.class, request);
		Page plazas = proxyFactory.proxy(PlazaJuzgadoApi.class).buscarPorDescripcion(dto);
		map.put("pagina", plazas);
		return "plugin/coreextension/tipoPlaza/listadoPlazasJSON";
	}
	
}
