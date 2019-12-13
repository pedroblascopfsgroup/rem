package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.exception.PlusvaliaActivoException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGestionPlusv;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;

@Component
public class UpdaterServiceSancionOfertaDocumentosPostVenta implements UpdaterService {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	

	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaDocumentosPostVenta.class);
	private static final String FECHA_INGRESO = "fechaIngreso";
	private static final String CHECKBOX_VENTA_DIRECTA = "checkboxVentaDirecta";
	private static final String CODIGO_T013_DOCUMENTOS_POST_VENTA = "T013_DocumentosPostVenta";
	private static final String CODIGO_T017_DOCUMENTOS_POST_VENTA = "T017_DocsPosVenta";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		for (TareaExternaValor valor : valores) {

			// fecha ingreso cheque
			if (FECHA_INGRESO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				Oferta oferta = ofertaApi.trabajoToOferta(tramite.getTrabajo());
				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());

				// Guardado adicional Fecha inicio => expediente comercial.fecha inicio
				try {
					if (!Checks.esNulo(expediente)) {
						expediente.setFechaContabilizacionPropietario(ft.parse(valor.getValor()));
					}
				} catch (ParseException e) {
					logger.error(e);
				}

				genericDao.save(ExpedienteComercial.class, expediente);
			}

			if (CHECKBOX_VENTA_DIRECTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				Oferta oferta = ofertaApi.trabajoToOferta(tramite.getTrabajo());
				Activo activo = oferta.getActivoPrincipal();
				activo.setVentaDirectaBankia("true".equals(valor.getValor()) ? true : false);
				genericDao.save(Activo.class, activo);
			}
		}

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());

			// Expediente se marca a vendido.
			Filter filtro = null;
			if(DDCartera.CODIGO_CARTERA_LIBERBANK.equals(expediente.getOferta().getActivosOferta().get(0).getPrimaryKey().getActivo().getCartera().getCodigo())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.FIRMADO);
			}else {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.VENDIDO);
				if (ofertaAceptada.getActivoPrincipal() != null) {
					try {
						activoApi.changeAndSavePlusvaliaEstadoGestionActivoById(ofertaAceptada.getActivoPrincipal(), DDEstadoGestionPlusv.COD_EN_CURSO);
					} catch (PlusvaliaActivoException e) {
						logger.error(e);
					}
				}
			}
			DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
			expediente.setEstado(estado);
			genericDao.save(ExpedienteComercial.class, expediente);

			for (ActivoOferta activoOferta : ofertaAceptada.getActivosOferta()) {
				Activo activo = activoOferta.getPrimaryKey().getActivo();

				PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(activo.getId());
				perimetro.setAplicaComercializar(0);
				perimetro.setAplicaPublicar(false);
				perimetro.setFechaAplicaPublicar(new Date());
				perimetro.setFechaAplicaComercializar(new Date());
				genericDao.save(PerimetroActivo.class, perimetro);

				// Marcamos el activo como vendido
				Filter filtroSituacionComercial = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSituacionComercial.CODIGO_VENDIDO);
				activo.setSituacionComercial(genericDao.get(DDSituacionComercial.class, filtroSituacionComercial));

				activo.setBloqueoPrecioFechaIni(new Date());
				activoApi.saveOrUpdate(activo);
				
				
			}

			// Rechazamos el resto de ofertas
			List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
			for (Oferta oferta : listaOfertas) {
				if (DDEstadoOferta.CODIGO_CONGELADA.equals(oferta.getEstadoOferta().getCodigo())) {
					ofertaApi.rechazarOferta(oferta);
				}
			}

			genericDao.save(Oferta.class, ofertaAceptada);

		}
	}

	public String[] getCodigoTarea() {
		return new String[] {CODIGO_T013_DOCUMENTOS_POST_VENTA, CODIGO_T017_DOCUMENTOS_POST_VENTA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
