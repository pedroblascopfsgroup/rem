package es.pfsgroup.plugin.recovery.mejoras.acuerdos.controller;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;
import java.util.TreeMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.DDSubTipoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDTipoProducto;
import es.capgemini.pfs.core.api.acuerdo.AcuerdoApi;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.termino.TerminoOperacionesManager;
import es.capgemini.pfs.termino.dto.ListadoTerminosAcuerdoDto;
import es.capgemini.pfs.termino.dto.TerminoAcuerdoDto;
import es.capgemini.pfs.termino.dto.TerminoOperacionesDto;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.capgemini.pfs.termino.model.TerminoBien;
import es.capgemini.pfs.termino.model.TerminoContrato;
import es.capgemini.pfs.termino.model.TerminoOperaciones;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.MEJAcuerdoApi;
import es.pfsgroup.plugin.recovery.mejoras.api.revisionProcedimientos.RevisionProcedimientoApi;
import es.pfsgroup.plugin.recovery.mejoras.revisionProcedimiento.dto.RevisionProcedimientoDto;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;

@Controller
public class MEJAcuerdoController {
	
	static final String BO_ACUERDO_MGR_RECHAZAR_ACUERDO_MOTIVO = "acuerdoManager.rechazarAcuerdoMotivo";
	static final String JSON_LISTADO_CONTRATOS = "plugin/mejoras/acuerdos/listadoContratosAsuntoJSON";
	static final String JSON_LISTADO_TERMINOS = "plugin/mejoras/acuerdos/listadoTerminosAcuerdoJSON";	
	static final String JSP_ALTA_TERMINO_ACUERDO = "plugin/mejoras/acuerdos/altaTermino";
	static final String JSON_LIST_TIPO_ACUERDO  ="plugin/mejoras/acuerdos/tipoAcuerdoJSON";
	static final String JSON_LIST_SUB_TIPOS_ACUERDO  ="plugin/mejoras/acuerdos/subtiposAcuerdoJSON";
	static final String JSON_LIST_TIPO_PRODUCTO  ="plugin/mejoras/acuerdos/tipoProductoJSON";	
	static final String JSON_LISTADO_BIENES_ACUERDO = "plugin/mejoras/acuerdos/listadoBienesAcuerdoJSON";	
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired TerminoOperacionesManager terminoOperacionesManager;
	
    /**
     * Pasa un acuerdo a estado Rechazado con motivo.
     * @param idAcuerdo el id del acuerdo a rechazar
     */
	@RequestMapping
    public String rechazarAcuerdoMotivo(Long idAcuerdo, String motivo) {
		
		proxyFactory.proxy(MEJAcuerdoApi.class).rechazarAcuerdoMotivo(idAcuerdo, motivo);
		
		return "default";
	}
	
	 /**
     * Obtiene la lista de Contratos asociados aun asunto.
     * @param idAsunto el id del asunto
     */
	@RequestMapping
    public String obtenerListadoContratosAcuerdoByAsuId(ModelMap model, Long idAsunto) {
		List<Contrato> listadoContratosAsuntos = proxyFactory.proxy(MEJAcuerdoApi.class).obtenerListadoContratosAcuerdoByAsuId(idAsunto);
		model.put("listadoContratosAsuntos", listadoContratosAsuntos);
		
		return JSON_LISTADO_CONTRATOS;
	}
	
	 /**
     * Obtiene la lista de Terminos de una acuerdo
     * @param idAcuerdo el id del acuerdo
     */
	@RequestMapping
    public String obtenerListadoTerminosAcuerdoByAcuId(ModelMap model, Long idAcuerdo) {
		List<ListadoTerminosAcuerdoDto> listadoTerminosAcuerdo = proxyFactory.proxy(MEJAcuerdoApi.class).obtenerListadoTerminosAcuerdoByAcuId(idAcuerdo);
		model.put("listadoTerminosAcuerdo", listadoTerminosAcuerdo);
		
		return JSON_LISTADO_TERMINOS;
	}
	
	/**
	 * 
	 * Devuelve la página de alta de terminos
	 * 
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String openAltaTermino(ModelMap map, 
			@RequestParam(value = "id", required = true) Long id,
			String contratosIncluidos, 
			Long idAcuerdo) {
				
		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(id);
			
		map.put("asunto", asunto);
		map.put("contratosIncluidos", contratosIncluidos);		
		map.put("idAcuerdo", idAcuerdo);
		
		return JSP_ALTA_TERMINO_ACUERDO;
	}	
	
	/**
	 * Obtener la lista de tipos de acuerdo
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping
	public String getListTipoAcuerdosData(ModelMap model){
		List<DDTipoAcuerdo> list = proxyFactory.proxy(MEJAcuerdoApi.class).getListTipoAcuerdo();
		model.put("data", list);
		return JSON_LIST_TIPO_ACUERDO;
	}	
	
	
	/**
	 * Obtener la lista de sub-tipos de acuerdo
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping
	public String getListSubTiposAcuerdosData(ModelMap model){
		List<DDSubTipoAcuerdo> list = proxyFactory.proxy(MEJAcuerdoApi.class).getListSubTipoAcuerdo();
		model.put("data", list);
		return JSON_LIST_SUB_TIPOS_ACUERDO;
	}
	
	/**
	 * Obtener la lista de tipos de producto
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping
	public String getListTipoProductosData(ModelMap model){
		List<DDTipoProducto> list = proxyFactory.proxy(MEJAcuerdoApi.class).getListTipoProducto();
		model.put("data", list);
		return JSON_LIST_TIPO_PRODUCTO;
	}	
	
	/**
	 * Creación de un Término asociado a un objeto
	 * 
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")	
	@RequestMapping
	public String crearTerminoAcuerdo(TerminoOperacionesDto termOpDto, WebRequest request, ModelMap model){
		
		TerminoAcuerdoDto taDTO = creaTerminoAcuerdoDTO(request);
		
		String contratosIncluidos = request.getParameter("contratosIncluidos"); 
		String bienesIncluidos = request.getParameter("bienesIncluidos"); 		
		
		TerminoAcuerdo ta = new TerminoAcuerdo();
		EXTAcuerdo acuerdo = genericDao.get(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", taDTO.getIdAcuerdo()));
		ta.setAcuerdo(acuerdo);
		DDTipoAcuerdo tipoAcuerdo = genericDao.get(DDTipoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", taDTO.getIdTipoAcuerdo()));
		ta.setTipoAcuerdo(tipoAcuerdo);
		DDSubTipoAcuerdo subtipoAcuerdo = genericDao.get(DDSubTipoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", taDTO.getIdSubTipoAcuerdo()));
		ta.setSubtipoAcuerdo(subtipoAcuerdo);
		DDTipoProducto tipoProducto = genericDao.get(DDTipoProducto.class, genericDao.createFilter(FilterType.EQUALS, "id", taDTO.getIdTipoProducto()));
		ta.setTipoProducto(tipoProducto);
		ta.setModoDesembolso(taDTO.getModoDesembolso());
		ta.setFormalizacion(taDTO.getFormalizacion());
		ta.setImporte(taDTO.getImporte());
		ta.setComisiones(taDTO.getComisiones());		
		ta.setPeriodicidad(taDTO.getPeriodicidad());
		ta.setPeriodoFijo(taDTO.getPeriodoFijo());
		ta.setSistemaAmortizacion(taDTO.getSistemaAmortizacion());
		ta.setPeriodoVariable(taDTO.getPeriodoVariable());
		ta.setInformeLetrado(taDTO.getInformeLetrado());
		
		TerminoAcuerdo taSaved = proxyFactory.proxy(MEJAcuerdoApi.class).saveTerminoAcuerdo(ta);
		
		TerminoOperaciones terminooperaciones = terminoOperacionesManager.creaTerminoOperaciones(termOpDto);
		terminooperaciones.setTermino(taSaved);
		terminoOperacionesManager.guardaTerminoOperaciones(terminooperaciones);
		
		// Creamos los contratos asociados al termino
		if (contratosIncluidos.trim().length()>0) 
			crearContratosTermino(taSaved, contratosIncluidos);
		
		// Creamos los bienes asociados al termino
		if (bienesIncluidos.trim().length()>0) 		
			crearBienesTermino(taSaved, bienesIncluidos);
		
		return "default";

		
	}	
	

	/**
	 * Creación del DTO de TerminoAcuerdo
	 * 
	 * @param model
	 * @return
	 */
	public TerminoAcuerdoDto creaTerminoAcuerdoDTO(WebRequest request){
		TerminoAcuerdoDto taDTO = new TerminoAcuerdoDto();
					
		if (!Checks.esNulo(request.getParameter("idAcuerdo"))) taDTO.setIdAcuerdo(Long.parseLong(request.getParameter("idAcuerdo")));
		if (!Checks.esNulo(request.getParameter("idTipoAcuerdo"))) taDTO.setIdTipoAcuerdo(Long.parseLong(request.getParameter("idTipoAcuerdo")));
		if (!Checks.esNulo(request.getParameter("idSubTipoAcuerdo"))) taDTO.setIdSubTipoAcuerdo(Long.parseLong(request.getParameter("idSubTipoAcuerdo")));
		if (!Checks.esNulo(request.getParameter("idTipoProducto"))) taDTO.setIdTipoProducto(Long.parseLong(request.getParameter("idTipoProducto")));		
		if (!Checks.esNulo(request.getParameter("modoDesembolso"))) taDTO.setModoDesembolso(request.getParameter("modoDesembolso"));
		if (!Checks.esNulo(request.getParameter("formalizacion"))) taDTO.setFormalizacion(request.getParameter("formalizacion"));
		if (!Checks.esNulo(request.getParameter("importe"))) taDTO.setImporte(Float.parseFloat(request.getParameter("importe")));
		if (!Checks.esNulo(request.getParameter("comisiones"))) taDTO.setComisiones(Float.parseFloat(request.getParameter("comisiones")));
		if (!Checks.esNulo(request.getParameter("periodoCarencia"))) taDTO.setPeriodoCarencia(request.getParameter("periodoCarencia"));
		if (!Checks.esNulo(request.getParameter("periodicidad"))) taDTO.setPeriodicidad(request.getParameter("periodicidad"));
		if (!Checks.esNulo(request.getParameter("periodoFijo"))) taDTO.setPeriodoFijo(request.getParameter("periodoFijo"));
		if (!Checks.esNulo(request.getParameter("sistemaAmortizacion"))) taDTO.setSistemaAmortizacion(request.getParameter("sistemaAmortizacion"));
		if (!Checks.esNulo(request.getParameter("interes"))) taDTO.setInteres(Float.parseFloat(request.getParameter("interes")));
		if (!Checks.esNulo(request.getParameter("periodoVariable"))) taDTO.setPeriodoVariable(request.getParameter("periodoVariable"));
		if (!Checks.esNulo(request.getParameter("informeLetrado"))) taDTO.setInformeLetrado(request.getParameter("informeLetrado"));		
			
		return taDTO;
	}
	
	/**
	 * Creción de los Contratos asociados al Término
	 * 
	 * @param ta TerminoAcuerdo guardado
	 * @param contratosIncluidos Cadena con los códigos de los contratos
	 * 
	 */
	public void crearContratosTermino(TerminoAcuerdo ta, String contratosIncluidos){
		StringTokenizer tokens = new StringTokenizer(contratosIncluidos, ",");
		Contrato cnt; 
		TerminoContrato tc;
		while (tokens.hasMoreTokens()){
			cnt = genericDao.get(Contrato.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(tokens.nextElement()+"")));
			tc = new TerminoContrato();
			tc.setContrato(cnt);
			tc.setTermino(ta);
			
			proxyFactory.proxy(MEJAcuerdoApi.class).saveTerminoContrato(tc);			
			
		}
	}
	
	/**
	 * Creción de los Bienes asociados al Término
	 * 
	 * @param ta TerminoAcuerdo guardado
	 * @param bienesIncluidos Cadena con los códigos de los bienes
	 * 
	 */
	public void crearBienesTermino(TerminoAcuerdo ta, String bienesIncluidos){
		StringTokenizer tokens = new StringTokenizer(bienesIncluidos, ",");
		Bien bien; 
		TerminoBien tb;
		while (tokens.hasMoreTokens()){
			bien = genericDao.get(Bien.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(tokens.nextElement()+"")));
			tb = new TerminoBien();
			tb.setBien(bien);
			tb.setTermino(ta);
			
			proxyFactory.proxy(MEJAcuerdoApi.class).saveTerminoBien(tb);			
			
		}
	}	
	
	 /**
     * Obtiene la lista de Bienes asociados a todos los procedimientos de un asunto
     * 
     * @param idAcuerdo el id del acuerdo
     */
	@RequestMapping
    public String obtenerListadoBienesAcuerdoByAsuId(ModelMap model, Long idAsunto) {
		List<Bien> listadoBienesAcuerdoRep = proxyFactory.proxy(AsuntoApi.class).getBienesDeUnAsunto(idAsunto);
	    
		// En este punto tenemos una lista de bienes que puede estar repetida
		// Vamos a procesarla para quedarnos solo con los no repetidos
	    TreeMap<Long, Bien> bienesAsuntoMap = new TreeMap<Long, Bien>();
    	for (Bien bien : listadoBienesAcuerdoRep){
    		bienesAsuntoMap.put(bien.getId(), bien);
    	}	
    	
        // Convertir el Map con los bienes en una lista
        List<Bien> listadoBienesAcuerdo = new ArrayList<Bien>();
        Bien bienL;
        for(Iterator it = bienesAsuntoMap.keySet().iterator(); it.hasNext();) {
        	bienL = (Bien) bienesAsuntoMap.get(it.next());
        	listadoBienesAcuerdo.add(bienL);
       	}  
        
		model.put("listadoBienesAcuerdo", listadoBienesAcuerdo);
		
		return JSON_LISTADO_BIENES_ACUERDO;
	}	
	
	/**
	 * Eliminar un Término asociado a un objeto
	 * 
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")	
	@RequestMapping
	public String eliminarTerminoAcuerdo(WebRequest request, ModelMap model){			
		String idTerminoAcuerdo = request.getParameter("idTerminoAcuerdo");
		
		// eliminar los Contratos asociados al Termino
		eliminarContratosTermino(Long.parseLong(idTerminoAcuerdo));
		
		// eliminar los Bienes asociados al Termino
		eliminarBienesTermino(Long.parseLong(idTerminoAcuerdo));
		
		TerminoAcuerdo ta = genericDao.get(TerminoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(idTerminoAcuerdo)));
		
		proxyFactory.proxy(MEJAcuerdoApi.class).deleteTerminoAcuerdo(ta);	
		
		return "default";
		
	}
	
	
	/**
	 * 
	 * Eliminar los contratos asociados a un Termino
	 * 
	 * @param idTerminoAcuerdo
	 * 
	 */
	public void eliminarContratosTermino(Long idTerminoAcuerdo){
		
		 List<TerminoContrato> tcList = genericDao.getList(TerminoContrato.class, genericDao.createFilter(FilterType.EQUALS, "termino.id", idTerminoAcuerdo));
		 
		 for (TerminoContrato tc : tcList){
			 proxyFactory.proxy(MEJAcuerdoApi.class).deleteTerminoContrato(tc);
		 }		
	}
	
	/**
	 * 
	 * Eliminar los bienes asociados a un Termino
	 * 
	 * @param idTerminoAcuerdo
	 * 
	 */
	public void eliminarBienesTermino(Long idTerminoAcuerdo){
		
		 List<TerminoBien> tbList = genericDao.getList(TerminoBien.class, genericDao.createFilter(FilterType.EQUALS, "termino.id", idTerminoAcuerdo));
		 
		 for (TerminoBien tb : tbList){
			 proxyFactory.proxy(MEJAcuerdoApi.class).deleteTerminoBien(tb);
		 }		
	}	

}
