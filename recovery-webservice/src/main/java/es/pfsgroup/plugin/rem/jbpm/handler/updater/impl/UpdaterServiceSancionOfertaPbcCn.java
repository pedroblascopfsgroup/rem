package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.itinerario.EstadoManager;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoListadoTareas;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRechazoOferta;

@Component
public class UpdaterServiceSancionOfertaPbcCn implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private OfertaApi ofertaApi;

    @Autowired
    private UvemManagerApi uvemManagerApi;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    @Autowired
    private UtilDiccionarioApi utilDiccionarioApi;
    
    @Autowired
	private TareaActivoApi tareaActivoApi;
    
    @Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaPbcCn.class);

    private static final String COMBO_RESULTADO = "comboResultado";
    private static final String COMBO_RESPUESTA = "comboRespuesta";
    
    
    public static final String CODIGO_T017_PBC_CN = "T017_PBC_CN";
    
    public static final String CODIGO_T017 = "T017";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		ExpedienteComercial expediente = null;
		boolean estadoBcModificado = false;
		//Activo activo = ofertaAceptada.getActivoPrincipal();
		
		if(!Checks.esNulo(ofertaAceptada)) {
			expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());

			if (!Checks.esNulo(expediente)) {

				for(TareaExternaValor valor :  valores){

					if(COMBO_RESULTADO.equals(valor.getNombre()) || COMBO_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						if(DDSiNo.SI.equals(valor.getValor())) {
							expediente.setEstadoPbcCn(1);							
							DDEstadoExpedienteBc estadoBc = (DDEstadoExpedienteBc) utilDiccionarioApi
									.dameValorDiccionarioByCod(DDEstadoExpedienteBc.class,
											DDEstadoExpedienteBc.CODIGO_PDTE_APROBACION_BC);
							if (estadoBc != null) {
								expediente.setEstadoBc(estadoBc);
								estadoBcModificado = true;
							}							
							
						} else if(DDSiNo.NO.equals(valor.getValor())) {
							expediente.setEstadoPbcCn(0);	
						}
					}
					genericDao.save(ExpedienteComercial.class, expediente);
				}
			}
		}
		
		if(estadoBcModificado && expediente != null) {
			ofertaApi.replicateOfertaFlush(expediente.getOferta());
		}

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T017_PBC_CN};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		// TODO Auto-generated method stub
		
	}

}
