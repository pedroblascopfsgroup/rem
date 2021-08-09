package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.exception.RemUserException;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalificacionEnergetica;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.utils.DiccionarioTargetClassMap;

@Component
public class UpdaterServiceCEEEmisionCertificado implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;
    
    
    @Autowired
    private DiccionarioTargetClassMap diccionarioTargetClassMap;
    
    @Autowired
    private ActivoAdapter activoAdapter;
    
        
	private static final String CODIGO_T003_EMISION_CERTIFICADO = "T003_EmisionCertificado";
	
	private static final String FECHA_EMISION = "fechaEmision";
	private static final String COMBO_CALIFICACION = "comboCalificacion";
	private static final String COMBO_PROCEDE = "comboProcede";

	
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	@Transactional(readOnly = false)
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		Activo activo = tramite.getActivo();
		Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "configDocumento.tipoDocumentoActivo.codigo", DDTipoDocumentoActivo.CODIGO_CEE_TRABAJO);
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo", activo);
		ActivoAdmisionDocumento documentoCEE = genericDao.get(ActivoAdmisionDocumento.class, filtroTipo, filtroActivo);
		Trabajo trabajo = tramite.getTrabajo();
		
		
		
		/*
		 * Si no existe el documento, es decir, si se ha creado desde un trabajo, hay que crearlo.
		 */
		if(Checks.esNulo(documentoCEE)){
			DtoAdmisionDocumento dtoDocumento = new DtoAdmisionDocumento();
			dtoDocumento.setIdActivo(activo.getId());
			Filter filtroTipoActivo = genericDao.createFilter(FilterType.EQUALS, "tipoActivo", activo.getTipoActivo());
			Filter filtroTipoDocumento = genericDao.createFilter(FilterType.EQUALS, "codigo", diccionarioTargetClassMap.getTipoDocumento(tramite.getTrabajo().getSubtipoTrabajo().getCodigo()));
			DDTipoDocumentoActivo tipoDocumento = genericDao.get(DDTipoDocumentoActivo.class, filtroTipoDocumento);
			Filter filtroTipoDocumentoId = genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoActivo", tipoDocumento);
			ActivoConfigDocumento config = genericDao.get(ActivoConfigDocumento.class, filtroTipoActivo, filtroTipoDocumentoId);
			
			if(!Checks.esNulo(config.getId())){
				dtoDocumento.setIdConfiguracionDoc(config.getId());
			}
			
			//TODO: Pendiente de concretar si ha de ser SI aplica o NO aplica, cuando el documento se crea automáticamente por crear el trámite desde el trabajo.
			dtoDocumento.setAplica(0);
			
			try {
				activoAdapter.saveAdmisionDocumento(dtoDocumento);
			} catch (RemUserException e) {
				e.printStackTrace();
			}
			documentoCEE = genericDao.get(ActivoAdmisionDocumento.class, filtroTipo, filtroActivo);
		}
		
		
		for(TareaExternaValor valor :  valores){

			if(FECHA_EMISION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				Date f = null;
				try {
					f = ft.parse(valor.getValor());
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				if(!Checks.esNulo(f)) {
					documentoCEE.setFechaEmision(f); // Información administrativa
					documentoCEE.setFechaSolicitud(f); // Checking información
					documentoCEE.setFechaObtencion(f); // Fecha de obtención
					documentoCEE.setFechaVerificado(f); // Fecha de validación
					Calendar cal = Calendar.getInstance();
					cal.setTime(f);
					cal.add(Calendar.YEAR, 10); 
					f = cal.getTime();
					documentoCEE.setFechaCaducidad(f); // Fecha caducidad (Fecha emisión + 10 años)
					documentoCEE.setAplica(true);
					documentoCEE.setEstadoDocumento(genericDao.get(DDEstadoDocumento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoDocumento.CODIGO_ESTADO_OBTENIDO )));
				}
			}
			
			if(COMBO_CALIFICACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				Filter filtroCalificacion = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
				DDTipoCalificacionEnergetica tipoCalificacionEnergetica = genericDao.get(DDTipoCalificacionEnergetica.class, filtroCalificacion);
				documentoCEE.setTipoCalificacionEnergetica(tipoCalificacionEnergetica);
			}

			if(COMBO_PROCEDE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){

				if(DDSiNo.NO.equals(valor.getValor())){
					Filter filtroEstado = genericDao.createFilter(FilterType.EQUALS, "codigo" , DDEstadoTrabajo.ESTADO_PENDIENTE_CIERRE_ECONOMICO);
					DDEstadoTrabajo estado = genericDao.get(DDEstadoTrabajo.class, filtroEstado);
					trabajo.setEstado(estado);
					Auditoria.save(trabajo);
				}
				
			}

			
			// TODO: En el funcional se especifica que si se indica que no procede, en la columna FECHA EMISION del bloque documentación administrativa de la pestaña
			// información administrativa del activo se indique el mensaje "NO PROCEDE" hay que pensar como hacerlo puesto que no podemos guardar la cadena en base de datos.

		}
		genericDao.save(ActivoAdmisionDocumento.class, documentoCEE);
	
	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos.
		return new String[]{CODIGO_T003_EMISION_CERTIFICADO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
