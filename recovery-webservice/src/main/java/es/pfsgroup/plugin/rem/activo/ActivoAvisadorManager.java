package es.pfsgroup.plugin.rem.activo;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoAvisadorApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;


@Service("activoAvisadorManager")
public class ActivoAvisadorManager implements ActivoAvisadorApi {

	//private SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	protected static final Log logger = LogFactory.getLog(ActivoAvisadorManager.class);
	
	
	@Autowired
	private ActivoDao activoDao;

	
	@Autowired 
    private ActivoApi activoApi;

	
	@Override
	@BusinessOperation(overrides = "activoAvisadorManager.get")
	public String get(Long id) {
		return "";
	}


	@Override
	@BusinessOperation(overrides = "activoAvisadorManager.getListActivoAvisador")
	public List<DtoAviso> getListActivoAvisador(Long id, Usuario usuarioLogado) {
		
		List<DtoAviso> listaAvisos = new ArrayList<DtoAviso>();
		Activo activo = activoApi.get(id);
		activoApi.calcularFechaTomaPosesion(activo);
		
		boolean restringida = false;
		boolean obraNueva = false;
		boolean asistida = false;
		boolean lote = false;
		boolean conTitulo = false;
		boolean enPuja = false;
		
		try {
		//Avisos 1 y 2: Integrado en agrupación restringida / Integrado en obra nueva
		//Aviso 11: Integrado en Agrupación tipo PDV (Asistida)
			restringida = activoApi.isIntegradoAgrupacionRestringida(id, usuarioLogado);
			obraNueva = activoApi.isIntegradoAgrupacionObraNueva(id, usuarioLogado);
			asistida = activoApi.isIntegradoAgrupacionAsistida(activo);
			lote = activoApi.isIntegradoAgrupacionComercial(activo);
			conTitulo = activoApi.necesitaDocumentoInformeOcupacion(activo);
			enPuja = activoApi.isActivoEnPuja(activo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		if(enPuja) {
			DtoAviso dtoAviso = new DtoAviso();
			dtoAviso.setDescripcion("Incluido en Haz tu Puja hasta 30/11/2018");
			dtoAviso.setId(String.valueOf(id));
			listaAvisos.add(dtoAviso);
		}
		
		if (restringida) {
			DtoAviso dtoAviso = new DtoAviso();
			dtoAviso.setDescripcion("Incluido en agrupación restringida");
			dtoAviso.setId(String.valueOf(id));
			listaAvisos.add(dtoAviso);
		}
		
		if (obraNueva) {
			DtoAviso dtoAviso = new DtoAviso();
			dtoAviso.setDescripcion("Incluido en agrupación de obra nueva");
			dtoAviso.setId(String.valueOf(id));
			listaAvisos.add(dtoAviso);
		}
		
		if(asistida) {
			DtoAviso dtoAviso = new DtoAviso();
			dtoAviso.setDescripcion("Incluido en agrupación asistida");
			dtoAviso.setId(String.valueOf(id));
			listaAvisos.add(dtoAviso);	
		}
		
		if(lote) {
			DtoAviso dtoAviso = new DtoAviso();
			dtoAviso.setDescripcion("Incluido en agrupación comercial");
			dtoAviso.setId(String.valueOf(id));
			listaAvisos.add(dtoAviso);
		}
		
		if(conTitulo) {
			DtoAviso dtoAviso = new DtoAviso();
			dtoAviso.setDescripcion("Es necesario adjuntar el documento “Informe ocupación”");
			dtoAviso.setId(String.valueOf(id));
			listaAvisos.add(dtoAviso);
		}

		if (Checks.esNulo(activo.getSituacionPosesoria())) {
			Auditoria auditoria = Auditoria.getNewInstance();

			ActivoSituacionPosesoria actSit = new ActivoSituacionPosesoria();
			actSit.setActivo(activo);
			actSit.setVersion(new Long(0));
			actSit.setAuditoria(auditoria);
			activo.setSituacionPosesoria(actSit);

		}
		
		// Aviso 3 / 4: Situación posesoria OCUPADO + Con o sín título
		if (!Checks.esNulo(activo.getSituacionPosesoria().getOcupado())) {
			if (activo.getSituacionPosesoria().getOcupado() == 1) {

				if (activo.getSituacionPosesoria().getConTitulo() == 1) {
					DtoAviso dtoAviso = new DtoAviso();
					dtoAviso.setDescripcion("Situación posesoria ocupado con título");
					dtoAviso.setId(String.valueOf(id));
					listaAvisos.add(dtoAviso);
				} else {
					DtoAviso dtoAviso = new DtoAviso();
					dtoAviso.setDescripcion("Situación posesoria ocupado sin título");
					dtoAviso.setId(String.valueOf(id));
					listaAvisos.add(dtoAviso);
				}
			}
		}
		
		// Aviso 5: Tapiado
		if (!Checks.esNulo(activo.getSituacionPosesoria().getAccesoTapiado())) {
			if (BooleanUtils.toBoolean(activo.getSituacionPosesoria().getAccesoTapiado())) {
				DtoAviso dtoAviso = new DtoAviso();
				dtoAviso.setDescripcion("Situación de acceso tapiado");
				dtoAviso.setId(String.valueOf(id));
				listaAvisos.add(dtoAviso);
			}
		}

		// Aviso 6: Acceso antiocupa
		if (!Checks.esNulo(activo.getSituacionPosesoria().getAccesoAntiocupa())) {
			if (BooleanUtils.toBoolean(activo.getSituacionPosesoria().getAccesoAntiocupa())) {
				DtoAviso dtoAviso = new DtoAviso();
				dtoAviso.setDescripcion("Situación de acceso con puerta antiocupa");
				dtoAviso.setId(String.valueOf(id));
				listaAvisos.add(dtoAviso);
			}
		}
				
		// Aviso 7: Pendiente toma posesión
				if (!Checks.esNulo(activo.getAdjJudicial())
						&& Checks.esNulo(activo.getSituacionPosesoria().getFechaTomaPosesion())) {
					if (!Checks.esNulo(activo.getAdjJudicial().getAdjudicacionBien())) {

						DtoAviso dtoAviso = new DtoAviso();
						dtoAviso.setDescripcion("Pendiente toma de posesión");
						dtoAviso.setId(String.valueOf(id));
						listaAvisos.add(dtoAviso);

					}
				}
		// Aviso 8: Sin gestión
		// Si no es judicial...
		if(!Checks.esNulo(activo)){
			PerimetroActivo perimetro= activoApi.getPerimetroByIdActivo(activo.getId());
			if(!Checks.esNulo(perimetro)){
				if(!Checks.esNulo(perimetro.getAplicaGestion()) && 0 == perimetro.getAplicaGestion()){
					DtoAviso dtoAviso = new DtoAviso();
					dtoAviso.setDescripcion("Activo sin gestión");
					dtoAviso.setId(String.valueOf(id));
					listaAvisos.add(dtoAviso);
				}
			}
		}
		
		
		// Aviso 9: Estado Comercial		
		if(!Checks.esNulo(activo.getSituacionComercial())) {
				DtoAviso dtoAviso = new DtoAviso();
				dtoAviso.setDescripcion(activo.getSituacionComercial().getDescripcion());
				dtoAviso.setId(String.valueOf(id));
				listaAvisos.add(dtoAviso);		
			
		}
		
		
		// Aviso 10: Perímetro Haya
		if(!activoApi.isActivoIncluidoEnPerimetro(id)) {
			DtoAviso dtoAviso = new DtoAviso();
			dtoAviso.setDescripcion("Fuera del perímetro Haya");
			dtoAviso.setId(String.valueOf(id));
			listaAvisos.add(dtoAviso);	
		}

		// Aviso 11: Activo en trámite
		if(activo.getEnTramite()) {
			DtoAviso dtoAviso = new DtoAviso();
			dtoAviso.setDescripcion("Activo en trámite");
			dtoAviso.setId(String.valueOf(id));
			listaAvisos.add(dtoAviso);
		}

		// Aviso 12: Activo no publicable
		PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activo.getId());
		if(!Checks.esNulo(perimetroActivo) && !Checks.esNulo(perimetroActivo.getAplicaPublicar()) && !perimetroActivo.getAplicaPublicar()) {
			DtoAviso dtoAviso = new DtoAviso();
			dtoAviso.setDescripcion("No publicable");
			dtoAviso.setId(String.valueOf(id));
			listaAvisos.add(dtoAviso);
		}

		// Aviso 13: Activo publicable
		if(!Checks.esNulo(perimetroActivo) && !Checks.esNulo(perimetroActivo.getAplicaPublicar()) && perimetroActivo.getAplicaPublicar()) {
			DtoAviso dtoAviso = new DtoAviso();
			dtoAviso.setDescripcion("Publicable");
			dtoAviso.setId(String.valueOf(id));
			listaAvisos.add(dtoAviso);
		}

		// Aviso 14: Estado activo vandalizado
		if(!Checks.esNulo(activo.getEstadoActivo())) {
			if (DDEstadoActivo.ESTADO_ACTIVO_VANDALIZADO.equals(activo.getEstadoActivo().getCodigo())) {
				DtoAviso dtoAviso = new DtoAviso();
				dtoAviso.setDescripcion(activo.getEstadoActivo().getDescripcion());
				dtoAviso.setId(String.valueOf(id));
				listaAvisos.add(dtoAviso);		
			}
		}
		
		// Aviso 15: Estado activo vandalizado
		if(!Checks.esNulo(activo.getEstadoActivo())) {
			if (DDEstadoActivo.ESTADO_ACTIVO_NO_OBRA_NUEVA_VANDALIZADO.equals(activo.getEstadoActivo().getCodigo())) {

				DtoAviso dtoAviso = new DtoAviso();
				dtoAviso.setDescripcion(activo.getEstadoActivo().getDescripcion());
				dtoAviso.setId(String.valueOf(id));
				listaAvisos.add(dtoAviso);

			}
		}

		// Aviso 16: Estado activo afecto por GENCAT / bloqueado GENCAT
		if(!Checks.esNulo(activo)) {
			DtoAviso dtoAviso = new DtoAviso();
			if (activoDao.isActivoBloqueadoGENCAT(activo.getId())) {
				dtoAviso.setDescripcion("Activo bloqueado por GENCAT");
				dtoAviso.setId(String.valueOf(id));
				listaAvisos.add(dtoAviso);
			} else if(activoDao.isActivoAfectoGENCAT(activo.getId())) {
				dtoAviso.setDescripcion("Activo afecto por GENCAT");
				dtoAviso.setId(String.valueOf(id));
				listaAvisos.add(dtoAviso);
			}
		}

		if(!(Checks.esNulo(activo.getTieneDemandaAfecCom())) && activo.getTieneDemandaAfecCom()==1) {
			DtoAviso dtoAviso = new DtoAviso();
			dtoAviso.setDescripcion("Activo con demanda con afectación comercial");
			dtoAviso.setId(String.valueOf(id));
			listaAvisos.add(dtoAviso);
		}
		return listaAvisos;
	}
}