package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.utils.DiccionarioTargetClassMap;

@Component
public class UpdaterServiceComunObtencionGestorInterno implements UpdaterService {
	
	private static final String FECHA_EMISION = "fechaEmision";
	private static final String REFERENCIA_DOCUMENTO = "refDocumento";
	private static final String COMBO_OBTENCION = "comboObtencion";
	private static final String CODIGO_T002_OBTENCION_GESTOR_INTERNO = "T002_ObtencionLPOGestorInterno";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private DiccionarioTargetClassMap diccionarioTargetClassMap;
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		
		Trabajo trabajo = tramite.getTrabajo();
		
		for(TareaExternaValor valor : valores){
			
			//Fecha Emisión
			if(FECHA_EMISION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
			{
				DDSubtipoTrabajo subtipoTrabajo = trabajo.getSubtipoTrabajo();
				List<ActivoAdmisionDocumento> listaDocumentos = tramite.getActivo().getAdmisionDocumento();
				for(ActivoAdmisionDocumento documento : listaDocumentos){
					if(subtipoTrabajo.getCodigo().equals(diccionarioTargetClassMap.getSubtipoTrabajo(documento.getConfigDocumento().getTipoDocumentoActivo().getCodigo()))) {
						try {
							Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoDocumento.CODIGO_ESTADO_EN_TRAMITE);
							DDEstadoDocumento estadoDocumento = (DDEstadoDocumento) genericDao.get(DDEstadoDocumento.class, filtro);
							
							documento.setFechaEmision(ft.parse(valor.getValor()));
							documento.setEstadoDocumento(estadoDocumento);
							Auditoria.save(documento);
						} catch (ParseException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				}
			}
			
			//Número de referencia
			if(REFERENCIA_DOCUMENTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
			{
				DDSubtipoTrabajo subtipoTrabajo = trabajo.getSubtipoTrabajo();
				List<ActivoAdmisionDocumento> listaDocumentos = tramite.getActivo().getAdmisionDocumento();
				for(ActivoAdmisionDocumento documento : listaDocumentos){
					if(subtipoTrabajo.getCodigo().equals(diccionarioTargetClassMap.getSubtipoTrabajo(documento.getConfigDocumento().getTipoDocumentoActivo().getCodigo()))) {
						documento.setNumDocumento(valor.getValor());
						Auditoria.save(documento);
					}
				}
			}
			
			//Imposible Obtencion documento
			//El combo regula el cambio de estado del trabajo. Agrupamos todos los cambios de estado sobre el 
			// mismo campo debido a que no hay certidumbre en el orden en que se van a evaluar los campos de
			// la lista de "valores"
            if(COMBO_OBTENCION.equals(valor.getNombre())){
            	
	            if(DDSiNo.NO.equals(valor.getValor())){
                    // Obtención documento = NO : Trabajo -> estado -> IMPOSIBLE OBTENCION
                    Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_IMPOSIBLE_OBTENCION);
                    DDEstadoTrabajo estadoTrabajo = genericDao.get(DDEstadoTrabajo.class, filter);
                    trabajo.setEstado(estadoTrabajo);
	            }else{
					// Obtención documento = SI : Trabajo -> Estado -> FINALIZADO PENDIENTE VALIDACION
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_FINALIZADO);
					DDEstadoTrabajo estadoTrabajo = genericDao.get(DDEstadoTrabajo.class, filter);
					trabajo.setEstado(estadoTrabajo);
	            }
            }
            
		}	
		genericDao.save(Trabajo.class, trabajo);

	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos.
		return new String[]{CODIGO_T002_OBTENCION_GESTOR_INTERNO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

    
}
