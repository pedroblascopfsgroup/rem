package es.pfsgroup.plugin.rem.api.impl;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.dto.DtoExcelPropuestaUnificada;
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
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;
import es.pfsgroup.plugin.rem.model.VBusquedaNumActivosTipoPrecio;
import es.pfsgroup.plugin.rem.model.VDatosPropuestaUnificada;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPropuestaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPropuestaPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPropuestaPrecio;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.PropuestaPrecioDao;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.VActivosPropuestaDao;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.VNumActivosTipoPrecioDao;
import es.pfsgroup.plugin.rem.service.PropuestaPreciosExcelService;

@Service("preciosManager")
public class PreciosManager extends BusinessOperationOverrider<PreciosApi> implements  PreciosApi {
	
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
	
	//Porcentajes para el calculo de precios propuestos
	private static final Double porc120 = 1.20;
	private static final Double porc115 = 1.15;
	private static final Double porc110 = 1.10;
	private static final Double porc090 = 0.90;
	private static final Double porc075 = 0.75;
	private static final Double porc060 = 0.60;

		
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
	
		//TODO: CrearFuncionalidad para crear una propuesta generada desde la pantalla "Generar propuesta - Automatica"
		// Consejo: seguir los mismos pasos de la propuesta manual
		// No se utiliza, he reaprovechando el Manual, que hace lo mismo
		return new PropuestaPrecio();
	}
	
	@Override
	public Page getHistoricoPropuestasPrecios(DtoHistoricoPropuestaFilter dtoPropuestaFiltro) {
		
		return propuestaPrecioDao.getListHistoricoPropuestasPrecios(dtoPropuestaFiltro);
	}
	
	@Override
	@Transactional(readOnly = false)
	public PropuestaPrecio createPropuestaPreciosManual(List<VBusquedaActivosPrecios> activosPrecios, String nombrePropuesta, String tipoPropuestaCodigo, Boolean esPropManual){

		// Funcionalidad para crear una propuesta generada desde la pantalla "Generar propuesta - Manual - Automatica"
		
		// Se instancia una lista de Activos, usando los id's de activos de la lista del buscador
		List<Activo> activos = new ArrayList<Activo>();
		for(VBusquedaActivosPrecios activoPrecio : activosPrecios){
			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(activoPrecio.getId()));
			Activo activo = (Activo) genericDao.get(Activo.class, filtroActivo);
			activos.add(activo);
		}

		// Se toman precauciones para crear una lista con activos unicos ya que proveniendo de una vista,
		// pueden haberse creado filas multiples del mismo activo
		Set<Activo> uniqueSetActivos =  new HashSet<Activo>(activos);
		List<Activo> uniqueListActivos = new ArrayList<Activo>(uniqueSetActivos);
		
		// Nueva propuesta de precios con activos asociados
		//Boolean esPropManual = true;
		PropuestaPrecio propuestaPrecio = createPropuestaPrecios(uniqueListActivos, nombrePropuesta, tipoPropuestaCodigo, esPropManual);
		
		// Nuevo trabajo+tramite de propuesta de precios: Preciar o Repreciar
		// La propuesta es necesaria en el create ya que es necesario crear la relacion con el nuevo trabajo.
		DDSubtipoTrabajo subtipoTrabajoPropuestaPrecios = (DDSubtipoTrabajo) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoTrabajo.class, DDSubtipoTrabajo.CODIGO_TRAMITAR_PROPUESTA_PRECIOS);
		Trabajo trabajo = trabajoApi.create(subtipoTrabajoPropuestaPrecios, uniqueListActivos, propuestaPrecio);
		
		// Relacion nuevo trabajo con nueva propuesta
		propuestaPrecio.setTrabajo(trabajo);
		
		propuestaPrecioDao.saveOrUpdate(propuestaPrecio);
		
		return propuestaPrecio;
		
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
	@Transactional(readOnly = false)
	private PropuestaPrecio createPropuestaPrecios(List<Activo> activos, String nombrePropuesta, String tipoPropuestaCodigo, Boolean esPropManual){
		
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
		propuestaPrecio.setEsPropuestaManual(esPropManual);
		
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
			}
			
			activoDao.update(activo);
			
		}
	}
	
	@Override
	public List<DtoExcelPropuestaUnificada> getDatosPropuestaUnificada(Long idPropuesta) throws IllegalAccessException, InvocationTargetException {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idPropuesta", idPropuesta);
		List<VDatosPropuestaUnificada> listDatosPropuesta = genericDao.getList(VDatosPropuestaUnificada.class,filtro);
		List<DtoExcelPropuestaUnificada> listDto = new ArrayList<DtoExcelPropuestaUnificada>();
		
		for(VDatosPropuestaUnificada datos : listDatosPropuesta) {
			DtoExcelPropuestaUnificada dto = new DtoExcelPropuestaUnificada();
			BeanUtils.copyProperties(dto, datos);
			BeanUtils.copyProperty(dto, "valorPropuesto", valorPropuestaPrecio(dto));
			
			listDto.add(dto);
		}
		
		return listDto;
		
	}
	
	/**
	 * Devuelve el precio propuesto, y lo calcula según cartera
	 * @param dto
	 * @return
	 */
	private Double valorPropuestaPrecio(DtoExcelPropuestaUnificada dto) {
		
		Integer cartera = Integer.parseInt(dto.getCodCartera());
		Double resultado = null;

		
		switch(cartera) {
		
			case 1: // Cajamar
				resultado = precioPropuestoCajamar(dto.getValorFsv(),dto.getValorTasacion(),dto.getValorVnc(),dto.getValorAdquisicion());
				break;
			case 2: // Sareb
				resultado = precioPropuestoSareb(dto.getValorFsv());
				break;
			case 3: // Bankia
				if(dto.getCodCartera()=="03" && !Checks.esNulo(dto.getCodSubCartera())) 
					resultado = precioPropuestoBankiaTerceros(dto.getValorTasacion());
				else
					resultado = precioPropuestoBankia(dto.getTipoActivoCodigo()!="02",dto.getValorTasacion(),dto.getValorVnc(),dto.getValorLiquidativo(),dto.getValorFsv());
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
		
		if((fsv > tasacion * porc110) && (fsv > vnc * porc110) && (fsv > adquisicion * porc110))
			return fsv;
		
		if((porc110 * vnc) > (porc090 * tasacion) && (porc110 * vnc) > (porc060 * adquisicion))
			return porc110 * vnc;
		
		if((tasacion > porc110 * vnc) && (tasacion > porc060 * adquisicion))
			return tasacion;
		
		if((porc060 * adquisicion) > (porc090 * tasacion) && (porc060 * adquisicion) > (porc110 * vnc))
			return porc060 * adquisicion;
		
		return tasacion;
	}
	
	/**
	 * Calculo del precio propuesta para Sareb
	 * @param fsv
	 * @return
	 */
	private Double precioPropuestoSareb(Double fsv) {

		return porc110 * fsv;
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
		
		Double vncDefecto = porc110 * vnc;
		
		if(!residencial) {
			if(tasacion >= vnc)
				return porc110 * tasacion;
		}
		else {
			Double mayor = liquidativo > fsv ? liquidativo : fsv;
			
			if(!Checks.esNulo(liquidativo) && !Checks.esNulo(fsv) && (porc115 * mayor >= vncDefecto)) {
				return porc115 * mayor;
			}
			else if(!Checks.esNulo(liquidativo) && Checks.esNulo(fsv) && (porc120 * liquidativo >= vncDefecto)) {
				return porc120 * liquidativo;
			}
			else if(Checks.esNulo(liquidativo) && Checks.esNulo(fsv) && (porc075 * tasacion >= vncDefecto)) {
				return porc075 * tasacion;
			}
			else if(Checks.esNulo(liquidativo) && !Checks.esNulo(fsv) && (porc115 * fsv >= vncDefecto)) {
				return porc115 * fsv;
			}
			
		}
		
		return vncDefecto;
	
	}
	
	private Double precioPropuestoBankiaTerceros(Double tasacion) {
		return tasacion;	
	}

}
