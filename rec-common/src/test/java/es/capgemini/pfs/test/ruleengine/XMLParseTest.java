package es.capgemini.pfs.test.ruleengine;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;

import es.capgemini.pfs.ruleengine.RuleConverterUtil;
import es.capgemini.pfs.test.ruleengine.bean.xml.ArquetipoFechaMenorXML;
import es.capgemini.pfs.test.ruleengine.bean.xml.ArquetipoSexoMujerXML;

public class XMLParseTest {

    private RuleConverterUtil rcUtil = new RuleConverterUtil();

    @Test
    public void testXML() {

        assertNotNull(rcUtil.XMLToHelperRule(new ArquetipoSexoMujerXML().getDefinitionRule()));
        assertNotNull(rcUtil.XMLToHelperRule(new ArquetipoFechaMenorXML().getDefinitionRule()));
    }
}
