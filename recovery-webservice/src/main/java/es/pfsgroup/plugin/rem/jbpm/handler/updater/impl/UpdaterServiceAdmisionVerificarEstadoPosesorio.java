package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.recovery.api.UsuarioApi;


@Component
public class UpdaterServiceAdmisionVerificarEstadoPosesorio implements UpdaterService {
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	
	private static final String FECHA = "fecha";
	private static final String COMBO_OCUPADO = "comboOcupado";
	private static final String COMBO_TITULO = "comboTitulo";
	private static final String CODIGO_T001_VERIFICAR_ESTADO_POSESORIO = "T001_VerificarEstadoPosesorio";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		// TODO Código que guarda las tareas.
		
		ActivoSituacionPosesoria sitpos = tramite.getActivo().getSituacionPosesoria();
		Filter tituloActivo;
		DDTipoTituloActivoTPA tipoTitulo;
		
		Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		String usuarioModificar = usu == null ? CODIGO_T001_VERIFICAR_ESTADO_POSESORIO : CODIGO_T001_VERIFICAR_ESTADO_POSESORIO + " - " + usu.getUsername();
		
		//Valores trasladados a pestaña "Situación Posesoria"
		for(TareaExternaValor valor :  valores){

			// Fecha revisión estado
			if(FECHA.equals(valor.getNombre()))
				try {
					sitpos.setFechaRevisionEstado(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			// Activo ocupado si/no
			if(COMBO_OCUPADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				sitpos.setOcupado((DDSiNo.NO.equals(valor.getValor()))? 0 : 1);			
				sitpos.setFechaModificarOcupado(new Date());
				sitpos.setUsuarioModificarOcupado(usuarioModificar);
				
			}
			
			// Ocupante con titulo xa activo
			if(COMBO_TITULO.equals(valor.getNombre()))
				if(!Checks.esNulo(valor.getValor())) {
					tituloActivo = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
					tipoTitulo = genericDao.get(DDTipoTituloActivoTPA.class, tituloActivo);
					sitpos.setConTitulo(tipoTitulo);
				} else {//En el caso de que no se haya rellenado el campo título lo nuleamos por si tuviese algún valor anteriormente.
					sitpos.setConTitulo(null);
				}
				sitpos.setUsuarioModificarConTitulo(usuarioModificar);
				sitpos.setFechaModificarConTitulo(new Date());
				sitpos.setFechaUltCambioTit(new Date());
		}
		genericDao.save(ActivoSituacionPosesoria.class, sitpos);
	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos.
		return new String[]{CODIGO_T001_VERIFICAR_ESTADO_POSESORIO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
