package es.pfsgroup.plugin.rem.api.impl;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ComunicacionGencatApi;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComunicacionGencat;


@Component
public class MSVActualizadorCargaMasivaComunicaciones extends AbstractMSVActualizador implements MSVLiberator {
	
	@Autowired
	private ComunicacionGencatApi comunicacionGencatApi;
	
	@Autowired
	private GenericABMDao genericDao; 
	
	@Autowired
	AgendaAdapter agendaAdapter;
	
	@Autowired
	ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	ActivoManager activoManager;
	
	@Autowired
	ActivoTareaExternaApi activoTareaExternaApi;
	
	
	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_COMUNICACIONES;
	}
	
	private static final int POSICION_COLUMNA_NUMERO_ACTIVO = 0;
	private static final int POSICION_COLUMNA_FECHA_COMUNICACION = 1;
	private static final String TIPO_TRAMITE_GENCAT = "T016";
	private static final String TAREA_COMUNICAR_GENCAT = "T016_ComunicarGENCAT";

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws Exception {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoComunicacionGencat.COD_COMUNICADO);
		DDEstadoComunicacionGencat estado = genericDao.get(DDEstadoComunicacionGencat.class, filtro);
		Long idNumActivo= Long.parseLong(exc.dameCelda(fila, POSICION_COLUMNA_NUMERO_ACTIVO));
		ComunicacionGencat cmg = comunicacionGencatApi.getByNumActivoHaya(idNumActivo);
		
		if(DDEstadoComunicacionGencat.COD_CREADO.equals(cmg.getEstadoComunicacion().getCodigo())) {
			
			Date fechaComunicacion = new SimpleDateFormat("dd/MM/yyyy").parse(exc.dameCelda(fila, POSICION_COLUMNA_FECHA_COMUNICACION));  
			avanzaTareaComunicarGencat(idNumActivo, fechaComunicacion);
			
			//Una vez se avanza la tarea se actualiza el estado a Comunicado
			cmg.setEstadoComunicacion(estado);
			genericDao.update(ComunicacionGencat.class, cmg);
		}
		
		return new ResultadoProcesarFila();
	}

	
	private void avanzaTareaComunicarGencat(Long idNumActivo, Date fechaComunicacion) throws Exception {

		ActivoTramite tramiteGencat= null;
		List<TareaExterna> listaTareas= null;
		TareaExterna tareaComunicarGencat= null;
		Long idTramite= null;
	
		tramiteGencat= obtenerTramiteGencat(idNumActivo);
					
		if(!Checks.esNulo(tramiteGencat))
			idTramite= tramiteGencat.getId();
			
		//Obtener la tarea de Comunicar a GENCAT del trámite y guardar la fecha de comunicación
		if(!Checks.esNulo(idTramite)) {
			
			listaTareas= activoTareaExternaApi.getTareasByIdTramite(idTramite);
			tareaComunicarGencat= obtenerTareaComunicarGencat(listaTareas);
		
			if(!Checks.esNulo(tareaComunicarGencat) && !Checks.esNulo(tareaComunicarGencat.getTareaPadre().getId())) 
				guardarFechaComunicacionTEV(tareaComunicarGencat.getTareaPadre().getId(), fechaComunicacion);					
			
		}
	}


	private void guardarFechaComunicacionTEV(Long idTarea, Date fechaComunicacion) throws Exception {
		DateFormat format = new SimpleDateFormat("dd/MM/yyyy");
		Map<String, String[]> valoresTarea = new HashMap<String, String[]>();
		valoresTarea.put("fechaComunicacion", new String[] { format.format(fechaComunicacion) });
		valoresTarea.put("idTarea", new String[] { idTarea.toString() });
		agendaAdapter.save(valoresTarea);
	}


	private TareaExterna obtenerTareaComunicarGencat(List<TareaExterna> listaTareas) {
		for(TareaExterna tarea : listaTareas) {
			if( TAREA_COMUNICAR_GENCAT.equals(tarea.getTareaProcedimiento().getCodigo())) 
				return tarea;			
		}
		return null;
	}


	private ActivoTramite obtenerTramiteGencat(Long idNumActivo) {
		Filter filtroTramitesDelactivo = genericDao.createFilter(FilterType.EQUALS, "activo.numActivo", idNumActivo);
		Filter filtroTPOGencat = genericDao.createFilter(FilterType.EQUALS, "tipoTramite.codigo", TIPO_TRAMITE_GENCAT);
		Filter filtroTramiteActual = genericDao.createFilter(FilterType.NULL, "fechaFin");
		return genericDao.get(ActivoTramite.class, filtroTramitesDelactivo, filtroTPOGencat, filtroTramiteActual);
	}
	
}
