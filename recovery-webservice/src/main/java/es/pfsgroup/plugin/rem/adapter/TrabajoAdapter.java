package es.pfsgroup.plugin.rem.adapter;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoFoto;
import es.pfsgroup.plugin.rem.model.DtoListadoTareas;
import es.pfsgroup.plugin.rem.model.DtoListadoTramites;
import es.pfsgroup.plugin.rem.model.DtoTrabajoListActivos;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.TrabajoFoto;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosTrabajoParticipa;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;



@Service
public class TrabajoAdapter {

    @Resource
    MessageService messageServices;
    
	@Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ActivoTramiteApi activoTramiteApi;
    
    @Autowired 
    private TareaActivoApi tareaActivoApi;
    
    @Autowired
    private ActivoTareaExternaApi activoTareaExternaApi;  
    
    @Autowired
    private ProcessAdapter processAdapter;
        
    @Autowired
    private MSVExcelParser excelParser;
    
    @Autowired
    private ActivoDao activoDao;
    
    BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	public List<ActivoTrabajo> getListadoActivoTrabajos(Long idActivo, String codigoSubtipotrabajo){
		List<ActivoTrabajo> ActivoTrabajo = new ArrayList<ActivoTrabajo>();
		
		  Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS,"activo.id", idActivo); 
		  Filter filtroSubtipoTrabajo =genericDao.createFilter(FilterType.EQUALS,"trabajo.subtipoTrabajo.codigo", codigoSubtipotrabajo);
		 
		try {
			ActivoTrabajo = genericDao.getList(ActivoTrabajo.class,filtroActivo,filtroSubtipoTrabajo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return ActivoTrabajo;		
	}
	
	public List<DtoListadoTramites> getListadoTramitesTareasTrabajo(Long idTrabajo, WebDto webDto){		
		
		List<DtoListadoTramites> tramites = new ArrayList<DtoListadoTramites>();
		
		try {
			
			@SuppressWarnings("unchecked")
			List<ActivoTramite> tramitesActivo = (List<ActivoTramite>) activoTramiteApi.getTramitesActivoTrabajo(idTrabajo, webDto).getResults();
	
			List<VBusquedaActivosTrabajoParticipa> listaActivosTrabajo =  genericDao.getList(VBusquedaActivosTrabajoParticipa.class, genericDao.createFilter(FilterType.EQUALS,"idTrabajo", idTrabajo.toString()));
			
			for(ActivoTramite tramite : tramitesActivo){
				
				DtoListadoTramites dtoTramite = new DtoListadoTramites();
	
					beanUtilNotNull.copyProperty(dtoTramite, "idTramite", tramite.getId());
					beanUtilNotNull.copyProperty(dtoTramite, "idTipoTramite", tramite.getTipoTramite().getId());
					beanUtilNotNull.copyProperty(dtoTramite, "tipoTramite", tramite.getTipoTramite().getDescripcion());
					if(!Checks.esNulo(tramite.getTramitePadre()))
					beanUtilNotNull.copyProperty(dtoTramite, "idTramitePadre", tramite.getTramitePadre().getId());
					if(!Checks.estaVacio(listaActivosTrabajo))
					beanUtilNotNull.copyProperty(dtoTramite, "idActivo", listaActivosTrabajo.get(0).getIdActivo());
					beanUtilNotNull.copyProperty(dtoTramite, "nombre", tramite.getTipoTramite().getDescripcion());
					beanUtilNotNull.copyProperty(dtoTramite, "estado", tramite.getEstadoTramite().getDescripcion());
					
					List<TareaExterna> tareasTramite = activoTareaExternaApi.getTareasByIdTramite(tramite.getId());
					DtoListadoTareas[] tareas = new DtoListadoTareas[tareasTramite.size()];
					
					for(int i=0; i<tareasTramite.size(); i++) {
						
						TareaExterna tarea = tareasTramite.get(i);
						
						DtoListadoTareas dtoListadoTareas = new DtoListadoTareas();

						TareaActivo tareaActivo = tareaActivoApi.get(tarea.getTareaPadre().getId());
	
						beanUtilNotNull.copyProperty(dtoListadoTareas, "id", tarea.getTareaPadre().getId());
						beanUtilNotNull.copyProperty(dtoListadoTareas, "idTareaExterna", tarea.getId());
						beanUtilNotNull.copyProperty(dtoListadoTareas, "tipoTarea", tarea.getTareaProcedimiento().getDescripcion());
						//idTramite necesario para poder abrir desde listado de tareas del trabajo
						beanUtilNotNull.copyProperty(dtoListadoTareas, "idTramite", tramite.getId());
						beanUtilNotNull.copyProperty(dtoListadoTareas, "tipoTramite", tramite.getTipoTramite().getDescripcion());
						beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaInicio", tarea.getTareaPadre().getFechaInicio());
						beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaFin", tarea.getTareaPadre().getFechaFin());
						beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaVenc", tarea.getTareaPadre().getFechaVenc());
						
						if(!Checks.esNulo(tareaActivo.getUsuario())){
							beanUtilNotNull.copyProperty(dtoListadoTareas, "idGestor", tareaActivo.getUsuario().getId());
							beanUtilNotNull.copyProperty(dtoListadoTareas, "gestor", tareaActivo.getUsuario().getUsername());
						}
						beanUtilNotNull.copyProperty(dtoListadoTareas, "subtipoTareaCodigoSubtarea", tareaActivo.getSubtipoTarea().getCodigoSubtarea());
							
						tareas[i] = dtoListadoTareas;
					}
					
					dtoTramite.setTareas(tareas);
					
					tramites.add(dtoTramite);
			}					
					
				
		} catch (Exception e) {
			e.printStackTrace();
		}

		return tramites;		
		
	}

	public List<TrabajoFoto> getListFotosTrabajoById(Long id, boolean solicitanteProveedor) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", id);
		Filter filtroSolicitante = genericDao.createFilter(FilterType.EQUALS, "solicitanteProveedor", solicitanteProveedor);
		Order order = new Order(OrderType.ASC, "orden");
		
		return genericDao.getListOrdered(TrabajoFoto.class, order, filtro, filtroSolicitante);

	}

	public TrabajoFoto getFotoTrabajoById(Long id) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);	
		
		return genericDao.get(TrabajoFoto.class, filtro);

	}	
	
	@Transactional(readOnly = false)
	public boolean saveFoto(DtoFoto dtoFoto) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoFoto.getId());
		TrabajoFoto trabajoFoto = genericDao.get(TrabajoFoto.class, filtro);
		
		try {
			
			beanUtilNotNull.copyProperties(trabajoFoto, dtoFoto);
			genericDao.save(TrabajoFoto.class, trabajoFoto);
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return true;
		
	}
	
	@Transactional(readOnly = false)
	public boolean deleteFotosTrabajoById(Long[] id) {
		
		try {
			
			for (int i = 0; i<id.length; i++) {
				genericDao.deleteById(TrabajoFoto.class, id[i]);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		return true;
		
	}
	
	public String getAdvertenciaCrearTrabajo(Long idActivo, String codigoSubtipoTrabajo, List<ActivoTrabajo> listaActivoTrabajo ){

		String mensaje = "";		
		

		// Al seleccionar tramitar propuesta de precios, avisa al usuario si existe una propuesta de precios en trámite para el activo.
		if(DDSubtipoTrabajo.CODIGO_TRAMITAR_PROPUESTA_DESCUENTO.equals(codigoSubtipoTrabajo) ||  DDSubtipoTrabajo.CODIGO_TRAMITAR_PROPUESTA_PRECIOS.equals(codigoSubtipoTrabajo)) {
			
			List<VBusquedaActivosPrecios> listaActivos = activoDao.getListActivosPreciosFromListId(idActivo.toString());
			
			if(!Checks.estaVacio(listaActivos)) {
				VBusquedaActivosPrecios activoPrecio = listaActivos.get(0);
				
				if(activoPrecio.getActivoEnPropuestaEnTramitacion()) {
					mensaje = messageServices.getMessage("trabajo.advertencia.existe.propuesta.precios.activa");
				}
			}
			
			
		} else {
			
		
			//Avisa al usuario de algún trabajo existente del mismo tipo/subtipo y que no sea de los anteriores
			if(Checks.estaVacio(listaActivoTrabajo)) {
				
				listaActivoTrabajo = getListadoActivoTrabajos(idActivo, codigoSubtipoTrabajo);
			}
		
		
			if (!listaActivoTrabajo.isEmpty()){
	
				Integer countActivoTrabajos = listaActivoTrabajo.size();
				String tipoTrabajoDescripcion = listaActivoTrabajo.get(0).getTrabajo().getTipoTrabajo().getDescripcion();
				String subTipoTrabajoDescripcion = listaActivoTrabajo.get(0).getTrabajo().getSubtipoTrabajo().getDescripcion();
				
				if (countActivoTrabajos == 1){
					mensaje = messageServices.getMessage("trabajo.advertencia.existenMismoSubtipo.uno.yaExiste").concat(" "); //"Advertencia: Para este activo ya existe un trabajo del tipo ";
					mensaje = mensaje.concat(tipoTrabajoDescripcion);
					mensaje = mensaje.concat(" / ");
					mensaje = mensaje.concat(subTipoTrabajoDescripcion);
					mensaje = mensaje.concat(" ").concat(messageServices.getMessage("trabajo.advertencia.existenMismoSubtipo.uno.conEstado")).concat(" "); //mensaje.concat(" y en estado ");
					mensaje = mensaje.concat(listaActivoTrabajo.get(0).getTrabajo().getEstado().getDescripcion()).concat(".");
				}else {
					String estados = new String();
					//Se almacenan los estados de todos los trabajos encontrados en un objeto tipo HashSet para
					//crear una colección de estados distintos
					HashSet<String> listaEstadosTrabajos = new HashSet<String>();
					
					
					for (ActivoTrabajo activoTrabajo : listaActivoTrabajo){
						listaEstadosTrabajos.add(activoTrabajo.getTrabajo().getEstado().getDescripcion());
					}
					
					for (String estadosTrabajos : listaEstadosTrabajos){
						estados = estados.concat(estadosTrabajos).concat(", ");
					}
					estados = estados.substring(0, estados.length()-2);
					
					mensaje = messageServices.getMessage("trabajo.advertencia.existenMismoSubtipo.varios.yaExiste").concat(" "); //"Advertencia: Para este activo ya existen ";
					mensaje = mensaje.concat(String.valueOf(countActivoTrabajos));
					mensaje = mensaje.concat(" ").concat(messageServices.getMessage("trabajo.advertencia.existenMismoSubtipo.varios.trabajosTipo")).concat(" "); //mensaje.concat(" trabajos del tipo ");
					mensaje = mensaje.concat(tipoTrabajoDescripcion);
					mensaje = mensaje.concat(" / ");
					mensaje = mensaje.concat(subTipoTrabajoDescripcion);
					mensaje = mensaje.concat(" ").concat(messageServices.getMessage("trabajo.advertencia.existenMismoSubtipo.varios.conEstado")).concat(" "); //mensaje.concat(" y en estados ");
					mensaje = mensaje.concat(estados).concat(".");
				}
			}
		}
			
		return mensaje;
	}
	
	
	
	public Page getListActivosByProceso(Long idProceso, DtoTrabajoListActivos webDto){
		
		List<String> listIdActivos = new ArrayList<String>();
		
		if(Checks.esNulo(idProceso))
			return null;

		MSVDocumentoMasivo document = processAdapter.getMSVDocumento(idProceso);

		MSVHojaExcel exc = excelParser.getExcel(document.getContenidoFichero().getFile());
		
		try {
			Integer numFilas = exc.getNumeroFilasByHoja(0,document.getProcesoMasivo().getTipoOperacion());
			for(int i = 1; i < numFilas; i++){ //Nos saltamos la línea del título	
				listIdActivos.add(exc.dameCelda(i, 0));
			}
			
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return activoDao.getActivosFromCrearTrabajo(listIdActivos, webDto);
	}

}
