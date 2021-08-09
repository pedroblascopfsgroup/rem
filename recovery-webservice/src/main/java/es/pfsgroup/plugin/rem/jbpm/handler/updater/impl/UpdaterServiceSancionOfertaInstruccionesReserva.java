package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTiposArras;

@Component
public class UpdaterServiceSancionOfertaInstruccionesReserva implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
    private UvemManagerApi uvemManagerApi;
    
    private static final String FECHA_ENVIO = "fechaEnvio";
    private static final String TIPO_ARRAS = "tipoArras";
   	public static final String CODIGO_T013_INSTRUCCIONES_RESERVA = "T013_InstruccionesReserva";
   	public static final String CODIGO_T017_INSTRUCCIONES_RESERVA = "T017_InstruccionesReserva";
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaInstruccionesReserva.class);
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if(!Checks.esNulo(ofertaAceptada)){
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		
			for(TareaExternaValor valor :  valores){
	
				if(FECHA_ENVIO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
				{
					Reserva reserva = expediente.getReserva();
					if(!Checks.esNulo(reserva)){
						try {
							reserva.setFechaEnvio(ft.parse(valor.getValor()));
							genericDao.save(Reserva.class, reserva);
						} catch (ParseException e) {
							e.printStackTrace();
						}
					}
				}
				
				if(TIPO_ARRAS.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
					Reserva reserva = expediente.getReserva();
					if(!Checks.esNulo(reserva)){
						
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
						DDTiposArras tipoArras = (DDTiposArras) genericDao.get(DDTiposArras.class, filtro);						
						reserva.setTipoArras(tipoArras);
						genericDao.save(Reserva.class, reserva);
					}
				}
				genericDao.save(ExpedienteComercial.class, expediente);
			}
			// LLamada servicio web Bankia para modificaciones según tipo
			// propuesta (MOD3)
			if (!Checks.estaVacio(valores) && !uvemManagerApi.esTramiteOffline(
					UpdaterServiceSancionOfertaInstruccionesReserva.CODIGO_T013_INSTRUCCIONES_RESERVA, expediente)) {
				if (!Checks.esNulo(ofertaAceptada.getActivoPrincipal())
						&& !Checks.esNulo(ofertaAceptada.getActivoPrincipal().getCartera())
						&& ofertaAceptada.getActivoPrincipal().getCartera().getCodigo()
								.equals(DDCartera.CODIGO_CARTERA_BANKIA)) {
					uvemManagerApi.modificacionesSegunPropuesta(valores.get(0).getTareaExterna());
				}
			}

		}

	}
	
	
	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_INSTRUCCIONES_RESERVA,CODIGO_T017_INSTRUCCIONES_RESERVA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
