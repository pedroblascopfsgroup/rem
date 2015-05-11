package es.capgemini.pfs.test.ruleengine.bean.xml;

import es.capgemini.pfs.test.ruleengine.bean.ArquetipoTest;
import es.capgemini.pfs.test.ruleengine.bean.Arquetipo_Test_Constants;

public class ArquetipoSexoHombreXML extends ArquetipoTest {

    public ArquetipoSexoHombreXML() {
        id = 1L;
        name = "Arquetipo Sexo";
        priority = 1L;
        value = "1";
        definitionRule = "<rule title=\"Hombre\" ruleid=\"" + Arquetipo_Test_Constants.DD_RULE_PER_SEXO + "\" operator=\"equal\" values=\"[2]\" />";//

    }

}
