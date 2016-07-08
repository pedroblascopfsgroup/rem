package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.utils.DiccionarioTargetClassMap;

@Component
public class UpdaterServiceCEEObtencionEtiqueta implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private DiccionarioTargetClassMap diccionarioTargetClassMap;
    
	private static final String CODIGO_T003_OBTENCION_ETIQUETA = "T003_ObtencionEtiqueta";
	
	private static final String FECHA_INSCRIPCION = "fechaInscripcion";
	private static final String REFERENCIA_ETIQUETA= "refEtiqueta";
	
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		Activo activo = tramite.getActivo();
		Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "configDocumento.tipoDocumentoActivo.codigo", DDTipoDocumentoActivo.CODIGO_CEE);
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo", activo);
		ActivoAdmisionDocumento documentoCEE = genericDao.get(ActivoAdmisionDocumento.class, filtroTipo, filtroActivo);
		
		for(TareaExternaValor valor :  valores){

			if(FECHA_INSCRIPCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				try {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoDocumento.CODIGO_ESTADO_EN_TRAMITE);
					DDEstadoDocumento estadoDocumento = (DDEstadoDocumento) genericDao.get(DDEstadoDocumento.class, filtro);
					
					documentoCEE.setFechaEtiqueta(ft.parse(valor.getValor()));
					documentoCEE.setFechaObtencion(ft.parse(valor.getValor())); //En caso de que sea CEE con etiqueta se sobreescribe con este valor
					documentoCEE.setFechaVerificado(ft.parse(valor.getValor())); //En este trámite: Fecha obtención = Fecha validación
					documentoCEE.setEstadoDocumento(estadoDocumento);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
			if(REFERENCIA_ETIQUETA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				documentoCEE.setNumDocumento(Integer.parseInt(valor.getValor()));
			}
						
			// TODO: En el funcional se especifica que si se indica que no procede, en la columna FECHA EMISION del bloque documentación administrativa de la pestaña
			// información administrativa del activo se indique el mensaje "NO PROCEDE" hay que pensar como hacerlo puesto que no podemos guardar la cadena en base de datos.

		}

	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos.
		return new String[]{CODIGO_T003_OBTENCION_ETIQUETA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
