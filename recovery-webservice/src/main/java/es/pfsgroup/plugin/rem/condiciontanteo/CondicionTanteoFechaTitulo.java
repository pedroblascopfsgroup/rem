package es.pfsgroup.plugin.rem.condiciontanteo;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;

@Service("condicionTanteoFechaTitulo")
public class CondicionTanteoFechaTitulo implements CondicionTanteoApi {
	
	private static final String FECHA_MINIMA = "2008-04-08";

	protected static final Log logger = LogFactory.getLog(CondicionTanteoFechaTitulo.class);
	
	/**
	 * Comprueba que la fecha título o fecha de auto adjuncación (según el tipo de titulo judicial del activo)
	 * sea mayor a 08-04-2008
	 */
	@Override
	public Boolean checkCondicion(Activo activo){
		
		Boolean condicionValida = false;
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date fechaMinima = null;
		try {
			fechaMinima = sdf.parse(FECHA_MINIMA);
		} catch (ParseException e) {
			logger.error(e.getMessage());
		}
		
		//Si es judicial, y con fecha adjudicacion mayor a la fecha mínima, la condicion es verdadera
		if(!Checks.esNulo(activo.getTipoTitulo()) && DDTipoTituloActivo.tipoTituloJudicial.equals(activo.getTipoTitulo().getCodigo())
				&& !Checks.esNulo(activo.getAdjJudicial()) && !Checks.esNulo(activo.getAdjJudicial().getFechaAdjudicacion()) && fechaMinima.before(activo.getAdjJudicial().getFechaAdjudicacion())) {
			
			condicionValida = true;
		}
		// Si es NO judicial, y la fecha título es mayor a la mínima, la condición es verdadera
		else if (!Checks.esNulo(activo.getTipoTitulo()) && DDTipoTituloActivo.tipoTituloNoJudicial.equals(activo.getTipoTitulo().getCodigo())
				&& !Checks.esNulo(activo.getAdjNoJudicial()) && !Checks.esNulo(activo.getAdjNoJudicial().getFechaTitulo()) && fechaMinima.before(activo.getAdjNoJudicial().getFechaTitulo())) {
			
			condicionValida = true;
		}
		
		return condicionValida;
	}
}
