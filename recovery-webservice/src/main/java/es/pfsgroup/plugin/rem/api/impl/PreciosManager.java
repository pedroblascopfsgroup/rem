package es.pfsgroup.plugin.rem.api.impl;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.PreciosApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.PropuestaPreciosExcelReport;
import es.pfsgroup.plugin.rem.factory.PropuestaPreciosExcelFactoryApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoPropuesta;
import es.pfsgroup.plugin.rem.model.ActivoPropuesta.ActivoPropuestaPk;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.AdjuntoTrabajo;
import es.pfsgroup.plugin.rem.model.CarteraCondicionesPrecios;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoConfiguracionPropuestasPrecios;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;
import es.pfsgroup.plugin.rem.model.VBusquedaNumActivosTipoPrecio;
import es.pfsgroup.plugin.rem.model.VDatosPropuestaEntidad01;
import es.pfsgroup.plugin.rem.model.VDatosPropuestaEntidad02;
import es.pfsgroup.plugin.rem.model.VDatosPropuestaEntidad03;
import es.pfsgroup.plugin.rem.model.VDatosPropuestaUnificada;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCondicionIndicadorPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPropuestaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPropuestaPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPropuestaPrecio;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.PropuestaPrecioDao;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.VActivosPropuestaDao;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.VNumActivosTipoPrecioDao;
import es.pfsgroup.plugin.rem.propuestaprecios.dto.DtoGenerarPropuestaPreciosUnificada;
import es.pfsgroup.plugin.rem.propuestaprecios.dto.DtoGenerarPropuestaPrecios;
import es.pfsgroup.plugin.rem.propuestaprecios.dto.DtoGenerarPropuestaPreciosEntidad01;
import es.pfsgroup.plugin.rem.propuestaprecios.dto.DtoGenerarPropuestaPreciosEntidad02;
import es.pfsgroup.plugin.rem.propuestaprecios.dto.DtoGenerarPropuestaPreciosEntidad03;
import es.pfsgroup.plugin.rem.service.PropuestaPreciosExcelService;
import es.pfsgroup.plugin.rem.trabajo.dao.TrabajoDao;

@Service("preciosManager")
public class PreciosManager extends BusinessOperationOverrider<PreciosApi> implements  PreciosApi {
	
	protected static final Log logger = LogFactory.getLog(PreciosManager.class);
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private PropuestaPrecioDao propuestaPrecioDao;
	
	@Autowired
	private VActivosPropuestaDao vActivosPropuestaDao;
	
	@Autowired
	private VNumActivosTipoPrecioDao vNumActivosTipoPrecioDao;
	
	@Autowired
	private PropuestaPreciosExcelFactoryApi propuestaPreciosExcelFactory;

	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private TrabajoDao trabajoDao;

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	//Porcentajes para el calculo de precios propuestos
	private static final Double PORC_120 = 1.20;
	private static final Double PORC_115 = 1.15;
	private static final Double PORC_110 = 1.10;
	private static final Double PORC_090 = 0.90;
	private static final Double PORC_075 = 0.75;
	private static final Double PORC_060 = 0.60;
		
	@Override
	public String managerName() {
		return "preciosManager";
	}
	
	@Override
	public Page getActivos(DtoActivoFilter dtoActivoFiltro) {
		
		return activoDao.getListActivosPrecios(dtoActivoFiltro);
		
	}	
	
	@Override
	public Page getPropuestas(DtoPropuestaFilter dtoPropuestaFiltro) {

		return propuestaPrecioDao.getListPropuestasPrecio(dtoPropuestaFiltro);
	}

	@Override
	@Transactional(readOnly = false)
	public PropuestaPrecio createPropuestaPreciosAutom(List<VBusquedaActivosPrecios> activosPrecios, String nombrePropuesta, String tipoPropuestaCodigo){
	
		// Consejo: seguir los mismos pasos de la propuesta manual
		// No se utiliza, he reaprovechando el Manual, que hace lo mismo
		return new PropuestaPrecio();
	}
	
	@Override
	public Page getHistoricoPropuestasPrecios(DtoHistoricoPropuestaFilter dtoPropuestaFiltro) {
		Long usuarioId = genericAdapter.getUsuarioLogado().getId();

		return propuestaPrecioDao.getListHistoricoPropuestasPrecios(dtoPropuestaFiltro, usuarioId);
	}
	
	@Override
	@Transactional(readOnly = false)
	public PropuestaPrecio createPropuestaPreciosManual(List<VBusquedaActivosPrecios> activosPrecios, String nombrePropuesta, String tipoPropuestaCodigo) throws Exception{

		// Funcionalidad para crear una propuesta generada desde la pantalla "Generar propuesta - Manual - Automatica"
		
		// Se instancia una lista de Activos, usando los id's de activos de la lista del buscador
		List<Activo> activos = new ArrayList<Activo>();
		for(VBusquedaActivosPrecios activoPrecio : activosPrecios){
			if(!activoPrecio.getActivoEnPropuestaEnTramitacion()) {
				Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(activoPrecio.getId()));
				Activo activo = genericDao.get(Activo.class, filtroActivo);
				activos.add(activo);
			}
		}
		
		//Si esta vacio, es porque todos los activos de la busqueda están incluidos en otras propuestas en trámite.
		if(Checks.estaVacio(activos))
			return null;
		
		// Se toman precauciones para crear una lista con activos unicos ya que proveniendo de una vista,
		// pueden haberse creado filas multiples del mismo activo
		Set<Activo> uniqueSetActivos =  new HashSet<Activo>(activos);
		List<Activo> uniqueListActivos = new ArrayList<Activo>(uniqueSetActivos);
		
		// Nueva propuesta de precios con activos asociados
		PropuestaPrecio propuestaPrecio = createPropuestaPrecios(uniqueListActivos, nombrePropuesta, tipoPropuestaCodigo, null);
		
		// Nuevo trabajo+tramite de propuesta de precios: Preciar o Repreciar
		// La propuesta es necesaria en el create ya que es necesario crear la relacion con el nuevo trabajo.
		DDSubtipoTrabajo subtipoTrabajoPropuestaPrecios = (DDSubtipoTrabajo) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoTrabajo.class, DDSubtipoTrabajo.CODIGO_TRAMITAR_PROPUESTA_PRECIOS);
		Trabajo trabajo = trabajoApi.create(subtipoTrabajoPropuestaPrecios, uniqueListActivos, propuestaPrecio);
		
		// Relacion nuevo trabajo con nueva propuesta
		propuestaPrecio.setTrabajo(trabajo);
		
		propuestaPrecioDao.saveOrUpdate(propuestaPrecio);
		
		return propuestaPrecio;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public PropuestaPrecio createPropuestaPreciosFromTrabajo(Long idTrabajo, String nombrePropuesta) {
		
		PropuestaPrecio propuesta = null;
		
		List<BigDecimal> listIdActivos = propuestaPrecioDao.getActivosFromTrabajo(idTrabajo);
		
		if(!Checks.estaVacio(listIdActivos)) {
			List<Activo> activos = new ArrayList<Activo>();
			for(BigDecimal idActivo : listIdActivos) {
				
				Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "id",idActivo.longValue());
				Activo activo = genericDao.get(Activo.class, filtroActivo);
				activos.add(activo);
			}
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idTrabajo);
			Trabajo trabajo = genericDao.get(Trabajo.class, filtro);
			String codigoPropuesta = this.getCodTipoPropuestaFromSubtipoTrabajo(trabajo.getSubtipoTrabajo().getCodigo());
	
			propuesta = createPropuestaPrecios(activos, nombrePropuesta, codigoPropuesta, trabajo);
		}
		return propuesta;
	}
	
	/**
	 * Crea una nueva propuesta de precios del tipo indicado, para una lista de activos
	 * Es un metodo generico para crear cualquier propuesta de precios
	 * @param activos
	 * @param nombrePropuesta Nombre que se da a la propuesta
	 * @param tipoPropuestaCodigo Tipo de propuesta solicitada: Preciar, Repreciar, Descuento
	 * @param esPropManual Indicador del origen de la propuesta: Peticion o Manual
	 * @return PropuestaPrecio
	 */
	private PropuestaPrecio createPropuestaPrecios(List<Activo> activos, String nombrePropuesta, String tipoPropuestaCodigo, Trabajo trabajo){
		
		PropuestaPrecio propuestaPrecio = new PropuestaPrecio();
		
		propuestaPrecio.setNombrePropuesta(nombrePropuesta);

		// Las propuestas se generan con activos de una misma cartera
		// Para extraer la cartera de una propuesta, se toma de la cartera del 1er activo
		if(!Checks.esNulo(activos) && !Checks.esNulo(activos.get(0))){
			DDCartera cartera = (DDCartera) utilDiccionarioApi.dameValorDiccionarioByCod(DDCartera.class, activos.get(0).getCartera().getCodigo());
			propuestaPrecio.setCartera(cartera);
		}
		
		propuestaPrecio.setGestor(genericAdapter.getUsuarioLogado());
		propuestaPrecio.setFechaEmision(new Date());
		propuestaPrecio.setNumPropuesta(propuestaPrecioDao.getNextNumPropuestaPrecio());
		
		DDEstadoPropuestaPrecio estadoPropuestaPrecios = (DDEstadoPropuestaPrecio) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPropuestaPrecio.class, DDEstadoPropuestaPrecio.ESTADO_GENERADA);
		propuestaPrecio.setEstado(estadoPropuestaPrecios);
		DDTipoPropuestaPrecio tipoPropuestaPrecio = (DDTipoPropuestaPrecio) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPropuestaPrecio.class, tipoPropuestaCodigo);
		propuestaPrecio.setTipoPropuesta(tipoPropuestaPrecio);
		
		if(Checks.esNulo(trabajo))
			propuestaPrecio.setEsPropuestaManual(true);
		else {
			propuestaPrecio.setEsPropuestaManual(false);
			propuestaPrecio.setTrabajo(trabajo);
		}
		propuestaPrecio.setActivosPropuesta(listaActivosToActivosPropuesta(activos, propuestaPrecio));
		propuestaPrecioDao.saveOrUpdate(propuestaPrecio);
		
		this.eliminarMarcaActivosPropuesta(propuestaPrecio.getActivosPropuesta(), tipoPropuestaPrecio);
		
		return propuestaPrecio;
		
	}

	private List<ActivoPropuesta> listaActivosToActivosPropuesta(List<Activo> activos, PropuestaPrecio propuestaPrecio){
		List<ActivoPropuesta> listaActivosPropuesta = new ArrayList<ActivoPropuesta>();
		
		for(Activo activo : activos){
			ActivoPropuesta activoPropuesta = createActivoPropuesta(activo, propuestaPrecio);
			listaActivosPropuesta.add(activoPropuesta);
		}
		
		return listaActivosPropuesta;
	}
	
	private ActivoPropuesta createActivoPropuesta(Activo activo, PropuestaPrecio propuestaPrecio){
		ActivoPropuesta activoPropuesta = new ActivoPropuesta();
		ActivoPropuestaPk activoPropuestaPK = new ActivoPropuestaPk();

		activoPropuestaPK.setActivo(activo);
		activoPropuestaPK.setPropuestaPrecio(propuestaPrecio);
		activoPropuesta.setPrimaryKey(activoPropuestaPK);
		activoPropuesta.setEstado((DDEstadoPropuestaActivo) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPropuestaActivo.class, DDEstadoPropuestaActivo.ESTADO_PENDIENTE));

		return activoPropuesta;
	}
	
	@Override
	public ExcelReport createExcelPropuestaPrecios(List<VBusquedaActivosPrecios> activosPrecios, String entidadPropietariaCodigo, String nombrePropuesta) {
		
		PropuestaPreciosExcelService propuestaPreciosService = propuestaPreciosExcelFactory.getService(entidadPropietariaCodigo);
		
		List<Map<String,String>> lista = propuestaPreciosService.getExcelData(activosPrecios);
		
		return new PropuestaPreciosExcelReport(lista, nombrePropuesta);			
		
	}
	
	@Override
	public Page getActivosByIdPropuesta(Long idPropuesta, WebDto webDto) {
		
		return vActivosPropuestaDao.getListActivosByPropuestaPrecio(idPropuesta,webDto);
	}
	
	@Override
	public List<VBusquedaNumActivosTipoPrecio> getNumActivosByTipoPrecioAndCartera() {
		
		return vNumActivosTipoPrecioDao.getNumActivosByTipoPrecioAndCartera();
	}
	
	@Override
	public List<VBusquedaNumActivosTipoPrecio> getNumActivosByTipoPrecioAndEstadoSareb(){
		return this.getNumActivosByTipoPrecioAndEstado(DDCartera.CODIGO_CARTERA_SAREB);
	}
	
	@Override
	public List<VBusquedaNumActivosTipoPrecio> getNumActivosByTipoPrecioAndEstado(String entidadPropietariaCodigo){
		return vNumActivosTipoPrecioDao.getNumActivosByTipoPrecioAndEstado(entidadPropietariaCodigo);
	}
	
	/**
	 * Método para quitar la marca del Activo (preciar/repreciar/descuento) una vez se ha generado la propuesta correspondiente
	 * @param listaActProp
	 * @param tipoPropuestaPrecio
	 */
	private void eliminarMarcaActivosPropuesta(List<ActivoPropuesta> listaActProp, DDTipoPropuestaPrecio tipoPropuestaPrecio) {
		
		for(ActivoPropuesta actProp : listaActProp) {
			Activo activo = actProp.getPrimaryKey().getActivo();
			
			switch (Integer.parseInt(tipoPropuestaPrecio.getCodigo())) {
				case 1:
					activo.setFechaPreciar(null);
					break;
				case 2:
					activo.setFechaRepreciar(null);
					break;
				case 3:
					activo.setFechaDescuento(null);
					break;
				default:					
			}
			
			activoDao.update(activo);
			
		}
	}
	
	/**
	 * Al final se divide en tres excels, se conserva por posible aplicación futura
	 */
	@Override
	public List<DtoGenerarPropuestaPreciosUnificada> getDatosPropuestaUnificada(Long idPropuesta) throws IllegalAccessException, InvocationTargetException {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idPropuesta", idPropuesta);
		List<VDatosPropuestaUnificada> listDatosPropuesta = genericDao.getList(VDatosPropuestaUnificada.class,filtro);
		List<DtoGenerarPropuestaPreciosUnificada> listDto = new ArrayList<DtoGenerarPropuestaPreciosUnificada>();
		
		
		for(VDatosPropuestaUnificada datos : listDatosPropuesta) {
			DtoGenerarPropuestaPreciosUnificada dto = new DtoGenerarPropuestaPreciosUnificada();
			BeanUtils.copyProperties(dto, datos);
			BeanUtils.copyProperty(dto, "valorPropuesto", valorPropuestaPrecio(dto, null));
			
			listDto.add(dto);
		}
		
		return listDto;
		
	}
	
	/**
	 * Devuelve el precio propuesto, y lo calcula según cartera
	 * @param dto
	 * @return
	 */
	private Double valorPropuestaPrecio(DtoGenerarPropuestaPrecios dto, Double valorAdquisitivo) {
		
		Integer cartera = Integer.parseInt(dto.getCodCartera());
		Double resultado = null;

		
		switch (cartera) {

		case 1: // Cajamar
			resultado = precioPropuestoCajamar(dto.getValorFsv(), dto.getValorTasacion(), dto.getValorVnc(),
					valorAdquisitivo);
			break;
		case 2: // Sareb
			resultado = precioPropuestoSareb(dto.getValorFsv());
			break;
		case 3: // Bankia
			if (dto.getCodSubCartera() != null && dto.getCodCartera() != null && dto.getCodCartera().equals("03"))
				resultado = precioPropuestoBankiaTerceros(dto.getValorTasacion());
			else
				resultado = precioPropuestoBankia(
						dto.getTipoActivoCodigo() != null && dto.getTipoActivoCodigo().equals("02"),
						dto.getValorTasacion(), dto.getValorVnc(), dto.getValorLiquidativo(), dto.getValorFsv());
			break;
		default:
			break;

		}

		return resultado;
	}
	
	/**
	 * Calculo del precio propuesta para Cajamar
	 * @param fsv
	 * @param tasacion
	 * @param vnc
	 * @param adquisicion
	 * @return
	 */
	private Double precioPropuestoCajamar(Double fsv, Double tasacion, Double vnc, Double adquisicion) {
		
		if((fsv > tasacion * PORC_110) && (fsv > vnc * PORC_110) && (fsv > adquisicion * PORC_110))
			return fsv;
		
		if((PORC_110 * vnc) > (PORC_090 * tasacion) && (PORC_110 * vnc) > (PORC_060 * adquisicion))
			return PORC_110 * vnc;
		
		if((tasacion > PORC_110 * vnc) && (tasacion > PORC_060 * adquisicion))
			return tasacion;
		
		if((PORC_060 * adquisicion) > (PORC_090 * tasacion) && (PORC_060 * adquisicion) > (PORC_110 * vnc))
			return PORC_060 * adquisicion;
		
		return tasacion;
	}
	
	/**
	 * Calculo del precio propuesta para Sareb
	 * @param fsv
	 * @return
	 */
	private Double precioPropuestoSareb(Double fsv) {

		return PORC_110 * fsv;
	}
	
	/**
	 * Calculo del precio propuesta para Bankia
	 * @param residencial
	 * @param tasacion
	 * @param vnc
	 * @param liquidativo
	 * @param fsv
	 * @return
	 */
	private Double precioPropuestoBankia(Boolean residencial, Double tasacion, Double vnc, Double liquidativo, Double fsv) {
		
		Double vncDefecto = PORC_110 * vnc;
		
		if(!residencial) {
			if(tasacion >= vnc)
				return PORC_110 * tasacion;
		}
		else {
			Double mayor = liquidativo > fsv ? liquidativo : fsv;
			
			if(!Checks.esNulo(liquidativo) && !Checks.esNulo(fsv) && (PORC_115 * mayor >= vncDefecto)) {
				return PORC_115 * mayor;
			}
			else if(!Checks.esNulo(liquidativo) && Checks.esNulo(fsv) && (PORC_120 * liquidativo >= vncDefecto)) {
				return PORC_120 * liquidativo;
			}
			else if(Checks.esNulo(liquidativo) && Checks.esNulo(fsv) && (PORC_075 * tasacion >= vncDefecto)) {
				return PORC_075 * tasacion;
			}
			else if(Checks.esNulo(liquidativo) && !Checks.esNulo(fsv) && (PORC_115 * fsv >= vncDefecto)) {
				return PORC_115 * fsv;
			}
			
		}
		
		return vncDefecto;
	
	}
	
	private Double precioPropuestoBankiaTerceros(Double tasacion) {
		return tasacion;	
	}
	
	/**
	 * Segun el subtipo de Trabajo, devuelve un codigo de tipo propuesta
	 * @param codSubtipo
	 * @return
	 */
	private String getCodTipoPropuestaFromSubtipoTrabajo(String codSubtipo) {
		
		if(codSubtipo.equals(DDSubtipoTrabajo.CODIGO_TRAMITAR_PROPUESTA_PRECIOS))
			return DDTipoPropuestaPrecio.TIPO_PRECIAR;
		else if(codSubtipo.equals(DDSubtipoTrabajo.CODIGO_TRAMITAR_PROPUESTA_DESCUENTO))
			return DDTipoPropuestaPrecio.TIPO_DESCUENTO;
		else
			return null;
	}
	
	@Override
	public String puedeCreasePropuestaFromTrabajo(Long idTrabajo) {
		
		String mensaje = "";
		
		//Si el trabajo ya tiene una propuesta asociada, no debe crearla
		if(!propuestaPrecioDao.existePropuestaEnTrabajo(idTrabajo)) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idTrabajo);
			Trabajo trabajo = genericDao.get(Trabajo.class, filtro);
			String codigoPropuesta = this.getCodTipoPropuestaFromSubtipoTrabajo(trabajo.getSubtipoTrabajo().getCodigo());
			
			// Si el subtipo de trabajo no es de preciar o descuento, no se genera la propuesta
			if(Checks.esNulo(codigoPropuesta)) {
				mensaje = "El Tipo/Subtipo de trabajo no permite generar una propuesta de precios.";
			}			
		}
		else {
			mensaje = "Ya existe una propuesta asociada";
		}
		
		return mensaje;
	}
	
	@Override
	public PropuestaPrecio getPropuestaByTrabajo(Long idTrabajo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", idTrabajo);
		Order orden = new Order(OrderType.DESC,"auditoria.fechaCrear");
		
		List<PropuestaPrecio>  listaPropuestas = genericDao.getListOrdered(PropuestaPrecio.class, orden, filtro);
		PropuestaPrecio propuesta = null;
		
		if(!Checks.estaVacio(listaPropuestas))
			propuesta = listaPropuestas.get(0);
		
		return propuesta;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void guardarFileEnTrabajo(File file, Trabajo trabajo) {
		FileItem fileItem = new FileItem(file);
		fileItem.setContentType("application/vnd.ms-excel");
		fileItem.setFileName(file.getName());
		fileItem.setLength(file.length());
		
		try {
			Adjunto adj = uploadAdapter.saveBLOB(fileItem);
			
			AdjuntoTrabajo adjuntoTrabajo = new AdjuntoTrabajo();
			adjuntoTrabajo.setAdjunto(adj);
			adjuntoTrabajo.setTrabajo(trabajo);

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoDocumentoActivo.CODIGO_LISTADO_PROPUESTA_PRECIOS);
			DDTipoDocumentoActivo tipoDocumento =  genericDao.get(DDTipoDocumentoActivo.class, filtro);
			
			adjuntoTrabajo.setTipoDocumentoActivo(tipoDocumento);
			adjuntoTrabajo.setContentType(fileItem.getContentType());
			adjuntoTrabajo.setTamanyo(fileItem.getLength());
			adjuntoTrabajo.setNombre(fileItem.getFileName());
			adjuntoTrabajo.setFechaDocumento(new Date());
			Auditoria.save(adjuntoTrabajo);
			
			List<AdjuntoTrabajo> adjuntosTrabajo = new ArrayList<AdjuntoTrabajo>();
			if(!Checks.estaVacio(trabajo.getAdjuntos()))
			{
				adjuntosTrabajo.addAll(trabajo.getAdjuntos());
				adjuntosTrabajo.add(adjuntoTrabajo);
				
				trabajo.getAdjuntos().clear();
				trabajo.getAdjuntos().addAll(adjuntosTrabajo);
	
				trabajoDao.save(trabajo);
			}
			else {
				genericDao.save(AdjuntoTrabajo.class, adjuntoTrabajo);
			}
			
			// Copia de adjunto al Activo
			ActivoAdjuntoActivo adjuntoActivo = new ActivoAdjuntoActivo();
			
			adjuntoActivo.setAdjunto(adj);
			adjuntoActivo.setActivo(trabajo.getActivo());
			adjuntoActivo.setTipoDocumentoActivo(tipoDocumento);
			adjuntoActivo.setContentType(fileItem.getContentType());
			adjuntoActivo.setTamanyo(fileItem.getLength());
			adjuntoActivo.setNombre(fileItem.getFileName());
			adjuntoActivo.setFechaDocumento(new Date());
			Auditoria.save(adjuntoActivo);
			
			List<ActivoAdjuntoActivo> adjuntosActivo = new ArrayList<ActivoAdjuntoActivo>();
			if(!Checks.estaVacio(trabajo.getActivo().getAdjuntos())) {
				adjuntosActivo.addAll(trabajo.getActivo().getAdjuntos());
				adjuntosActivo.add(adjuntoActivo);
				
				trabajo.getActivo().getAdjuntos().clear();
				trabajo.getActivo().getAdjuntos().addAll(adjuntosActivo);
			}
			else {
				genericDao.save(ActivoAdjuntoActivo.class, adjuntoActivo);
			}

		} catch (Exception e) {
			logger.error(e.getMessage(),e);
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public <T> List<T> getDatosPropuestaByEntidad(PropuestaPrecio propuesta) throws IllegalAccessException, InvocationTargetException {
		
		if(DDCartera.CODIGO_CARTERA_CAJAMAR.equals(propuesta.getCartera().getCodigo())) {
				return (List<T>) this.getDatosPropuestaEntidad01(propuesta.getId());
			} 
			else if(DDCartera.CODIGO_CARTERA_SAREB.equals(propuesta.getCartera().getCodigo())) {
				return (List<T>) this.getDatosPropuestaEntidad02(propuesta.getId());
			}
			else if(DDCartera.CODIGO_CARTERA_BANKIA.equals(propuesta.getCartera().getCodigo())) {
				return (List<T>) this.getDatosPropuestaEntidad03(propuesta.getId());
			}
			else {
				return (List<T>) this.getDatosPropuestaUnificada(propuesta.getId());
				
			}

	}
	
	/**
	 * Devuelve el listado con los datos para la generación de propuesta de precios de la Entidad con códgio '03'
	 * @param idPropuesta
	 * @return
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	private List<DtoGenerarPropuestaPreciosEntidad03> getDatosPropuestaEntidad03(Long idPropuesta) throws IllegalAccessException, InvocationTargetException {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idPropuesta", idPropuesta);
		List<VDatosPropuestaEntidad03> listDatosPropuesta = genericDao.getList(VDatosPropuestaEntidad03.class,filtro);
		List<DtoGenerarPropuestaPreciosEntidad03> listDto = new ArrayList<DtoGenerarPropuestaPreciosEntidad03>();
		
		for(VDatosPropuestaEntidad03 datos : listDatosPropuesta) {
			DtoGenerarPropuestaPreciosEntidad03 dto = new DtoGenerarPropuestaPreciosEntidad03();
			BeanUtils.copyProperties(dto, datos);
			BeanUtils.copyProperty(dto, "valorPropuesto", valorPropuestaPrecio(dto, null));
			
			listDto.add(dto);
		}
		
		return listDto;
	}
	
	/**
	 * Devuelve el listado con los datos para la generación de propuesta de precios de la Entidad con códgio '02'
	 * @param idPropuesta
	 * @return
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	private List<DtoGenerarPropuestaPreciosEntidad02> getDatosPropuestaEntidad02(Long idPropuesta) throws IllegalAccessException, InvocationTargetException {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idPropuesta", idPropuesta);
		List<VDatosPropuestaEntidad02> listDatosPropuesta = genericDao.getList(VDatosPropuestaEntidad02.class,filtro);
		List<DtoGenerarPropuestaPreciosEntidad02> listDto = new ArrayList<DtoGenerarPropuestaPreciosEntidad02>();
		
		for(VDatosPropuestaEntidad02 datos : listDatosPropuesta) {
			DtoGenerarPropuestaPreciosEntidad02 dto = new DtoGenerarPropuestaPreciosEntidad02();
			BeanUtils.copyProperties(dto, datos);
			BeanUtils.copyProperty(dto, "valorPropuesto", valorPropuestaPrecio(dto, null));
			
			listDto.add(dto);
		}
		
		return listDto;
	}
	
	/**
	 * Devuelve el listado con los datos para la generación de propuesta de precios de la Entidad con códgio '01'
	 * @param idPropuesta
	 * @return
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	private List<DtoGenerarPropuestaPreciosEntidad01> getDatosPropuestaEntidad01(Long idPropuesta) throws IllegalAccessException, InvocationTargetException {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idPropuesta", idPropuesta);
		List<VDatosPropuestaEntidad01> listDatosPropuesta = genericDao.getList(VDatosPropuestaEntidad01.class,filtro);
		List<DtoGenerarPropuestaPreciosEntidad01> listDto = new ArrayList<DtoGenerarPropuestaPreciosEntidad01>();
		
		for(VDatosPropuestaEntidad01 datos : listDatosPropuesta) {
			DtoGenerarPropuestaPreciosEntidad01 dto = new DtoGenerarPropuestaPreciosEntidad01();
			BeanUtils.copyProperties(dto, datos);
			BeanUtils.copyProperty(dto, "valorPropuesto", valorPropuestaPrecio(dto, dto.getValorAdquisicion()));
			
			listDto.add(dto);
		}
		
		return listDto;
	}

	@Override
	public List<DtoConfiguracionPropuestasPrecios> getConfiguracionGeneracionPropuestas() {
		List<DtoConfiguracionPropuestasPrecios> listaPropuestas = new ArrayList<DtoConfiguracionPropuestasPrecios>();
		List<CarteraCondicionesPrecios> listaCondiciones = genericDao.getList(CarteraCondicionesPrecios.class);

		if(!Checks.estaVacio(listaCondiciones)) {
			for(CarteraCondicionesPrecios condicion: listaCondiciones) {
				DtoConfiguracionPropuestasPrecios dto = new DtoConfiguracionPropuestasPrecios();

				dto.setIdRegla(condicion.getId().toString());
				if(!Checks.esNulo(condicion.getCartera())) {
					dto.setCarteraCodigo(condicion.getCartera().getCodigo());
				}
				if(!Checks.esNulo(condicion.getPropuestaPrecio())) {
					dto.setPropuestaPrecioCodigo(condicion.getPropuestaPrecio().getCodigo());
				}
				if(!Checks.esNulo(condicion.getCondicionIndicadorPrecio())) {
					dto.setIndicadorCondicionCodigo(condicion.getCondicionIndicadorPrecio().getCodigo());
				}
				dto.setMayorQueText(condicion.getMayorQue());
				dto.setMenorQueText(condicion.getMenorQue());
				dto.setIgualQueText(condicion.getIgualQue());
				
				listaPropuestas.add(dto);
			}
		}

		return listaPropuestas;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deleteConfiguracionGeneracionPropuesta(DtoConfiguracionPropuestasPrecios dto) {
		if(Checks.esNulo(dto.getIdRegla())) {
			return false;
		}

		genericDao.deleteById(CarteraCondicionesPrecios.class, Long.parseLong(dto.getIdRegla()));

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createConfiguracionGeneracionPropuesta(DtoConfiguracionPropuestasPrecios dto) {
		CarteraCondicionesPrecios nuevaRegla = new CarteraCondicionesPrecios();

		try{
			if(!Checks.esNulo(dto.getCarteraCodigo())) {
				DDCartera cartera = (DDCartera) utilDiccionarioApi.dameValorDiccionarioByCod(DDCartera.class, dto.getCarteraCodigo());
				nuevaRegla.setCartera(cartera);
			}
			if(!Checks.esNulo(dto.getPropuestaPrecioCodigo())) {
				DDTipoPropuestaPrecio propuestaPrecio = (DDTipoPropuestaPrecio) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPropuestaPrecio.class, dto.getPropuestaPrecioCodigo());
				nuevaRegla.setPropuestaPrecio(propuestaPrecio);
			}
			if(!Checks.esNulo(dto.getIndicadorCondicionCodigo())) {
				DDCondicionIndicadorPrecio indicadorPrecio = (DDCondicionIndicadorPrecio) utilDiccionarioApi.dameValorDiccionarioByCod(DDCondicionIndicadorPrecio.class, dto.getIndicadorCondicionCodigo());
				nuevaRegla.setCondicionIndicadorPrecio(indicadorPrecio);
			}
			nuevaRegla.setMenorQue(dto.getMenorQueText());
			nuevaRegla.setMayorQue(dto.getMayorQueText());
			nuevaRegla.setIgualQue(dto.getIgualQueText());

			genericDao.save(CarteraCondicionesPrecios.class, nuevaRegla);
		}catch(Exception e) {
			logger.error(e.getMessage());
			return false;
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateConfiguracionGeneracionPropuesta(DtoConfiguracionPropuestasPrecios dto) {
		if(Checks.esNulo(dto.getIdRegla())) {
			return false;
		}

		Filter filterReglaID = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getIdRegla()));
		CarteraCondicionesPrecios regla = genericDao.get(CarteraCondicionesPrecios.class, filterReglaID);
		if(!Checks.esNulo(regla)) {
			try{
				if(!Checks.esNulo(dto.getCarteraCodigo())) {
					DDCartera cartera = (DDCartera) utilDiccionarioApi.dameValorDiccionarioByCod(DDCartera.class, dto.getCarteraCodigo());
					regla.setCartera(cartera);
				}
				if(!Checks.esNulo(dto.getPropuestaPrecioCodigo())) {
					DDTipoPropuestaPrecio propuestaPrecio = (DDTipoPropuestaPrecio) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPropuestaPrecio.class, dto.getPropuestaPrecioCodigo());
					regla.setPropuestaPrecio(propuestaPrecio);
				}
				if(!Checks.esNulo(dto.getIndicadorCondicionCodigo())) {
					DDCondicionIndicadorPrecio indicadorPrecio = (DDCondicionIndicadorPrecio) utilDiccionarioApi.dameValorDiccionarioByCod(DDCondicionIndicadorPrecio.class, dto.getIndicadorCondicionCodigo());
					regla.setCondicionIndicadorPrecio(indicadorPrecio);
				}
				beanUtilNotNull.copyProperty(regla, "menorQue", dto.getMenorQueText());
				beanUtilNotNull.copyProperty(regla, "mayorQue", dto.getMayorQueText());
				beanUtilNotNull.copyProperty(regla, "igualQue", dto.getIgualQueText());

				genericDao.save(CarteraCondicionesPrecios.class, regla);
			}catch(Exception e) {
				logger.error(e.getMessage());
				return false;
			}
		}

		return true;
	}
	
	@Override
	public String tienePropuestaActivosEnPropuestasEnTramitacion(List<VBusquedaActivosPrecios> listaActivos) {
		
		String codMsgActivosEnPropuesta = null;
		Boolean todosEnOtrasPropeustas = true;
		
		for(VBusquedaActivosPrecios act : listaActivos) {
			if(act.getActivoEnPropuestaEnTramitacion()) {
				codMsgActivosEnPropuesta = COD_MSG_GENERAR_PROPUESTA_PRECIOS_TODOS;
			}
			else {
				todosEnOtrasPropeustas = false;
			}
			
			if(!Checks.esNulo(codMsgActivosEnPropuesta) && !todosEnOtrasPropeustas) {
				codMsgActivosEnPropuesta = COD_MSG_GENERAR_PROPUESTA_PRECIOS_ALGUNOS;
				break;
			}
		}
		
		return codMsgActivosEnPropuesta;
	}
	
	@Override
	public String tieneTrabajoActivosEnPropuestasEnTramitacion(Long idTrabajo) {
		
		Trabajo trabajo = trabajoApi.findOne(idTrabajo);
		String cadenaId = "";
		for(ActivoTrabajo activoTrabajo : trabajo.getActivosTrabajo()) {
			cadenaId = cadenaId + activoTrabajo.getActivo().getId() +",";
		}
		
		List<VBusquedaActivosPrecios> listaActivos = new ArrayList<VBusquedaActivosPrecios>();
		if(cadenaId.length() > 0) {
			cadenaId = cadenaId.substring(0,cadenaId.length()-1);
			listaActivos = activoDao.getListActivosPreciosFromListId(cadenaId);
		}
		
		return this.tienePropuestaActivosEnPropuestasEnTramitacion(listaActivos);
	}
}
