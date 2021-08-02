package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo.ActivoTrabajoPk;
import es.pfsgroup.plugin.rem.model.ConfiguracionTarifa;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.TrabajoConfiguracionTarifa;
import es.pfsgroup.plugin.rem.model.dd.DDAcoAprobacionComite;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDIdentificadorReam;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTarifa;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;
import es.pfsgroup.plugin.rem.trabajo.dao.TrabajoDao;

@Component
public class MSVActualizadorAltaTrabajosProcesar extends AbstractMSVActualizador implements MSVLiberator {

	protected static final Log logger = LogFactory.getLog(MSVActualizadorAltaTrabajosProcesar.class);
	
	private static final String EMAIL_CREACION = "CREACION";
	

	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	private List<String> comprobacionTrue = Arrays.asList("S","SI");
	private List<String> comprobacionFalse = Arrays.asList("N","NO");
	
	@Autowired
	private TrabajoDao trabajoDao;
	
	@Autowired
	private GenericAdapter adapter;
	
	static final String CODIGO_REAM_MANTENIMIENTO = "01";
	static final String CODIGO_REAM_SEGURIDAD = "02";
	static final String CODIGO_RAM = "03";
	static final String CODIGO_EDIFICACIÓN = "04";
	
	static final List<String> listCodAreaPeticionaria = Arrays.asList(CODIGO_REAM_MANTENIMIENTO,CODIGO_REAM_SEGURIDAD,CODIGO_RAM,CODIGO_EDIFICACIÓN);
	
	static final String SOLICITADO="SOL";
	static final String APROBADO="APR";
	static final String RECHAZADO="REC";
	
	static final List<String> listCodAprobacionComite = Arrays.asList(SOLICITADO,APROBADO,RECHAZADO);
	
	public static final class COL_NUM{
		static final int FILA_CABECERA = 0;
		static final int FILA_DATOS = 1;

		
		static final int COL_ID_ACTIVO = 0;
		static final int COL_TIPO_TRABAJO = 1;
		static final int COL_SUBTIPO_TRABAJO = 2;
		static final int COL_PROVEEDOR = 3;
		static final int COL_PROVEEDOR_CONTACTO = 4;
		static final int COL_ID_TAREA = 5;
		static final int COL_AREA_PETICIONARIA = 6;
		static final int COL_APLICA_COMITE = 7;
		static final int COL_RES_COMITE = 8;
		static final int COL_FECHA_RES_COMITE = 9;
		static final int COL_ID_RES_COMITE = 10;
		static final int COL_ID_TARIFA = 11;
		static final int COL_FECHA_CONCRETA = 12;
		static final int COL_HORA_CONCRETA = 13;
		static final int COL_FECHA_TOPE = 14;
		static final int COL_IMPORTE_PRESUPUESTO = 15;
		static final int COL_REFERENCIA_PRESUPUESTO = 16;
		static final int COL_TARIFA_PLANA = 17;
		static final int COL_URGENTE = 18;
		static final int COL_RIESGO_TERCEROS = 19;
		static final int COL_SINIESTRO = 20;
		static final int COL_DESCRIPCION = 21;
		
		
	}
	
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_ALTA_TRABAJOS;
		
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		
		

		SimpleDateFormat formatoFechaHora = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat formatoFechaString = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaHoraConcreta = null;
		Long referenciaPresupuesto = null;
		
		Trabajo trabajo = new Trabajo();
		Activo activo = new Activo();
		DDTipoTrabajo tipoTrabajo;
		DDSubtipoTrabajo subtipoTrabajo;
		ActivoProveedorContacto proveedorContacto = new ActivoProveedorContacto();
		DDIdentificadorReam areaPeticionaria;
		DDAcoAprobacionComite aprobacionComite;
		Date fechaResComite = null;
		Date fechaTope = null;
		Double importePresupuesto = null;
		Long codRemProveedor  = null;
		Long numActivo = null;
		
		if(!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_ID_ACTIVO))) {
			numActivo = Long.parseLong(exc.dameCelda(fila, COL_NUM.COL_ID_ACTIVO)); //0
		}
		String codTipoTrabajo = exc.dameCelda(fila,COL_NUM.COL_TIPO_TRABAJO);//1
		String codSubtipoTrabajo = exc.dameCelda(fila, COL_NUM.COL_SUBTIPO_TRABAJO);//2
		if(!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_PROVEEDOR))) {
			codRemProveedor = Long.parseLong(exc.dameCelda(fila, COL_NUM.COL_PROVEEDOR));//3
		}
		
		String userProveedorContacto = exc.dameCelda(fila, COL_NUM.COL_PROVEEDOR_CONTACTO);//4
		String idTarea = exc.dameCelda(fila, COL_NUM.COL_ID_TAREA);//5
		String codAreaPeticionaria = exc.dameCelda(fila, COL_NUM.COL_AREA_PETICIONARIA);//6
		String aplicaComite = exc.dameCelda(fila, COL_NUM.COL_APLICA_COMITE);//7
		String resolucionComite = exc.dameCelda(fila, COL_NUM.COL_RES_COMITE);//8
		if(!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_FECHA_RES_COMITE))) {
			fechaResComite = formatoFechaString.parse(exc.dameCelda(fila, COL_NUM.COL_FECHA_RES_COMITE));//9
		}
		String idResComite = exc.dameCelda(fila, COL_NUM.COL_ID_RES_COMITE);//10
		String codTarifa = exc.dameCelda(fila, COL_NUM.COL_ID_TARIFA);//11
		String fechaConcreta =exc.dameCelda(fila, COL_NUM.COL_FECHA_CONCRETA);//12
		String horaConcreta= exc.dameCelda(fila, COL_NUM.COL_HORA_CONCRETA);//13
		if(!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_FECHA_TOPE))) {
			fechaTope= formatoFechaString.parse(exc.dameCelda(fila, COL_NUM.COL_FECHA_TOPE));//14
		}
		
		if(!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_IMPORTE_PRESUPUESTO))) {
			importePresupuesto= Double.parseDouble(exc.dameCelda(fila, COL_NUM.COL_IMPORTE_PRESUPUESTO));//15
		}
		if(!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_REFERENCIA_PRESUPUESTO))) {
			referenciaPresupuesto=Long.parseLong(exc.dameCelda(fila, COL_NUM.COL_REFERENCIA_PRESUPUESTO));//16
		}
		String tarifaPlana= exc.dameCelda(fila, COL_NUM.COL_TARIFA_PLANA);//17
		String urgente= exc.dameCelda(fila, COL_NUM.COL_URGENTE);//18
		String riesgoTerceros= exc.dameCelda(fila, COL_NUM.COL_RIESGO_TERCEROS);//19
		String siniestro=exc.dameCelda(fila, COL_NUM.COL_SINIESTRO);//20
		String descripcion=exc.dameCelda(fila, COL_NUM.COL_DESCRIPCION);//21
		
		if (!Checks.esNulo(numActivo)) {
			activo = activoApi.getByNumActivo(numActivo);
		}
		if (activo != null) {
			Filter filtroTipoTrabajo= genericDao.createFilter(FilterType.EQUALS, "codigo", codTipoTrabajo);
			tipoTrabajo=genericDao.get(DDTipoTrabajo.class, filtroTipoTrabajo);
			if (tipoTrabajo != null) {
				trabajo.setTipoTrabajo(tipoTrabajo);
			}
			Filter filtroSubtipoTrabajo=genericDao.createFilter(FilterType.EQUALS, "codigo", codSubtipoTrabajo);
			subtipoTrabajo = genericDao.get(DDSubtipoTrabajo.class, filtroSubtipoTrabajo);
			if (subtipoTrabajo != null) {
				trabajo.setSubtipoTrabajo(subtipoTrabajo);
			}
			Filter filtroCodRemProveedor=genericDao.createFilter(FilterType.EQUALS, "proveedor.codigoProveedorRem", codRemProveedor);
			Filter filtroUserProveedorContacto=genericDao.createFilter(FilterType.EQUALS,"usuario.username", userProveedorContacto);
			proveedorContacto = genericDao.get(ActivoProveedorContacto.class, filtroCodRemProveedor, filtroUserProveedorContacto);
			if (proveedorContacto != null) {
				trabajo.setProveedorContacto(proveedorContacto);
			}
			
						
			if (!Checks.esNulo(idTarea)) {
				trabajo.setIdTarea(idTarea);
			}			
			if (!Checks.esNulo(codAreaPeticionaria) && listCodAreaPeticionaria.contains(codAreaPeticionaria)) {
					Filter filtroAreaPeticionaria=genericDao.createFilter(FilterType.EQUALS,"codigo", codAreaPeticionaria);
					areaPeticionaria=genericDao.get(DDIdentificadorReam.class,filtroAreaPeticionaria);
					trabajo.setIdentificadorReam(areaPeticionaria);
			}
			if (!Checks.esNulo(aplicaComite) && (comprobacionTrue.contains(aplicaComite) ||comprobacionFalse.contains(aplicaComite))) {
				if(comprobacionTrue.contains(aplicaComite)){
					trabajo.setAplicaComite(true);
				}else if(comprobacionFalse.contains(aplicaComite)){
					trabajo.setAplicaComite(false);
				}
			}
			if (!Checks.esNulo(aplicaComite) && comprobacionTrue.contains(aplicaComite) && !Checks.esNulo(resolucionComite)
					&& listCodAprobacionComite.contains(resolucionComite)){
				Filter filtroCodAprobComite=genericDao.createFilter(FilterType.EQUALS,"codigo", resolucionComite);
				aprobacionComite=genericDao.get(DDAcoAprobacionComite.class,filtroCodAprobComite);
				trabajo.setAprobacionComite(aprobacionComite);
			}
			if (fechaResComite != null && !Checks.esNulo(resolucionComite) 
					&& (APROBADO.equalsIgnoreCase(resolucionComite)||RECHAZADO.equalsIgnoreCase(resolucionComite))){
				trabajo.setFechaResolucionComite(fechaResComite);
			}
			if (!Checks.esNulo(idResComite)  && fechaResComite != null && !Checks.esNulo(resolucionComite) 
					&& (APROBADO.equalsIgnoreCase(resolucionComite)||RECHAZADO.equalsIgnoreCase(resolucionComite))) {
				trabajo.setResolucionComiteId(idResComite);
			}
			
			if (!Checks.esNulo(fechaConcreta)) {
				String fecha = fechaConcreta;
				String hora ="";
				if (horaConcreta != null) {
					hora = horaConcreta;
				}
				fecha = formatoFecha.format(formatoFechaString.parse(fecha));
				
				if(!hora.isEmpty() && !fecha.isEmpty()) {
					fechaHoraConcreta = formatoFechaHora.parse(fecha+" "+hora);
					trabajo.setFechaHoraConcreta(fechaHoraConcreta);
				}else if(hora.isEmpty()){
					fechaHoraConcreta = formatoFecha.parse(fecha);
					trabajo.setFechaHoraConcreta(fechaHoraConcreta);
				}		
				
				
			}
			if (fechaTope != null) {
				trabajo.setFechaTope(fechaTope);
			}
			if (!Checks.esNulo(importePresupuesto)) {			
				trabajo.setImportePresupuesto(importePresupuesto);
			}
			if (!Checks.esNulo(referenciaPresupuesto)) {
				trabajo.setResolucionImportePresupuesto(String.valueOf(referenciaPresupuesto));
			}
			if (!Checks.esNulo(tarifaPlana) && (comprobacionTrue.contains(tarifaPlana) ||comprobacionFalse.contains(tarifaPlana))) {
				if(comprobacionTrue.contains(tarifaPlana)){
					trabajo.setEsTarifaPlana(true);
				}else if(comprobacionFalse.contains(tarifaPlana)){
					trabajo.setEsTarifaPlana(false);
				}
			}
			if (!Checks.esNulo(urgente) && (comprobacionTrue.contains(urgente) ||comprobacionFalse.contains(urgente))) {
				if(comprobacionTrue.contains(urgente)){
					trabajo.setUrgente(true);
				}else if(comprobacionFalse.contains(urgente)){
					trabajo.setUrgente(false);
				}
			}
			if (!Checks.esNulo(riesgoTerceros) && (comprobacionTrue.contains(riesgoTerceros) ||comprobacionFalse.contains(riesgoTerceros))) {
				if(comprobacionTrue.contains(riesgoTerceros)){
					trabajo.setRiesgoInminenteTerceros(true);
				}else if(comprobacionFalse.contains(riesgoTerceros)){
					trabajo.setRiesgoInminenteTerceros(false);
				}
			}
			if (!Checks.esNulo(siniestro) && (comprobacionTrue.contains(siniestro) ||comprobacionFalse.contains(siniestro))) {
				if(comprobacionTrue.contains(siniestro)){
					trabajo.setSiniestro(true);
				}else if(comprobacionFalse.contains(siniestro)){
					trabajo.setSiniestro(false);
				}
			}
			if (descripcion != null) {
				trabajo.setDescripcion(descripcion);
			}
			
			trabajo.setNumTrabajo(trabajoDao.getNextNumTrabajo());
			trabajo.setActivo(activo);
			trabajo.setFechaSolicitud(new Date());
			DDEstadoTrabajo estadoTrabajo= genericDao.get(DDEstadoTrabajo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.CODIGO_ESTADO_EN_CURSO));
			trabajo.setEstado(estadoTrabajo);
			trabajo.setSolicitante(adapter.getUsuarioLogado());
			trabajo.setGestorAlta(adapter.getUsuarioLogado());
			trabajoDao.saveOrUpdate(trabajo);
			
			if (!Checks.esNulo(codTarifa)){
			
				TrabajoConfiguracionTarifa trabajoConfig = new TrabajoConfiguracionTarifa();
				ConfiguracionTarifa configuracionTarifa = getConfigTarifaByCodigoTarifaAndNumTrabajo(codTarifa, trabajo);
				
				if (configuracionTarifa != null) {
					trabajoConfig.setConfigTarifa(configuracionTarifa);
					trabajoConfig.setTrabajo(trabajo);
					if(configuracionTarifa.getPrecioUnitario() != null) {
						trabajoConfig.setPrecioUnitario(configuracionTarifa.getPrecioUnitario());
					}
					if(configuracionTarifa.getPrecioUnitarioCliente() != null) {
						trabajoConfig.setPrecioUnitarioCliente(configuracionTarifa.getPrecioUnitarioCliente());
					}
					trabajoConfig.setMedicion(1F);					
					genericDao.save(TrabajoConfiguracionTarifa.class, trabajoConfig);
					trabajoApi.actualizarImporteTotalTrabajo(trabajo.getId());
				}
			}
			
			ActivoTrabajo activoTrabajo = new ActivoTrabajo();
			
			activoTrabajo.setActivo(activo);
			activoTrabajo.setTrabajo(trabajo);
			activoTrabajo.setPrimaryKey(new ActivoTrabajoPk(activo.getId(),trabajo.getId()));
			activoTrabajo.setParticipacion(100F);
			trabajo.getActivosTrabajo().add(activoTrabajo);
			
			trabajoDao.saveOrUpdate(trabajo);
			
			trabajoApi.EnviarCorreoTrabajos(trabajo, EMAIL_CREACION);
			
		}
		
		
		return new ResultadoProcesarFila();
	}
	
	private ConfiguracionTarifa getConfigTarifaByCodigoTarifaAndNumTrabajo(String codTarifa, Trabajo trabajo) {
		Long idCartera = null;
		Long idSubcartera = null;
		Long idTipoTarifa = null;

		DDTipoTarifa tipoTarifa = genericDao.get(DDTipoTarifa.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", codTarifa));
		if (tipoTarifa != null) {
			idTipoTarifa = tipoTarifa.getId();
		}

		if (trabajo.getActivo() != null) {
			idCartera = trabajo.getActivo().getCartera().getId();
			idSubcartera = trabajo.getActivo().getSubcartera().getId();
		} else {
			List<ActivoTrabajo> activosTrabajo = genericDao.getList(ActivoTrabajo.class,
					genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId()));
			if (activosTrabajo != null && activosTrabajo.get(0) != null && activosTrabajo.get(0).getActivo() != null) {
				idCartera = activosTrabajo.get(0).getActivo().getCartera().getId();
				idSubcartera = activosTrabajo.get(0).getActivo().getSubcartera().getId();
			}
		}

		return getConfiguracionTarifa(idTipoTarifa, idCartera, idSubcartera);
	}

	private ConfiguracionTarifa getConfiguracionTarifa(Long idTipoTarifa, Long idCartera, Long idSubcartera) {

		if (idCartera != null && idTipoTarifa != null && idSubcartera != null) {
			Filter fCartera = genericDao.createFilter(FilterType.EQUALS, "cartera.id", idCartera);
			Filter fTipoTarifa = genericDao.createFilter(FilterType.EQUALS, "tipoTarifa.id", idTipoTarifa);
			Filter fSubcartera = genericDao.createFilter(FilterType.EQUALS, "subcartera.id", idSubcartera);


			ConfiguracionTarifa cfg = genericDao.get(ConfiguracionTarifa.class, fCartera, fTipoTarifa, fSubcartera);
			if(cfg == null) {
				List<ConfiguracionTarifa> listcfg = genericDao.getList(ConfiguracionTarifa.class, fCartera, fTipoTarifa);
				if(listcfg != null) {
					cfg = listcfg.get(0);
				}
			}
			return cfg;
		}
		return null;
	}
}
