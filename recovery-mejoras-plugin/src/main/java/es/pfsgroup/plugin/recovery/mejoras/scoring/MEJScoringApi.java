package es.pfsgroup.plugin.recovery.mejoras.scoring;

import java.util.List;

import es.capgemini.devon.web.DynamicElement;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface MEJScoringApi {
	
	public static final String MEJ_MGR_SCORING_BUTTONS_RIGHT = "plugin.mejoras.web.metrica.buttons.right";
	public static final String MEJ_MGR_SCORING_BUTTONS_LEFT = "plugin.mejoras.web.metrica.buttons.left";

	@BusinessOperationDefinition(MEJ_MGR_SCORING_BUTTONS_RIGHT)
	List<DynamicElement> getButtonsScoringRight();
	
	@BusinessOperationDefinition(MEJ_MGR_SCORING_BUTTONS_LEFT)
	List<DynamicElement> getButtonsScoringLeft();

}
