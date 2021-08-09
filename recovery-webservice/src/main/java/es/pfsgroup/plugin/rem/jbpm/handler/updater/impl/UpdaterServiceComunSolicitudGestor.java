package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.exception.RemUserException;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoConfigDocumento;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.utils.DiccionarioTargetClassMap;

@Component
public class UpdaterServiceComunSolicitudGestor implements UpdaterService {
	
	private static final String FECHA_SOLICITUD = "fechaSolicitud";
	private static final String CODIGO_T002_SOLICITUD_GESTORIA = "T002_SolicitudDocumentoGestoria";
	private static final String CODIGO_T002_SOLICITUD_GESTOR_INTERNO = "T002_SolicitudLPOGestorInterno";
	private static final String CODIGO_T008_SOLICITUD_GESTORIA = "T008_SolicitudDocumento";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	@Autowired
	private GenericABMDao genericDao;
	
	
	@Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	private DiccionarioTargetClassMap diccionarioTargetClassMap;
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		Activo activo = tramite.getActivo();
		Trabajo trabajo = tramite.getTrabajo();
		
		// Tipo de documento a obtener
		String codigoTipoDocumento = diccionarioTargetClassMap.getTipoDocumento(trabajo.getSubtipoTrabajo().getCodigo());

		//Existen trabajos de Obtencion Documental que no tienen relacion con un tipo de documento
		// Estos trabajos producen un "codigoTipoDocumento" nulo y no deben operar/validar ningun documento
		if(!Checks.esNulo(codigoTipoDocumento)){
			
			// Obtenemos el tipo de documento afectado
			Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "configDocumento.tipoDocumentoActivo.codigo", codigoTipoDocumento);
			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo", activo);
			ActivoAdmisionDocumento documento = genericDao.get(ActivoAdmisionDocumento.class, filtroTipo, filtroActivo);
			
			
			// Comprobamos si es nulo para crearlo
			if(Checks.esNulo(documento)){
				DtoAdmisionDocumento dtoDocumento = new DtoAdmisionDocumento();
				dtoDocumento.setIdActivo(activo.getId());
				Filter filtroTipoActivo = genericDao.createFilter(FilterType.EQUALS, "tipoActivo", activo.getTipoActivo());
				Filter filtroTipoDocumento = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipoDocumento);
				DDTipoDocumentoActivo tipoDocumento = genericDao.get(DDTipoDocumentoActivo.class, filtroTipoDocumento);
				Filter filtroTipoDocumentoId = genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoActivo", tipoDocumento);
				ActivoConfigDocumento config = genericDao.get(ActivoConfigDocumento.class, filtroTipoActivo, filtroTipoDocumentoId);
				dtoDocumento.setIdConfiguracionDoc(config.getId());
				//TODO: Pendiente de concretar si ha de ser SI aplica o NO aplica, cuando el documento se crea automáticamente por crear el trámite desde el trabajo.
				dtoDocumento.setAplica(0);
				
				try {
					activoAdapter.saveAdmisionDocumento(dtoDocumento);
				} catch (RemUserException e) {
					e.printStackTrace();
				}
				documento = genericDao.get(ActivoAdmisionDocumento.class, filtroTipo, filtroActivo);
				}
			
			for(TareaExternaValor valor : valores){
				
				//Fecha Solicitud
				if(FECHA_SOLICITUD.equals(valor.getNombre()))
				{
					try {
							Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoDocumento.CODIGO_ESTADO_EN_TRAMITE);
							DDEstadoDocumento estadoDocumento = (DDEstadoDocumento) genericDao.get(DDEstadoDocumento.class, filtro);
							
							documento.setFechaSolicitud(ft.parse(valor.getValor()));
							documento.setEstadoDocumento(estadoDocumento);
							Auditoria.save(documento);
						} catch (ParseException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
				}
			}
		}
		
		if(DDTipoDocumentoActivo.CODIGO_CEDULA_HABITABILIDAD.equals(codigoTipoDocumento)){
			Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo" , DDEstadoTrabajo.ESTADO_EN_TRAMITE);
			DDEstadoTrabajo estado = genericDao.get(DDEstadoTrabajo.class, filter);
			trabajo.setEstado(estado);
			Auditoria.save(trabajo);
		}
	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos.
		return new String[]{CODIGO_T002_SOLICITUD_GESTORIA, CODIGO_T002_SOLICITUD_GESTOR_INTERNO, CODIGO_T008_SOLICITUD_GESTORIA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

    
}