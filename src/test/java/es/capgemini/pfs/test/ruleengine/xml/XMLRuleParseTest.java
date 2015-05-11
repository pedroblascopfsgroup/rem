package es.capgemini.pfs.test.ruleengine.xml;

import static org.junit.Assert.assertEquals;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.List;

import org.junit.Test;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.io.xml.DomDriver;

import es.capgemini.pfs.ruleengine.xml.XMLRule;

public class XMLRuleParseTest {

    @Test
    public void testParse() {
        String xml = "<rule operator=\"ope\" ruleid=\"8\" values=\"[&quot;1&quot;,'2']\" title=\"hola\" type=\"and\">hola</rule>";
        XStream xstream = new XStream(new DomDriver());
        xstream.processAnnotations(XMLRule.class);
        xstream.alias("rule", XMLRule.class);
        xstream.aliasAttribute("ruleid", "ruleId");

        // xstream.autodetectAnnotations(true);
        XMLRule rule = (XMLRule) xstream.fromXML(xml);
        assertEquals(8, rule.getRuleId());
        assertEquals("hola", rule.getTitle());
        assertEquals("ope", rule.getOperator());
        assertEquals("and", rule.getType());
        List<String> values = rule.getValues();
        assertEquals("\"1\"", values.get(0));

        xml = "<rule></rule>";
        rule = (XMLRule) xstream.fromXML(xml);

        xml = "<rule type=\"and\"></rule>";
        rule = (XMLRule) xstream.fromXML(xml);

        xml = "<rule type=\"and\"><rule type=\"or\"></rule></rule>";
        rule = (XMLRule) xstream.fromXML(xml);
        assertEquals(1, rule.getRules().size());
        assertEquals("or", rule.getRules().get(0).getType());

    }

    //@Test
    public void testFile() throws FileNotFoundException {
        XStream xstream = new XStream(new DomDriver());
        xstream.processAnnotations(XMLRule.class);
        xstream.alias("rule", XMLRule.class);
        xstream.aliasAttribute("ruleid", "ruleId");

        File f = new File("c:\\condiciones.xml");
        FileInputStream fi = new FileInputStream(f);
        xstream.fromXML(fi);

    }
}
