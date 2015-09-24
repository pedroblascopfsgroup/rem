package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.controller;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
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
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.plazaJuzgado.BuscaPlazaPaginadoDtoInfo;
import es.capgemini.pfs.core.api.plazaJuzgado.PlazaJuzgadoApi;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;
import es.pfsgroup.plugin.recovery.coreextension.informes.cierreDeuda.DatosLoteCDD;
import es.pfsgroup.plugin.recovery.coreextension.informes.cierreDeuda.InfoBienesCDD;
import es.pfsgroup.plugin.recovery.coreextension.informes.cierreDeuda.InformeValidacionCDDDto;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.NMBDtoBuscarLotesSubastas;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.NMBDtoBuscarSubastas;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.BatchAcuerdoCierreDeuda;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoLoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDResultadoValidacionCDD;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDResultadoValidacionNuse;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcel;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcelInformeSubasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcelMasivoSubastas;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.EditBienApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.NMBProjectContext;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.NMBBienManager;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.InformeActaComiteBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastaSareb.InformeSubastaSarebBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia.InformeSubastaBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia.InformeSubastaLetradoBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdicionalBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBDDTipoBienContrato;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.recoveryapi.BienApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.relacionesContratoBien.dto.BusquedaContratoDTO;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.SubastaApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.BienSubastaDTO;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.EditarInformacionCierreDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.GuardarInstruccionesDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.LotesSubastaDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.manager.SubastaManager;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.manager.SubastaManager.ValorNodoTarea;
import es.pfsgroup.recovery.geninformes.GENINFVisorInformeController;
import es.pfsgroup.recovery.geninformes.api.GENINFInformesApi;

@Controller
public class SubastaController {

	private static final String SUBASTAS_JSON = "plugin/nuevoModeloBienes/subastas/subastasJSON"; 
	private static final String LOTES_SUBASTA_JSON = "plugin/nuevoModeloBienes/subastas/lotesSubastaJSON"; 
	private static final String DISABLED_BOTONES_CDD_JSON = "plugin/nuevoModeloBienes/subastas/disableBotonesCDDJSON";
	private static final String WIN_AGREGAR_EXCLUIR_BIEN = "plugin/nuevoModeloBienes/subastas/agregarExcluirBien"; 
	private static final String BIENES_JSON = "plugin/nuevoModeloBienes/subastas/bienesJSON";
	private static final String WIN_INSTRUCCIONES_LOTE = "plugin/nuevoModeloBienes/subastas/instruccionesLoteSubasta"; 
	private static final String DEFAULT = "default"; 
	private static final String LOTES_SUBASTA_BUSCADOR_JSON = "plugin/nuevoModeloBienes/subastas/resultadoLotesSubastaJSON"; 
	private static final String EDITAR_INFORMACION_CIERRE = "plugin/nuevoModeloBienes/subastas/editarInformacionCierre";
	private static final String DICCIONARIO_JSON = "plugin/nuevoModeloBienes/subastas/diccionarioJSON";
	
	
	private static final String ADD_RELACION_CONTRATO_BIEN = "plugin/nuevoModeloBienes/subastas/addRelacionContratoBien";
	private static final String BORRAR_RELACION_CONTRATO_BIEN = "plugin/nuevoModeloBienes/subastas/borrarRelacionContratoBien";
	private static final String BUSQUEDA_CONTRATO_JSON = "plugin/nuevoModeloBienes/subastas/busquedaContratoJSON";
	private static final String ADD_BIEN_CARGAS = "plugin/nuevoModeloBienes/bienes/AgregarBienCargasMultiple";
	private static final String ADD_REVISION_CARGAS = "plugin/nuevoModeloBienes/subastas/editarRevisionCargasMultiple";
	

	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private SubastaApi subastaApi;
	
	@Autowired
	private SubastaManager subastaManager;
	
	@Autowired
	private NMBProjectContext nmbProjectContext;

	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	@Autowired
    private Executor executor;	
	
	@Autowired
	private NMBBienManager nmbBienManager;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getSubastasAsunto(@RequestParam(value = "id", required = true) Long id, ModelMap map) {
	
		List<Subasta> subastas = subastaApi.getSubastasAsunto(id);	
		map.put("subastas", subastas);		
		return SUBASTAS_JSON;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getDisableBotonesCDD(@RequestParam(value = "idSubasta", required = true) Long id, ModelMap map) {
		Subasta subasta = subastaApi.getSubasta(id);
		List<Boolean> list = new ArrayList<Boolean>();
		list.add(!habilitarEditInfoCDD(subasta));
		map.put("disableBotonesCDD", list);
		return DISABLED_BOTONES_CDD_JSON;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String reiniciarKOCDD(@RequestParam(value = "idAsunto", required = true) Long id, ModelMap map) {
		subastaApi.eliminarBatchCierreDeudaAsunto(id);		
		return DEFAULT;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getLotesSubasta(@RequestParam(value = "idSubasta", required = true) Long idSubasta, ModelMap map) {
		
		List<LotesSubastaDto> lotesDto = new ArrayList<LotesSubastaDto>();
		Subasta subasta = subastaApi.getSubasta(idSubasta);
		
		for (LoteSubasta lb : subasta.getLotesSubasta()) {
			LotesSubastaDto loteSubastaDto = new LotesSubastaDto();
			loteSubastaDto.setLote(lb);
			loteSubastaDto.setNumLote(lb.getNumLote());
			lotesDto.add(loteSubastaDto);
		}

		map.put("lotes", lotesDto);
		return LOTES_SUBASTA_JSON;
	}
	
	private Boolean habilitarEditInfoCDD(Subasta subasta){
		String tareaCelebracionSubasta = subasta.getProcedimiento().getTipoProcedimiento().getCodigo() + "_CelebracionSubasta";
		return subastaApi.tareaExisteYFinalizada(subasta.getProcedimiento(), tareaCelebracionSubasta);
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
	public String generarInformeCierreDeuda(
			@RequestParam(value = "idSubasta", required = true) Long idSubasta,
			@RequestParam(value = "idBien", required = false) String idsBien,
			ModelMap model) {

		InformeValidacionCDDDto informe = proxyFactory.proxy(SubastaProcedimientoDelegateApi.class)
				.generarInformeValidacionCDD(idSubasta, idsBien);
		return creaExcelValidacion(informe,model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String enviarCierreDeuda(
			@RequestParam(value = "idSubasta", required = true) Long idSubasta,
			@RequestParam(value = "idBien", required = false) String idsBien,
			ModelMap model) {		
	
		// En caso de tener bienes informados (SAREB) validamos por bien, y finalmente generamos un informe
		// global que será el que creará el excel		
		
		Subasta subasta = subastaApi.getSubasta(idSubasta);		
		InformeValidacionCDDDto informe = null;
		boolean resultadoGlobalOK = true;
		
		if(!Checks.esNulo(idsBien)) { // Si tenemos bienes informados (SAREB)
			
			String[] arrBienes = idsBien.split(",");
			
			for (String idBien:arrBienes) {				
			
				informe = proxyFactory.proxy(SubastaApi.class).generarEnvioCierreDeuda(subasta, Long.valueOf(idBien), BatchAcuerdoCierreDeuda.PROPIEDAD_MANUAL);
				if(!informe.getValidacionOK()) {
					resultadoGlobalOK = false;					
				}
			}			
			if(!resultadoGlobalOK) { // Si hay algún bien con KO generamos el informe global que creará el excel
				informe = proxyFactory.proxy(SubastaProcedimientoDelegateApi.class)
						.generarInformeValidacionCDD(idSubasta, idsBien);				
			}
			
		} else { // Si no tenemos bienes, se trata como un único envio
			
			informe = subastaApi.generarEnvioCierreDeuda(subasta, null, BatchAcuerdoCierreDeuda.PROPIEDAD_MANUAL);
			if(!informe.getValidacionOK()) {
				resultadoGlobalOK = false;					
			}
		}
		
		// Si alguna validación es KO, generamos el excel		
		if(!resultadoGlobalOK) {

			return creaExcelValidacion(informe,model);
			
		} else {	
			
			return DEFAULT;
		}
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
		dto.setFechaSenyalamiento(DateFormat.toString(subasta.getFechaSenyalamiento()));
		dto.setDeudaJudicial(subasta.getDeudaJudicial());
		if(Checks.esNulo(procedimiento.getJuzgado())) {
			dto.setIdPlazaJuzgado(null);			
			dto.setCodigoPlaza("");
			dto.setIdTipoJuzgado(null);
			dto.setCodigoJuzgado("");
		}else{
			dto.setIdPlazaJuzgado(procedimiento.getJuzgado().getPlaza().getId());
			dto.setCodigoPlaza(procedimiento.getJuzgado().getPlaza().getCodigo());
			dto.setIdTipoJuzgado(procedimiento.getJuzgado().getId());
			dto.setCodigoJuzgado(procedimiento.getJuzgado().getCodigo());
		}
		dto.setPrincipalDemanda(procedimiento.getSaldoRecuperacion());
		
		String tareaSenyalamientoSubasta = subasta.getProcedimiento().getTipoProcedimiento().getCodigo() + "_SenyalamientoSubasta";
		String tareaCelebracionSubasta = subasta.getProcedimiento().getTipoProcedimiento().getCodigo() + "_CelebracionSubasta";
		
		ValorNodoTarea costasLetrado = subastaApi.obtenValorNodoPrc(procedimiento, tareaSenyalamientoSubasta, "costasLetrado");
		ValorNodoTarea costasProcurador = subastaApi.obtenValorNodoPrc(procedimiento, tareaSenyalamientoSubasta, "costasProcurador");
		
		ValorNodoTarea conPostores = null;
		
		String comboPostores = nmbProjectContext.getComboPostoresCelebracionSubasta();
		conPostores = subastaApi.obtenValorNodoPrc(procedimiento, tareaCelebracionSubasta, comboPostores);	
		
		if(!Checks.esNulo(costasLetrado)) {
			dto.setCostasLetrado(costasLetrado.getValor());
			dto.setIdValorCostasLetrado(costasLetrado.getIdTareaNodoValor());	
		}
		if(!Checks.esNulo(costasProcurador)) {
			dto.setCostasProcurador(costasProcurador.getValor());
			dto.setIdValorCostasProcurador(costasProcurador.getIdTareaNodoValor());	
		}
		if(!Checks.esNulo(conPostores)) {
			dto.setConPostores(conPostores.getValor());
			dto.setIdValorConPostores(conPostores.getIdTareaNodoValor());	
		}
		model.put("dto", dto);
		return EDITAR_INFORMACION_CIERRE;
	}
	
	@RequestMapping
	public String saveDatosEditarInformacionCierre(EditarInformacionCierreDto dto, ModelMap map){
		subastaApi.actualizarInformacionCierreDeuda(dto);
		return DEFAULT;
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
	 * MÃ©todo para buscar subastas segÃºn filtros indicados en el DTO.
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
	
	@SuppressWarnings("unchecked")
	private String creaExcelValidacion(InformeValidacionCDDDto informe,ModelMap model){
		
		List<List<String>> valores = new ArrayList<List<String>>();
		List<String> fila =new ArrayList<String>();
		
		List<String> cabeceras=new ArrayList<String>();
		cabeceras.add("TIPO PROCEDIMIENTO");
		cabeceras.add("LETRADO");
		cabeceras.add("JUZGADO");
		cabeceras.add("PRINCIPAL");
		cabeceras.add("DEUDA");
		cabeceras.add("COSTAS LETRADO");
		cabeceras.add("COSTAS PROCURADOR");
		cabeceras.add("F. SEÑALAMIENTO");
		cabeceras.add("CON POSTORES");
		
		fila=new ArrayList<String>();
		if(!Checks.esNulo(informe.getProcedimientoSubastaCDD().getTipoProcedimiento())){
			fila.add(informe.getProcedimientoSubastaCDD().getTipoProcedimiento().concat(";White;Text"));
		} else {
			fila.add("******;Red;Text");
		}
		
		if(!Checks.esNulo(informe.getProcedimientoSubastaCDD().getLetrado())){
			fila.add(informe.getProcedimientoSubastaCDD().getLetrado().concat(";White;Text"));
		} else {
			fila.add("******;Red;Text");
		}
		
		if(!Checks.esNulo(informe.getProcedimientoSubastaCDD().getJuzgado())){
			fila.add(informe.getProcedimientoSubastaCDD().getJuzgado().concat(";White;Text"));
		} else {
			fila.add("******;Red;Text");
		}
		
		if(!Checks.esNulo(informe.getProcedimientoSubastaCDD().getPrincipal()) && !informe.getProcedimientoSubastaCDD().getPrincipal().equals("0")){
			fila.add(informe.getProcedimientoSubastaCDD().getPrincipal().concat(";White;Number"));
		} else {
			fila.add("******;Red;Text");
		}
		
		if(!Checks.esNulo(informe.getProcedimientoSubastaCDD().getDeudaJudicial())){
			fila.add(informe.getProcedimientoSubastaCDD().getDeudaJudicial().concat(";White;Number"));
		} else {
			fila.add("******;Red;Text");
		}
		
		if(!Checks.esNulo(informe.getProcedimientoSubastaCDD().getCostasLetrado())){
			fila.add(informe.getProcedimientoSubastaCDD().getCostasLetrado().concat(";White;Number"));
		} else {
			fila.add("******;Red;Text");
		}
		
		if(!Checks.esNulo(informe.getProcedimientoSubastaCDD().getCostasProcurador())){
			fila.add(informe.getProcedimientoSubastaCDD().getCostasProcurador().concat(";White;Number"));
		} else {
			fila.add("******;Red;Text");
		}
		
		if(!Checks.esNulo(informe.getProcedimientoSubastaCDD().getFechaCelebracionSubasta())){
			fila.add(informe.getProcedimientoSubastaCDD().getFechaCelebracionSubasta().concat(";White;Text"));
		} else {
			fila.add("******;Red;Text");
		}
		
		if(!Checks.esNulo(informe.getProcedimientoSubastaCDD().getSubastaConPostores())){
			fila.add(informe.getProcedimientoSubastaCDD().getSubastaConPostores().concat(";White;Text"));
		} else {
			fila.add("******;Red;Text");
		}
		valores.add(fila);
		
		for(DatosLoteCDD datosLoteCDD : informe.getDatosLoteCDD()) {	
			fila=new ArrayList<String>();
			fila.add("LOTE;Blue;Text");
			fila.add("PUJA SIN POSTORES;Blue;Text");
			fila.add("PUJA CON POSTORES DESDE;Blue;Text");
			fila.add("PUJA CON POSTORES HASTA;Blue;Text");
			fila.add("VALOR SUBASTA;Blue;Text");
			valores.add(fila);
			
			fila=new ArrayList<String>();
			if(!Checks.esNulo(datosLoteCDD.getNumLote())){
				fila.add(datosLoteCDD.getNumLote().toString().concat(";Grey;Text"));
			} else {
				fila.add("******;Red;Text");
			}
			
			if(!Checks.esNulo(datosLoteCDD.getSinPostores()) && !datosLoteCDD.getSinPostores().equals("0")){
				String sinPostores=datosLoteCDD.getSinPostores().replace(",",".");
				fila.add(sinPostores.concat(";Grey;Number"));
			} else {
				fila.add("******;Red;Text");
			}
			
			if(!Checks.esNulo(datosLoteCDD.getConPostoresDesde()) && !datosLoteCDD.getConPostoresDesde().equals("0")){
				String conPostores=datosLoteCDD.getConPostoresDesde().replace(",", ".");
				fila.add(conPostores.concat(";Grey;Number"));
			} else {
				fila.add("******;Red;Text");
			}
			
			if(!Checks.esNulo(datosLoteCDD.getConPostoresHasta()) && !datosLoteCDD.getConPostoresHasta().equals("0")){
				String conPostoresHasta=datosLoteCDD.getConPostoresHasta().replace(",", ".");
				fila.add(conPostoresHasta.concat(";Grey;Number"));
			} else {
				fila.add("******;Red;Text");
			}
			
			if(!Checks.esNulo(datosLoteCDD.getValorSubasta()) && !datosLoteCDD.getValorSubasta().equals("0")){
				String valorSubasta=datosLoteCDD.getValorSubasta().replace(",", ".");
				fila.add(valorSubasta.concat(";Grey;Number"));
			} else {
				fila.add("******;Red;Text");
			}
			valores.add(fila);
			
			if(!Checks.esNulo(datosLoteCDD.getInfoBienes())){
					
				fila=new ArrayList<String>();
				fila.add(" ; ;Text");
				fila.add("Nº FINCA;Blue;Text");
				fila.add("Nº ACTIVO;Blue;Text");
//				fila.add("REFERENCIA CATASTRAL;Blue;Text");
				fila.add("DESCRIPCIÓN;Blue;Text");
				fila.add("Nº REGISTRO;Blue;Text");
				fila.add("VALOR TASACIÓN;Blue;Text");
				fila.add("FECHA TASACIÓN;Blue;Text");
				fila.add("VALOR JUDICIAL;Blue;Text");
				fila.add("VIVIENDA HABITUAL;Blue;Text");
				fila.add("RESULTADO ADJUDICACIÓN;Blue;Text");
				fila.add("IMPORTE ADJUDICACIÓN;Blue;Text");
				//Si la subasta es de Bankia no mostramos la columna Fecha Testimonio
				if(!"P401".equals(informe.getSubasta().getProcedimiento().getTipoProcedimiento().getCodigo())){
					fila.add("F. TESTIMONIO ADJ SAREB;Blue;Text");
				}
				
				valores.add(fila);
				
				for(InfoBienesCDD infoBienes : datosLoteCDD.getInfoBienes()) {	
					fila=new ArrayList<String>();
					fila.add(" ; ");
					if(!Checks.esNulo(infoBienes.getNumFinca())){
						fila.add(infoBienes.getNumFinca().concat(";White;Text"));
					} else {
						fila.add("******;Red;Text");
					}
					
					if(!Checks.esNulo(infoBienes.getNumeroActivo())){
						fila.add(infoBienes.getNumeroActivo().concat(";White;Text"));
					} else {
						fila.add("******;Red;Text");
					}
					
//					if(!Checks.esNulo(infoBienes.getReferenciaCatastral())){
//						fila.add(infoBienes.getReferenciaCatastral().concat(";White;Text"));
//					}
//					else
//					{
//						fila.add("******;Red;Text");
//					}
					
					if(!Checks.esNulo(infoBienes.getDescripcion())){
						fila.add(infoBienes.getDescripcion().concat(";White;Text"));
					} else {
						fila.add("******;Red;Text");
					}
					
					if(!Checks.esNulo(infoBienes.getNumRegistro())){
						fila.add(infoBienes.getNumRegistro().concat(";White;Text"));
					} else {
						fila.add("******;Red;Text");
					}
					
					if(!Checks.esNulo(infoBienes.getValorTasacion()) && !infoBienes.getValorTasacion().equals("0")){
						String valorTasacion=infoBienes.getValorTasacion().replace(",",".");
						fila.add(valorTasacion.concat(";White;Number"));
					} else {
						fila.add("******;Red;Text");
					}
					
					if(!Checks.esNulo(infoBienes.getFechaTasacion())){
						fila.add(infoBienes.getFechaTasacion().concat(";White;Text"));
					} else {
						fila.add("******;Red;Text");
					}
					
					if(!Checks.esNulo(infoBienes.getValorJudicial()) && !infoBienes.getValorJudicial().equals("0")){
						String valorJudicial=infoBienes.getValorJudicial().replace(",", ".");
						fila.add(valorJudicial.concat(";White;Number"));
					} else {
						fila.add("******;Red;Text");
					}
					
					
					if(!Checks.esNulo(infoBienes.getViviendaHabitual())){
						fila.add(infoBienes.getViviendaHabitual().concat(";White;Text"));
					} else {
						fila.add("******;Red;Text");
					}
					
					if(!Checks.esNulo(infoBienes.getResultadoAdjudicacion())){
						fila.add(infoBienes.getResultadoAdjudicacion().concat(";White;Text"));
					} else {
						fila.add("******;Red;Text");
					}
					
					if(!Checks.esNulo(infoBienes.getImporteAdjudicacion()) && !infoBienes.getImporteAdjudicacion().equals("0")){
						String importeAdjudicacion=infoBienes.getImporteAdjudicacion().replace(",", ".");
						fila.add(importeAdjudicacion.concat(";White;Number"));
					} else {
						fila.add("******;Red;Text");
					}
					//Si la subasta es de Bankia no mostramos la columna Fecha Testimonio
					if(!"P401".equals(informe.getSubasta().getProcedimiento().getTipoProcedimiento().getCodigo())){
						if(!Checks.esNulo(infoBienes.getFechaTestimonioAdjudicacionSareb())){
							fila.add(infoBienes.getFechaTestimonioAdjudicacionSareb().concat(";White;Text"));
						} else {
							fila.add("******;Red;Text");
						}
					}
					valores.add(fila);
				}
			}	
		}
		
		fila=new ArrayList<String>();
		fila.add(" ;White;Text");
		fila.add(" ;White;Text");
		fila.add(" ;White;Text");
		fila.add(" ;White;Text");
		fila.add(" ;White;Text");
		valores.add(fila);
		
		fila=new ArrayList<String>();
		fila.add("MENSAJES VALIDACION;Blue;Text");
		fila.add(" ;Blue;Text");
		fila.add(" ;Blue;Text");
		fila.add(" ;Blue;Text");
		fila.add(" ;Blue;Text");
		valores.add(fila);
		
		if(!informe.getValidacionOK()){
			
			String [] arrayMensajes=informe.getMensajesValidacion().split(";");
			
			for(String mensaje : arrayMensajes){
				fila=new ArrayList<String>();
				fila.add(mensaje.concat(" ;Red;Text"));
				fila.add(" ;Red;Text");
				fila.add(" ;Red;Text");
				fila.add(" ;Red;Text");
				fila.add(" ;Red;Text");
				valores.add(fila);
			}
		}
		
		
		HojaExcelInformeSubasta hojaExcel = new HojaExcelInformeSubasta();
		hojaExcel.crearNuevoExcel("informe_validacion.xls", cabeceras, valores);
		
		FileItem excelFileItem = new FileItem(hojaExcel.getFile());
        excelFileItem.setFileName("informe_validacion.xls");
        excelFileItem.setContentType(HojaExcel.TIPO_EXCEL);
        excelFileItem.setLength(hojaExcel.getFile().length());
	    
        model.put("fileItem",excelFileItem);
		return GENINFVisorInformeController.JSP_DOWNLOAD_FILE;
	}
	
	@RequestMapping
	public String getListErrorPreviCDDData(ModelMap model){
		List<DDResultadoValidacionCDD> list = proxyFactory.proxy(SubastaApi.class).getListErrorPreviCDDData();
		model.put("data", list);
		return DICCIONARIO_JSON;
	}
	
	
		
	@RequestMapping
	public String getListErrorPostCDDData(ModelMap model){
		List<DDResultadoValidacionNuse> list = proxyFactory.proxy(SubastaApi.class).getListErrorPostCDDData();
		model.put("data", list);
		return DICCIONARIO_JSON;
	}
	
	/*
	 * Modificaciones operaciones masivas subasta
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getRelacionContratoBien(WebRequest request, ModelMap model,@RequestParam(value = "idBienes", required = true) Long[] idBienes){
		
		List<NMBDDTipoBienContrato> diccionarioRelaciones = (List<NMBDDTipoBienContrato>) executor.execute("dictionaryManager.getList", "NMBDDTipoBienContrato");
		model.put("diccionarioRelaciones", diccionarioRelaciones);
		
		model.put("idBienes",idBienes);
		
		return ADD_RELACION_CONTRATO_BIEN;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String buscaContratoByCodigo(ModelMap model,String nroContrato){
		
		BusquedaContratoDTO dto=new BusquedaContratoDTO();
		Contrato contrato=subastaManager.getContratoByNroContrato(nroContrato);
		
		
		if(!Checks.esNulo(contrato)){
			dto.setIdContrato(contrato.getId().toString());
			dto.setNumContrato(contrato.getNroContrato());
			dto.setTipoProducto(contrato.getTipoProducto().getDescripcion());
			model.put("contrato", dto);
			
			return BUSQUEDA_CONTRATO_JSON;
		}
		else{
			return "KO";
		}
	}
	
	@RequestMapping
	public String guardarRelacionesContratoBienes(ModelMap model,String[] nroContratoTipoBienContrato,@RequestParam(value = "idBienes", required = true) Long[] idBienes){
		
		for(int i=0;i<nroContratoTipoBienContrato.length;i++){
			if(!nroContratoTipoBienContrato[i].equals("")){
				String nroContrato=nroContratoTipoBienContrato[i].split(",")[0];
				String codTipoBienContrato=nroContratoTipoBienContrato[i].split(",")[1];
				Contrato contrato=subastaManager.getContratoByNroContrato(nroContrato);
				if(!Checks.esNulo(contrato)){
					for(int c=0;c<idBienes.length;c++){
						nmbBienManager.saveBienContrato(contrato.getId(),idBienes[c],codTipoBienContrato);
					}
				}
			}
		}
		
		return DEFAULT;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getBorrarRelacionContratoBien(WebRequest request, ModelMap model,@RequestParam(value = "idBienes", required = true) Long[] idBienes){
		
		model.put("idBienes",idBienes);
		
		return BORRAR_RELACION_CONTRATO_BIEN;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getContratos(WebRequest request, ModelMap model,@RequestParam(value = "idBienes", required = true) Long[] idBienes) {
		List<NMBContratoBien> listNMBContratoBien=subastaManager.getRelacionesContratosBienes(idBienes);
		model.put("contratosBienes", listNMBContratoBien);
		return "plugin/nuevoModeloBienes/bienes/NMBcontratosBienJSON";
			
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getAgregarBienCargas(WebRequest request, ModelMap model,@RequestParam(value = "idBienes", required = true) Long[] idBienes){
		
		List<DDSituacionCarga> situacionCarga = (List<DDSituacionCarga>) executor
				.execute("dictionaryManager.getList", "DDSituacionCarga");
		

		List<DDSituacionCarga> situacionCargaEconomica = (List<DDSituacionCarga>) executor
				.execute("dictionaryManager.getList", "DDSituacionCarga");
		
		List<DDTipoCarga> tipoCarga = (List<DDTipoCarga>) executor
				.execute("dictionaryManager.getList", "DDTipoCarga");
	
		
		model.put("idBienes", idBienes);
		model.put("situacionCarga", situacionCarga);
		model.put("situacionCargaEconomica", situacionCargaEconomica);
		model.put("tipoCarga", tipoCarga);
		
		
		return ADD_BIEN_CARGAS;
	}
	
	
	@RequestMapping
	public String saveCargaMultiple(WebRequest request, ModelMap map,@RequestParam(value = "idBienes", required = true) Long[] idBienes) {
		
		for(int i=0;i<idBienes.length;i++){
			saveCarga(request,idBienes[i]);
		}
		return DEFAULT;
	}
	
	/**
	 * Metodo para generar el excel con las instrucciones de subasta
	 * @param request
	 * @param model
	 * @param numAutos
	 * @param fechaSubasta
	 * @param numLotes
	 * @return
	 */
	@RequestMapping
	public String descargarPlantillaInstrucciones(WebRequest request,ModelMap model,@RequestParam(value = "numAutos", required = true) String numAutos,@RequestParam(value = "fechaSubasta", required = true) String fechaSubasta,
			@RequestParam(value = "numLotes", required = true) String numLotes) {
			
			String[] idNumLotes=numLotes.split(",");
		
			List<String> cabeceras = new ArrayList<String>();
			cabeceras.add("Num. Autos");
			cabeceras.add("Fecha subasta");
			cabeceras.add("Lote");
			cabeceras.add("Puja sin postores");
			cabeceras.add("Puja con postores DESDE");
			cabeceras.add("Puja con postores HASTA");
			cabeceras.add("Tipo subasta");
			cabeceras.add("Deuda judicial");
			cabeceras.add("Instrucciones");
		    
			
			List<List<String>> listaValores = new ArrayList<List<String>>();
			
			for (int i=0;i<idNumLotes.length;i++) {

					List<String> filaValores = new ArrayList<String>();
			
					filaValores.add(numAutos);
					filaValores.add(fechaSubasta);
					filaValores.add(idNumLotes[i]);
					filaValores.add("");
					filaValores.add("");
					filaValores.add("");
					filaValores.add("");
					filaValores.add("");
					filaValores.add("");

					listaValores.add(filaValores);
				
			}
			
			HojaExcelMasivoSubastas hojaExcel = new HojaExcelMasivoSubastas();
			hojaExcel.crearNuevoExcel("plantilla_instrucciones.xls", cabeceras, listaValores);
			
			FileItem excelFileItem = new FileItem(hojaExcel.getFile());
	        excelFileItem.setFileName("plantilla_instrucciones.xls");
	        excelFileItem.setContentType(HojaExcel.TIPO_EXCEL);
	        excelFileItem.setLength(hojaExcel.getFile().length());
		    
	        model.put("fileItem",excelFileItem);
			return GENINFVisorInformeController.JSP_DOWNLOAD_FILE;
	}
	
	@RequestMapping
	public String validarFicheroInstrucciones(WebRequest request,Long idTipoOperacion,String nombreFichero){
		
		return DEFAULT;
	}

	/**
	 * Salvar la carga de un bien
	 * 
	 * @param request
	 * @return
	 */

	private String saveCarga(WebRequest request,Long idBien) {

		NMBBienCargas carga;
		if (!Checks.esNulo(request.getParameter("idCarga"))) {
			carga = (NMBBienCargas) proxyFactory.proxy(EditBienApi.class)
					.getCarga(Long.parseLong(request.getParameter("idCarga")));
		} else {
			carga = new NMBBienCargas();
		}

		NMBBien bien = null;
		if (!Checks.esNulo(idBien)) {
			bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(
					idBien);
			carga.setBien(bien);
		}

		if (!Checks.esNulo(request.getParameter("fechaPresentacion"))) {
			try {
				carga.setFechaPresentacion(DateFormat.toDate(request
						.getParameter("fechaPresentacion")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			carga.setFechaPresentacion(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaInscripcion"))) {
			try {
				carga.setFechaInscripcion(DateFormat.toDate(request
						.getParameter("fechaInscripcion")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			carga.setFechaInscripcion(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaCancelacion"))) {
			try {
				carga.setFechaCancelacion(DateFormat.toDate(request
						.getParameter("fechaCancelacion")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			carga.setFechaCancelacion(null);
		}

		if (!Checks.esNulo(request.getParameter("registral"))) {
			carga.setRegistral(Boolean.parseBoolean(request
					.getParameter("registral")));
		} else {
			carga.setRegistral(null);
		}

		if (!Checks.esNulo(request.getParameter("economica"))) {
			carga.setEconomica(Boolean.parseBoolean(request
					.getParameter("economica")));
		} else {
			carga.setEconomica(false);
		}

		if (!Checks.esNulo(request.getParameter("letra"))) {
			carga.setLetra(request.getParameter("letra"));
		} else {
			carga.setLetra(null);
		}

		if (!Checks.esNulo(request.getParameter("titular"))) {
			carga.setTitular(request.getParameter("titular"));
		} else {
			carga.setTitular(null);
		}

		if (!Checks.esNulo(request.getParameter("importeRegistral"))) {
			carga.setImporteRegistral(Float.parseFloat(request
					.getParameter("importeRegistral")));
		} else {
			carga.setImporteRegistral(null);
		}

		if (!Checks.esNulo(request.getParameter("importeEconomico"))) {
			carga.setImporteEconomico(Float.parseFloat(request
					.getParameter("importeEconomico")));
		} else {
			carga.setImporteEconomico(null);
		}

		DDSituacionCarga situacionCarga;
		DDSituacionCarga situacionCargaEconomica;

		if (!Checks.esNulo(request.getParameter("situacionCarga")))
			situacionCarga=subastaManager.getSituacionCarga(request.getParameter("situacionCarga"));
		else {
			situacionCarga = null;
		}
		carga.setSituacionCarga(situacionCarga);

		if (!Checks.esNulo(request.getParameter("situacionCargaEconomica")))
			situacionCargaEconomica=subastaManager.getSituacionCargaEconomica(request.getParameter("situacionCargaEconomica"));
		else {
			situacionCargaEconomica = null;
		}
		carga.setSituacionCargaEconomica(situacionCargaEconomica);

		DDTipoCarga tipoCarga;
		if (!Checks.esNulo(request.getParameter("tipoCarga")))
			tipoCarga=subastaManager.getTipoCarga(request.getParameter("tipoCarga"));
		else {
			tipoCarga = null;
		}
		carga.setTipoCarga(tipoCarga);

		Auditoria auditoria = Auditoria.getNewInstance();
		carga.setAuditoria(auditoria);

		proxyFactory.proxy(EditBienApi.class).guardarCarga(carga);

		return DEFAULT;

	}
	
	@RequestMapping
	public String getEditarRevisionCargas(WebRequest request, ModelMap model,@RequestParam(value = "idBienes", required = true) Long[] idBienes){
		
		model.put("idBienes", idBienes);
		
		return ADD_REVISION_CARGAS;
	}
	
	@RequestMapping
	public String saveRevisionCargasMultiple(WebRequest request, ModelMap map,@RequestParam(value = "idBienes", required = true) Long[] idBienes) {
		
		for(int i=0;i<idBienes.length;i++){
			saveRevisionCargas(request,idBienes[i]);
		}
		return DEFAULT;
	}
	
	private String saveRevisionCargas(WebRequest request,Long idBien) {
		NMBAdicionalBien adicional = new NMBAdicionalBien();
		NMBBien bien = null;
		if (!Checks.esNulo(idBien)) {
			bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(idBien);

			if (bien.getAdicional() != null) {
				adicional = bien.getAdicional();
				Auditoria auditoria = adicional.getAuditoria();
				auditoria.setFechaModificar(new Date());
				adicional.setAuditoria(auditoria);
			} else {
				Auditoria auditoria = Auditoria.getNewInstance();
				adicional.setAuditoria(auditoria);
			}
		} else {
			adicional.setBien(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaRevision"))) {
			try {
				adicional.setFechaRevision(DateFormat.toDate(request
						.getParameter("fechaRevision")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adicional.setFechaRevision(null);
		}

		if (!Checks.esNulo(request.getParameter("sinCargas"))) {
			adicional.setSinCargas(Boolean.parseBoolean(request
					.getParameter("sinCargas")));
		} else {
			adicional.setSinCargas(null);
		}

		if (!Checks.esNulo(request.getParameter("observaciones"))) {
			adicional.setObservaciones(request.getParameter("observaciones"));
		} else {
			adicional.setObservaciones(null);
		}

		bien.setAdicional(adicional);
		adicional.setBien(bien);

		proxyFactory.proxy(EditBienApi.class).guardarRevisionCargas(adicional);

		return DEFAULT;

	}
	
	
	
}
