package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoConfigDocumento;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
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
	
	@Transactional
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		Activo activo = tramite.getActivo();
		Trabajo trabajo = tramite.getTrabajo();
		Filter filter;
		Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "configDocumento.tipoDocumentoActivo.codigo", DDTipoDocumentoActivo.CODIGO_CEE);
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo", activo);
		ActivoAdmisionDocumento documentoCEE = genericDao.get(ActivoAdmisionDocumento.class, filtroTipo, filtroActivo);
		
		
		
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
			dtoDocumento.setIdConfiguracionDoc(config.getId());
			//TODO: Pendiente de concretar si ha de ser SI aplica o NO aplica, cuando el documento se crea automáticamente por crear el trámite desde el trabajo.
			dtoDocumento.setAplica(0);
			
			activoAdapter.saveAdmisionDocumento(dtoDocumento);
			documentoCEE = genericDao.get(ActivoAdmisionDocumento.class, filtroTipo, filtroActivo);
		}
		
		
		for(TareaExternaValor valor :  valores){

			if(FECHA_EMISION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				try {
					documentoCEE.setFechaEmision(ft.parse(valor.getValor())); // Información administrativa
					documentoCEE.setFechaSolicitud(ft.parse(valor.getValor())); // Checking información
					documentoCEE.setFechaObtencion(ft.parse(valor.getValor())); // Fecha de obtención
					documentoCEE.setFechaVerificado(ft.parse(valor.getValor())); // Fecha de validación
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
			if(COMBO_CALIFICACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				Filter filtroCalificacion = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
				DDTipoCalificacionEnergetica tipoCalificacionEnergetica = genericDao.get(DDTipoCalificacionEnergetica.class, filtroCalificacion);
				documentoCEE.setTipoCalificacionEnergetica(tipoCalificacionEnergetica);
			}

			if(COMBO_PROCEDE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){

				if(DDSiNo.SI.equals(valor.getValor())){
					// Si combo procede = SI, estado del trabajo a "CON CEE PENDIENTE DE ETIQUETA"
					filter = genericDao.createFilter(FilterType.EQUALS, "codigo" , DDEstadoTrabajo.ESTADO_CEE_PENDIENTE_ETIQUETA);
					DDEstadoTrabajo estado = genericDao.get(DDEstadoTrabajo.class, filter);
					trabajo.setEstado(estado);
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
