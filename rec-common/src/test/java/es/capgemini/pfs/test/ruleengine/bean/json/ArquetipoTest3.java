package es.capgemini.pfs.test.ruleengine.bean.json;

import es.capgemini.pfs.test.ruleengine.bean.ArquetipoTest;
import es.capgemini.pfs.test.ruleengine.bean.Arquetipo_Test_Constants;


/**
 * @author lgiavedo
 *
 */
public class ArquetipoTest3 extends ArquetipoTest{
    
     public ArquetipoTest3(){
         id = 3L;
         name="Arquetipo Test III";
         priority = 3L;
         value = "3";
        
         
         definitionRule = "{\"type\": \"and\", \"rules\": ["
             + "                 {\"type\": \"compare1\", \"title\": \"Hombre?\", \"ruleId\": "+Arquetipo_Test_Constants.DD_RULE_PER_SEXO+", \"operator\":  \"equal\", \"values\":  [\"2\"]}"
             + "                        ,{\"type\": \"or\", \"rules\": ["
             + "                            {\"type\": \"compare2\", \"operator\": \"between\", \"title\": \"Riesgo Persona entre 20-80\", \"ruleId\": "+Arquetipo_Test_Constants.DD_RULE_PER_RIESGO_2+", \"values\":  [\"20\",\"80\"]}"
             + "                            ,{\"type\": \"compare1\", \"title\": \"Riesgo Movimiento > 50\", \"operator\": \"greaterThan\", \"ruleId\": "+Arquetipo_Test_Constants.DD_RULE_MOV_RIESGO+", \"values\":  [\"50\"]}"
             + "                     ]}"
             + "                    ,{\"type\": \"or\", \"rules\": ["
             + "                        {\"type\": \"and\", \"rules\": ["
             + "                              {\"type\": \"dictionary\", \"title\": \"Tipo Persona 1\", \"operator\": \"equal\", \"ruleId\": "+Arquetipo_Test_Constants.DD_RULE_TPE_ID+", \"values\":  [\"1\"]}"
             + "                              ,{\"type\": \"dictionary\", \"title\": \"DD_SCE = 4\", \"operator\": \"equal\", \"ruleId\": "+Arquetipo_Test_Constants.DD_RULE_SCE_ID+", \"values\":  [\"4\"]}"
             + "                        ]}"
             + "                        ,{\"type\": \"and\", \"rules\": ["
             + "                             {\"type\": \"dictionary\", \"title\": \"Tipo Persona no sea 2\", \"operator\": \"notEqual\", \"ruleId\": "+Arquetipo_Test_Constants.DD_RULE_TPE_ID+", \"values\":  [\"2\"]}"
             + "                              ,{\"type\": \"or\", \"rules\": ["
             + "                                      {\"type\": \"dictionary\", \"title\": \"DD_SCE = 3\", \"operator\": \"equal\", \"ruleId\": "+Arquetipo_Test_Constants.DD_RULE_SCE_ID+", \"values\":  [\"3\"]}"
             + "                                     ,{\"type\": \"dictionary\", \"title\": \"DD_SCE = 2\", \"operator\": \"equal\", \"ruleId\": "+Arquetipo_Test_Constants.DD_RULE_SCE_ID+", \"values\":  [\"2\"]}"
             + "                             ]}"
             + "                        ]}"
             + "                    ]}"
             + " ]}";

     }

}
 