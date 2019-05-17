package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.TareaActivo;

@Component	
public class MSVActualizadorOfertasGTAMCargaMasiva extends AbstractMSVActualizador implements MSVLiberator{
	
	public static final String APROBADA = "01";
	public static final String DENEGADA = "02";
	public static final String CONTRAOFERTA = "03";
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_OFERTAS_GTAM;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		
		Long numOferta = Long.valueOf(exc.dameCelda(fila, 0));
		Long idOferta = ofertaApi.getOfertaByNumOfertaRem(numOferta).getId();
		Long idTrabajo = expedienteComercialApi.expedienteComercialPorOferta(idOferta).getTrabajo().getId();
		
		//Tramite
		ActivoTramite tramite = activoTramiteApi.getTramitesActivoTrabajoList(idTrabajo).get(0);
		
		//Lista de TareaActivo
		Filter filtroTac = genericDao.createFilter(FilterType.EQUALS, "tramite.id", tramite.getId());
		Order order = new Order(OrderType.DESC, "id");
		List<TareaActivo> tacList = genericDao.getListOrdered(TareaActivo.class, order, filtroTac);
		
		//La ultima TareaActivo que corresponderia a Resolucion Comite
		TareaActivo tac = tacList.get(0);
		
		//TareaExterna
		TareaExterna tex = tac.getTareaExterna();
		
		//-------Obtener el valor de los 4 campos de la Tarea Resolucion Comite desde el excel
		String campoUno = exc.dameCelda(fila, 12);
		if(!Checks.esNulo(campoUno)){
			String pattern1 = "dd/MM/yy";
			SimpleDateFormat sdf1 = new SimpleDateFormat(pattern1);
			Date date1 = sdf1.parse(campoUno);
			String pattern2 = "yyyy-MM-dd";
			SimpleDateFormat sdf2 = new SimpleDateFormat(pattern2);
			campoUno = sdf2.format(date1);
		}
		
		  String estadoResolucion = exc.dameCelda(fila, 6);
		  if(!Checks.esNulo(estadoResolucion)){
			  if(estadoResolucion == "1" || estadoResolucion == "2" || estadoResolucion == "3") {
				  	HashMap<String, String> estadosResolucion = new HashMap<String, String>();
				  	estadosResolucion.put("1", "01");
				  	estadosResolucion.put("2", "02");
				  	estadosResolucion.put("3", "03");
				  	estadoResolucion = estadosResolucion.get(estadoResolucion);
			  }
		}
		
		String campoTres = exc.dameCelda(fila, 8);
		
		String campoCuatro = exc.dameCelda(fila, 13);
		
		String pattern = "yyyy-MM-dd";
		SimpleDateFormat sdf = new SimpleDateFormat(pattern);
		String sysDate = sdf.format(new Date());
		
		//-------Rellenar los 4 campos de la Tarea Resolucion Comite
		
		//Campo 1
		if(!Checks.esNulo(campoUno)){
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "nombre", "fechaRespuesta");
			Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "tareaExterna.id", tex.getId());
			TareaExternaValor fechaDeRespuesta = genericDao.get(TareaExternaValor.class, filtro1, filtro2);
			
			if(APROBADA.equals(estadoResolucion) || CONTRAOFERTA.equals(estadoResolucion)){
				if(Checks.esNulo(fechaDeRespuesta)){
					fechaDeRespuesta = new TareaExternaValor();
					fechaDeRespuesta.setTareaExterna(tex);
					fechaDeRespuesta.setNombre("fechaRespuesta");
					fechaDeRespuesta.setValor(campoUno);
				}else{
					fechaDeRespuesta.setValor(campoUno);
				}
			}else if(DENEGADA.equals(estadoResolucion)){
				if(Checks.esNulo(fechaDeRespuesta)){
					fechaDeRespuesta = new TareaExternaValor();
					fechaDeRespuesta.setTareaExterna(tex);
					fechaDeRespuesta.setNombre("fechaRespuesta");
					fechaDeRespuesta.setValor(sysDate);
				}else{
					fechaDeRespuesta.setValor(sysDate);
				}
			}
			
			genericDao.save(TareaExternaValor.class, fechaDeRespuesta);
		}
	
		//Campo 2
		if(!Checks.esNulo(estadoResolucion)){
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "nombre", "comboResolucion");
			Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "tareaExterna.id", tex.getId());
			TareaExternaValor resolucion = genericDao.get(TareaExternaValor.class, filtro1, filtro2);
			
			if(Checks.esNulo(resolucion)){
				resolucion = new TareaExternaValor();
				resolucion.setTareaExterna(tex);
				resolucion.setNombre("comboResolucion");
				resolucion.setValor(estadoResolucion);
			}else{
				resolucion.setValor(estadoResolucion);
			}
			
			genericDao.save(TareaExternaValor.class, resolucion);
		}		
		
		//Campo 3
		if(!Checks.esNulo(campoTres)){
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "nombre", "numImporteContra");
			Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "tareaExterna.id", tex.getId());
			TareaExternaValor importeContraoferta = genericDao.get(TareaExternaValor.class, filtro1, filtro2);
			
			if(Checks.esNulo(importeContraoferta)){
				importeContraoferta = new TareaExternaValor();
				importeContraoferta.setTareaExterna(tex);
				importeContraoferta.setNombre("numImporteContra");
				importeContraoferta.setValor(campoTres);
			}else{
				importeContraoferta.setValor(campoTres);
			}
			
			genericDao.save(TareaExternaValor.class, importeContraoferta);	
		}
		
		//Campo 4
		if(!Checks.esNulo(campoCuatro)){
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "nombre", "observaciones");
			Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "tareaExterna.id", tex.getId());
			TareaExternaValor observaciones = genericDao.get(TareaExternaValor.class, filtro1, filtro2);
			
			if(Checks.esNulo(observaciones)){
				observaciones = new TareaExternaValor();
				observaciones.setTareaExterna(tex);
				observaciones.setNombre("observaciones");
				observaciones.setValor(campoCuatro);
			}else{
				observaciones.setValor(campoCuatro);
			}
			
			genericDao.save(TareaExternaValor.class, observaciones);
		}
		
		return new ResultadoProcesarFila();
	}

}