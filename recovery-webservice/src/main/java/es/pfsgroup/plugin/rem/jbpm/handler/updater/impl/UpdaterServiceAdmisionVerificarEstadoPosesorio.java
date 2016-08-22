package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

@Component
public class UpdaterServiceAdmisionVerificarEstadoPosesorio implements UpdaterService {
	
	private static final String FECHA = "fecha";
	private static final String COMBO_OCUPADO = "comboOcupado";
	private static final String COMBO_TITULO = "comboTitulo";
	private static final String CODIGO_T001_VERIFICAR_ESTADO_POSESORIO = "T001_VerificarEstadoPosesorio";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		// TODO Código que guarda las tareas.
		//Valores trasladados a pestaña "Situación Posesoria"
		for(TareaExternaValor valor :  valores){

			// Fecha revisión estado
			if(FECHA.equals(valor.getNombre()))
				try {
					tramite.getActivo().getSituacionPosesoria().setFechaRevisionEstado(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			// Activo ocupado si/no
			if(COMBO_OCUPADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
				tramite.getActivo().getSituacionPosesoria().setOcupado((DDSiNo.NO.equals(valor.getValor()))? 0 : 1);
			
			// Ocupante con titulo xa activo
			if(COMBO_TITULO.equals(valor.getNombre()))
				if(!Checks.esNulo(valor.getValor()))
					tramite.getActivo().getSituacionPosesoria().setConTitulo((DDSiNo.NO.equals(valor.getValor()))? 0 : 1);
				else //En el caso de que no se haya rellenado el campo título lo nuleamos por si tuviese algún valor anteriormente.
					tramite.getActivo().getSituacionPosesoria().setConTitulo(null);
		}

	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos.
		return new String[]{CODIGO_T001_VERIFICAR_ESTADO_POSESORIO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
